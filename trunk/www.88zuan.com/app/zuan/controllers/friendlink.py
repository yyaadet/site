#coding=utf-8

import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from pylons.decorators import *

from zuan.lib.base import BaseController, render
from zuan.lib.helpers import *


from zuan.model.all_table import *
from zuan.controllers.user import UserController

import md5

log = logging.getLogger(__name__)

class FriendlinkController(UserController):        
    @jsonify
    def query(self):
        limit = request.params.get('limit')
        if not limit:
            limit = 10
        else:
            limit = int(limit)
        
        page = request.params.get('page')
        if not page:
            page = 0
        else:
            page = int(page)
            
        cond = request.params.get('cond')

        data = Friendlink.query_page(cond, page, limit)
                
        return data
    
    @jsonify
    def total(self):
        cond = request.params.get('cond')
        cnt = Friendlink.query_num(cond)
        return [cnt]
        
