#coding=utf-8
import logging
import time

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from pylons.decorators.cache import beaker_cache

from digg.lib.base import BaseController, render
from digg.lib.helpers import *
from digg.model.all_table import *


import pymongo

log = logging.getLogger(__name__)

class HomeController(BaseController):
    def index(self):
        c.webgame_num = Webgame.query_num()
        c.webgame_news_num = WebgameNews.query_num()
        c.today_news_num = Stat.current().today_news_num
        c.card_num = Card.query_num()
        c.webgame_news = WebgameNews.query({}, limit = 25, sort = [("score", pymongo.DESCENDING), ("timestamp", pymongo.DESCENDING)])
        return render('/home/index.mako.html')
    
    def tuan(self):
        return render('/home/tuan.mako.html')
        
    def shop(self):
        return render('/home/shop.mako.html')    
    
    def bussiness(self):
        return render("/home/bussiness.mako.html")
    
    def help(self):
        c.fls = Friendlink.query({})
        return render('/home/help.mako.html')      
    
    def friend_link(self):
        c.fls = Friendlink.query({})
        return render('/home/friend_link.mako.html')

