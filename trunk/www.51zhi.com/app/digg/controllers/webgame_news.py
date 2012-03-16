#coding=utf-8

import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from pylons.decorators import *
from routes.util import *

from digg.lib.base import BaseController, render
from digg.lib.helpers import *
from digg.lib.utils import *
from digg.model.all_table import *
from digg.lib.query_ip import *


import md5
import random
import shutil
import pymongo

log = logging.getLogger(__name__)

WEBGAME_NEWS_TITLE_MAX=200


class WebgameNewsController(BaseController):
    def index(self):
        return "ok"
    
    def detail(self):
        id = request.params.get("id")
        c.obj = WebgameNews.get_data(id)
        if not c.obj:
            return goto_tip(u"该新闻已经不存在了")
        c.obj.view_num += 1
        #c.obj.score = calc_news_rank(c.obj)
        WebgameNews.put_data(c.obj)

        author = User.get_data(c.obj.uid)
        Action.visit_my(author)

        #incr game hot
        game = Webgame.get_data(c.obj.webgame_id)
        today_click(game)

        #comments    
        limit = 25
        page_num = 10
                
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)
            
        skip = (c.page - 1) * limit
        
        c.comments = WebgameComment.query({'webgame_news_id': c.obj._id}, skip = skip, limit = limit, sort = [("timestamp", pymongo.DESCENDING)])            
        
        c.total_pages = WebgameComment.query_num({'webgame_news_id': c.obj._id}) / limit + 1
            
        c.start_page = int((c.page -1) / page_num) * page_num + 1
        
        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        
        return render('/webgame_news/detail.mako.html')
        
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
        
        if c.group_id:
            c.objs = WebgameNews.query({'group_id': c.group_id, 'uid': c.uid}, skip = skip, limit = limit, sort = [("timestamp", pymongo.DESCENDING)])            
            c.total_pages = WebgameNews.query_num({'group_id': c.group_id, 'uid': c.uid}) / limit + 1
        else:
            c.objs = WebgameNews.query({'uid': c.uid}, skip = skip, limit = limit, sort = [("timestamp", pymongo.DESCENDING)])            
            c.total_pages = WebgameNews.query_num({'uid': c.uid}) / limit + 1
            
        c.start_page = int((c.page -1) / page_num) * page_num + 1
        
        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        
        return render('/webgame_news/my.mako.html')
    
    def newest(self):
        limit = 25
        c.limit = limit
        page_num = 10
        
        c.menu_name = u"最新"
                
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

        sort = [("timestamp", pymongo.DESCENDING)]

        c.objs = WebgameNews.query(cond, skip = skip, limit = limit, sort = sort)

        c.total_num = WebgameNews.query_num(cond)

        if c.total_num % limit == 0:
            c.total_pages = c.total_num / limit
        else:
            c.total_pages = c.total_num / limit + 1

        c.start_page = int(c.page / page_num) * page_num

        c.end_page = c.start_page + page_num
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages

        return render('/webgame_news/newest.mako.html')    

    def hotest(self):
        limit = 25
        c.limit = limit
        page_num = 10
        
        c.menu_name = u"最热"
                
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

        sort = [("score", pymongo.DESCENDING), ("timestamp", pymongo.DESCENDING)]

        c.objs = WebgameNews.query(cond, skip = skip, limit = limit, sort = sort)

        c.total_num = WebgameNews.query_num(cond)

        if c.total_num % limit == 0:
            c.total_pages = c.total_num / limit
        else:
            c.total_pages = c.total_num / limit + 1
            
        c.start_page = int(c.page / page_num) * page_num
        
        c.end_page = c.start_page + page_num
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        
        return render('/webgame_news/hotest.mako.html')    

    def add_url(self):
        url = safe_url(request.params.get("url"))
        title, summary = parse_url_page(url)

        if not title:
            return goto_tip(u"该页面比较特殊，试着提交其他的URL新闻吧")
        obj = WebgameNews.new_obj()
        obj.uid = self.uid
        obj.uname = self.username
        obj.type = 0
        obj.url = url
        obj.title = title.strip()
        obj.cnt = remove_html_tag(summary.strip())
        obj.ip = request.ip
        #obj.city = get_ip_city(request.ip)
        obj.timestamp = int(time.time())
        obj.score = calc_news_rank(obj)
        WebgameNews.put_data(obj)
        Action.add_news(self.user)
        return redirect("/webgame_news/newest")


    def add(self):
        self.check()
        c.tip = request.params.get('tip')
        return render("/webgame_news/add.mako.html")   

    def do_add(self):
        type = int(request.params.get('type'))
        title = request.params.get('title')
        url = request.params.get('url')
        cnt = request.params.get('cnt')
        imgs = request.params.get("imgs")
        webgame_name = request.params.get('webgame_name')
        
        if not title:
            return goto_tip(u"标题不能为空")
        if len(title) > WEBGAME_NEWS_TITLE_MAX:
            return goto_tip(u"标题超过了最大长度%d" % WEBGAME_NEWS_TITLE_MAX)

        if type == 0 and not url:
            return goto_tip(u"URL不能为空")
        elif type == 1 and not cnt:
            return goto_tip(u"内容不能为空")    
        
        webgame = None
        if webgame_name:
            webgame_name = webgame_name.strip()
            result = Webgame.query({'name': webgame_name}, limit = 1)
            if not result:
                return goto_tip(u"【%s】不在游戏库中，注册成为会员，添加该游戏" % webgame_name)
            webgame = result[0]
        
        url = safe_url(url).strip()
        
        if type == 0 and WebgameNews.query_num({'url': url}) > 0:
            return goto_tip(u"您的链接已经被人提交过了，不能重复提交")    
            
        obj = WebgameNews.new_obj()
        obj.uid = self.uid
        obj.uname = self.username
        obj.type = type
        obj.url = url
        obj.title = title.strip()
        obj.cnt = remove_html_tag(cnt.strip())
        obj.ip = request.ip
        #obj.city = get_ip_city(request.ip)
        obj.timestamp = int(time.time())
        obj.score = calc_news_rank(obj)
        if imgs:
            obj.imgs = imgs.split(";")
        if webgame:
            obj.webgame_id = webgame._id
            obj.webgame_name = webgame.name
            obj.group_id = webgame.group_id
            #incr news num for webgame
            webgame.news_num += 1
            webgame.score = calc_game_rank(webgame)
            Webgame.put_data(webgame)
        WebgameNews.put_data(obj)
        
        Action.add_news(self.user)
        
        return redirect("/webgame_news/newest")

    @jsonify
    def rem(self):
        id = request.params.get("id")
        obj = WebgameNews.get_data(id)
        if not obj:
            return {"is_ok": 0, reason: u"新闻已经被删除了"}
        
        if obj.uid != self.uid and c.is_admin == 0:
            return {"is_ok": 0, reason: u"无权删除"}
        now = int(time.time())
        if c.is_admin == 0 and now - obj.timestamp > 24*3600:
            return {"is_ok": 0, reason: u"新闻已经超时了"}
            
        WebgameNews.rem_data(obj)
        return {"is_ok": 1}
        
    @jsonify    
    def vote(self):
        id = request.params.get("id")
        type = int(request.params.get("type"))
        num = 0
        if "num" in request.params:
            num = int(request.params.get("num"))
        obj = WebgameNews.get_data(id)
        if not obj:
            return {"is_ok": 0}
        if request.ip in obj.ips and not c.is_admin:
            return {"is_ok": 0}
        if type == 1:
            if c.is_admin == 1 and num:
                obj.good_num += 50
            else:
                obj.good_num += 1
        else:
            obj.bad_num += 1
        obj.score = calc_news_rank(obj)
        obj.ips.append(request.ip)
        WebgameNews.put_data(obj)
        
        webgame = None
        if obj.webgame_id:
            webgame = Webgame.get_data(obj.webgame_id)
        if webgame:
            if type == 1:
                if c.is_admin == 1 and num:
                    webgame.good_num += 50
                else:
                    webgame.good_num += 1
            else:
                webgame.bad_num += 1
            webgame.score = calc_game_rank(webgame)
            Webgame.put_data(webgame)
        return {"is_ok": 1, 'score': obj.good_num - obj.bad_num}    
            
    def comment(self):
        id = request.params.get("id")
        cnt = request.params.get("cnt")
        news = WebgameNews.get_data(id)
        if not news:
            return goto_tip(u"该新闻已经不存在了")
        
        if len(cnt) > 500:
            return goto_tip(u"字数超过上限了")
        
        news.comment_num += 1
        news.score = calc_news_rank(news)
        WebgameNews.put_data(news)
        
        cm = WebgameComment.new_obj()
        cm.uid = self.uid
        cm.uname = self.username
        cm.cnt = remove_html_tag(cnt)
        cm.webgame_news_id = news._id
        cm.ip = request.ip
        #cm.city = get_ip_city(cm.ip)
        cm.timestamp = int(time.time())
        WebgameComment.put_data(cm)

        Action.add_comment(self.user)

        webgame = None
        if news.webgame_id:
            webgame = Webgame.get_data(news.webgame_id)
        if webgame:
            webgame.comment_num += 1
            webgame.score = calc_game_rank(webgame)
            Webgame.put_data(webgame)
        return redirect(static_webgame_news_detail_url(news._id))
        
    @jsonify    
    def get_url_title(self):
        url = request.params.get('url')
        url = safe_url(url)
        title, summary, imgs = parse_url_page(url)
        if title:
            title = remove_unused_info_from_title(title)
        return {'title': title, 'cnt': summary, "imgs": imgs}

    @jsonify
    def get_city(self):
        id = request.params.get("id")
        obj = WebgameNews.get_data(id)
        if obj.city:
            return {"city": obj.city}
        obj.city = get_ip_city(obj.ip)
        WebgameNews.put_data(obj)
        return {"city": obj.city}

    def go(self):
        id = request.params.get("id")
        obj = WebgameNews.get_data(id)
        obj.go_num += 1
        #obj.score = calc_news_rank(obj)
        WebgameNews.put_data(obj)
        url = obj.url
        if not url:
            url = static_webgame_news_detail_url(obj._id)

        #game today click
        game = Webgame.get_data(obj.webgame_id)
        today_click(game)

        return redirect(url)