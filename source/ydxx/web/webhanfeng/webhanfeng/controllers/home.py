# -*- coding: utf-8 -*-
import logging
import urllib2
import urllib
import time
import socket
import random

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to

from webhanfeng.lib.base import BaseController, render
from webhanfeng.lib.utils import *
from webhanfeng.model import *

from xml.dom.minidom import parseString
from xml.dom import minidom, Node

log = logging.getLogger(__name__)


class HomeController(BaseController):

    def __init__(self):
        BaseController.__init__(self)

    def index(self):
        return redirect_to(str(get_redirect_url()))

    def load_game(self):
        c.need_invite = get_need_invite()
        c.maintenance = get_is_maintenance()
        force = get_params("force", "0")
        if force != "1":
            if c.maintenance == "1":
                c.maintenance_text = get_maintenance_text()
                return render("/maintenance.html")
        
        username = get_params("username", "")
        referrer = get_params("referrer", "")
        hashid = get_params("hashid", "")
        oid = username
        c.uname = username
        c.server_name = get_server_name()
        c.game_name = get_game_name()
        if username == None or hashid == None:
            return redirect_to(str(get_redirect_url()))
        params = urllib.urlencode({"username":username.encode("utf-8"), "hashid":hashid})
        socket.setdefaulttimeout(15)
        f = urllib2.urlopen(str(get_starpass_check()), params)
        ret = f.read()
        if ret != "0" and ret != "1":
            return redirect_to(str(get_redirect_url()))
        elif ret == "0":
            return redirect_to(str(get_redirect_url()))
        else:
            c.uid = 0
            c.hashid = 0
            c.socket_ip = get_socket_ip()
            c.socket_port = get_socket_port()
            c.flex_ip = get_flex_ip()
            c.flex_port = get_flex_port()
            c.res_url = get_res_url()
            c.convert_money = get_convert_money()
            c.redirect_url = get_redirect_url()
            u = get_user_by_oid(oid)
            if u:
                c.uid = u.id
                c.hashid = u.hash_id
                if c.need_invite == '1' and u.is_activated == 0:
                    return redirect_to("/home/activate_user", uid=c.uid)
                elif u.is_locked == 1:
                    return "Your account has been closed, please contact the administrator."
            else:
                u = new_user(oid, get_client_ip(),referrer)
                if u:
                    c.uid = u.id
                    c.hashid = u.hash_id
                    if c.need_invite == '1' and u.is_activated == 0:
                        return redirect_to("/home/activate_user", uid=c.uid)
                else:
                    return redirect_to(str(get_redirect_url()))
        if u.is_activated == 0:
            update_user_activated(u.id)
        return render("/game.html")

    def shop(self):
        total = get_shop_count()
        shop = get_all_shop()
        ATTRIBUTE = ["id", "url","big_url","level", \
                    "name", "type", "num", \
                    "coins", "sold", "description"]
        doc =  minidom.Document() 
        root = doc.createElement("shops") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in shop:
            node = doc.createElement("shop")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def gm(self):
        total = get_gm_count()
        gm = get_all_gm()
        ATTRIBUTE = ["id"]
        doc =  minidom.Document() 
        root = doc.createElement("gms") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in gm:
            node = doc.createElement("gm")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def task(self):
        total = get_task_count()
        task = get_all_task()
        ATTRIBUTE = ["id", "before_id", "type",\
                    "num1", "num2", "num3", \
                    "prestige", "res1", "res2", \
                    "res3", "res4", "res5", "res6", \
                    "gold", "tre1","solider", \
                    "title", "info", "guide", \
                    "target"]
        doc =  minidom.Document() 
        root = doc.createElement("tasks") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in task:
            node = doc.createElement("task")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def zhanyi(self):
        total = get_zhanyi_count()
        zhanyi = get_all_zhanyi()
        ATTRIBUTE = ["id", "pic_u1",\
                    "title", "info", "site"]
        doc =  minidom.Document() 
        root = doc.createElement("zhanyis") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in zhanyi:
            node = doc.createElement("zhanyi")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def city(self):
        total = get_zhanyi_count()
        zhanyi = get_all_city()
        ATTRIBUTE = ["id", "is_alloted"]
        doc =  minidom.Document() 
        root = doc.createElement("cities") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in zhanyi:
            node = doc.createElement("city")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def guanka(self):
        total = get_guanka_count()
        guanka = get_all_guanka()
        ATTRIBUTE = ["id", "zy_id", "name", "x", \
                    "y", "prestige", "type", "level", "num", \
                    "times", "percent", "cd"]
        doc =  minidom.Document() 
        root = doc.createElement("guankas") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in guanka:
            node = doc.createElement("guanka")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def battle_info(self):
        total = get_battle_info_count()
        battle_info = get_all_battle_info()
        ATTRIBUTE = ["id", "gk_id", "gen_id",\
                    "w1_type", "w1_level", "w2_type", \
                    "w2_level", "w3_type", "w3_level", \
                    "w4_type", "w4_level", "solider", \
                    "train", "spirit", "x","y"]
        doc =  minidom.Document() 
        root = doc.createElement("battle_infos") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in battle_info:
            node = doc.createElement("battle_info")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")


    def filters(self):
        return render("/filters.txt")

    def helps(self):
        ATTRIBUTE = ["id", "father_id", "title",\
                    "content",  "link1", \
                    "link2", "link3", "link4", \
                    "link5","link6", \
                    "pic_u1", \
                    "pic_t2", "pic_u2", \
                    "pic_t3", "pic_u3"]
        def add_node(root,fid=0):
            doc =  minidom.Document() 
            task = get_all_helps_father(fid)
            for g in task:
                node = doc.createElement("help")
                for i in ATTRIBUTE:
                    node.setAttribute(i, "%s" % getattr(g,i))
                root.appendChild(node)
                add_node(node,g.id)
        
        doc =  minidom.Document() 
        root = doc.createElement("helps") 
        doc.appendChild(root)
        
        add_node(root,0)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def pk(self):
        total = get_pk_count()
        face = get_all_pk()
        ATTRIBUTE= ["id", "level", "name","face_id", \
        "skill", "zhen", \
        "kongfu", "intelligence", "polity", \
        "w1_type", "w1_level", \
        "w2_type", "w2_level", \
        "w3_type", "w3_level", \
        "w4_type", "w4_level", \
        "solider", "train", "spirit"]
        
        doc =  minidom.Document() 
        root = doc.createElement("pks") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in face:
            node = doc.createElement("pk")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def face(self):
        total = get_face_count()
        face = get_all_face()
        ATTRIBUTE= ["id", "sex","is_show","url"]
        
        doc =  minidom.Document() 
        root = doc.createElement("faces") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in face:
            node = doc.createElement("face")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def plunder(self):
        uid = force_int(get_params("uid", 0))
        total = get_plunder_count_uid(uid)
        plunder = get_all_plunder_uid(uid)
        ATTRIBUTE= ["id", "general_id", "from_id","to_id", \
            "res1", "res2", "res3", \
            "res4", "res5", "res6", \
            "start_time", "end_time"]
        
        doc =  minidom.Document() 
        root = doc.createElement("plunders") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in plunder:
            node = doc.createElement("plunder")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def money(self):
        id = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        user = get_user_by_ids(id, hash_id)
        
        money = 0
        gold = 0
        if user:
            money = user.money
            gold = user.gold
        
        doc =  minidom.Document() 
        root = doc.createElement("money") 
        doc.appendChild(root)
        
        money_mode = doc.createElement("num")
        data = doc.createTextNode("%s" % money)
        money_mode.appendChild(data)
        root.appendChild(money_mode)
        
        gold_mode = doc.createElement("gold")
        data = doc.createTextNode("%s" % gold)
        gold_mode.appendChild(data)
        root.appendChild(gold_mode)
        
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def mail(self):
        uid = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        now = force_int(get_params("now", 0))
        user = get_user_by_ids(uid, hash_id)
        if user:
            receive_id = user.id
        else:
            receive_id = 0
        total = get_mail_count_five_days(receive_id,now)
        mail = get_all_mail_five_days(receive_id,now)
        ATTRIBUTE= ["id", "sender_id","sender_name", \
            "receive_id", "receive_name", "title", \
            "content", "is_read", "type", "send_time"]
        
        doc =  minidom.Document() 
        root = doc.createElement("mails") 
        doc.appendChild(root)
        
        total_node = doc.createElement("total")
        data = doc.createTextNode("%s" % total)
        total_node.appendChild(data)
        root.appendChild(total_node)
        
        for g in mail:
            node = doc.createElement("mail")
            for i in ATTRIBUTE:
                id_node = doc.createElement("%s" % i)
                data = doc.createTextNode("%s" % getattr(g,i))
                id_node.appendChild(data)
                node.appendChild(id_node)
            root.appendChild(node)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def del_mail(self):
        uid = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        mail_id = force_int(get_params("mail_id", 0))
        user = get_user_by_ids(uid, hash_id)
        if not user:
            return "0"
        else:
            try:
                delete_mail_by_ids(mail_id,uid)
                return str(mail_id)
            except:
                return "0"

    def read_mail(self):
        uid = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        mail_id = force_int(get_params("mail_id", 0))
        user = get_user_by_ids(uid, hash_id)
        if not user:
            return "0"
        else:
            mail = read_mail_by_ids(mail_id,uid)
            if mail:
                return str(mail.id)
            else:
                return "0"

    def add_report(self):
        sender_id = force_int(get_params("sender_id",0))
        name = get_params("name","")
        description = get_params("description","")
        report = new_report(sender_id,name,description)
        if report is None:
            return "0"
        else:
            return "1"

    def convert_money(self):
        username = get_params("username", "")
        count =  force_int(get_params("count", 0))
        gold =  force_int(get_params("gold", 0))
        sign = get_params("sign", "")
        key = get_pay_key()
        request_parmas = get_all_params()
        params = {}
        for k, v in request_parmas.items():
            if k not in ('sign', 'sign_type'):
                params[k] = v
        valid_sign = validate_url(params,key)
        if sign == valid_sign:
            user = get_user_by_oid(username)
            if user == None:
                return "false"
            else:
                update_user_rmb(user.id,count)
                new_chongzhi(user.id,gold,count)
                return 'true'
        else:
            return 'false'

    def activate_user(self):
        action = get_params("action", "")
        c.error = get_params("error", "")
        c.uid = force_int(get_params("uid", 0))
        if action == "activate":
            codes = get_params("invite_code", "")
            user = get_user_by_id(c.uid)
            invite_code = get_invite_code_by_code(codes)
            if user is None:
                msg = u"用户不存在"
                c.error = msg
                return redirect_to("/home/activate_user", error=msg, uid=c.uid)
            elif user.is_activated == 1:
                msg = u"你已经激活了"
                c.error = msg
                return redirect_to("/home/activate_user", error=msg, uid=c.uid)
            if invite_code is None:
                msg = u"激活码不可用"
                return redirect_to("/home/activate_user", error=msg, uid=c.uid)
            elif invite_code.is_alloted == 1:
                msg = u"激活码已经用过了"
                return redirect_to("/home/activate_user", error=msg, uid=c.uid)
                
            try:
                update_user_activated(user.id)
                update_invite_code(invite_code.id)
                msg = u"激活成功"
                c.error = msg
            except:
                msg = u"服务器出错"
                c.error = msg
            finally:
                return redirect_to("/home/activate_user", error=msg, uid=c.uid)
        return render("/activate_user.html")

    def apply_for(self):
        c.uid = force_int(get_params("uid", 0))
        action = get_params("action", "")
        user = get_user_by_id(c.uid)
        af = get_apply_for_by_user_id(c.uid)
        if user is None:
            url = get_redirect_url()
            return redirect_to(str(url))
        elif user.is_activated == 1:
            msg = u"你已经激活了"
            c.error = msg 
            return render("/info.html")
            
        if af is not None:
            num = get_apply_for_count_less_than(af.id)
            msg = u"你已经提交过申请了，你前面还有%d个人。" % num
            c.error = msg
            return render("/info.html")
        if action == "apply_for":
            user_id = c.uid
            age = force_int(get_params("age", 0))
            sex = force_int(get_params("sex", 0))
            profession = get_params("profession", "")
            email = get_params("email", "")
            place = get_params("place", "")
            game_hour = force_int(get_params("game_hour", 0))
            income = get_params("income", "")
            know_from = get_params("know_from", "")
            reason = get_params("reason", "")
            apply_for = new_apply_for(user_id, age, sex, profession, \
                email, place, game_hour, income,know_from,reason)
            if apply_for is None:
                msg = u"出错了"
                return redirect_to("/home/apply_for", error=msg, uid=c.uid)
            else:
                msg = u"申请已经提交，请留意邮件"
                c.error = msg
                return render("/info.html")
        return render("/apply_for.html")

    def use_game_gift(self):
        user_id = force_int(get_params("user_id", 0))
        code = get_params("code", "")
        user = get_user_by_id(user_id)
        game_gift = get_game_gift_by_code(code)
        
        doc =  minidom.Document()
        root = doc.createElement("gift")
        doc.appendChild(root)
        if user is None:
            is_success = doc.createElement("is_success")
            data = doc.createTextNode("0")
            is_success.appendChild(data)
            root.appendChild(is_success)
            
            msg = doc.createElement("msg")
            data = doc.createTextNode(u"用户信息错误")
            msg.appendChild(data)
            root.appendChild(msg)
        elif game_gift is None:
            is_success = doc.createElement("is_success")
            data = doc.createTextNode("0")
            is_success.appendChild(data)
            root.appendChild(is_success)
            
            msg = doc.createElement("msg")
            data = doc.createTextNode(u"礼品码不存在")
            msg.appendChild(data)
            root.appendChild(msg)
        elif game_gift.is_used == 1:
            is_success = doc.createElement("is_success")
            data = doc.createTextNode("0")
            is_success.appendChild(data)
            root.appendChild(is_success)
            
            msg = doc.createElement("msg")
            data = doc.createTextNode(u"该礼品码已经用过")
            msg.appendChild(data)
            root.appendChild(msg)
        elif game_gift.date < int(time.time()):
            is_success = doc.createElement("is_success")
            data = doc.createTextNode("0")
            is_success.appendChild(data)
            root.appendChild(is_success)
            
            msg = doc.createElement("msg")
            data = doc.createTextNode(u"该礼品码已经过期")
            msg.appendChild(data)
            root.appendChild(msg)
        elif (game_gift.is_oneoff == 1 or game_gift.is_oneoff == 3) and (user.have_gift == 1 or user.have_gift == 11):
            is_success = doc.createElement("is_success")
            data = doc.createTextNode("0")
            is_success.appendChild(data)
            root.appendChild(is_success)
            
            msg = doc.createElement("msg")
            data = doc.createTextNode(u"您已经使用过新手卡了")
            msg.appendChild(data)
            root.appendChild(msg)
        elif game_gift.is_oneoff == 2 and (user.have_gift == 10 or user.have_gift == 11):
            is_success = doc.createElement("is_success")
            data = doc.createTextNode("0")
            is_success.appendChild(data)
            root.appendChild(is_success)
            
            msg = doc.createElement("msg")
            data = doc.createTextNode(u"您已经使用过工会卡了")
            msg.appendChild(data)
            root.appendChild(msg)
        else:
            update_game_gift(game_gift.id)
            update_user_moeny(user.id,game_gift.money)
            if game_gift.is_oneoff == 1:
                update_user_have_gift(user.id,1)
            elif game_gift.is_oneoff == 2:
                update_user_have_gift(user.id,10)
            is_success = doc.createElement("is_success")
            data = doc.createTextNode("1")
            is_success.appendChild(data)
            root.appendChild(is_success)
            
            msg = doc.createElement("msg")
            data = doc.createTextNode("%s" % game_gift.money)
            msg.appendChild(data)
            root.appendChild(msg)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def get_ref_gold(self):
        user_id = force_int(get_params("user_id", 0))
        user = get_user_by_id(user_id)
        gold = 0
        is_ok = 0
        msg_text = ""
        
        doc =  minidom.Document()
        root = doc.createElement("referrer")
        doc.appendChild(root)
        if user is None:
            msg_text = u"用户信息错误"
        else:
            users = get_user_by_referrer(user.oid)
            cnt = 0
            for u in users:
                update_user_referrer_flag(u.id)
                cnt += 1
            if cnt == 0:
                msg_text = u"您未邀请新玩家，或者邀请玩家登陆时间太短，请在您登录时，左边我的信息里面获取您的推广链接"
            else:
                is_ok = 1
                gold = cnt*5
                update_user_moeny(user.id,gold)
                msg_text = u"获取邀请金币成功"
            
        is_success = doc.createElement("is_success")
        data = doc.createTextNode("%s" % is_ok)
        is_success.appendChild(data)
        root.appendChild(is_success)
        
        gold_node = doc.createElement("gold")
        data = doc.createTextNode("%s" % gold)
        gold_node.appendChild(data)
        root.appendChild(gold_node)
        
        msg = doc.createElement("msg")
        data = doc.createTextNode("%s" % msg_text)
        msg.appendChild(data)
        root.appendChild(msg)
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")


    def set_pay_password(self):
        id = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        q_type = force_int(get_params("q_type", 0))
        q_answer = get_params("q_answer", "")
        password = get_params("password", "")
        is_success = 0
        msg = ""
        user = get_user_by_ids(id, hash_id)
        if user is None:
            msg = u"用户不存在"
        else:
            user_pay = new_user_pay_info(user.id, password, q_type, q_answer)
            if user_pay:
                msg = u"设置成功"
                is_success = 1
            else:
                msg = u"设置失败"
        
        doc =  minidom.Document() 
        root = doc.createElement("pay") 
        doc.appendChild(root)
        
        money_mode = doc.createElement("is_success")
        data = doc.createTextNode("%s" % is_success)
        money_mode.appendChild(data)
        root.appendChild(money_mode)
        
        gold_mode = doc.createElement("msg")
        data = doc.createTextNode("%s" % msg)
        gold_mode.appendChild(data)
        root.appendChild(gold_mode)
        
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def change_pay_password(self):
        id = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        old_password = get_params("old_password", "")
        new_password = get_params("new_password", "")
        is_success = 0
        msg = ""
        user = get_user_by_ids(id, hash_id)
        if user is None:
            msg = u"用户不存在"
        elif user.pay_password != md5.md5(old_password).hexdigest():
            msg = u"密码不正确"
        else:
            user_pay = update_user_pay_password(user.id, new_password)
            if user_pay:
                msg = u"修改成功"
                is_success = 1
            else:
                msg = u"修改失败"
        
        doc =  minidom.Document() 
        root = doc.createElement("pay") 
        doc.appendChild(root)
        
        money_mode = doc.createElement("is_success")
        data = doc.createTextNode("%s" % is_success)
        money_mode.appendChild(data)
        root.appendChild(money_mode)
        
        gold_mode = doc.createElement("msg")
        data = doc.createTextNode("%s" % msg)
        gold_mode.appendChild(data)
        root.appendChild(gold_mode)
        
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def find_pay_password(self):
        id = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        q_answer = get_params("q_answer", "")
        new_password = get_params("new_password", "")
        is_success = 0
        msg = ""
        user = get_user_by_ids(id, hash_id)
        if user is None:
            msg = u"用户不存在"
        elif user.question_answer != q_answer:
            msg = u"问题答案不正确"
        else:
            user_pay = update_user_pay_password(user.id, new_password)
            if user_pay:
                msg = u"修改成功"
                is_success = 1
            else:
                msg = u"修改失败"
        
        doc =  minidom.Document() 
        root = doc.createElement("pay") 
        doc.appendChild(root)
        
        money_mode = doc.createElement("is_success")
        data = doc.createTextNode("%s" % is_success)
        money_mode.appendChild(data)
        root.appendChild(money_mode)
        
        gold_mode = doc.createElement("msg")
        data = doc.createTextNode("%s" % msg)
        gold_mode.appendChild(data)
        root.appendChild(gold_mode)
        
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def check_pay_password(self):
        id = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        password = get_params("password", "")
        is_success = 0
        msg = ""
        if password == "":
            check_password = ""
        else:
            check_password = md5.md5(password).hexdigest()
        user = get_user_by_ids(id, hash_id)
        if user is None:
            msg = u"用户不存在"
        elif user.pay_password != check_password:
            msg = u"密码不正确"
        else:
            is_success = 1
            msg = u"密码正确"
        
        doc =  minidom.Document() 
        root = doc.createElement("pay") 
        doc.appendChild(root)
        
        money_mode = doc.createElement("is_success")
        data = doc.createTextNode("%s" % is_success)
        money_mode.appendChild(data)
        root.appendChild(money_mode)
        
        gold_mode = doc.createElement("msg")
        data = doc.createTextNode("%s" % msg)
        gold_mode.appendChild(data)
        root.appendChild(gold_mode)
        
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def pay_transfer(self):
        id = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        password = get_params("password", "")
        other_oid = get_params("other_oid", "")
        gold = force_int(get_params("gold", 0))
        is_success = 0
        if gold < 0:
            gold = 0
        msg = ""
        if password == "":
            check_password = ""
        else:
            check_password = md5.md5(password).hexdigest()
        user = get_user_by_ids(id, hash_id)
        other_user = get_user_by_oid(other_oid)
        if user is None:
            msg = u"用户不存在"
        elif user.pay_password != check_password:
            msg = u"密码不正确"
        elif user.money < gold:
            msg = u"您的余额不足"
        elif other_user is None:
            msg = u"对方账号不存在"
        else:
            update_user_rmb(user.id,-gold)
            update_user_rmb(other_user.id,gold)
            is_success = 1
            msg = u"转账成功"
        
        doc =  minidom.Document() 
        root = doc.createElement("pay") 
        doc.appendChild(root)
        
        money_mode = doc.createElement("is_success")
        data = doc.createTextNode("%s" % is_success)
        money_mode.appendChild(data)
        root.appendChild(money_mode)
        
        gold_mode = doc.createElement("msg")
        data = doc.createTextNode("%s" % msg)
        gold_mode.appendChild(data)
        root.appendChild(gold_mode)
        
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")

    def get_pay_info(self):
        id = force_int(get_params("uid", 0))
        hash_id = get_params("hash_id", "")
        is_success = 0
        have_password = 0
        q_type = 0
        msg = ""
        user = get_user_by_ids(id, hash_id)
        if user is None:
            msg = u"用户不存在"
        else:
            is_success = 1
            if user.pay_password != "":
                have_password = 1
                q_type = user.question_type
        
        doc =  minidom.Document() 
        root = doc.createElement("pay") 
        doc.appendChild(root)
        
        s_mode = doc.createElement("is_success")
        data = doc.createTextNode("%s" % is_success)
        s_mode.appendChild(data)
        root.appendChild(s_mode)
        
        money_mode = doc.createElement("have_password")
        data = doc.createTextNode("%s" % have_password)
        money_mode.appendChild(data)
        root.appendChild(money_mode)
        
        gold_mode = doc.createElement("q_type")
        data = doc.createTextNode("%s" % q_type)
        gold_mode.appendChild(data)
        root.appendChild(gold_mode)
        
        msg_mode = doc.createElement("msg")
        data = doc.createTextNode("%s" % msg)
        msg_mode.appendChild(data)
        root.appendChild(msg_mode)
        
        set_header("Content-type", "text/xml")
        return doc.toxml("utf-8")