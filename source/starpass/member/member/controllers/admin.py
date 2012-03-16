# -*- coding: utf-8 -*-

import logging
import md5
import time
import datetime
import cStringIO

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to
from pylons.templating import render_mako as render

from member.lib.utils import *
from member.lib.yee_pay import *
from member.model import *

from member.lib.base import BaseController

log = logging.getLogger(__name__)

def validate_user(fun, level=1):
    def _valid(*args):
        if c.admin_name is None:
            return redirect_to("/admin/login")
        else:
            return fun(*args)
    return _valid

def permission(level=1):
    def user_level(fun):
        def _valid(*args):
            if c.admin_name is None:
                return redirect_to("/admin/login")
            elif c.admin_level > level:
                return redirect_to("/admin/login")
            else:
                return fun(*args)
        return _valid
    return user_level


class AdminController(BaseController):

    def __init__(self):
        c.per_pages = 10
        c.page_num = force_int(get_params('page', 1))
        c.limit = c.per_pages
        c.offset = (c.page_num - 1) * c.limit
        c.act = get_params("act", "")
        c.err = get_params("err", "")
        c.admin_name = get_cookie("admin_name")
        c.admin_level = force_int(get_cookie("admin_level"))
        c.admin_id = force_int(get_cookie("admin_id"))

    def index(self):
        return redirect_to("/admin/login")

    def login(self):
        if c.act == "login":
            admin_name = get_params("admin_name", "")
            password = get_params("password", "")
            admin = get_admin_by_name(admin_name)
            if admin is None:
                msg = u"用户不存在"
                return redirect_to("/admin/login", err=msg)
            elif admin.password !=  md5.md5(password).hexdigest():
                msg = u"密码错误"
                return redirect_to("/admin/login", err=msg)
            else:
                set_cookie("admin_name", admin.name, '/', 24*3600)
                set_cookie("admin_level", admin.level, '/', 24*3600)
                set_cookie("admin_id", admin.id, '/', 24*3600)
                c.admin_name = admin.name
                c.admin_level = admin.level
                c.admin_id = admin.id
                return render("/admin/index.html")
        return render('/admin/login.html')

    def logout(self):
        remove_cookie("admin_name")
        remove_cookie("admin_level")
        remove_cookie("admin_id")
        return redirect_to("/admin/login")

    @validate_user
    def edit_password(self):
        if c.act == "edit":
            password = get_params("password", "")
            password1 = get_params("password1", "")
            password2 = get_params("password2", "")
            m = get_admin_by_name(c.admin_name)
            if m.password !=  md5.md5(password).hexdigest():
                msg = u"密码错误"
                return redirect_to("/admin/edit_password", err=msg)
            if password1 == password:
                msg = u"密码不能和从前一样"
                return redirect_to("/admin/edit_password", err=msg)
            if password1 != password2:
                msg = u"两次密码输入不一样"
                return redirect_to("/admin/edit_password", err=msg)
            if password1 == "":
                msg = u"密码不能为空"
                return redirect_to("/admin/edit_password", err=msg)    
            update_admin_password(m.id,password2)
            msg = u"提交成功"
            return redirect_to("/admin/edit_password", err=msg)
        return render("/admin/edit_password.html")

    @permission(1)
    def lock_user(self):
        id = force_int(get_params("id", 0))
        lock_user_by_id(id)
        description = u"锁定/解锁用户"
        new_operation_log(c.admin_id,c.admin_name,description)
        return "1"

    @permission(1)
    def user_list(self):
        c.self_url = get_self_url()
        if c.act == "lock":
            id = force_int(get_params("id", 0))
            lock_user_by_id(id)
            description = u"锁定/解锁用户"
            new_operation_log(c.admin_id,c.admin_name,description)
            return redirect_to("/admin/user_list")
        elif c.act == "search":
            c.flag = "s"
            c.s_name = get_params("s_name", "")
            c.way = get_params("way", "0")
            if c.way == "0":
                name = "%" + c.s_name + "%"
                c.data = get_users_name_like(name,c.offset, c.limit)
                c.total = get_users_name_like_count(name)
            else:
                c.data = get_users_by_id(force_int(c.s_name))
                if c.data is None:
                    c.total = 0
                else:
                    c.total = 1
            return render('/admin/user_list.html')
        else:
            c.data = get_all_users(c.offset, c.limit)
            c.total = get_user_count()
        return render('/admin/user_list.html')

    @permission(1)
    def expand_list(self):
        c.data = get_all_expand_peoples(c.offset, c.limit)
        c.total = get_expand_people_count()
        return render('/admin/expand_list.html')

    @permission(1)
    def admin_list(self):
        if c.act == "del":
            id = force_int(get_params("id", 0))
            del_admin_by_id(id)
            return redirect_to("/admin/admin_list")
        c.data = get_all_admins(c.offset, c.limit)
        c.total = get_admin_count()
        return render('/admin/admin_list.html')

    @permission(1)
    def add_admin(self):
        if c.act == "add":
            admin_name = get_params("admin_name", "")
            password = get_params("password", "")
            level = force_int(get_params("level", 0))
            game_id = force_int(get_params("game_id", 0))
            if admin_name == "" or password == "":
                msg = u"用户名或密码不能为空"
                return redirect_to("/admin/add_admin", err=msg)
            admin = get_admin_by_name(admin_name)
            if admin is not None:
                msg = u"用户已经存在"
                return redirect_to("/admin/add_admin", err=msg)
            else:
                new_admin(admin_name, password, level, game_id)
                return redirect_to("/admin/admin_list")
        c.games = get_all_games()
        return render('/admin/add_admin.html')

    @permission(1)
    def game_list(self):
        c.self_url = get_self_url()
        if c.act == "del":
            id = force_int(get_params("id", 0))
            del_game_by_id(id)
            description = u"删除游戏%s" %id
            new_operation_log(c.admin_id,c.admin_name,description)
            return redirect_to("/admin/game_list")
        c.data = get_all_games(c.offset, c.limit)
        c.total = get_game_count()
        return render('/admin/game_list.html')

    @permission(1)
    def add_game(self):
        if c.act == "add":
            game_name = get_params("game_name", "")
            developer = get_params("developer", "")
            website = get_params("website", "")
            description = get_params("description", "")
            pic_url = get_params("pic_url", "")
            if game_name == "" or developer == "" or website == "" or pic_url == "":
                msg = u"请写入完整内容"
                return redirect_to("/admin/add_game", err=msg)
            else:
                new_game(game_name, developer,website,description,pic_url)
                return redirect_to("/admin/game_list")
        return render("/admin/add_game.html")

    @permission(1)
    def edit_game(self):
        game_id = force_int(get_params('game_id', 0))
        c.game = get_game_by_id(game_id)
        if c.act == "edit":
            game_name = get_params("game_name", "")
            developer = get_params("developer", "")
            website = get_params("website", "")
            description = get_params("description", "")
            pic_url = get_params("pic_url", "")
            if game_name == "" or developer == "" or website == "" or pic_url == "":
                msg = u"请写入完整内容"
                return redirect_to("/admin/edit_game", game_id=game_id)
            else:
                edit_game(c.game.id, game_name, developer,website,description,pic_url)
                return redirect_to("/admin/game_list")
        return render("/admin/edit_game.html")

    @permission(1)
    def line_list(self):
        c.self_url = get_self_url()
        if c.act == "del":
            id = force_int(get_params("id", 0))
            del_line_by_id(id)
            description = u"删除区%s" %id
            new_operation_log(c.admin_id,c.admin_name,description)
            return redirect_to("/admin/line_list")
        c.data = get_all_lines(c.offset, c.limit)
        c.total = get_line_count()
        return render('/admin/line_list.html')

    @permission(1)
    def add_line(self):
        if c.act == "add":
            line_name = get_params("line_name", "")
            game_id = force_int(get_params("game_id", 0))
            game = get_game_by_id(game_id)
            if game is None:
                msg = u"游戏不存在"
                return redirect_to("/admin/add_line", err=msg)
            elif line_name == "":
                msg = u"名称不能为空"
                return redirect_to("/admin/add_line", err=msg)
            else:
                new_line(line_name, game_id)
                return redirect_to("/admin/line_list")
        c.games = get_all_games()
        return render("/admin/add_line.html")

    @permission(1)
    def edit_line(self):
        line_id = force_int(get_params('line_id', 0))
        c.line = get_line_by_id(line_id)
        if c.act == "edit":
            line_name = get_params("line_name", "")
            game_id = force_int(get_params("game_id", 0))
            game = get_game_by_id(game_id)
            if game is None:
                msg = u"游戏不存在"
                return redirect_to("/admin/edit_line", err=msg, line_id=line_id)
            elif line_name == "":
                msg = u"名称不能为空"
                return redirect_to("/admin/edit_line", err=msg, line_id=line_id)
            else:
                edit_line(line_id,line_name, game_id)
                return redirect_to("/admin/line_list")
        c.games = get_all_games()
        return render("/admin/edit_line.html")


    @permission(1)
    def server_list(self):
        c.self_url = get_self_url()
        if c.act == "del":
            id = force_int(get_params("id", 0))
            del_server_by_id(id)
            description = u"删除服务器%s" %id
            new_operation_log(c.admin_id,c.admin_name,description)
            return redirect_to("/admin/server_list")
        c.data = get_all_servers(c.offset, c.limit)
        c.total = get_server_count()
        return render('/admin/server_list.html')

    @permission(1)
    def add_server(self):
        if c.act == "add":
            server_name = get_params("server_name", "")
            game_id = force_int(get_params("game_id", 0))
            rate = force_int(get_params("rate", 1))
            url = get_params("url", "")
            recharge_url = get_params("recharge_url", "")
            pay_key = get_params("pay_key", "")
            line = force_int(get_params("line", 0))
            game = get_game_by_id(game_id)
            if game is None:
                msg = u"游戏不存在"
                return redirect_to("/admin/add_server", err=msg)
            elif server_name == "" or url == "" or recharge_url == "" or pay_key == "":
                msg = u"服务器名称、URL、充值URL、支付密钥不能为空"
                return redirect_to("/admin/add_server", err=msg)
            else:
                new_server(server_name, game_id, url, recharge_url,rate,pay_key,line)
                return redirect_to("/admin/server_list")
        c.games = get_all_games()
        return render("/admin/add_server.html")

    @permission(1)
    def edit_server(self):
        server_id = force_int(get_params('server_id', 0))
        c.server = get_server_by_id(server_id)
        if c.act == "edit":
            server_name = get_params("server_name", "")
            game_id = force_int(get_params("game_id", 0))
            rate = force_int(get_params("rate", 1))
            url = get_params("url", "")
            recharge_url = get_params("recharge_url", "")
            pay_key = get_params("pay_key", "")
            line = force_int(get_params("line", 0))
            game = get_game_by_id(game_id)
            if game is None:
                msg = u"游戏不存在"
                return redirect_to("/admin/edit_server", err=msg, server_id=server_id)
            elif server_name == "" or url == "" or recharge_url == "" or pay_key == "":
                msg = u"服务器名称、URL、充值URL、支付密钥不能为空"
                return redirect_to("/admin/edit_server", err=msg, server_id=server_id)
            else:
                edit_server(server_id,server_name, game_id, url, recharge_url,rate,pay_key,line)
                return redirect_to("/admin/server_list")
        c.games = get_all_games()
        return render("/admin/edit_server.html")

    @permission(1)
    def game_gift(self):
        c.games = get_all_games()
        if c.act == "add":
            game_gift = get_params("game_gift", None)
            game_id = force_int(get_params("game_id", 0))
            is_oneoff = force_int(get_params("is_oneoff", 1))
            server_id = force_int(get_params("server_id", 0))
            game = get_game_by_id(game_id)
            ser = get_server_by_id(server_id)
            if game is None:
                msg = u"游戏不存在"
            elif ser is None:
                msg = u"服务器不存在"
            elif game_gift is not None:
                li = game_gift.value.split("\n")
                new_game_gifts(game.id,ser.id,is_oneoff, li)
                msg = u"上传成功"
            else:
                msg = u"上传失败"
            return redirect_to("/admin/game_gift", err=msg)
        return render('/admin/add_game_gift.html')

    @permission(1)
    def recharge_log(self):
        c.data = get_all_recharge_logs_ok(c.offset, c.limit)
        c.total = get_recharge_log_count_ok()
        return render('/admin/recharge_log.html')

    @permission(1)
    def exchange_log(self):
        c.data = get_all_exchange_logs(c.offset, c.limit)
        c.total = get_exchange_log_count()
        return render('/admin/exchange_log.html')

    @permission(1)
    def operation_log(self):
        c.data = get_all_operation_logs(c.offset, c.limit)
        c.total = get_operation_log_count()
        return render('/admin/operation_log.html')

    @validate_user
    def settlement(self):
        c.data = []
        if c.admin_level == 1:
            games = get_all_games()
        else:
            admin = get_admin_by_id(c.admin_id)
            games = get_all_games_by_id(admin.game_id)
        for game in games:
            dic = {}
            dic["id"] = game.id
            dic["name"] = game.name
            dic["developer"] = game.developer
            all_gold = get_all_gold_by_game_id(game.id)
            dic["all"] = all_gold
            local_start, local_end = get_local_month()
            last_start, last_end = get_last_month()
            local_gold = get_all_gold_by_game_id_time(game.id, local_start, local_end)
            last_gold = get_all_gold_by_game_id_time(game.id, last_start, last_end)
            dic["local"] = local_gold
            dic["last"] = last_gold
            c.data.append(dic)
        return render('/admin/settlement.html')

    @validate_user
    def game_settlement(self):
        c.data = []
        c.game_id = force_int(get_params("game_id", 0))
        c.date = get_params("date", "")
        if c.date == "":
            c.date = time.strftime("%Y-%m", time.localtime())
        servers = get_servers_by_game_id(c.game_id)
        c.cnts = get_exchange_log_count_by_game_id_date(c.game_id,c.date)
        for s in servers:
            dic = {}
            dic["id"] = s.id
            dic["name"] = s.name
            all_gold = get_all_gold_by_server_id_date(s.id,c.date)
            dic["all"] = all_gold
            cnt = get_exchange_log_count_by_server_id_date(s.id,c.date)
            dic["count"] = cnt
            c.data.append(dic)
        return render("/admin/game_settlement.html")

    @validate_user
    def upload_exchange_log(self):
        server_id = force_int(get_params("server_id", 0))
        date = get_params("date", "")
        data = get_exchange_logs_by_server_id_date(server_id,date)
        out = cStringIO.StringIO()
        str_list = []
        str_list.append("%s\t%s\t%s\t%s\t%s\r\n" %("用户ID","游戏ID","服务器ID","平台币","时间"))
        for item in data:
            str_list.append("%s\t%s\t%s\t%s\t%s\r\n" %(item.uid,item.game_id,item.server_id,item.gold,readable_time(item.time)))
        out.write("".join(str_list))
        set_header('Content-type', 'text')
        set_header('Content-Disposition', 'attachment;filename=%s.txt' % date)
        return out.getvalue()

    @permission(1)
    def yibao_setting(self):
        c.mer_id = get_mer_id()
        c.md5_key = get_md5_key()
        if c.act == "edit":
            mer_id = get_params("mer_id", '')
            add_setting("mer_id", mer_id)
            md5_key = get_params("md5_key", '')
            add_setting("md5_key", md5_key)
            msg = u"修改成功"
            return redirect_to("/admin/yibao_setting", err=msg)
        return render("/admin/yibao_setting.html")

    @permission(1)
    def recharge_interface_setting(self):
        c.interface_key = get_interface_key()
        c.interface_ip = get_interface_ip()
        if c.act == "edit":
            interface_key = get_params("interface_key", '')
            add_setting("interface_key", interface_key)
            interface_ip = get_params("interface_ip", '')
            add_setting("interface_ip", interface_ip)
            msg = u"修改成功"
            return redirect_to("/admin/recharge_interface_setting", err=msg)
        return render("/admin/recharge_interface_setting.html")

    @permission(1)
    def alipay_setting(self):
        c.aliapy_security_code = get_aliapy_security_code()
        c.aliapy_seller_email = get_aliapy_seller_email()
        c.aliapy_partner_id = get_aliapy_partner_id()
        c.alipay_used = get_alipay_used()
        if c.act == "edit":
            aliapy_security_code = get_params("aliapy_security_code", '')
            add_setting("aliapy_security_code", aliapy_security_code)
            aliapy_seller_email = get_params("aliapy_seller_email", '')
            add_setting("aliapy_seller_email", aliapy_seller_email)
            aliapy_partner_id = get_params("aliapy_partner_id", '')
            add_setting("aliapy_partner_id", aliapy_partner_id)
            alipay_used = get_params("alipay_used", '1')
            add_setting("alipay_used", alipay_used)
            msg = u"修改成功"
            return redirect_to("/admin/alipay_setting", err=msg)
        return render("/admin/alipay_setting.html")

    @permission(1)
    def expand_setting(self):
        c.expand_txt = get_expand_txt()
        c.expand_rate = get_expand_rate()
        c.expand_return = get_expand_return()
        if c.act == "edit":
            expand_txt = get_params("expand_txt", '')
            add_setting("expand_txt", expand_txt)
            expand_rate = get_params("expand_rate", '')
            add_setting("expand_rate", expand_rate)
            expand_return = get_params("expand_return", '')
            add_setting("expand_return", expand_return)
            msg = u"修改成功"
            return redirect_to("/admin/expand_setting", err=msg)
        return render("/admin/expand_setting.html")

    @permission(1)
    def home_page(self):
        c.home_url = get_home_url()
        if c.act == "edit":
            home_url = get_params("home_url", '')
            add_setting("home_url", home_url)
            msg = u"修改成功"
            return redirect_to("/admin/home_page", err=msg)
        return render("/admin/home_page.html")

    @permission(1)
    def recharge_rate(self):
        c.data = get_all_recharge_rates(c.offset, c.limit)
        c.total = get_recharge_rate_count()
        return render("/admin/recharge_rate.html")

    @permission(1)
    def add_recharge_rate(self):
        if c.act == "add":
            rmb = force_int(get_params("rmb", 0))
            rate = force_int(get_params("rate", 0))
            if rmb <= 0 or rate <= 0:
                msg = u"金额或折扣不能为零"
                return redirect_to("/admin/add_recharge_rate", err=msg)
            else:
                new_recharge_rate(rmb, rate)
                return redirect_to("/admin/recharge_rate")
        return render("/admin/add_recharge_rate.html")

    @permission(1)
    def edit_recharge_rate(self):
        id = force_int(get_params('id', 0))
        c.recharge_rate = get_recharge_rate_by_id(id)
        if c.act == "edit":
            rmb = force_int(get_params("rmb", 0))
            rate = force_int(get_params("rate", 0))
            if rmb <= 0 or rate <= 0:
                msg = u"金额或折扣不能为零"
                return redirect_to("/admin/edit_recharge_rate", err=msg)
            else:
                update_recharge_rate_all(id,rmb,rate)
                return redirect_to("/admin/recharge_rate")
        return render("/admin/edit_recharge_rate.html")