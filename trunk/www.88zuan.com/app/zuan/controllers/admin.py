#coding=utf-8
import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from routes.util import *

from zuan.lib.base import BaseController, render, ADMIN_COOKIE, ADMIN_UID_COOKIE
from zuan.lib.helpers import *
from zuan.lib.utils import *

from zuan.model.all_table import *
from zuan.controllers.flash_game import *

import md5
import time

log = logging.getLogger(__name__)

MAX_WIDTH = 800
MAX_HEIGHT = 600


class AdminController(BaseController):
    def index(self):
        self.check()
        return render('/admin/index.mako.html')

    def login(self):
        if c.admin_name:
            return redirect("/admin/index")
        c.reason = request.params.get("reason")
        return render("/admin/login.mako.html")
        
    def do_login(self):
    	username = request.params.get("username")
    	passwd = request.params.get("passwd")
    	
    	passwd = md5.md5(passwd).hexdigest()
    	
    	u = Admin.query({"name": username})
    	if not u:
    	    return redirect(url_for(controller='admin', action='login', reason="not found user"))
        u = u[0]
    	if u.password != passwd:
            return redirect(url_for(controller='admin', action='login', reason="password input error"))
    		
    	set_cookie(ADMIN_COOKIE, username)
    	
    	return redirect('/admin/index')

    def logout(self):
    	remove_cookie(ADMIN_COOKIE)
        return redirect("/admin/login")
        
    def reset_passwd(self):
    	self.check()
    	c.error = request.params.get('error')
    	return render('/admin/reset_passwd.mako.html')
    	
    def do_reset_passwd(self):
    	self.check()
    	old_passwd = request.params.get('old_passwd')
    	new_passwd = request.params.get('new_passwd')
    	new_passwd1 = request.params.get('new_passwd1')
    	
    	u = Admin.query({'name': self.admin_name})[0]
    	if not old_passwd or md5.md5(old_passwd).hexdigest() != u.password:
    	    return redirect(url_for(controller='admin', action='reset_passwd', error = u'密码错误'))
    	if new_passwd != new_passwd1:
    	    return redirect(url_for(controller='admin', action='reset_passwd', error = u'两次输入密码不一致'))
    	u.password = md5.md5(new_passwd).hexdigest()
    	Admin.put_data(u.id, u)
    	return render('/admin/reset_passwd.mako.html')
    #####################################################
    # flash game
    #####################################################
    def flash_game(self):
        self.check()
        return render('/admin/flash_game.mako.html')
        
    def flash_game_edit(self):
        self.check()
        id = request.params.get('id')
        c.obj = FlashGame.get_data(id)
        if not c.obj:
            return goto_tip(u'%s 不存在' % id)
        return render('/admin/flash_game_edit.mako.html')
        
    def flash_game_edit_do(self):
        id = request.params.get('id')
        name = request.params.get('name')
        fil = request.POST.get('file')
        pic = request.POST.get('pic')
        group_id = request.params.get('group')
        info = request.params.get('info')
        operate_info = request.params.get('operate_info')
        author = request.params.get('author')
        phone = request.params.get('phone')
        width = int(request.params.get('width'))
        height = int(request.params.get('height'))
        obj = FlashGame.get_data(id)
            
        if not obj:
            return goto_tip(u'该游戏已经不存在了')
            
        if not name:
            return goto_tip(u'请输入游戏名称')
        
        old = FlashGame.query({'name': name})
        if old and old[0]._id != id:
            return goto_tip(u'%s 已经被使用了' % name)
                                    
        if fil:
            if get_file_tail(fil.filename) != 'swf':
                return goto_tip(u'必须是swf文件')
            
        if pic:
            tail = get_file_tail(pic.filename)
            if not is_img(tail):
                 return goto_tip(u'图片格式不支持')
        
        if not group_id:
            return goto_tip(u'请选择游戏类型')                            
        group_id = int(group_id)
        
        if not info:
            return goto_tip(u'请输入游戏简介')
      
        if not operate_info:
            return goto_tip(u'请输入操作说明')
        
        if not author:
            return goto_tip(u'请输入名称')
      
        obj.name = name
        obj.group_id = group_id
        obj.info = info
        obj.operate_info = operate_info
        obj.author = author
        obj.phone = phone
        obj.width = width
        obj.height = height
        FlashGame.put_data(obj)
        
        #write to disk
        if fil:
             path = get_flash_game_path(c.setting, obj._id)
             f = open(path, 'wb')
             shutil.copyfileobj(fil.file, f)
             f.close()
             fil.file.close()
             obj.file_path = path
             obj.file_size = os.path.getsize(path)
         
        if pic:
             path = get_flash_game_pic_path(c.setting, obj._id, tail)
             f = open(path, 'wb')
             shutil.copyfileobj(pic.file, f)
             f.close()
             pic.file.close()
             obj.pic_path = path
        
        FlashGame.put_data(obj)             
        return redirect("/admin/flash_game_edit?id=" + obj._id)

    def flash_game_rem(self):
        self.check()
        id = request.params.get("id")
        delete_flash_game(id)
        return goto_tip(u"成功删除")

    def flash_game_add(self):
        self.check()
        return render('/admin/flash_game_add.mako.html')

    def flash_game_add_do(self):
        self.check()
        name = request.params.get('name')
        fil = request.POST['file']
        pic = request.POST['pic']
        group_id = request.params.get('group')
        info = request.params.get('info')
        operate_info = request.params.get('operate_info')
        author = request.params.get('author')
        phone = request.params.get('phone')
        width = int(request.params.get('width'))
        height = int(request.params.get('height'))

        if width > MAX_WIDTH:
            width = MAX_WIDTH
        if height > MAX_HEIGHT:
            height = MAX_HEIGHT

        if not name:
            return  u'请输入游戏名称'

        if FlashGame.query_num({"name": name}) > 0:
            return u"%s 已经存在了" % name

        if english_name and FlashGame.query_num({"english_name": english_name}) > 0:
            return u"%s 已经被使用了" % english_name

        if fil == '':
            if not external_file_path:
                return u'请选择游戏文件'

        if fil != '' and get_file_tail(fil.filename) != 'swf':
            return u'文件格式必须为swf'

        if pic == '':
            return u'请选择游戏封面'

        tail = get_file_tail(pic.filename)
        if not is_img(tail):
            return u'图片格式不支持'

        if not group_id:
            return u"请选择游戏类型"
        group_id = int(group_id)

        if not info:
            return u'请输入游戏简介'

        if not operate_info:
            return u'请输入操作说明'

        if not author:
            return u'请输入名称'

        obj = FlashGame.new_obj()
        obj.uid = self.uid
        obj.name = name
        obj.english_name = english_name
        obj.group_id = group_id
        obj.info = info
        obj.operate_info = operate_info
        obj.author = author
        obj.phone = phone
        obj.width = width
        obj.height = height
        obj.timestamp = int(time.time())
        FlashGame.put_data(obj)

        #write to disk
        small_path = get_flash_game_small_pic_path(c.setting, obj._id, tail)
        path = get_flash_game_pic_path(c.setting, obj._id, tail)
        f = open(path, 'wb')
        shutil.copyfileobj(pic.file, f)
        f.close()
        pic.file.close()
        obj.pic_path = path
        #resize img
        resize_img(path, path, BIG_IMG_SIZE)
        resize_img(path, small_path, SMALL_IMG_SIZE)

        if fil != '':
            tail = get_file_tail(fil.filename)
            path = get_flash_game_path(c.setting, obj._id, tail)
            f = open(path, 'wb')
            shutil.copyfileobj(fil.file, f)
            f.close()
            fil.file.close()
            obj.file_path = path
            obj.file_size = os.path.getsize(path)

        FlashGame.put_data(obj)

        return '1'

    #####################################################
    # friend link
    #####################################################    
    def friendlink(self):
        self.check()
        limit = 48
        page_num = 10
        cond = ""
        
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)
            
        skip = (c.page - 1) * limit
        cond = {}
        if c.group_id:
            cond = {"group_id": c.group_id}

        c.objs = Friendlink.query(cond, skip = skip, limit = limit, sort = [("is_in_home", pymongo.DESCENDING)])
        c.total_pages = Friendlink.query_num() / limit + 1
        
        c.start_page = int((c.page -1) / page_num) * page_num + 1
        
        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        return render("/admin/friendlink.mako.html")
        
    def friendlink_add(self):
        self.check()
        return render("/admin/friendlink_add.mako.html")
        
    def friendlink_do_add(self):
        self.check()
        name = request.params.get('name')
        url = request.params.get('url')
        is_in_home = request.params.get('is_in_home')
        
        if not name:
            return goto_tip(u'请输入名称')
        if not url:
            return goto_tip(u'请输入url')
        if not is_in_home:
            return goto_tip(u'请选择是否在主页显示')
        
        obj = Friendlink.new_obj()
        obj.name = name
        obj.url = url
        obj.is_in_home = is_in_home
        obj.add_timestamp = int(time.time())
        Friendlink.put_data(obj)
        return redirect('/admin/friendlink')
        
    def friendlink_edit(self):
        self.check()
        id = request.params.get('id')
        if not id:
            return goto_tip("not found friendlink id")
        c.friendlink = Friendlink.get_data(id)
        return render('/admin/friendlink_edit.mako.html')
        
    def friendlink_do_edit(self):
        self.check()
        id = request.params.get('id')
        name = request.params.get('name')
        url = request.params.get('url')
        is_in_home = request.params.get('is_in_home')
        obj = Friendlink.get_data(id)
        
        if not obj:
            return goto_tip(u"该友情链接不存在了")
        if not name:
            return goto_tip(u'请输入名称')
        if not url:
            return goto_tip(u'请输入url')
        if not is_in_home:
            return goto_tip(u'请选择是否在主页显示')
        
        obj.name = name
        obj.url = url
        obj.is_in_home = is_in_home
        Friendlink.put_data(obj)
        return redirect('/admin/friendlink')
        
    def friendlink_rem(self):
        self.check()
        id = request.params.get('id')
        if not id:
            return redirect('/admin/friendlink')
        obj = Friendlink.get_data(id)
        Friendlink.rem_data(obj)
        return redirect('/admin/friendlink')
        
    def it(self):
        self.check()
        return render("/admin/play_log.mako.html")
    
    #####################################################
    # setting
    #####################################################
    def setting(self):
        self.check()
        c.setting = Setting.get()
        return render('/admin/setting.mako.html')

    def do_setting(self):
        self.check()
        upload_dir = request.params.get('upload_dir')
        static_addr = request.params.get('static_addr')
        is_use_static_url = int(request.params.get('is_use_static_url'))
        seo_title = request.params.get("seo_title")
        seo_keywords = request.params.get("seo_keywords")
        seo_desc = request.params.get("seo_desc")
        
        setting = Setting.get()
        if setting:
            setting.upload_dir = upload_dir
            setting.static_addr = static_addr
            setting.is_use_static_url = is_use_static_url
            setting.seo_title = seo_title
            setting.seo_keywords = seo_keywords
            setting.seo_desc = seo_desc
            Setting.put_data(setting)
            
        return redirect('/admin/setting') 

        
