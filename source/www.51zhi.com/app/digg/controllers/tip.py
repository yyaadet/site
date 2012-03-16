#coding=utf-8

import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from pylons.decorators import *

from digg.lib.base import BaseController, render
from digg.lib.helpers import *

log = logging.getLogger(__name__)

class TipController(BaseController):
    def index(self):
        c.tip = request.params.get('tip')
        return render('/tip/index.mako.html')
        
