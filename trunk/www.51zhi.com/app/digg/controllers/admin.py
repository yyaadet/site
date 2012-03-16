#coding=utf-8
import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from routes.util import *

from digg.lib.base import BaseController, render
from digg.lib.helpers import *
from digg.lib.utils import *

from digg.model.all_table import *

import md5
import time
import pymongo

log = logging.getLogger(__name__)


class AdminController(BaseController):
    def __init__(self):
        super(AdminController, self).__init__()
        if not (self.uid and self.is_admin == 1):
            abort(405, "You arn't admin")
    	    
    def index(self):
        return render('/admin/index.mako.html')
    	
    def user_list(self):
        limit = 25
        page_num = 10
        cond = {}

        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        skip = (c.page - 1) * limit

        c.objs = User.query(cond, skip = skip, limit = limit, sort = [("reg_timestamp", pymongo.DESCENDING)])

        c.total_pages = User.query_num(cond) / limit + 1

        c.start_page = int((c.page -1) / page_num) * page_num + 1

        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages

    	return render('/admin/user.mako.html')

    def user_set_is_admin(self):
        u = User.get_data(self.uid)
        if not u:
            return goto_tip(u"not found user")
        if u.is_admin == 0:
            u.is_admin = 1
        else:
            u.is_admin = 0
        User.put_data(u)
        return redirect("/admin/user")
    #####################################################
    # send mail
    #####################################################
    def send_sys_mail(self):
        return render("/admin/send_sys_mail.mako.html")
    
    def do_send_sys_mail(self):
        to = request.params.get('to')
        title = request.params.get('title')
        cnt = request.params.get('cnt')
        is_broadcast = int(request.params.get('is_broadcast'))
        
        if not is_broadcast:
            u =User.query("name='%s'" % to)
            if not u:
                return goto_tip(u"该用户不存在")
            u = u[0]
            ret = send_email(u.email, title, cnt)
            return goto_tip(u"发送状态: %s, %s" % (bool(ret), u.email))
       
        send_email_all(title, cnt)
        return goto_tip(u'完成发送')

    #####################################################
    # friend link
    #####################################################    
    def friendlink(self):
        limit = 25
        page_num = 10
        cond = {}
               
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)
            
        c.is_in_home = request.params.get('is_in_home')
        if not c.is_in_home:
            c.is_in_home = 0
        else:
            c.is_in_home = int(c.is_in_home)
            cond['is_in_home'] = c.is_in_home
            
        skip = (c.page - 1) * limit
        
        c.objs = Friendlink.query(cond, skip = skip, limit = limit, sort = [("timestamp", pymongo.DESCENDING)])            
        
        c.total_pages = Friendlink.query_num(cond) / limit + 1
            
        c.start_page = int((c.page -1) / page_num) * page_num + 1
        
        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages

        return render("/admin/friendlink.mako.html")
        
    def friendlink_add(self):
        return render("/admin/friendlink_add.mako.html")
        
    def friendlink_add_do(self):
        name = request.params.get('name')
        url = request.params.get('url')
        is_in_home = int(request.params.get('is_in_home'))
        is_hot = int(request.params.get('is_hot'))
        order = int(request.params.get('order'))
        
        if not name:
            return goto_tip(u'请输入名称')
        if not url:
            return goto_tip(u'请输入url')
        
        obj = Friendlink.new_obj()
        obj.name = name
        obj.url = safe_url(url)
        obj.is_in_home = is_in_home
        obj.is_hot = is_hot
        obj.order = order
        obj.timestamp = int(time.time())
        Friendlink.put_data(obj)
        return redirect('/admin/friendlink')
        
    def friendlink_edit(self):
        self.check()
        id = request.params.get('id')
        if not id:
            return goto_tip("not found id")
        c.obj = Friendlink.get_data(id)
        return render('/admin/friendlink_edit.mako.html')
        
    def friendlink_edit_do(self):
        self.check()
        id = request.params.get('id')
        name = request.params.get('name')
        url = request.params.get('url')
        is_in_home = int(request.params.get('is_in_home'))
        is_hot = int(request.params.get('is_hot'))
        order = int(request.params.get('order'))
        obj = Friendlink.get_data(id)
        
        if not obj:
            return goto_tip(u"该友情链接不存在了")
        if not name:
            return goto_tip(u'请输入名称')
        if not url:
            return goto_tip(u'请输入url')
            
        obj.name = name
        obj.url = safe_url(url)
        obj.is_in_home = is_in_home
        obj.is_hot = is_hot
        obj.order = order
        Friendlink.put_data(obj)
        return redirect('/admin/friendlink')
        
    def friendlink_rem(self):
        self.check()
        id = request.params.get('id')
        if not id:
            return goto_tip("not found id")
        obj = Friendlink.get_data(id)
        if not obj:
            return goto_tip("not found friendlink")
        Friendlink.rem_data(obj)
        return redirect('/admin/friendlink')

    #####################################################
    # feed
    #####################################################
    def feed(self):
        limit = 25
        page_num = 10
        cond = {}

        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)

        skip = (c.page - 1) * limit

        c.objs = Feed.query(cond, skip = skip, limit = limit, sort = [("timestamp", pymongo.DESCENDING)])

        c.total_pages = Feed.query_num(cond) / limit + 1

        c.start_page = int((c.page -1) / page_num) * page_num + 1

        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages

        return render("/admin/feed.mako.html")

    def feed_add(self):
        return render("/admin/feed_add.mako.html")

    def feed_add_do(self):
        name = request.params.get('name')
        url = request.params.get('url')
        num = int(request.params.get('num'))
        
        if not name:
            return goto_tip(u'请输入名称')
        if not url:
            return goto_tip(u'请输入url')

        obj = Feed.new_obj()
        obj.name = name
        obj.url = safe_url(url)
        obj.num = num
        obj.timestamp = int(time.time())
        Feed.put_data(obj)
        return redirect('/admin/feed')

    def feed_edit(self):
        self.check()
        id = request.params.get('id')
        if not id:
            return goto_tip("not found id")
        c.obj = Feed.get_data(id)
        return render('/admin/feed_edit.mako.html')

    def feed_edit_do(self):
        self.check()
        id = request.params.get('id')
        name = request.params.get('name')
        url = request.params.get('url')
        num = int(request.params.get('num'))
        obj = Feed.get_data(id)

        if not obj:
            return goto_tip(u"该feed不存在了")
        if not name:
            return goto_tip(u'请输入名称')
        if not url:
            return goto_tip(u'请输入url')

        obj.name = name
        obj.url = safe_url(url)
        obj.num = num
        Feed.put_data(obj)
        return redirect('/admin/feed')

    def feed_rem(self):
        self.check()
        id = request.params.get('id')
        if not id:
            return goto_tip("not found id")
        obj = Feed.get_data(id)
        if not obj:
            return goto_tip("not found feed")
        Feed.rem_data(obj)
        return redirect('/admin/feed')

    #####################################################
    # setting
    #####################################################
    def setting(self):
        return render('/admin/setting.mako.html')

    def setting_edit(self):
        upload_dir = request.params.get('upload_dir')
        static_addr = request.params.get('static_addr')
        is_use_static_url = int(request.params.get('is_use_static_url'))
        seo_title = request.params.get("seo_title")
        seo_keywords = request.params.get("seo_keywords")
        seo_desc = request.params.get("seo_desc")
        
        c.setting.upload_dir = upload_dir
        c.setting.static_addr = static_addr
        c.setting.is_use_static_url = is_use_static_url
        c.setting.seo_title = seo_title
        c.setting.seo_keywords = seo_keywords
        c.setting.seo_desc = seo_desc
        Setting.put_data(c.setting)
            
        return redirect('/admin/setting') 

        
