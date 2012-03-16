"""The base Controller API

Provides the BaseController class for subclassing.
"""
from pylons.controllers import WSGIController
from pylons.templating import render_mako as render
from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from zuan.model.setting import *

import time
import traceback
import sys

ADMIN_COOKIE="zuanadmin"
ADMIN_UID_COOKIE="zuanadminuid"

class BaseController(WSGIController):
    def __init__(self):
        from helpers import get_cookie
        c.setting = Setting.get()
        c.admin_name = get_cookie(ADMIN_COOKIE)

    def check(self):
        if not (c.admin_name):
            return redirect("/admin/login")
        
    def __call__(self, environ, start_response):
        true_client_ip = environ.get('HTTP_TRUE_CLIENT_IP')
        forwarded_for = environ.get('HTTP_X_FORWARDED_FOR', ())
        remote_addr = environ.get('REMOTE_ADDR')

        if forwarded_for:
            request.ip = forwarded_for.split(',')[-1]
        else:
            request.ip = environ['REMOTE_ADDR']

        request.get = request.GET
        request.post = request.POST
        request.referer = environ.get('HTTP_REFERER')
        request.url_path = environ.get('PATH_INFO')
        request.user_agent = environ.get('HTTP_USER_AGENT')
        request.fullpath = environ.get('FULLPATH', request.path)
        request.port = environ.get('request_port')

        res = None
        try:
            res = WSGIController.__call__(self, environ, start_response)
        except Exception, e:
            traceback.print_exc(file=sys.stdout)
        return res

