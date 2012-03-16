#coding=utf-8
import logging
import time

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from pylons.decorators.cache import beaker_cache

from feed.lib.base import BaseController, render
from feed.lib.helpers import *
from feed.model.all_table import *


import pymongo

log = logging.getLogger(__name__)

class HomeController(BaseController):
    #@beaker_cache(expire=3600)
    def index(self):
        return render('/home/index.mako.html')
    
    def tuan(self):
        return render('/home/tuan.mako.html')
        
    def shop(self):
        return render('/home/shop.mako.html')    
    
    def bussiness(self):
        return render("/home/bussiness.mako.html")
    
    def help(self):
        return render('/home/help.mako.html')      
    
    def friend_link(self):
        c.fls = Friendlink.query({})
        return render('/home/friend_link.mako.html')
