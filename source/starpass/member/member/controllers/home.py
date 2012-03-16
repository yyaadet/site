# -*- coding: utf-8 -*-

import logging
import md5
import time
import datetime
import cStringIO
import simplejson
import urllib
import urllib2
import string
import random
import traceback

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to
from pylons.templating import render_mako as render
from routes import url_for

from member.lib.utils import *
from member.lib.yee_pay import *
from member.lib.alipay import *
from member.model import *
from member.lib.base import BaseController

log = logging.getLogger(__name__)

def validate_user(fun):
    def _valid(*args):
        if c.user_name is None:
            return redirect_to("/home/login")
        else:
            return fun(*args)
    return _valid

class HomeController(BaseController):

    def __init__(self):
        c.per_pages = 10
        c.page_num = force_int(get_params('page', 1))
        c.limit = c.per_pages
        c.offset = (c.page_num - 1) * c.limit
        c.act = get_params("act", "")
        c.err = get_params("err", "")
        c.user_name = get_cookie("user_name")
        c.user_id = get_cookie("user_id")
        c.hash_id = get_cookie("hash_id")
        c.home_url = get_home_url()

    def index(self):
        return redirect_to("/home/login")

    def login(self):
        c.server_id = force_int(get_params("server_id", 0))
        if c.act == "login":
            user_name = get_params("user_name", "")
            password = get_params("password", "")
            user = get_user_by_name(user_name)
            if user is None:
                msg = u"用户不存在"
                return redirect_to("/home/login", err=msg)
            elif user.password !=  md5.md5(password).hexdigest():
                msg = u"密码错误"
                return redirect_to("/home/login", err=msg)
            elif user.state == 1:
                msg = u"您的账户被锁"
                return redirect_to("/home/login", err=msg)
            else:
                set_cookie("user_name", user.name, '/', 24*3600)
                set_cookie("user_id", user.id, '/', 24*3600)
                set_cookie("hash_id", user.hash_id, '/', 24*3600)
                c.user_name = user.name
                c.user_id = user.id
                c.hash_id = user.hash_id
                if c.server_id != 0:
                    return redirect_to("/home/load_game", server_id=c.server_id)
                return redirect_to("/home/my_game")
        elif c.user_name is not None and c.user_id is not None:
            if c.server_id != 0:
                    return redirect_to("/home/load_game", server_id=c.server_id)
            return redirect_to("/home/my_game")
        return render('/home/login.html')

    def logout(self):
        remove_cookie("user_name")
        remove_cookie("user_id")
        remove_cookie("hash_id")
        return redirect_to("/home/login")

    def reg(self):
        c.expand_code = get_params("expand_code", "")
        c.expand_return = get_params("expand_return", "")
        if c.act == "reg":
            username = get_params("user_name", "")
            password = get_params("password", "")
            password2 = get_params("password2", "")
            email = get_params("email", "")
            sex = force_int(get_params("sex", 1))
            real_name = get_params("real_name", "")
            id_card = get_params("id_card", "")
            if username == '':
                msg = u"用户名不能为空"
                return redirect_to("/home/reg", err=msg)
            if email == '':
                msg = u"邮箱名不能为空"
                return redirect_to("/home/reg", err=msg)
            if password != password2 or password == "" or password2 == "":
                msg = u"密码不为空或者两次密码输入不一致"
                return redirect_to("/home/reg", err=msg)
            user = get_user_by_name(username)
            if user is not None:
                msg = u"改用户名已经存在"
                return redirect_to("/home/reg", err=msg)
            reg_ip = get_client_ip()
            last_ip = get_client_ip()
            referer = get_params("refer", "")
            expand_people = get_expand_people_by_code(c.expand_code)
            expand_id = 0
            if expand_people is not None:
                expand_id = expand_people.id
            user = new_user(username, password, email,sex,real_name,id_card, reg_ip, last_ip,expand_id,referer)
            
            if user == None:
                msg = u'服务器忙'
                return redirect_to("/home/reg", err=msg)
            else:
                set_cookie("user_name", user.name, '/', 24*3600)
                set_cookie("user_id", user.id, '/', 24*3600)
                set_cookie("hash_id", user.hash_id, '/', 24*3600)
                c.user_name = user.name
                c.user_id = user.id
                c.hash_id = user.hash_id
                if c.expand_return == "":
                    msg = u"注册成功，请登录"
                    return redirect_to("/home/login", err=msg)
                else:
                    return redirect_to(str(c.expand_return))
        return render('/home/reg.html')

    @validate_user
    def my_game(self):
        c.games = get_all_games()
        return render('/home/my_game.html')

    @validate_user
    def game_server(self):
        game_id = force_int(get_params("game_id", 0))
        c.game = get_game_by_id(game_id)
        user = get_user_by_name(c.user_name)
        c.lines = get_lines_by_game_id(game_id)
        c.server = get_server_by_id(user.last_server)
        c.servers = get_servers_by_game_id(game_id)
        return render('/home/game_server.html')

    @validate_user
    def my_info(self):
        c.user = get_user_by_name(c.user_name)
        return render('/home/my_info.html')

    def recharge(self):
        c.way = force_int(get_params("way", 1))
        c.alipay_used = get_alipay_used()
        if c.act == "one":
            c.li = get_rate_li()
            return render('/home/recharge_one.html')
        elif c.act == "two":
            c.username = get_params("username", "")
            c.username2 = get_params("username2", "")
            c.rmb = force_int(get_params("rmb", 0))
            c.rate = get_really_rate(c.rmb)
            user = get_user_by_name(c.username)
            if c.username != c.username2:
                msg = u"两次输入用户不一样"
                return redirect_to("/home/recharge", way=c.way, err=msg, act="one")
            elif c.rmb <= 0:
                msg = u"所输入充值数量有误"
                return redirect_to("/home/recharge", way=c.way, err=msg, act="one")
            elif user is None:
                msg = u"用户不存在"
                return redirect_to("/home/recharge", way=c.way, err=msg, act="one")
            return render('/home/recharge_two.html')
        elif c.act == "ok":
            username = get_params("username", "")
            rmb = force_int(get_params("rmb", 0))
            ways = ""
            rate = get_really_rate(rmb)
            if c.way == 1:
                gold = rmb * 10 * rate
            elif c.way == 2:
                ways = "SZX-NET"
                gold = rmb * 9 * rate
            elif c.way == 3:
                ways = "UNICOM-NET"
                gold = rmb * 9 * rate
            elif c.way == 4:
                gold = rmb * 10 * rate
            elif c.way == 5:
                ways = "JUNNET-NET"
                gold = rmb * 8 * rate
            elif c.way == 6:
                ways = "ZHENGTU-NET"
                gold = rmb * 8 * rate
            elif c.way == 7:
                ways = "SNDACARD-NET"
                gold = rmb * 8 * rate
            elif c.way == 8:
                ways = "QQCARD-NET"
                gold = rmb * 8 * rate
            elif c.way == 9:
                ways = "JIUYOU-NET"
                gold = rmb * 8 * rate 
            elif c.way == 10:
                ways = "NETEASE-NET"
                gold = rmb * 8 * rate
            elif c.way == 11:
                ways = "WANMEI-NET"
                gold = rmb * 8 * rate
            elif c.way == 12:
                ways = "SOHU-NET"
                gold = rmb * 8 * rate
            elif c.way == 13:
                ways = "YPCARD-NET"
                gold = rmb * 8 * rate
            elif c.way == 14:
                ways = "TELECOM-NET"
                gold = rmb * 9 * rate
            gold = int(gold)
            user = get_user_by_name(username)
            recharge_log = new_recharge_log(user.id,c.way,rmb,gold)
            if user is None:
                msg = u"用户不存在"
                return redirect_to("/home/recharge", way=c.way, err=msg, act="two")
            elif recharge_log is None:
                msg = u"充值记录写入错误"
                return redirect_to("/home/recharge", way=c.way, err=msg, act="two")
            if c.way != 4:
                mer_id = get_mer_id()
                md5_key = get_md5_key()
                callback_url = "http://" + str(get_self_host()) + "/home/recharge_callback"
                yeepay = Yeepay(mer_id, md5_key,callback_url,ways)
#                yeepay = Yeepay("10001126856", "69cl522AV6q613Ii4W6u8K6XuW8vM1N6bFgyv769220IuYe9u37N4y7rI4Pl",callback_url,ways)
                url = yeepay.create_order_yeepay_url(recharge_log.id,rmb)
                return redirect_to(url)
            else:
                host = str(get_self_host())
                security_code = get_aliapy_security_code()
                seller_email = get_aliapy_seller_email()
                partner_id = get_aliapy_partner_id()
                notify_url = "http://" + host + "/home/alipay_notify_url"
                return_url = "http://" + host + "/home/my_info"
                show_url = "http://" + host + "/home/my_game"
                alipay = Alipay(security_code, seller_email, partner_id,notify_url,return_url,show_url)
                sign_type = "MD5"
                url = alipay.create_order_alipay_url(sign_type,str(recharge_log.id),str(rmb))
                return redirect_to(url)
        return render('/home/recharge.html')


    def alipay_notify_url(self):
        ret = "fail"
        host = str(get_self_host())
        security_code = get_aliapy_security_code()
        seller_email = get_aliapy_seller_email()
        partner_id = get_aliapy_partner_id()
        notify_url = "http://" + host + "/home/alipay_notify_url"
        return_url = "http://" + host + "/home/my_info"
        show_url = "http://" + host + "/home/my_game"
        alipay = Alipay(security_code, seller_email, partner_id,notify_url,return_url,show_url)
        sign_type = "MD5"
        request_parmas = get_all_params()
        sign_type = get_params("sign_type", "MD5")
        sign = get_params("sign", "")
        out_trade_no = get_params("out_trade_no", "")
        params = {}        
        for k, v in request_parmas.items():
            if k not in ('sign', 'sign_type'):
                params[k] = v
        if sign == alipay.validate_notify_url(params,sign_type):
            notify_id = get_params("notify_id", "")
            notify_verify_url = alipay.create_notify_verify_url(notify_id)
            req = urllib2.Request(notify_verify_url)
            fd = urllib2.urlopen(req, {})
            rsp = fd.read()
            if rsp == "true":
                pay_log_id = force_int(out_trade_no)
                recharge_log = get_recharge_log_by_id(pay_log_id)
                if recharge_log is not None:
                    user = get_user_by_id(recharge_log.uid)
                    if user is not None:
                        recharge_gold(user.id,recharge_log.rmb,recharge_log.gold)
                        expand_people = get_expand_people_by_id(user.expand_id)
                        if expand_people is not None:
                            rate = force_int(get_expand_rate())
                            rmb = recharge_log.rmb * rate/100
                            update_expand_people(expand_people.id,rmb)
                            new_expand_log(user.id,expand_people.id,rmb)
                        update_recharge_log_state(recharge_log.id)
                        ret = "success"
        return ret

    def recharge_callback(self):
        mer_id = get_mer_id()
        md5_key = get_md5_key()
        callback_url = "http://" + str(get_self_host()) + "/home/recharge_callback"
        dic = get_all_params()
        yee = Yeepay(mer_id, md5_key,callback_url)
#        yee = Yeepay("10001126856", "69cl522AV6q613Ii4W6u8K6XuW8vM1N6bFgyv769220IuYe9u37N4y7rI4Pl",callback_url)
        res = yee.validate_callback_url(dic)
        recharge_log_id = force_int(get_params("r6_Order", 0))
        recharge_log = get_recharge_log_by_id(recharge_log_id)
        if recharge_log is None:
            return "充值记录不存在"
        elif recharge_log.state == 1:
            return "改订单已经被处理过了"
        if res:
            user = get_user_by_id(recharge_log.uid)
            if user is None:
                return "不存在该用户"
            else:
                recharge_gold(user.id,recharge_log.rmb,recharge_log.gold)
                expand_people = get_expand_people_by_id(user.expand_id)
                if expand_people is not None:
                    rate = force_int(get_expand_rate())
                    rmb = recharge_log.rmb * rate/100
                    update_expand_people(expand_people.id,rmb)
                    new_expand_log(user.id,expand_people.id,rmb)
                update_recharge_log_state(recharge_log.id)
                return "充值成功，充值金额为%s人民币，获得平台币%s" %(recharge_log.rmb, recharge_log.gold)
        else:
            return "回调地址解析错误"

    #for ajax
    def get_game_servers(self):
        game_id = force_int(get_params("game_id", 0))
        servers = get_servers_by_game_id(game_id)
        arry = []
        for server in servers:
            arry.append({"id":server.id, "name":server.name, "rate":server.rate,\
                 "recharge_url":server.recharge_url})
        set_header("content-type", "text/javascript")
        return simplejson.dumps(arry)

    #for ajax
    def get_game_lines(self):
        game_id = force_int(get_params("game_id", 0))
        lines = get_lines_by_game_id(game_id)
        arry = []
        for line in lines:
            arry.append({"id":line.id, "name":line.name})
        set_header("content-type", "text/javascript")
        return simplejson.dumps(arry)

    @validate_user
    def exchange(self):
        c.user = get_user_by_name(c.user_name)
        c.games = get_all_games()
        if c.act == "convert":
            count =  force_int(get_params("count", 0))
            server_id = force_int(get_params("server_id", 0))
            server = get_server_by_id(server_id)
            if server is None:
                msg = u"服务器不存在"
                return redirect_to("/home/exchange", err=msg)
            elif c.user.gold < count:
                msg = u"平台币不够"
                return redirect_to("/home/exchange", err=msg)
            elif count <= 0:
                msg = u"平台币有错误"
                return redirect_to("/home/exchange", err=msg)
            else:
                key = server.pay_key
                post_url = server.recharge_url
                rate = server.rate
                params = {}
                params['username'] = c.user_name
                params['gold'] = str(count)
                params['count'] = str(count*rate)
                url = create_url(params,key,post_url)
                
                req = urllib2.Request(url)
                fd = urllib2.urlopen(req, {})
                rsp = fd.read()
                if rsp == "true":
                    exchange_gold_to_money(c.user.id, count)
                    new_exchange_log(c.user.id, server.game_id, server.id,count,count*rate)
                    msg = u"兑换成功"
                    return redirect_to("/home/exchange", err=msg)
                else:
                    msg = u"兑换失败"
                    return redirect_to("/home/exchange", err=msg)
            
        return render('/home/exchange.html')


    @validate_user
    def recharge_log(self):
        c.data = get_recharge_logs_by_uid(c.user_id,c.offset, c.limit)
        c.total = get_recharge_log_count_uid(c.user_id)
        return render('/home/recharge_log.html')

    @validate_user
    def exchange_log(self):
        c.data = get_exchange_logs_by_uid(c.user_id,c.offset, c.limit)
        c.total = get_exchange_log_count_uid(c.user_id)
        return render('/home/exchange_log.html')

    @validate_user
    def edit_password(self):
        if c.act == "edit":
            password = get_params("password", "")
            password1 = get_params("password1", "")
            password2 = get_params("password2", "")
            m = get_user_by_name(c.user_name)
            if m.password !=  md5.md5(password).hexdigest():
                msg = u"密码错误"
                return redirect_to("/home/edit_password", err=msg)
            if password1 == password:
                msg = u"密码不能和从前一样"
                return redirect_to("/home/edit_password", err=msg)
            if password1 != password2:
                msg = u"两次密码输入不一样"
                return redirect_to("/home/edit_password", err=msg)
            if password1 == "":
                msg = u"密码不能为空"
                return redirect_to("/home/edit_password", err=msg)    
            update_user_password(m.id,password2)
            msg = u"提交成功"
            return redirect_to("/home/edit_password", err=msg)
        return render("/home/edit_password.html")

    def reset_password(self):
        if c.act == "reset":
            username = get_params("username", "")
            email = get_params("email", "")
            user = get_user_by_name(username)
            if user is None:
                msg = u"用户不存在"
                return redirect_to("/home/reset_password", err=msg)
            elif user.email != email:
                msg = u"用户邮箱不符合"
                return redirect_to("/home/reset_password", err=msg)
            else:
                str_pass = string.digits + string.ascii_lowercase + string.ascii_uppercase
                password = "".join(random.sample(str_pass,6))
                message_text = u"""你好，你的新密码是：\n%s""" % password
                message_text = force_utf8(message_text)
                subject = u"密码找回"
                try:
                    send_email(email,message_text,subject)
                    update_user_password(user.id,password)
                    msg = u"邮件发送成功"
                except:
                    msg = u"邮件发送失败"
                    traceback.print_exc()
                finally:
                    return redirect_to("/home/reset_password", err=msg)
        return render("/home/reset_password.html")

    @validate_user
    def expand_game(self):
        c.expand_people = get_expand_people_by_uid(c.user_id)
        if c.expand_people is None:
            if c.act == "applyfor":
                email = get_params("email", "")
                real_name = get_params("real_name", "")
                id_card = get_params("id_card", "")
                alipay = get_params("alipay", "")
                if email == "" or real_name == "" or id_card == "" or alipay == "":
                    msg = u"申请信息不完整"
                    return redirect_to("/home/expand_game", err=msg)
                else:
                    ep = new_expand_people(c.user_id,email,real_name,id_card,alipay)
                    if ep is None:
                        msg = u"申请失败"
                    else:
                        msg = u"申请成功"
                    return redirect_to("/home/expand_game", err=msg)
            return render("/home/expand_game.html")
        else:
            c.cnt = get_users_by_expand_id(c.expand_people.id)
            return render("/home/expand_info.html")

    @validate_user
    def expand_url(self):
        c.expand_people = get_expand_people_by_uid(c.user_id)
        if c.expand_people is None:
            return render("/home/expand_game.html")
        else:
            host = get_self_host()
            c.expand_txt = get_expand_txt()
            c.expand_return = get_expand_return()
            c.url = "http://" + host + "/home/reg?" + urllib.urlencode({"expand_code":c.expand_people.code}) \
                + "&" + urllib.urlencode({"expand_return":c.expand_return})
        return render("/home/expand_url.html")

    @validate_user
    def load_game(self):
        server_id = force_int(get_params("server_id", 0))
        s = get_server_by_id(server_id)
        url = str(s.url)
        update_user_last_server(c.user_id,s.id)
        return redirect_to(url,username=c.user_name,hashid=c.hash_id)

    @validate_user
    def game_gift(self):
        c.games = get_all_games()
        if c.act == "get":
            game_id = force_int(get_params("game_id", 0))
            server_id = force_int(get_params("server_id", 0))
            gg = get_game_gift_by_ids(game_id, server_id, c.user_id)
            user = get_user_by_name(c.user_name)
            if gg is None:
                gg = get_game_gift_by_ids(game_id, server_id, 0, user.expand_id)
            if gg is None:
                msg = u"新手卡已经发放完毕"
            else:
                update_game_gift_uid(gg.id,c.user_id)
                msg = u"恭喜你，你获得新手卡：%s" % gg.code
            return redirect_to("/home/game_gift", err=msg)
        return render("/home/game_gift.html")

    #for ajax form
    def test_user(self):
        user_name = get_params("username", "")
        user = get_user_by_name(user_name)
        if user is None:
            return "1"
        else:
            return "0"
