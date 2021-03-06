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
from feed.lib.qq import  *

log = logging.getLogger(__name__)

class UserController(BaseController):
    def index(self):
        self.check()
        limit = 25
        page_num = 10
        rss_id = request.params.get('rss_id')
        cond = {'uid': c.user._id}

        if rss_id:
            cond['feed_id'] = rss_id
            c.rss_id = rss_id
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)
        skip = (c.page - 1) * limit
        c.objs = News.query(cond, skip = skip, limit = limit, sort = [("timestamp", pymongo.DESCENDING)])
        c.total_pages = News.query_num(cond) / limit + 1
        c.start_page = int((c.page -1) / page_num) * page_num + 1
        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        return render('/user/index.mako.html')
        
    def join_rss(self):
        self.check()
        rss_id = request.params.get('rss_id')
        old_obj = Rss.get_data(rss_id)
        if not old_obj:
            return goto_tip(u"订阅已经不存在了")
        if old_obj.is_del == 1:
            return goto_tip(u"订阅已经被删除")
        if old_obj.uid == c.user._id:
            return goto_tip(u"该订阅您已经订阅了")
        obj = Rss.new_obj()
        obj.url = old_obj.url
        obj.name = old_obj.name
        obj.uid = c.user._id
        obj.uname = c.user.name
        obj.add_timestamp = int(time.time())
        obj.group_id = old_obj.group_id
        Rss.put_data(obj)
        return redirect("/rss/index")

    def login(self):
        c.name = request.params.get('name')
        return render("/user/login.mako.html")

    def _post_login(self, u):
        u.last_login_timestamp = int(time.time())
        u.last_login_ip = request.ip
        User.put_data(u)
        gen_signature(u)

    def do_login(self):
        username = request.params.get("username")
        passwd = request.params.get("passwd")
        passwd = md5.md5(passwd).hexdigest()
        
        u = User.query({'name': username})
        if not u:
            return goto_tip(u'用户不存在')
        u = u[0]    
        if u.passwd != passwd:
            return goto_tip(u'密码不对')
        self._post_login(u)
        return redirect('/user/index')
        
    def find_passwd(self):
        return render("/user/find_passwd.mako.html")
        
    def do_find_passwd(self):
        email = request.params.get('email')
        if not email:
            return goto_tip(u"请输入邮箱")
        objs = User.query({"email": email}, limit = 1)
        if not objs:
            return goto_tip(u"非法邮箱")
        u = objs[0]
        u.find_passwd_timestamp = int(time.time())
        User.put_data(u)
        body = u"点击如下链接，找回密码：<br />"
        body += site_url("/user/done_find_passwd?uid=" + u._id)
        send_mail(email, u"找回密码", body)
        return goto_tip(u"去邮箱查看找回密码")
        
    def done_find_passwd(self):
        now = int(time.time())
        uid = request.params.get('uid')
        u = User.get_data(uid)
        if not u:
            return goto_tip(u"用户不存在了")
        c.user = u
        if now - u.find_passwd_timestamp > 3600:
            url = site_url("/user/done_find_passwd?uid=" + u._id)
            return goto_tip(u"链接过时，重新<a href=\"%s\">找回密码</a>" % url)
        return render("/user/done_find_passwd.mako.html")
    
    def do_done_find_passwd(self):
        passwd = request.params.get('passwd')
        passwd1 = request.params.get('passwd1')
        uid = request.params.get('uid')
        u = User.get_data(uid)
        if not u:
            return goto_tip(u"用户不存在了")
        if passwd != passwd1:
            return goto_tip(u"两次输入密码不对")
        u.passwd = md5.md5(passwd).hexdigest()
        User.put_data(u)
        return goto_tip(u"设置新密码成功，现在去登陆")
        
    def reg(self):
        c.reason = request.params.get('reason')
        return render("/user/reg.mako.html")
        
    def do_reg(self):
        username = request.params.get('username')
        passwd = request.params.get('passwd')
        passwd1 = request.params.get('passwd1')
        email = request.params.get('email')
        
        if not username:
            return goto_tip(u'用户名不能为空')
        
        if has_cn_char(username):
            return goto_tip(u'用户名不能包含中文字符')
            
        if len(username) >= 20:
            return goto_tip(u'名称不能超过20个字符')
            
        if not passwd:
            return goto_tip(u'密码不能为空')
        
        if passwd != passwd1:
            return goto_tip(u'两次输入密码不一致')
        
        if not email:
            return goto_tip(u'请输入Email')
            
        if User.query({'name': username}):
            return goto_tip(u'该用户名已经被其他人使用了')
            
        u = User.new_obj()
        u.name = username
        u.passwd = md5.md5(passwd).hexdigest()
        u.email = email
        u.reg_ip = request.ip
        u.reg_timestamp = int(time.time())
        u.last_login_timestamp = int(time.time())
        User.put_data(u)
         
        return goto_tip(u"注册成功，现在登录")

    def logout(self):
        remove_cookie(USER_ID_COOKIE)
        remove_cookie(USER_IS_ADMIN_COOKIE)
        remove_cookie(USER_SIGNATURE_COOKIE)
        return redirect('/')
           
    def reset_passwd(self):
        self.check()
        c.error = request.params.get('error')
        return render('/user/reset_passwd.mako.html')
        
    def do_reset_passwd(self):
        self.check()
        passwd = request.params.get('passwd')
        old_passwd = request.params.get('old_passwd')
        passwd1 = request.params.get('passwd1')
        
        u = self.user
        if not u:
            return goto_tip(u'用户不存在')
        if passwd != passwd1:
            return goto_tip(u'密码不一致')
        if md5.md5(old_passwd).hexdigest() != u.passwd:
            return goto_tip(u'密码错误')
        u.passwd = md5.md5(passwd).hexdigest()
        User.put_data(u)
        return redirect('/user/index')

#  for qq auth 1.0
    def qq_login(self):
        req_tokens = QQ.get_request_token()
        #save it for later
        session['oauth_token'] = req_tokens['oauth_token']
        session['oauth_token_secret'] = req_tokens['oauth_token_secret']
        session.save()
        auth_url = QQ.get_access_token_url(req_tokens['oauth_token'], site_url("/user/qq_access_token"))
        return redirect(auth_url)

    def qq_access_token(self):
        params = request.params
        token = params.get('oauth_token')
        vericode = params.get('oauth_vericode')
        token_secret = session["oauth_token_secret"]
        #get access token now
        result = QQ.get_access_token(token, token_secret, vericode)
        #get old openid
        u = None
        users = User.query({'openid': result['openid']})
        if not users:
            u = User.new_obj()
            u.openid = result['openid']
            u.token = result['oauth_token']
            u.token_secret = result['oauth_token_secret']
            user_info = QQ.get_user_info(u.token, u.token_secret, u.openid)
            u.name = user_info['nickname']
            u.reg_timestamp = int(time.time())
            u.last_login_timestamp = int(time.time())
            User.put_data(u)
        else:
            u = users[0]
            u.openid = result['openid']
            u.token = result['oauth_token']
            u.token_secret = result['oauth_token_secret']
            user_info = QQ.get_user_info(u.token, u.token_secret, u.openid)
            u.name = user_info['nickname']
            u.last_login_timestamp = int(time.time())
            User.put_data(u)

        self._post_login(u)
        return redirect(site_url("/"))

#  for qq auth 2.0