#coding=utf-8

import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from pylons.decorators import *
from routes.util import *

from digg.lib.base import BaseController, render
from digg.lib.helpers import *
from digg.model.all_table import *


import md5
import random
import shutil
import pymongo

log = logging.getLogger(__name__)

WEBGAME_INFO_MAX=500

class WebgameController(BaseController):
    def index(self):
        return "ok"
    
    def detail(self):
        id = request.params.get("id")
        c.obj = Webgame.get_data(id)
        if not c.obj:
            return goto_tip(u"%s 游戏已经不存在了" % id)
        c.obj.view_num += 1
        c.obj.score = calc_game_rank(c.obj)
        Webgame.put_data(c.obj)

        author = User.get_data(c.obj.uid)
        Action.visit_my(author)

        c.cards = Card.query({"webgame_id": c.obj._id}, limit = 5, sort=[("add_timestamp", pymongo.DESCENDING)])

        limit = 10
        page_num = 10
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)
            if not c.page:
                c.page = 1

        skip = (c.page - 1) * limit

        cond = {'webgame_id': c.obj._id}
        
        sort = [("score", pymongo.DESCENDING), ("timestamp", pymongo.DESCENDING)]

        c.news = WebgameNews.query(cond, skip = skip, limit = limit, sort = sort)

        c.total_num = WebgameNews.query_num(cond)

        if c.total_num % limit == 0:
            c.total_pages = c.total_num / limit
        else:
            c.total_pages = c.total_num / limit + 1

        c.start_page = int(c.page / page_num) * page_num

        c.end_page = c.start_page + page_num
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages

        return render("/webgame/detail.mako.html")
        
    def my(self):
        self.check()
        limit = 25
        page_num = 10

        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        c.group_id = request.params.get('group_id')
        if not c.group_id:
            c.group_id = 0
        else:
            c.group_id = int(c.group_id)

        skip = (c.page - 1) * limit

        cond = {'uid': c.uid}
        if c.group_id:
            cond['group_id'] = c.group_id

        sort = [("add_timestamp", pymongo.DESCENDING)]

        c.objs = Webgame.query(cond, skip = skip, limit = limit, sort = sort)

        c.total_num = Webgame.query_num(cond)

        if c.total_num % limit == 0:
            c.total_pages = c.total_num / limit
        else:
            c.total_pages = c.total_num / limit + 1

        c.start_page = int(c.page / page_num) * page_num

        c.end_page = c.start_page + page_num
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        return render('/webgame/my.mako.html')

    def hot(self):
        c.menu_name = u"最热"
        limit = 25
        page_num = 10

        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        c.group_id = request.params.get('group_id')
        if not c.group_id:
            c.group_id = 0
        else:
            c.group_id = int(c.group_id)

        skip = (c.page - 1) * limit

        cond = {}
        if c.group_id:
            cond = {'group_id': c.group_id}

        sort = [("score", pymongo.DESCENDING), ("add_timestamp", pymongo.DESCENDING)]

        c.objs = Webgame.query(cond, skip = skip, limit = limit, sort = sort)

        c.total_num = Webgame.query_num(cond)

        if c.total_num % limit == 0:
            c.total_pages = c.total_num / limit
        else:
            c.total_pages = c.total_num / limit + 1

        c.start_page = int(c.page / page_num) * page_num

        c.end_page = c.start_page + page_num
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages

        return render('/webgame/hot.mako.html')

    def newest(self):
        c.menu_name = u"最新"
        limit = 25
        page_num = 10
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        c.group_id = request.params.get('group_id')
        if not c.group_id:
            c.group_id = 0
        else:
            c.group_id = int(c.group_id)

        skip = (c.page - 1) * limit

        cond = {}
        if c.group_id:
            cond = {'group_id': c.group_id}

        sort = [("add_timestamp", pymongo.DESCENDING)]

        c.objs = Webgame.query(cond, skip = skip, limit = limit, sort = sort)

        c.total_num = Webgame.query_num(cond)

        if c.total_num % limit == 0:
            c.total_pages = c.total_num / limit
        else:
            c.total_pages = c.total_num / limit + 1

        c.start_page = int(c.page / page_num) * page_num

        c.end_page = c.start_page + page_num
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages

        return render('/webgame/newest.mako.html')

    def search(self):
        limit = 10
        page_num = 10
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)
            
        c.query = request.params.get('query', '')
        
        q = '.*' + c.query.encode("utf-8") + '.*' 
            
        skip = (c.page - 1) * limit

        c.objs = Webgame.query({"name": {'$regex': q, "$options": 'i'}}, skip = skip, limit = limit, sort = [("score", pymongo.DESCENDING)])            
        c.total_num = Webgame.query_num({"name": {'$regex': q, "$options": 'i'}})
        c.total_pages = c.total_num / limit + 1
            
        c.start_page = int((c.page -1) / page_num) * page_num + 1
        
        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        
        return render('/webgame/search.mako.html')

    def add(self):
        self.check()
        c.name = request.params.get("name")
        return render("/webgame/add.mako.html")   

    def do_add(self):
        self.check()
        name = request.params.get('name')
        info = request.params.get('info')
        author = request.params.get('author')
        group_id = request.params.get('group_id')
        site = request.params.get('site')
        
        if not name:
            return goto_tip(u"游戏名不能为空")
        if not author:
            return goto_tip(u"开发者不能为空")
        if len(info) > WEBGAME_INFO_MAX:
            return goto_tip(u"游戏简介不能超过200字")
        if not group_id:
            return goto_tip(u"游戏类型不能为空")
        
        name = name.strip()
        group_id = int(group_id)
        
        if Webgame.query_num({'name': name}) > 0:
            return goto_tip(u"游戏名称已经被其他人使用了")
            
        obj = Webgame.new_obj()
        obj.uid = self.uid
        obj.uname = self.username
        obj.name = name
        obj.info = info
        obj.author = author
        obj.group_id = group_id
        obj.site = safe_url(site)
        obj.add_timestamp = int(time.time())
        obj.score = calc_game_rank(obj)
        Webgame.put_data(obj)
        Action.add_game(self.user)
        
        return redirect("/webgame/my")
        
    def edit(self):
        self.check()
        id = request.params.get("id")
        c.obj = Webgame.get_data(id)
        if not c.obj:
            return goto_tip(u"%s 游戏已经不存在了" % id)
        
        if c.obj.uid != self.uid and c.is_admin == 0:
            return goto_tip(u"无权操作")
            
        return render("/webgame/edit.mako.html")
    
    def do_edit(self):
        self.check()
        name = request.params.get('name')
        info = request.params.get('info')
        author = request.params.get('author')
        group_id = request.params.get('group_id')
        id = request.params.get("id")
        site = request.params.get('site')
        c.obj = Webgame.get_data(id)
        
        if not c.obj:
            return goto_tip(u"%s 游戏已经不存在了" % id)
        if not name:
            return goto_tip(u"游戏名不能为空")
        if len(info) > WEBGAME_INFO_MAX:
            return goto_tip(u"游戏简介不能超过200字")
        if not author:
            return goto_tip(u"开发者不能为空")
        if not group_id:
            return goto_tip(u"游戏类型不能为空")
        
        name = name.strip()
        group_id = int(group_id)
        
        if name != c.obj.name and Webgame.query_num({'name': name}) > 0:
            return goto_tip(u"游戏名称已经被其他人使用了")
            
        c.obj.name = name
        c.obj.info = info
        c.obj.author = author
        c.obj.group_id = group_id
        c.obj.site = safe_url(site)
        Webgame.put_data(c.obj)
        
        return redirect("/webgame/my")    
        
    def rem(self):
        id = request.params.get("id")
        obj = Webgame.get_data(id)
        if not obj:
            return goto_tip(u"游戏已经被删掉了")
        if obj.uid != self.uid and c.is_admin == 0:
            return goto_tip(u"无权操作")
        
        if WebgameNews.query_num({'webgame_id': obj._id}) > 0:
            return goto_tip(u"该游戏有新闻链接，不能删除")
        Webgame.rem_data(obj)

        return redirect("/webgame/my")
        
    @jsonify    
    def check_name(self):
        name = request.params.get("name").strip()
        if Webgame.query_num({'name': name}) > 0:
            return {"is_ok": 1}
        q = '.*' + name.encode("utf-8") + '.*' 
        others = Webgame.query({"name": {'$regex': q, "$options": 'i'}}, limit=5, sort=[('score', pymongo.DESCENDING)])
        return {'is_ok': 0, 'others': others}