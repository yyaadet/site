#coding=utf-8

import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from pylons.decorators import *
from routes.util import *

from feed.lib.base import *
from feed.lib.helpers import *
from feed.model.all_table import *
from feed.model import *


import md5
import random
import shutil

log = logging.getLogger(__name__)

class RssController(BaseController):
    def index(self):
        self.check()
        limit = 25
        page_num = 10
        cond = {'is_del': 0, 'uid': c.user._id}

        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        skip = (c.page - 1) * limit

        c.objs = Rss.query(cond, skip = skip, limit = limit, sort = [("add_timestamp", pymongo.DESCENDING)])

        c.total_pages = Rss.query_num(cond) / limit + 1

        c.start_page = int((c.page -1) / page_num) * page_num + 1

        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        return render('/rss/index.mako.html')
        
    def add(self):
        self.check()
        return render('/rss/add.mako.html')
        
    def do_add(self):
        self.check()
        name = request.params.get('name')
        url = request.params.get('url')
        #num = int(request.params.get('num'))
        num = 10
        group_id = int(request.params.get('group_id'))
        
        if not name:
            return goto_tip(u'请输入名称')
        if not url:
            return goto_tip(u'请输入url')
        if num < 0 or num > 100:
            return goto_tip(u"数目无效")
        if not group_id:
            return goto_tip(u"请选择类别")

        obj = Rss.new_obj()
        obj.uid = c.user._id
        obj.uname = c.user.name
        obj.name = name
        obj.url = safe_url(url)
        obj.num = num
        obj.group_id = group_id
        obj.add_timestamp = int(time.time())
        Rss.put_data(obj)
        return redirect("/rss/index")
        
    def rem(self):
        self.check()
        id = request.params.get('id')
        obj = Rss.get_data(id)
        if not obj:
            return goto_tip(u"该订阅已经不存在了")
        obj.is_del = 1
        Rss.put_data(obj)
        return redirect("/rss/index")
        
    def edit(self):
        self.check()
        id = request.params.get('id')
        obj = Rss.get_data(id)
        if not obj:
            return goto_tip(u"该订阅已经不存在了")
        c.obj = obj
        return render("/rss/edit.mako.html")
        
    def do_edit(self):
        self.check()
        id = request.params.get('id')
        obj = Rss.get_data(id)
        if not obj:
            return goto_tip(u"该订阅已经不存在了")
        name = request.params.get('name')
        url = request.params.get('url')
        group_id = int(request.params.get('group_id'))
        
        if not name:
            return goto_tip(u'请输入名称')
        if not url:
            return goto_tip(u'请输入url')
        if not group_id:
            return goto_tip(u"请选择类别")

        obj.name = name
        obj.url = safe_url(url)
        obj.group_id = group_id
        obj.edit_timestamp = int(time.time())
        Rss.put_data(obj)
        return redirect("/rss/index")
        
        

