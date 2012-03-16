#-*- coding: utf-8 -*-

import logging
import urllib2
import urllib
import time
import random

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to

from webhanfeng.lib.base import BaseController
from webhanfeng.lib.utils import *
from webhanfeng.model import *
from webhanfeng.model.join import *

log = logging.getLogger(__name__)


def check_server_ip(ip):
    if ip == "192.168.36.88":
        return True
    else:
        socket_ip = get_socket_ip()
        if ip == socket_ip:
            return True
    return False

class ApiController(BaseController):

    def __init__(self):
#        action:1,get;2,add;3,del;4,edit
        c.action = get_params("action", "1")
        c.start = force_int(get_params("start", 1)) - 1
        c.count = force_int(get_params("count", 1))
        c.server_ip = get_client_ip()
    
    def index(self):
        return 'welcome to the webgame of hanfeng'
        
    def user(self):
        if c.action == "1":
            id = force_int(get_params("id", 0))
            total = get_user_count_wid()
            if id > 0:
                data = get_user_by_id_all(id)
                total = 1
            else:
                data = get_all_user_wid(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE = ["id", "hash_id", "oid", "name", "money", \
                "last_login_time", "last_login_ip", \
                "first_login_time", "consume", "isonline", "is_locked",\
                "vip_total_hour", "vip_used_hour", \
                "online_second","wid","is_gm"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            name = get_params("name", '')
            money = force_int(get_params("money", -1))
            last_login_time = force_int(get_params("last_login_time", 0))
            last_login_ip = get_params("last_login_ip", '')
            consume = force_int(get_params("consume", -1))
            isonline = force_int_bool(get_params("isonline", -1))
            vip_total_hour = force_int(get_params("vip_total_hour", -1))
            vip_used_hour = force_int(get_params("vip_used_hour", -1))
            online_second = force_int(get_params("online_second", 0))
            wid = force_int(get_params("wid", 0))
            update_user_all(id,name,money, \
                last_login_time,last_login_ip,consume,isonline, \
                vip_total_hour,vip_used_hour,online_second,wid)
            return str(id)


    def shop(self):
        if c.action == "1":
            total = get_shop_count()
            data = get_all_shop(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE = ["id", "level", \
                    "name", "type", "num", \
                    "coins", "sold", "description"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data

    def task(self):
        if c.action == "1":
            total = get_task_count()
            data = get_all_task(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE = ["id", "before_id", "type", \
                    "num1", "num2", "num3", \
                    "prestige", "res1", "res2", \
                    "res3", "res4", "res5", "res6", \
                    "gold","tre1","solider"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data

    def pk(self):
        if c.action == "1":
            total = get_pk_count()
            data = get_all_pk(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "level", "name","face_id", \
                "skill", "zhen", \
                "kongfu", "intelligence", "polity", \
                "w1_type", "w1_level", \
                "w2_type", "w2_level", \
                "w3_type", "w3_level", \
                "w4_type", "w4_level", \
                "solider", "train", "spirit"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data

    def face(self):
        if c.action == "1":
            total = get_face_count()
            data = get_all_face(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "sex","is_show","url"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data

    def zhanyi(self):
        if c.action == "1":
            total = get_zhanyi_count()
            data = get_all_zhanyi(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE = ["id", "pic_u1", \
                    "title", "info", "site"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data

    def guanka(self):
        if c.action == "1":
            total = get_guanka_count()
            data = get_all_guanka(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE = ["id", "zy_id", "name", "x", \
                    "y", "prestige", "type", "level", "num", \
                    "times", "percent","cd"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data

    def battle_info(self):
        if c.action == "1":
            total = get_battle_info_count()
            data = get_all_battle_info(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE = ["id", "gk_id", "gen_id",\
                    "w1_type", "w1_level", "w2_type", \
                    "w2_level", "w3_type", "w3_level", \
                    "w4_type", "w4_level", "solider", \
                    "train", "spirit", "x","y"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data

    def sphere(self):
        if c.action == "1":
            total = get_sphere_count()
            data = get_all_sphere(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "user_id","name","level","prestige","is_npc","description"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            user_id = force_int(get_params("user_id", 0))
            name = get_params("name", "")
            description = get_params("description", "")
            level = force_int(get_params("level", 0))
            prestige = force_int(get_params("prestige", 0))
            sphere = new_sphere(user_id,name,level,prestige,description)
            if sphere is None:
                return "0"
            else:
                return str(sphere.id)
        elif c.action == "3":
            id = force_int(get_params("id", 0))
            del_sphere_by_id(id)
            return str(id)
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            user_id = force_int(get_params("user_id", 0))
            name = get_params("name", "")
            description = get_params("description", "")
            level = force_int(get_params("level", 0))
            prestige = force_int(get_params("prestige", 0))
            update_sphere_all(id,user_id,name,level,prestige,description)
            return str(id)

    def city(self):
        if c.action == "1":
            total = get_city_count()
            data = get_all_city(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id","sphere_id","defense", \
                "name", "level", "jun_name", "zhou_name", "description", \
                "x", "y", "is_alloted", "jun_code", "zhou_code"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            sphere_id = force_int(get_params("sphere_id", -1))
            defense = force_int(get_params("defense", -1))
            is_alloted = force_int(get_params("is_alloted", -1))
            update_city_all(id,sphere_id,is_alloted)
            return str(id)

    def wubao(self):
        if c.action == "1":
            total = get_wubao_count()
            data = get_all_wubao(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id","user_id","people", \
                "family", "prestige", "city_id", "x", "y", \
                "sphere_id", "dig_id", "off_id","sol_num", \
                "money", "food", "wood", "iron", \
                "skin", "horse", "get_sol", "used_made","cure_solider","gongxun"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            user_id = force_int(get_params("user_id", -1))
            people = force_int(get_params("people", -1))
            family = force_int(get_params("family", -1))
            prestige = force_int(get_params("prestige", -1))
            sphere_id = force_int(get_params("sphere_id", -1))
            dig_id = force_int(get_params("dig_id", -1))
            off_id = force_int(get_params("off_id", -1))
            sol_num = force_int(get_params("sol_num", -1))
            money = force_int(get_params("money", -1))
            food = force_int(get_params("food", -1))
            wood = force_int(get_params("wood", -1))
            iron = force_int(get_params("iron", -1))
            skin = force_int(get_params("skin", -1))
            horse = force_int(get_params("horse", -1))
            get_sol = force_int(get_params("get_sol", -1))
            used_made = force_int(get_params("used_made", -1))
            cure_solider = force_int(get_params("cure_solider", -1))
            update_wubao_all(id,user_id,people,family,prestige,sphere_id,dig_id,off_id,sol_num,moeny, \
                food,wood,iron,skin,horse,get_sol,used_made,cure_solider)
            return str(id)

    def store(self):
        if c.action == "1":
            total = get_store_count()
            data = get_all_store(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id","wubao_id","type", \
                "level", "num"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            wubao_id = force_int(get_params("wubao_id", 0))
            type = force_int(get_params("type", 0))
            level = force_int(get_params("level", 0))
            num = force_int(get_params("num", 0))
            store = new_store(wubao_id,type,level,num)
            if store is None:
                return "0"
            else:
                return str(store.id)
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            wubao_id = force_int(get_params("wubao_id", -1))
            type = force_int(get_params("type", -1))
            level = force_int(get_params("level", -1))
            num = force_int(get_params("num", -1))
            update_store_all(wubao_id,type,level,num)
            return str(id)

    def building(self):
        if c.action == "1":
            total = get_building_count()
            data = get_all_building(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id","wubao_id","type", \
                "level", "end_time"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            wubao_id = force_int(get_params("wubao_id", -1))
            type = force_int(get_params("type", -1))
            level = force_int(get_params("level", -1))
            end_time = force_int(get_params("end_time", -1))
            update_building_all(id,wubao_id,type,levle,end_time)
            return str(id)

    def tech(self):
        if c.action == "1":
            total = get_tech_count()
            data = get_all_tech(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id","wubao_id","type", \
                "level", "end_time"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            wubao_id = force_int(get_params("wubao_id", -1))
            type = force_int(get_params("type", -1))
            level = force_int(get_params("level", -1))
            end_time = force_int(get_params("end_time", -1))
            update_tech_all(id,wubao_id,type,levle,end_time)
            return str(id)

    def general(self):
        if c.action == "1":
            total = get_general_count()
            data = get_all_general(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "user_id","type", "first_name", "last_name", \
                "zi", "sex", "born_year", "init_year", \
                "place", "place_id", "kongfu", "intelligence", \
                "polity", "speed", "faith", "face_id", "is_dead", \
                "skill", "zhen", "friendly", \
                "cur_used_zhen", "solider_num", \
                "hurt_num", "level", "solider_spirit", \
                "experience", "description", \
                "w1_type", "w1_level", \
                "w2_type", "w2_level", \
                "w3_type", "w3_level", \
                "w4_type", "w4_level"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            user_id = force_int(get_params("user_id", 0))
            type = force_int(get_params("type", 0))
            first_name = get_params("first_name", 0)
            last_name = get_params("last_name", 0)
            zi = get_params("zi", 0)
            sex = force_int(get_params("sex", 0))
            born_year = force_int(get_params("born_year", 0))
            init_year = force_int(get_params("init_year", 0))
            place = force_int(get_params("place", 0))
            place_id = force_int(get_params("place_id", 0))
            kongfu = force_int(get_params("kongfu", 0))
            intelligence = force_int(get_params("intelligence", 0))
            polity = force_int(get_params("polity", 0))
            speed = force_int(get_params("speed", 0))
            faith = force_int(get_params("faith", 0))
            face_id = force_int(get_params("face_id", 0))
            is_dead = force_int(get_params("is_dead", 0))
            mission_type = force_int(get_params("mission_type", 0))
            skill = force_int(get_params("skill", 0))
            zhen = force_int(get_params("zhen", 0))
            cur_used_zhen = force_int(get_params("cur_used_zhen", 0))
            solider_num = force_int(get_params("solider_num", 0))
            hurt_num = force_int(get_params("hurt_num", 0))
            level = force_int(get_params("level", 0))
            solider_spirit = force_int(get_params("solider_spirit", 0))
            experience = force_int(get_params("experience", 0))
            description = get_params("description", 0)
            w1_type = force_int(get_params("w1_type", 0))
            w1_level = force_int(get_params("w1_level", 0))
            w2_type = force_int(get_params("w2_type", 0))
            w2_level = force_int(get_params("w2_level", 0))
            w3_type = force_int(get_params("w3_type", 0))
            w3_level = force_int(get_params("w3_level", 0))
            w4_type = force_int(get_params("w4_type", 0))
            w4_level = force_int(get_params("w4_level", 0))
            general = new_genreal(user_id,type, first_name, last_name, \
                zi, sex, born_year, init_year, \
                place, place_id, kongfu, intelligence, \
                polity, speed, faith, face_id, is_dead, \
                mission_type, skill, zhen, \
                cur_used_zhen, solider_num, \
                hurt_num, level, solider_spirit, \
                experience, description, \
                w1_type, w1_level, \
                w2_type, w2_level, \
                w3_type, w3_level, \
                w4_type, w4_level)
            if general is None:
                return "0"
            else:
                return str(general.id)
        elif c.action == "3":
            id = force_int(get_params("id", 0))
            delete_general_by_id(id)
            return str(id)
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            user_id = force_int(get_params("user_id", -1))
            type = force_int(get_params("type", -1))
            first_name = get_params("first_name", "")
            last_name = get_params("last_name", "")
            zi = get_params("zi", "")
            sex = force_int(get_params("sex", -1))
            born_year = force_int(get_params("born_year", -1))
            init_year = force_int(get_params("init_year", -1))
            place = force_int(get_params("place", -1))
            place_id = force_int(get_params("place_id", -1))
            kongfu = force_int(get_params("kongfu", -1))
            intelligence = force_int(get_params("intelligence", -1))
            polity = force_int(get_params("polity", -1))
            speed = force_int(get_params("speed", -1))
            faith = force_int(get_params("faith", -1))
            face_id = force_int(get_params("face_id", -1))
            is_dead = force_int(get_params("is_dead", -1))
            mission_type = force_int(get_params("mission_type", -1))
            skill = force_int(get_params("skill", -1))
            zhen = force_int(get_params("zhen", -1))
            cur_used_zhen = force_int(get_params("cur_used_zhen", -1))
            solider_num = force_int(get_params("solider_num", -1))
            hurt_num = force_int(get_params("hurt_num", -1))
            level = force_int(get_params("level", -1))
            solider_spirit = force_int(get_params("solider_spirit", -1))
            experience = force_int(get_params("experience", -1))
            description = get_params("description", "")
            w1_type = force_int(get_params("w1_type", -1))
            w1_level = force_int(get_params("w1_level", -1))
            w2_type = force_int(get_params("w2_type", -1))
            w2_level = force_int(get_params("w2_level", -1))
            w3_type = force_int(get_params("w3_type", -1))
            w3_level = force_int(get_params("w3_level", -1))
            w4_type = force_int(get_params("w4_type", -1))
            w4_level = force_int(get_params("w4_level", -1))
            update_genreal_all(user_id,type, first_name, last_name, \
                zi, sex, born_year, init_year, \
                place, place_id, kongfu, intelligence, \
                polity, speed, faith, face_id, is_dead, \
                mission_type, skill, zhen, \
                cur_used_zhen, solider_num, \
                hurt_num, level, solider_spirit, \
                experience, description, \
                w1_type, w1_level, \
                w2_type, w2_level, \
                w3_type, w3_level, \
                w4_type, w4_level)
            return str(id)

    def army(self):
        if c.action == "1":
            total = get_army_count()
            data = get_all_army(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "name", \
                "general_id", "x", "y", "money", "food", \
                "original", "expedition_type"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            name = get_params("name", "")
            general_id = force_int(get_params("general_id", 0))
            x = force_int(get_params("x", 0))
            y = force_int(get_params("y", 0))
            money = force_int(get_params("money", 0))
            food = force_int(get_params("food", 0))
            original = force_int(get_params("original", 0))
            expedition_type = force_int(get_params("expedition_type", 0))
            general = new_army(name, general_id, x, y, money, food, original, expedition_type)
            if general is None:
                return "0"
            else:
                return str(general.id)
        elif c.action == "3":
            id = force_int(get_params("id", 0))
            del_army_by_id(id)
            return str(id)
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            name = get_params("name", "")
            general_id = force_int(get_params("general_id", -1))
            x = force_int(get_params("x", -1))
            y = force_int(get_params("y", -1))
            money = force_int(get_params("money", -1))
            food = force_int(get_params("food", -1))
            original = force_int(get_params("original", -1))
            expedition_type = force_int(get_params("expedition_type", -1))
            update_army_all(id,name, general_id, x, y, money, food, original, expedition_type)
            return str(id)

    def diplomacy(self):
        if c.action == "1":
            total = get_diplomacy_count()
            data = get_all_diplomacy(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "type", "self_id", \
                "target_id", "start", "end"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            type = force_int(get_params("type", 0))
            self_id = force_int(get_params("self_id", 0))
            target_id = force_int(get_params("target_id", 0))
            start = force_int(get_params("start", 0))
            end = force_int(get_params("end", 0))
            gd = new_diplomacy(type,self_id,target_id,start,end)
            if gd is not None:
                return str(gd.id)
            else:
                return '0'
        elif c.action == "3":
            id = force_int(get_params("id", 0))
            delete_diplomacy_by_id(id)
            return str(id)
        elif c.action == "4":
            id = force_int(get_params("id", 0))
            type = force_int(get_params("type", -1))
            self_id = force_int(get_params("self_id", -1))
            target_id = force_int(get_params("target_id", -1))
            start = force_int(get_params("start", 0))
            end = force_int(get_params("end", 0))
            update_diplomacy_all(id,type,self_id,target_id,start,end)
            return str(id)

    def trade(self):
        id = force_int(get_params("id", 0))
        uid = force_int(get_params("uid", 0))
        type = force_int(get_params("type", 0))
        res = force_int(get_params("res", 0))
        num = force_int(get_params("num", 0))
        deal_num = force_int(get_params("deal_num", 0))
        price = force_int(get_params("price", 0))
        timestamp = force_int(get_params("timestamp", 0))
        if c.action == "1":
            total = get_trade_count()
            data = get_all_trade(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "uid", "type", \
                "res", "num", \
                "deal_num", "price", "timestamp"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            trade = new_trade(uid, type, res, \
                num, deal_num, price, timestamp)
            if trade is not None:
                return str(trade.id)
            else:
                return '0'
        elif c.action == "3":
            delete_trade_by_id(id)
            return str(id)
        elif c.action == "4":
            update_trade_all(id,uid, type, res, num, deal_num, price, timestamp)
            return str(id)

    def sell(self):
        id = force_int(get_params("id", 0))
        uid = force_int(get_params("uid", 0))
        res_type = force_int(get_params("res_type", 0))
        res_level = force_int(get_params("res_level", 0))
        res_num = force_int(get_params("res_num", 0))
        res_price = force_int(get_params("res_price", 0))
        date = force_int(get_params("date", 0))
        if c.action == "1":
            total = get_sell_count()
            data = get_all_sell(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "uid", "res_type", \
                "res_level", "res_num", \
                "res_price", "date"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            sell = new_sell(uid, res_type, res_level, \
                res_num, res_price, date)
            if sell is not None:
                return str(sell.id)
            else:
                return '0'
        elif c.action == "3":
            delete_sell_by_id(id)
            return str(id)

    def treasure(self):
        if c.action == "1":
            total, = get_treasure_count_exist()
            data = get_all_treasure_exist(c.start,c.count)
            return_data = "%s\n" % total
            ATTRIBUTE= ["id", "treasure_id", "general_id", \
                "is_used", "user_id", "use_time", \
                "is_given", "given_time", "end_time"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            return_data = ""
            reason = ""
            id = 0
            treasure_id = force_int(get_params("treasure_id", 0))
            general_id = force_int(get_params("general_id", 0))
            user_id = force_int(get_params("user_id", 0))
            use_time = force_int(get_params("use_time", 0))
            is_given = force_int(get_params("is_given", 0))
            given_time = force_int(get_params("given_time", 0))
            end_time = force_int(get_params("end_time", 0))
            u = get_user_by_id(user_id)
            if not u:
                reason = u"用户不存在"
                return_data += urllib.urlencode({"id": id})
                return_data += "&"
                return_data += urllib.urlencode({"reason": force_utf8(reason)})
                return return_data
            shop = get_shop_by_id(treasure_id)
            if shop is None:
                reason = u"道具不存在"
                return_data += urllib.urlencode({"id": id})
                return_data += "&"
                return_data += urllib.urlencode({"reason": force_utf8(reason)})
                return return_data
            else:
                coins = shop.coins
            if (u.money+u.gold) < coins:
                reason = u"金币不够"
                return_data += urllib.urlencode({"id": id})
                return_data += "&"
                return_data += urllib.urlencode({"reason": force_utf8(reason)})
                return return_data
            t = new_treasure(treasure_id,general_id,user_id,use_time,is_given,given_time,end_time)
            if t == None:
                reason = u"插入数据失败"
                return_data += urllib.urlencode({"id": id})
                return_data += "&"
                return_data += urllib.urlencode({"reason": force_utf8(reason)})
                return return_data
            else:
                update_user_consume_moeny(user_id, coins)
                sell_treasure(t.treasure_id)
                id = t.id
                reason = u"购买道具成功"
                return_data += urllib.urlencode({"id": id})
                return_data += "&"
                return_data += urllib.urlencode({"reason": force_utf8(reason)})
                return return_data
        elif c.action == "3":
            return_data = ""
            reason = ""
            id = force_int(get_params("id", 0))
            delete_treasure_by_id(id)
            reason = u"删除成功"
            return_data += urllib.urlencode({"id": id})
            return_data += "&"
            return_data += urllib.urlencode({"reason": force_utf8(reason)})
            return return_data
        elif c.action == "4":
            return_data = ""
            reason = ""
            id = force_int(get_params("id", 0))
            general_id = force_int(get_params("general_id", -1))
            is_used = force_int_bool(get_params("is_used", -1))
            user_id = force_int(get_params("user_id", -1))
            use_time = force_int(get_params("use_time", -1))
            is_given = force_int(get_params("is_given", -1))
            given_time = force_int(get_params("given_time", -1))
            end_time = force_int(get_params("end_time", -1))
            update_treasure(id,general_id,is_used,user_id,use_time,is_given,given_time,end_time)
            reason = u"更新成功"
            return_data += urllib.urlencode({"id": id})
            return_data += "&"
            return_data += urllib.urlencode({"reason": force_utf8(reason)})
            return return_data

    def add_treasure(self):
        treasure_id = force_int(get_params("treasure_id", 0))
        general_id = force_int(get_params("general_id", 0))
        user_id = force_int(get_params("user_id", 0))
        use_time = force_int(get_params("use_time", 0))
        is_given = force_int(get_params("is_given", 0))
        given_time = force_int(get_params("given_time", 0))
        end_time = force_int(get_params("end_time", 0))
        u = get_user_by_id(user_id)
        if not u:
            return "0"
        shop = get_shop_by_id(treasure_id)
        if shop is None:
            return "0"
        t = new_treasure(treasure_id,general_id,user_id,use_time,is_given,given_time,end_time)
        if t is None:
            return '0'
        else:
            return str(t.id)

    def message(self):
        if c.action == "1":
            total = get_message_count()
            data = get_all_message(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "receive_id", "timestamp", \
                "content", "is_read", "flag", \
                "msg_type", "msg_title", "city_name"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data

    def mail(self):
        if c.action == "1":
            total = get_mail_count()
            data = get_all_mail(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "sender_id", "sender_name", \
                "receive_id", "receive_name", "title", \
                "conten", "is_read", "type", "send_time"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            sender_id = force_int(get_params("sender_id", 0))
            sender_name = get_params("sender_name","")
            receive_id = force_int(get_params("receive_id", 0))
            receive_name = get_params("receive_name", "")
            title = get_params("title", "")
            content = get_params("content", "")
            is_read = force_int(get_params("is_read", 0))
            type = force_int(get_params("type", 0))
            send_time = force_int(get_params("send_time", 0))
            mail = new_mail(sender_id,sender_name,receive_id,receive_name,title, \
                content,is_read,type,send_time)
            if mail:
                return str(mail.id)
            else:
                return "0"

    def clear_mail(self):
        time = force_int(get_params("time", 0))
        try:
            delete_mail_by_time(time)
            return "1"
        except:
            return "0"

    def plunder(self):
        if c.action == "1":
            total = get_plunder_count()
            data = get_all_plunder(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id","general_id", "from_id", "to_id", \
                "res1", "res2", "res3", \
                "res4", "res5", "res6", \
                "start_time", "end_time"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            general_id = force_int(get_params("general_id", 0))
            from_id = force_int(get_params("from_id", 0))
            to_id = force_int(get_params("to_id", 0))
            res1 = force_int(get_params("res1", 0))
            res2 = force_int(get_params("res2", 0))
            res3 = force_int(get_params("res3", 0))
            res4 = force_int(get_params("res4", 0))
            res5 = force_int(get_params("res5", 0))
            res6 = force_int(get_params("res6", 0))
            start_time = force_int(get_params("start_time", 0))
            end_time = force_int(get_params("end_time", 0))
            p = new_plunder(general_id,from_id, to_id, \
                res1,res2,res3,res4,res5,res6,\
                start_time,end_time)
            if p is None:
                return "0" 
            else:
                return str(p.id)
        elif c.action == "3":
            id = force_int(get_params("id", 0))
            del_plunder_by_id(id)
            return str(id)

    def cmd_transfer(self):
        if c.action == "1":
            total = get_cmd_transfer_count()
            data = get_all_cmd_transfer(c.start,c.count)
            return_data = "%d\n" % total
            ATTRIBUTE= ["id", "from_id", "to_id", "type", \
                "sphere_id", "goods_type", "goods_id", \
                "goods_num", "end_time"]
            for u in data:
                for i in ATTRIBUTE:
                    return_data += urllib.urlencode({i: force_utf8(getattr(u, i))})
                    return_data += "&"
                return_data = return_data[:-1] + "\n"
            return return_data
        elif c.action == "2":
            from_id = force_int(get_params("from_id", 0))
            to_id = force_int(get_params("to_id", 0))
            type = force_int(get_params("type", 0))
            sphere_id = force_int(get_params("sphere_id", 0))
            goods_type = force_int(get_params("goods_type", 0))
            goods_id = force_int(get_params("goods_id", 0))
            goods_num = force_int(get_params("goods_num", 0))
            end_time = force_int(get_params("end_time", 0))
            cmds = new_cmd_transfer(from_id, to_id, type, \
                sphere_id, goods_type, goods_id, goods_num, \
                end_time)
            if cmds is not None:
                return "0" 
            else:
                return str(cmds.id)
        elif c.action == "3":
            id = force_int(get_params("id", 0))
            del_cmd_transfer_by_id(id)
            return str(id)

    def become_vip(self):
        id = force_int(get_params("id", 0))
        reason = ""
        is_succ = 0
        vip_total_hour = 0
        return_data = ""
        need_money = force_int(get_vip_price())
        add_hours = force_int(get_vip_time())
        user = get_user_by_id(id)
        if user is None:
            reason = u"用户不存在"
        elif user.money < need_money:
            reason = u"金币不够"
        else:
            user = add_vip_hour(id,add_hours,need_money)
            if user is not None:
                is_succ = 1
                vip_total_hour = user.vip_total_hour
                update_user_consume(user.id, need_money)
                reason = u"升级VIP成功"
            else:
                is_succ = 0
                reason = u"数据库错误"
        return_data += urllib.urlencode({"is_succ": is_succ})
        return_data += "&"
        return_data += urllib.urlencode({"vip_total_hour": vip_total_hour})
        return_data += "&"
        return_data += urllib.urlencode({"reason": force_utf8(reason)})
        return return_data

    def sell_weapon(self):
        id = force_int(get_params("uid", 0))
        user = get_user_by_id(id)
        money = 5
        reason = ""
        is_succ = 0
        return_data = ""
        if user is None:
            reason = u"用户不存在"
        elif (user.money+user.gold) < money:
            reason = u"金币不够"
        else:
            user = user_speed(id,money)
            if user is not None:
                is_succ = 1
                reason = u"挂单成功"
            else:
                is_succ = 0
                reason = u"数据库错误"
        return_data += urllib.urlencode({"is_succ": is_succ})
        return_data += "&"
        return_data += urllib.urlencode({"money": money})
        return_data += "&"
        return_data += urllib.urlencode({"reason": force_utf8(reason)})
        return return_data

    def speed(self):
        id = force_int(get_params("uid", 0))
        hour = force_int(get_params("hour", 0))
        reason = ""
        is_succ = 0
        return_data = ""
        money = hour/6
        if money < 0:
            money = 0
        user = get_user_by_id(id)
        if user is None:
            reason = u"用户不存在"
        elif (user.money+user.gold) < money:
            reason = u"金币不够"
        else:
            user = user_speed(id,money)
            if user is not None:
                is_succ = 1
                reason = u"加速成功"
            else:
                is_succ = 0
                reason = u"数据库错误"
        return_data += urllib.urlencode({"is_succ": is_succ})
        return_data += "&"
        return_data += urllib.urlencode({"money": money})
        return_data += "&"
        return_data += urllib.urlencode({"reason": force_utf8(reason)})
        return return_data

    def buy_weap(self):
        sell_uid = force_int(get_params("sell_uid", 0))
        buy_uid = force_int(get_params("buy_uid", 0))
        gold = force_int(get_params("gold", 0))
        r = weapon_trade(sell_uid, buy_uid, gold)
        reason = ""
        is_succ = 0
        return_data = ""
        if r == "1":
            is_succ = 0
            reason = u"挂单用户错误"
        elif r == "2":
            is_succ = 0
            reason = u"买单用户错误"
        elif r == "3":
            is_succ = 0
            reason = u"用户充值金币不足"
        else:
            is_succ = 1
            reason = u"交易成功"
        return_data += urllib.urlencode({"is_succ": is_succ})
        return_data += "&"
        return_data += urllib.urlencode({"reason": force_utf8(reason)})
        return return_data

#   wubao data
#    def make_wubao(self):
#        cities = get_all_city()
#        for city in cities:
#            if city.is_alloted == 1:
#                for i in range(0,400):
#                    wubao = new_wubao(0,10000,2000,0,city.id,city.x,city.y, \
#                        0,0,0,0, \
#                        0,0,0,0,0,0,0,0)
#        meta.Session.commit()
#        return "OK...."

#   user data
    def make_user(self):
        cities = get_all_city()
        for i in range(40000,43200):
            oid = "oid" + str(i)
            name = "name" + str(i)
            users = new_users(oid,name,0)
        meta.Session.commit()
        return "OK...."

    def add_money(self):
        uid = force_int(get_params("uid", 0))
        money = force_int(get_params("money", 0))
        if money < 0:
            money = 0
        user = get_user_by_id(uid)
        if user is None:
            return "0"
        else:
            update_user_moeny(user.id,money)
            return "1"

    def sub_money(self):
        uid = force_int(get_params("uid", 0))
        money = force_int(get_params("money", 0))
        if money < 0:
            money = 0
        user = get_user_by_id(uid)
        if user is None:
            return "0"
        else:
            if (user.money+user.gold) >= money:
                user_speed(user.id,money)
                return "1"
            else:
                return "0"