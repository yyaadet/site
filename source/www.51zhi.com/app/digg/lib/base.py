"""The base Controller API

Provides the BaseController class for subclassing.
"""
from pylons import request
from pylons.controllers import WSGIController
from pylons.templating import render_mako as render
from helpers import *
from digg.model.all_table import *

import time
import logging
import sys
import traceback
import md5

loger = logging.getLogger(__name__)

exception_logging = True

USER_NAME_COOKIE="digg_uname"
USER_ID_COOKIE="digg_uid"
USER_IS_ADMIN_COOKIE = "digg_is_admin"
USER_SIGNATURE_COOKIE = "digg_signature"

def gen_signature(u):
    sig = md5.md5("%s%s"% (u._id, u.is_admin)).hexdigest()
    set_cookie(USER_ID_COOKIE, u._id)
    set_cookie(USER_IS_ADMIN_COOKIE, u.is_admin)
    set_cookie(USER_SIGNATURE_COOKIE, sig)

def check_signature():
    id = get_cookie(USER_ID_COOKIE)
    is_admin = get_cookie(USER_IS_ADMIN_COOKIE)
    signature = get_cookie(USER_SIGNATURE_COOKIE)
    if md5.md5("%s%s"% (id, is_admin)).hexdigest() != signature:
        remove_cookie(USER_ID_COOKIE)
        remove_cookie(USER_IS_ADMIN_COOKIE)
        remove_cookie(USER_SIGNATURE_COOKIE)
        return False
    return True

class BaseController(WSGIController):
    def __init__(self):
            self.uid = get_cookie(USER_ID_COOKIE)
            self.is_admin = get_cookie(USER_IS_ADMIN_COOKIE)
            if self.is_admin:
                self.is_admin = int(self.is_admin)
            c.uid = self.uid
            c.is_admin = self.is_admin
            setting = Setting.query({})
            if not setting:
                c.setting = Setting.new_obj()
            else:
                c.setting = setting[0]
            self.user = None
            self.username = ""
            c.username = ""
            if self.uid:
                self.user = User.get_data(self.uid)
                self.username = self.user.name
                c.username = self.username
            c.user = self.user
            check_signature()

    def check(self):
        if not self.uid:
            return redirect('/user/login')

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
        