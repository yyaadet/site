#coding=utf-8

import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from pylons.decorators import *
from routes.util import *

from feed.lib.base import BaseController, render
from feed.lib.helpers import *
from feed.lib.rss import *
from feed.lib.utils import *
from feed.lib.qq import *
from feed.model.all_table import *


import md5
import random
import shutil
import pymongo
import urlparse

log = logging.getLogger(__name__)

class NewsController(BaseController):
    def index(self):
        return "ok"
    
    def detail(self):
        id = request.params.get("id")
        
        c.obj = News.get_data(id)
        if not c.obj:
            return goto_tip(u"该新闻已经不存在了")
        c.obj.view_num += 1
        c.obj.cnt = remove_ads(c.obj.cnt)
        News.put_data(c.obj)
        
        #update rss
        rss = Rss.get_data(c.obj.feed_id)
        if rss:
            rss.visited_num += 1
            Rss.put_data(rss)
        # update user
        if c.user and c.user._id != c.obj.uid:
            u = User.get_data(c.obj.uid)
            if u:
                u.visited_num += 1
                User.put_data(u)
        return render('/news/detail.mako.html')
        
    
    def group(self):
        group_id = int(request.params.get("group_id"))
        limit = 25
        page_num = 10
        cond = {'group_id': group_id}
        c.group_id = group_id

        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        skip = (c.page - 1) * limit

        c.objs = News.query(cond, skip = skip, limit = limit, sort = [("timestamp", pymongo.DESCENDING)])

        c.total_pages = News.query_num(cond) / limit + 1

        c.start_page = int((c.page -1) / page_num) * page_num + 1

        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        
        return render('/news/group.mako.html')

    def rss(self):
        limit = 25
        page_num = 10
        c.rss_id = request.params.get("rss_id")
        cond = {'feed_id': c.rss_id}

        c.rss = Rss.get_data(c.rss_id)
        if not c.rss:
            return goto_tip(u"该订阅已经被不存在了")
            
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        skip = (c.page - 1) * limit

        c.objs = News.query(cond, skip = skip, limit = limit, sort = [("timestamp", pymongo.DESCENDING)])

        c.total_pages = News.query_num(cond) / limit + 1

        c.start_page = int((c.page -1) / page_num) * page_num + 1

        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        
        return render('/news/rss.mako.html')

    @jsonify
    def add_share(self):
        id = request.params.get("id")
        obj = News.get_data(id)
        if not obj:
            return {'ret': -1, 'msg': u"新闻不存在"}
        if not c.user:
            return {'ret': -1, 'msg': u"请先登录"}
        if not c.user.openid:
            return {'ret': -1, 'msg': u"请使用QQ登录，支持一键分享"}
        title = obj.title.encode("utf-8")
        url = site_url("/news/detail?id=" + obj._id )
        summary = short_text(obj.cnt, 200).encode("utf-8")
        result = QQ.add_share(c.user.token, c.user.token_secret, c.user.openid, title, url, summary)
        return result

    @jsonify
    def rem(self):
        id = request.params.get("id")
        obj = News.get_data(id)
        if not obj:
            return {"is_ok": 0, reason: u"新闻已经被删除了"}
        
        if obj.uid != c.user._id and c.user.is_admin == 0:
            return {"is_ok": 0, reason: u"无权删除"}
            
        News.rem_data(obj)
        return {"is_ok": 1}
           

    def go(self):
        id = request.params.get("id")
        
        obj = News.get_data(id)
        if not obj:
            return goto_tip(u"该新闻已经不存在了")
        obj.go_num += 1
        if obj.url.find("http://") == -1:
            rss = Rss.get_data(obj.feed_id)
            rss.go_num += 1
            Rss.put_data(rss)
            obj.url = urlparse.urljoin(rss.url, obj.url)
        News.put_data(obj)
        
        return redirect(obj.url)