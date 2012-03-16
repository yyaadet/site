from webhanfeng.lib.utils import *
import meta

def get_rmb_to_gold():
    r = get_sys_setting_by_name("rmb_to_gold")
    if r == None or r.value == "":
        return ""
    return r.value

def get_convert_money():
    r = get_sys_setting_by_name("convert_money")
    if r == None or r.value == "":
        return ""
    return r.value

def get_need_invite():
    r = get_sys_setting_by_name("need_invite")
    if r == None or r.value == "":
        return ""
    return r.value

def get_maintenance_text():
    r = get_sys_setting_by_name("maintenance_text")
    if r == None or r.value == "":
        return ""
    return r.value

def get_game_name():
    r = get_sys_setting_by_name("game_name")
    if r == None or r.value == "":
        return ""
    return r.value

def get_server_name():
    r = get_sys_setting_by_name("server_name")
    if r == None or r.value == "":
        return ""
    return r.value

def get_vip_price():
    r = get_sys_setting_by_name("vip_price")
    if r == None or r.value == "":
        return ""
    return r.value

def get_vip_time():
    r = get_sys_setting_by_name("vip_time")
    if r == None or r.value == "":
        return ""
    return r.value

def get_pay_key():
    r = get_sys_setting_by_name("pay_key")
    if r == None or r.value == "":
        return ""
    return r.value

def get_flex_ip():
    r = get_sys_setting_by_name("flex_ip")
    if r == None or r.value == "":
        return ""
    return r.value

def get_flex_port():
    r = get_sys_setting_by_name("flex_port")
    if r == None or r.value == "":
        return ""
    return r.value

def get_socket_ip():
    r = get_sys_setting_by_name("socket_ip")
    if r == None or r.value == "":
        return ""
    return r.value

def get_socket_port():
    r = get_sys_setting_by_name("socket_port")
    if r == None or r.value == "":
        return ""
    return r.value

def get_help_url():
    r = get_sys_setting_by_name("help_url")
    if r == None or r.value == "":
        return ""
    return r.value

def get_starpass_check():
    r = get_sys_setting_by_name("starpass_check")
    if r == None or r.value == "":
        return ""
    return r.value

def get_redirect_url():
    r = get_sys_setting_by_name("redirect_url")
    if r == None or r.value == "":
        return ""
    return r.value

def get_res_url():
    r = get_sys_setting_by_name("res_url")
    if r == None or r.value == "":
        return ""
    return r.value

def get_is_maintenance():
    r = get_sys_setting_by_name("is_maintenance")
    if r == None or r.value == "":
        return ""
    return r.value

@catch_exception
def add_setting(name, value):
    res = get_sys_setting_by_name(name)
    if res:
        res.value = value
        meta.Session.add(res)
        meta.Session.commit()
    return res

def get_sys_setting_by_name(name):
    r = meta.Session.query(SysSetting).filter(SysSetting.name == name).first()
    return r

class SysSetting(object): pass