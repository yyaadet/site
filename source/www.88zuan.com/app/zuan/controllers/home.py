import logging
import time

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from beaker.cache import cache_region
from pylons.decorators.cache import beaker_cache

from zuan.lib.base import BaseController, render
from zuan.lib.helpers import *
from zuan.model.all_table import *
from zuan.controllers.flash_game import GROUP_INFO

import pymongo

log = logging.getLogger(__name__)

class HomeController(BaseController):
    @beaker_cache(expire=600)
    def index(self):
        #del response.headers['Cache-Control']
        #del response.headers['Pragma']
        #response.cache_expires(seconds=3600)
        limit = 6
        #fetch from memcache
        c.fgs = {}
        for info in GROUP_INFO:
            cond = {"group_id": info[0]}
            c.fgs[info[0]] = FlashGame.query(cond, limit = limit, sort = [("score", pymongo.DESCENDING)])
            
        return render('/home/index.mako.html')
        
    def bussiness(self):
        return render("/home/bussiness.mako.html")
    
    def friend_link(self):
        c.fls = Friendlink.query("is_in_home=1")
        return render('/home/friend_link.mako.html')        
