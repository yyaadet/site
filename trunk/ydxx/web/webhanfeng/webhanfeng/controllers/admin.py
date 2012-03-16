# -*- coding: utf-8 -*-
import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to
from webhanfeng.lib.utils import *
from webhelpers    import paginate

import time
import cStringIO

from webhanfeng.lib.base import BaseController
from webhanfeng.model.join import *
from pylons.templating import render_mako as render

log = logging.getLogger(__name__)

def validate_user(fun):
    def _valid(*args):
        if c.username is None:
            return redirect_to("/admin/login")
        else:
            return fun(*args)
    return _valid

class AdminController(BaseController):

    def __init__(self):
        BaseController.__init__(self)
        c.per_pages = force_int(get_cookie("per_page",10))
        c.error = get_params("error", "")
        c.page_num = force_int(get_params('page', 1))
        c.action = get_params("action", "").lower()
        c.username = get_cookie("username")

    def login(self):
        if c.action == "login":
            username = get_params("username", "")
            password = get_params("password", "")
            admin = get_admin_by_name(username)
            if admin is None:
                msg = u'用户名不存在'
                return redirect_to("/admin/login",error=msg)
            elif admin.password !=  md5.md5(password).hexdigest():
                msg = u'密码错误'
                return redirect_to("/admin/login",error=msg)
            else:
                set_cookie("username", username, '/', 24*3600)
                return redirect_to("/admin/index")
        return render("/admin/login.html")

    @validate_user
    def index(self):
        return render("/admin/index.html")

    def logout(self):
        remove_cookie("username")
        return redirect_to("/admin/login")

    def set_page(self):
        per_page = force_int(get_params("per_page", 10))
        url = get_params("url", '/admin/index')
        set_cookie("per_page", per_page, '/', 24*3600)
        return redirect_to(url.encode('utf8'))
 
    @validate_user
    def lock_user(self):
        if c.action == "lock":
            id = force_int(get_params("id",0))
            update_user_locked(id)
            return '1'
        elif c.action == "unlock":
            id = force_int(get_params("id",0))
            update_user_unlocked(id)
            return '1'
    
    @validate_user
    def user_list(self):
        c.self_url = get_self_url()
        c.flag = get_params("flag", "")
        limit = c.per_pages
        offset = (c.page_num - 1) * limit
        if c.action == "search":
            c.s_name = get_params("s_name", "")
            name = "%" + c.s_name + "%"
            c.total = get_userlist_name_like_count(name)
            c.data = get_userlist_name_like(name,offset,limit)
            return render("/admin/userlist.html")
        elif c.action == "locked":
            c.total = get_userlist_locked_count()
            c.data = get_userlist_locked(offset,limit)
            return render("/admin/userlist.html")
        elif c.action == "onlinetime":
            c.total = get_userlist_count()
            c.data = get_userlist_onlinetime(offset,limit)
            return render("/admin/userlist.html")
        elif c.action == "gaming":
            c.total = get_userlist_gaming_count()
            c.data = get_userlist_gaming(offset,limit)
            return render("/admin/userlist.html")
        elif c.action == "lock":
            id = force_int(get_params("id",0))
            update_user_locked(id)
            return redirect_to("/admin/user_list")
        elif c.action == "unlock":
            id = force_int(get_params("id",0))
            update_user_unlocked(id)
            return redirect_to("/admin/user_list")
        elif c.action == "sort":
            c.total = get_user_count()
            c.upon = get_params("upon","id")
            c.sort = get_params("sort","desc")
            c.data = get_userlist_sort(c.upon,c.sort,offset,limit)
            return render("/admin/userlist.html")
        else:
            c.total = get_user_count()
            c.data = get_all_user(offset,limit)
            return render("/admin/userlist.html")

    @validate_user
    def gm_list(self):
        c.flag = get_params("flag", "")
        limit = c.per_pages
        offset = (c.page_num - 1) * limit
        if c.action == "search":
            c.s_name = get_params("s_name", "")
            name = "%" + c.s_name + "%"
            c.total = get_gmlist_name_like_count(name)
            c.data = get_gmlist_name_like(name,offset,limit)
            return render("/admin/gmlist.html")
        elif c.action == "add":
            a_name = get_params("a_name","")
            msg = ""
            user = get_user_by_oid(a_name)
            if user is None:
                msg = u'用户不存在'
            elif user.wid < 0:
                pass
            else:
                update_user_gm(user.id)
            return redirect_to("/admin/gm_list",error=msg)
        elif c.action == "del":
            id = force_int(get_params("id",0))
            update_user_gm(id)
            return redirect_to("/admin/gm_list")
        else:
            c.total = get_gm_count()
            c.data = get_all_gm(offset,limit)
            return render("/admin/gmlist.html")

    @validate_user
    def recharge_records(self):
        c.flag = get_params("flag", "")
        if c.action == "search":
            username = get_params("username", "")
            c.search_content = username
            name = "%" + username + "%"
            c.total = get_pay_name_like_count(name)
            c.data = get_pay_name_like(name)
            return render("/admin/recharge_records.html")
        else:
            c.total = get_pay_count()
            c.data = get_pay()
            return render("/admin/recharge_records.html")

    @validate_user
    def search_registed_users(self):
        now = time.strftime("%Y-%m-%d", time.localtime())
        c.start_time = get_params('start_time', now)
        start_time = c.start_time + " 00:00:00"
        try:
            s_time = time.mktime(time.strptime(start_time,"%Y-%m-%d %H:%M:%S"))
        except:
            s_time = 0
        c.end_time = get_params('end_time', now)
        end_time = c.end_time + " 23:59:59"
        e_time = time.mktime(time.strptime(end_time,"%Y-%m-%d %H:%M:%S"))
        
        limit = c.per_pages
        offset = (c.page_num - 1) * limit
        c.total = get_userlist_regist_time_count(s_time,e_time)
        c.data = get_userlist_regist_time(s_time,e_time,limit,offset)
        return render("/admin/search_registed_users.html")

    @validate_user
    def user_statistics(self):
        now = time.strftime("%Y-%m-%d", time.localtime())
        c.start_time = get_params('start_time', now)
        start_time = c.start_time + " 00:00:00"
        try:
            s_time = time.mktime(time.strptime(start_time,"%Y-%m-%d %H:%M:%S"))
        except:
            s_time = 0
        
        c.end_time = get_params('end_time', now)
        end_time = c.end_time + " 23:59:59"
        e_time = time.mktime(time.strptime(end_time,"%Y-%m-%d %H:%M:%S"))
        
        c.date = get_params('date', "day")
        if c.date == "day":
            format = "%Y-%m-%d (%W)"
        else:
            format = "%Y-%m"
        reg = get_user_regist_count(s_time,e_time,format)
        login = get_user_login_count(s_time,e_time,format)
        reg_data = map(list,reg)
        login_data = map(list,login)
        reg_date = [i for i,g in reg]
        login_date = [i for i,g in login]
        data2 = []
        for i in reg_data:
            for date,counts in login:
                if i[0] not in login_date:
                    i.append(0)
                    break
                elif date == i[0]:
                    i.append(counts)
                    break
        for date,counts in login:
            if date not in reg_date:
                data2.append([date,0,counts])
        data = reg_data + data2
        data.sort()
        c.data = data
        return render("/admin/user_statistics.html")

    @validate_user
    def cztj(self):
        format = "%Y-%m"
        tj = get_cztj(format)
        tj_data = map(list,tj)
        c.data = tj_data
        c.counts = get_cztj_counts()
        return render("/admin/cztj.html")

    @validate_user
    def game_gift(self):
        if c.action == "add":
            code_num = force_int(get_params("code_num",1))
            money = force_int(get_params("money",0))
            date = force_int(get_params("date",30))
            if date == 0:
                date = 30
            is_oneoff = force_int(get_params("is_oneoff",0))
            for i in range(code_num):
                new_game_gift(money ,date, is_oneoff)
            meta.Session.commit()
            return redirect_to("/admin/game_gift")
        elif c.action == "del":
            id = force_int(get_params("id",0))
            delete_game_gift_by_id(id)
            return redirect_to("/admin/game_gift")
        elif c.action == "del_more":
            params = get_all_params()
            for k,v in params.items():
                if v == "true":
                    key = k[2:]
                    delete_game_gift_by_id(force_int(key))
            return redirect_to("/admin/game_gift")
        elif c.action == "del_all":
            delete_game_gift_all()
            return redirect_to("/admin/game_gift")
        elif c.action == "export":
            export_code = get_all_game_gift_not_used()
            str_list = []
            out = cStringIO.StringIO()
            for codes in export_code:
                str_list.append("%s    %s    %s\r\n" % (codes.code, codes.money, codes.is_oneoff))
            out.write("".join(str_list))
            set_header('Content-type', 'text')
            set_header('Content-Disposition', 'attachment;filename=gift.txt')
            return out.getvalue()
        elif c.action == "geren":
            export_code = get_all_game_gift_geren()
            str_list = []
            out = cStringIO.StringIO()
            for codes in export_code:
                str_list.append("%s    %s\r\n" % (codes.code, codes.money))
            out.write("".join(str_list))
            set_header('Content-type', 'text')
            set_header('Content-Disposition', 'attachment;filename=geren.txt')
            return out.getvalue()
        elif c.action == "gonghui":
            export_code = get_all_game_gift_gonghui()
            str_list = []
            out = cStringIO.StringIO()
            for codes in export_code:
                str_list.append("%s    %s\r\n" % (codes.code, codes.money))
            out.write("".join(str_list))
            set_header('Content-type', 'text')
            set_header('Content-Disposition', 'attachment;filename=gonghui.txt')
            return out.getvalue()
        elif c.action == "huangjin":
            export_code = get_all_game_gift_huangjin()
            str_list = []
            out = cStringIO.StringIO()
            for codes in export_code:
                str_list.append("%s    %s\r\n" % (codes.code, codes.money))
            out.write("".join(str_list))
            set_header('Content-type', 'text')
            set_header('Content-Disposition', 'attachment;filename=huangjin.txt')
            return out.getvalue()
        else:
            limit = c.per_pages
            offset = (c.page_num - 1) * limit
            c.data = get_game_gift(offset,limit)
            c.total = get_game_gift_count()
            return render("/admin/game_gift.html")

    @validate_user
    def add_game_gift(self):
        return render("/admin/add_game_gift.html")

    @validate_user
    def maintainer(self):
        if c.action == "del":
            id = force_int(get_params("id", 0))
            del_admin_by_id(id)
            return redirect_to("/admin/maintainer")
        elif c.action == "add":
            group_id = force_int(get_params("group_id", 0))
            username = get_params("username", "")
            password = get_params("password", "")
            passwordconfirm = get_params("passwordconfirm", "")
            if password != passwordconfirm:
                msg = u"两次密码不一样"
                return redirect_to("/admin/add_maintainer",error=msg) 
            user = get_admin_by_name(username)
            if user != None:
                msg = u"用户名被占用"
                return redirect_to("/admin/add_maintainer",error=msg)
            else:
                new_admin(username,password,group_id)
                return redirect_to("/admin/maintainer")
        elif c.action == "edit":
            id = force_int(get_params("id", 0))
            group_id = force_int(get_params("group_id", 0))
            update_admin(id,group_id)
            return redirect_to("/admin/maintainer")
        else:
            limit = c.per_pages
            offset = (c.page_num - 1) * limit
            c.data = get_maintainer(offset,limit)
            c.total = get_maintainer_count()
            return render("/admin/maintainer.html")

    @validate_user
    def edit_maintainer(self):
        id = force_int(get_params("id", 0))
        c.admin,c.group = get_maintainer_by_id(id) 
        c.groups = get_all_group()
        return render("/admin/edit_maintainer.html")
    
    @validate_user
    def add_maintainer(self):
        c.groups = get_all_group()
        return render("/admin/add_maintainer.html")

    @validate_user
    def give_treasure(self):
        if c.action == "give":
            host = get_socket_ip()
            port = force_int(get_socket_port())
            username = get_params("username", "")
            treasure_name = get_params("treasure_name", "").strip()
            user = get_user_by_oid(username)
            treasure = get_shop_by_name(treasure_name)
            if user is None:
                msg = u"用户不存在"
                return redirect_to("/admin/give_treasure", error=msg)
            elif treasure is None:
                msg = u"道具不存在"
                return redirect_to("/admin/give_treasure", error=msg)
            else:
                res = donate(host, port, user.id, treasure.id)
                if res == 0:
                    msg = u"赠送失败"
                elif res == 1:
                    msg = u"赠送成功"
                else:
                    msg = u"出错了"
                return redirect_to("/admin/give_treasure", error=msg)
        return render("/admin/give_treasure.html")

    @validate_user
    def group(self):
        return "group"
        if c.action == "add":
            params = get_all_params()
            name = get_params("name", "")
            description = get_params("description", "")
            group = get_group_by_name(name)
            if name == "":
                return redirect_to("/admin/add_group",error="group name is empty")
            if group != None:
                return redirect_to("/admin/add_group",error="group name repeat")
            else:
                program = "g = new_group(name,description"
                for k,v in params.items():
                    if k != "action" and k != "name" and k != "description":
                        if v != "false":
                            program += ", %s=%s" % (k, 1)
                program += ")"
                print program
                exec(program)
                if g == None:
                    return redirect_to("/admin/add_group",error="fail to new group")
                else:
                    return redirect_to("/admin/group")
        elif c.action == "del":
            id = force_int(get_params("id", 0))
            del_group_by_id(id)
            return redirect_to("/admin/group")
        elif c.action == "view":
            id = force_int(get_params("id", 0))
            c.group = get_group_by_id(id)
            c.authority = get_authority_by_group_id(c.group.id)
            return render("/admin/view_group.html")
        elif c.action == "edit":
            params = get_all_params()
            name = get_params("name", "")
            description = get_params("description", "")
            id = force_int(get_params("id", 0))
            group = validate_group(id,name)
            if name == "":
                return redirect_to("/admin/edit_group",id=str(id),error="group name is empty")
            if group != None:
                return redirect_to("/admin/edit_group",id=str(id),error="group name repeat")
            else:
                program = "g = update_group(id,name,description"
                for k,v in params.items():
                    if k != "action" and k != "name" and k != "description" and k != "id":
                        if v != "false":
                            program += ", %s=%s" % (k, 1)
                program += ")"
                exec(program)
                if g == None:
                    return redirect_to("/admin/add_group",error="fail to new group")
                else:
                    return redirect_to("/admin/group")
        else:
            data = get_group()
            c.page = paginate.Page(data,  page=c.page_num, items_per_page=c.per_pages, 
                    sqlalchemy_session=meta.Session)
            return render("/admin/group.html")

    @validate_user
    def add_group(self):
        return render("/admin/add_group.html")

    @validate_user
    def server_url(self):
        if c.action == "edit":
            res_url = get_params("res_url", '')
            add_setting("res_url", res_url)
            redirect_url = get_params("redirect_url", '')
            add_setting("redirect_url", redirect_url)
            starpass_check = get_params("starpass_check", '')
            add_setting("starpass_check", starpass_check)
            help_url = get_params("help_url", '')
            add_setting("help_url", help_url)
            convert_money = get_params("convert_money", '')
            add_setting("convert_money", convert_money)
            msg = u"修改成功"
            return redirect_to("/admin/server_url", error=msg)
        else:
            c.res_url = get_res_url()
            c.redirect_url = get_redirect_url()
            c.starpass_check = get_starpass_check()
            c.help_url = get_help_url()
            c.convert_money = get_convert_money()
            return render("/admin/server_url.html")

    @validate_user
    def game_server(self):
        c.flag = get_params("flag", "")
        if c.action == "edit":
            socket_ip = get_params("socket_ip", '')
            add_setting("socket_ip", socket_ip)
            socket_port = get_params("socket_port", '')
            add_setting("socket_port", socket_port)
            flex_ip = get_params("flex_ip", '')
            add_setting("flex_ip", flex_ip)
            flex_port = get_params("flex_port", '')
            add_setting("flex_port", flex_port)
            server_name = get_params("server_name", '')
            add_setting("server_name", server_name)
            game_name = get_params("game_name", '')
            add_setting("game_name", game_name)
            msg = u"修改成功"
            return redirect_to("/admin/game_server", error=msg)
        else:
            c.socket_ip = get_socket_ip()
            c.socket_port = get_socket_port()
            c.flex_ip = get_flex_ip()
            c.flex_port = get_flex_port()
            c.server_name = get_server_name()
            c.game_name = get_game_name()
            return render("/admin/game_server.html")

    @validate_user
    def maintenance(self):
        if c.action == "edit":
            is_maintenance = get_params("is_maintenance", '')
            add_setting("is_maintenance", is_maintenance)
            maintenance_text = get_params("maintenance_text", '')
            add_setting("maintenance_text", maintenance_text)
            msg = u"修改成功"
            return redirect_to("/admin/maintenance", error=msg)
        else:
            c.is_maintenance = get_is_maintenance()
            c.maintenance_text = get_maintenance_text()
            return render("/admin/maintenance.html")

    @validate_user
    def invite(self):
        if c.action == "edit":
            need_invite = get_params("need_invite", '')
            add_setting("need_invite", need_invite)
            msg = u"修改成功"
            return redirect_to("/admin/invite", error=msg)
        else:
            c.need_invite = get_need_invite()
            return render("/admin/invite.html")

    @validate_user
    def pay_key(self):
        if c.action == "edit":
            pay_key = get_params("pay_key", '')
            add_setting("pay_key", pay_key)
            msg = u"修改成功"
            return redirect_to("/admin/pay_key", error=msg)
        else:
            c.pay_key = get_pay_key()
            return render("/admin/pay_key.html")

    @validate_user
    def rmb_to_gold(self):
        if c.username != "admin":
            redirect_to("/admin/login")
        if c.action == "edit":
            rate = get_params("rate", '')
            days = get_params("days", '')
            if rate == "":
                rate = "10"
            else:
                try:
                    tmp = int(rate)
                except:
                    msg = msg = u"比率错误"
                    return redirect_to("/admin/rmb_to_gold", error=msg)
            
            if days != "":
                try:
                    end_time = int(time.time()) + int(days)*24*60*60
                except:
                    msg = msg = u"有效时间错误"
                    return redirect_to("/admin/rmb_to_gold", error=msg)
            else:
                end_time = ""
            data = rate + ":" + str(end_time)
            add_setting("rmb_to_gold", data)
            msg = u"修改成功"
            return redirect_to("/admin/rmb_to_gold", error=msg)
        else:
            r_to_g = get_rmb_to_gold().split(":")
            if len(r_to_g) == 2:
                c.rate = r_to_g[0]
                c.end_time = force_int(r_to_g[1])
            elif len(r_to_g) == 1:
                c.rate = r_to_g[0]
                c.end_time = 0
            else:
                c.rate = "10"
                c.end_time = 0
            return render("/admin/rmb_to_gold.html")

    @validate_user
    def change_password(self):
        if c.action == "edit":
            password = get_params("password", "")
            password1 = get_params("password1", "")
            password2 = get_params("password2", "")
            m = get_admin_by_name(c.username)
            if m.password !=  md5.md5(password).hexdigest():
                msg = u"密码错误"
                return redirect_to("/admin/change_password", error=msg)
            if password1 == password:
                msg = u"密码不能和从前一样"
                return redirect_to("/admin/change_password", error=msg)
            if password1 != password2:
                msg = u"两次密码输入不一样"
                return redirect_to("/admin/change_password", error=msg)
            if password1 == "":
                msg = u"密码不能为空"
                return redirect_to("/admin/change_password", error=msg)    
            update_admin_password(m.id,password2)
            msg = u"提交成功"
            return redirect_to("/admin/change_password", error=msg)
        else:
            return render("/admin/change_password.html")

    @validate_user
    def report(self):
        if c.action == "del":
            id = force_int(get_params("id",0))
            delete_report_by_id(id)
            return redirect_to("/admin/report")
        elif c.action == "view":
            id = force_int(get_params("id",0))
            c.report = get_report_by_id(id)
            return render("/admin/view_report.html")
        elif c.action == "del_more":
            params = get_all_params()
            for k,v in params.items():
                if v == "true":
                    key = k[2:]
                    delete_report_by_id(force_int(key))
            return redirect_to("/admin/report")
        elif c.action == "del_all":
            delete_report_all()
            return redirect_to("/admin/report")
        else:
            limit = c.per_pages
            offset = (c.page_num - 1) * limit
            c.data = get_all_report(offset,limit)
            c.total = get_report_count()
            return render("/admin/report.html")

    @validate_user
    def invite_code(self):
        if c.action == "add":
            code_num = force_int(get_params("code_num",1))
            for i in range(code_num):
                new_invite_code(1)
            meta.Session.commit()
            return redirect_to("/admin/invite_code")
        elif c.action == "del":
            id = force_int(get_params("id",0))
            delete_invite_code_by_id(id)
            return redirect_to("/admin/invite_code")
        elif c.action == "del_more":
            params = get_all_params()
            for k,v in params.items():
                if v == "true":
                    key = k[2:]
                    delete_invite_code_by_id(force_int(key))
            return redirect_to("/admin/invite_code")
        elif c.action == "export":
            export_code = get_all_invite_code_not_used()
            str_list = []
            out = cStringIO.StringIO()
            for codes in export_code:
                str_list.append("%s\n" % codes.code)
            out.write("".join(str_list))
            set_header('Content-type', 'text')
            set_header('Cache-control', 'no')
            return out.getvalue()
        else:
            limit = c.per_pages
            offset = (c.page_num - 1) * limit
            c.data = get_game_invite_code(offset,limit)
            c.total = get_game_invite_code_count()
            return render("/admin/invite_code.html")

    @validate_user
    def add_invite_code(self):
        return render("/admin/add_invite_code.html")

    @validate_user
    def chongzhi(self):
        r_to_g = get_rmb_to_gold().split(":")
        if len(r_to_g) == 2:
            c.rate = r_to_g[0]
            c.end_time = force_int(r_to_g[1])
        elif len(r_to_g) == 1:
            c.rate = r_to_g[0]
            c.end_time = 0
        else:
            c.rate = "10"
            c.end_time = 0
        if c.action == "add":
            username = get_params("username","")
            rmb = force_int(get_params("rmb",0))
            if username == "":
                msg = u"请输入用户名"
                return redirect_to("/admin/chongzhi", error=msg)
            user = get_user_by_oid(username)
            if c.rate == "":
                c.rate = "10"
            gold = rmb * force_int(c.rate)
            if user is None:
                msg = u"用户不存在"
                return redirect_to("/admin/chongzhi", error=msg)
            try:
                user_chongzhi(user.id,rmb,gold)
                msg = u"充值成功"
            except:
                msg = u"充值失败"
            return redirect_to("/admin/chongzhi", error=msg)
        return render("/admin/chongzhi.html")

    @validate_user
    def apply_for(self):
        EMAIL = "noreply@hanfeng.com"
        if c.action == "del":
            id = force_int(get_params("id",0))
            delete_apply_for_by_id(id)
            return redirect_to("/admin/apply_for", page=c.page_num)
        elif c.action == "view":
            id = force_int(get_params("id",0))
            c.apply_for = get_apply_for_by_id(id)
            return render("/admin/view_apply_for.html")
        elif c.action == "del_more":
            params = get_all_params()
            for k,v in params.items():
                if v == "true":
                    key = k[2:]
                    delete_apply_for_by_id(force_int(key))
            return redirect_to("/admin/apply_for", page=c.page_num)
        elif c.action == "del_all":
            delete_apply_for_all()
            return redirect_to("/admin/apply_for")
        elif c.action == "ok_more":
            params = get_all_params()
            for k,v in params.items():
                if v == "true":
                    key = k[2:]
                    id = force_int(key)
                    apply_for = get_apply_for_by_id(id)
                    if apply_for is None:
                        msg = u"申请不存在"
                        return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
                    if apply_for.state != 0:
                        continue
                    user = get_user_by_id(apply_for.user_id)
                    if user is None:
                        msg = u"用户不存在"
                        return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
                    update_user_activated(apply_for.user_id)
                    update_apply_for_state(apply_for.id,1)
                    url = get_redirect_url()
                    content = u"""
%s，您好：

      汉风游戏项目组，通过了您的申请。请点击如下链接进入游戏.

      %s


---谢谢您的参与

北京星芒软件  www.51zhi.com
                    """ % (user.oid, url)
                    
                    subject = u"汉风游戏项目组通过了您的申请！"
                    content = force_utf8(content)
                    try:
                        send_a_mail(EMAIL,apply_for.email,content,subject)
                    except:
                        msg = u"发送邮件失败"
                        return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
            msg = u""
            return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
        elif c.action == "ok":
            id = force_int(get_params("id",0))
            apply_for = get_apply_for_by_id(id)
            if apply_for is None:
                msg = u"申请不存在"
                return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
            user = get_user_by_id(apply_for.user_id)
            if user is None:
                msg = u"用户不存在"
                return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
            update_user_activated(apply_for.user_id)
            update_apply_for_state(apply_for.id,1)
            url = get_redirect_url()
            content = u"""
%s，您好：

      汉风游戏项目组，通过了您的申请。请点击如下链接进入游戏.

      %s


---谢谢您的参与

北京星芒软件  www.51zhi.com
            """ % (user.oid, url)
            
            subject = u"汉风游戏项目组通过了您的申请！"
            content = force_utf8(content)
            
            try:
                send_a_mail(EMAIL,apply_for.email,content,subject)
            except:
                msg = u"发送邮件失败"
                return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
            msg = u""
            return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
        elif c.action == "refuse":
            id = force_int(get_params("id",0))
            apply_for = get_apply_for_by_id(id)
            user = get_user_by_id(apply_for.user_id)
            if user is None:
                msg = u"用户不存在"
                return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
            url = get_redirect_url()
            update_apply_for_state(apply_for.id,2)
            content = u"""
%s，您好：

      汉风游戏项目组，由于您提交的信息不太全面或是有疏漏，未能通过您的申请。您可以再次提出您的申请请求。

      %s


---谢谢您的参与

北京星芒软件  www.51zhi.com
            """ % (user.oid, url)
            
            subject = u"汉风游戏项目组未能通过您的申请！"
            content = force_utf8(content)
            
            try:
                send_a_mail(EMAIL,apply_for.email,content,subject)
            except:
                msg = u"发送邮件失败"
                return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
            msg = u""
            return redirect_to("/admin/apply_for", error=msg, page=c.page_num, page=c.page_num)
        elif c.action == "refuse_more":
            params = get_all_params()
            for k,v in params.items():
                if v == "true":
                    key = k[2:]
                    id = force_int(key)
                    apply_for = get_apply_for_by_id(id)
                    if apply_for is None:
                        continue
                    if apply_for.state != 0:
                        continue
                    user = get_user_by_id(apply_for.user_id)
                    if user is None:
                        msg = u"用户不存在"
                        return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
                    url = get_redirect_url()
                    update_apply_for_state(apply_for.id,2)
                    content = u"""
%s，您好：

      汉风游戏项目组，由于您提交的信息不太全面或是有疏漏，未能通过您的申请。您可以再次提出您的申请请求。

      %s


---谢谢您的参与

北京星芒软件  www.51zhi.com
                    """ % (user.oid, url)
                    
                    subject = u"汉风游戏项目组未能通过您的申请！"
                    content = force_utf8(content)
                    
                    try:
                        send_a_mail(EMAIL,apply_for.email,content,subject)
                    except:
                        msg = u"发送邮件失败"
                        return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
            msg = u""
            return redirect_to("/admin/apply_for", error=msg, page=c.page_num)
        elif c.action == "search":
            limit = c.per_pages
            offset = (c.page_num - 1) * limit
            c.s_name = get_params("s_name", "")
            name = "%" + c.s_name + "%"
            c.total = get_apply_for_search_count(name)
            datas = get_apply_for_search(name,offset,limit)
            print datas
            if len(datas) == 0:
                c.data = []
            else:
                c.data,user = zip(*datas)
            return render("/admin/apply_for.html")
        else:
            limit = c.per_pages
            offset = (c.page_num - 1) * limit
            c.data = get_all_apply_for(offset,limit)
            c.total = get_apply_for_count()
            return render("/admin/apply_for.html")