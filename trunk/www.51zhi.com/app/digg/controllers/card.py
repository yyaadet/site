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

CARD_CNT_MAX = 2048

class CardController(BaseController):
    def index(self):
        return "ok"

    @jsonify
    def get_card(self):
        id = request.params.get("id")
        statu = int(request.params.get("statu"))
        obj = Card.get_data(id)

        if request.ip in obj.ips:
            return {"ok": 0}
        if statu == 0:
            obj.fail_num += 1
            obj.last_fail_timestamp = int(time.time())
        else:
            obj.succ_num += 1
            obj.last_succ_timestamp = int(time.time())
        obj.score = calc_card_score(obj)
        obj.ips.append(request.ip)
        Card.put_data(obj)
        return {"score": obj.score}

    def detail(self):
        id = request.params.get("id")
        c.obj = Card.get_data(id)
        if not c.obj:
            return goto_tip(u"%s 该卡已经不存在了" % id)
        return render("/card/detail.mako.html")
        
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
        return render('/card/my.mako.html')

    def hotest(self):
        c.menu_name = u"高成功率"
        limit = 25
        page_num = 10

        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        c.webgame_id = request.params.get('webgame_id')
        if not c.webgame_id:
            c.webgame_id = ''

        skip = (c.page - 1) * limit

        cond = {}
        if c.webgame_id:
            cond = {'webgame_id': c.webgame_id}

        sort = [("score", pymongo.DESCENDING), ("add_timestamp", pymongo.DESCENDING)]

        c.objs = Card.query(cond, skip = skip, limit = limit, sort = sort)

        c.total_num = Card.query_num(cond)

        if c.total_num % limit == 0:
            c.total_pages = c.total_num / limit
        else:
            c.total_pages = c.total_num / limit + 1

        c.start_page = int(c.page / page_num) * page_num

        c.end_page = c.start_page + page_num
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages

        return render('/card/hotest.mako.html')

    def newest(self):
        c.menu_name = u"最新"
        limit = 25
        page_num = 10
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        c.webgame_id = request.params.get('webgame_id')
        if not c.webgame_id:
            c.webgame_id = ''
            
        skip = (c.page - 1) * limit

        cond = {}
        if c.webgame_id:
            cond = {'webgame_id': c.webgame_id}

        sort = [("add_timestamp", pymongo.DESCENDING)]

        c.objs = Card.query(cond, skip = skip, limit = limit, sort = sort)

        c.total_num = Card.query_num(cond)

        if c.total_num % limit == 0:
            c.total_pages = c.total_num / limit
        else:
            c.total_pages = c.total_num / limit + 1

        c.start_page = int(c.page / page_num) * page_num

        c.end_page = c.start_page + page_num
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages

        return render('/card/newest.mako.html')

    def do_add(self):
        self.check()
        webgame_name = request.params.get("webgame_name")
        title = request.params.get('title')
        cnt = request.params.get('cnt')
        url = request.params.get('url')
        
        if not webgame_name:
            return goto_tip(u"游戏名不能为空")
        if not url:
            return goto_tip(u"链接不能为空")
        if len(cnt) > CARD_CNT_MAX:
            return goto_tip(u"奖励不能超过200字")
        if not title:
            return goto_tip(u"卡名不能为空")

        url = safe_url(url.strip())
        webgame_name = webgame_name.strip()

        tmp = Webgame.query({'name': webgame_name}, limit = 1)
        if not tmp:
            return goto_tip(u"游戏未入库")
        if Card.query_num({"url": url}) > 0:
            return goto_tip(u"该卡已经入库了")
        webgame = tmp[0]
        
        obj = Card.new_obj()
        obj.uid = self.uid
        obj.uname = self.username
        obj.title = title.strip()
        obj.cnt = cnt.strip()
        obj.group_id = webgame.group_id
        obj.webgame_id = webgame._id
        obj.webgame_name = webgame.name
        obj.url = url
        obj.add_timestamp = int(time.time())
        obj.ip = request.ip
        obj.succ_num = 1
        obj.last_succ_timestamp = obj.add_timestamp + random.randint(160, 280)
        obj.fail_num = 1
        obj.last_fail_timestamp = obj.add_timestamp + random.randint(160, 280)
        obj.score = calc_card_score(obj)
        Card.put_data(obj)

        webgame.card_num += 1
        Webgame.put_data(webgame)
        
        return redirect("/card/newest")
        
    def rem(self):
        id = request.params.get("id")
        obj = Card.get_data(id)
        if not obj:
            return goto_tip(u"已经被删掉了")
        if obj.uid != self.uid and c.is_admin == 0:
            return goto_tip(u"无权操作")
        Card.rem_data(obj)

        return redirect("/card/newest")
