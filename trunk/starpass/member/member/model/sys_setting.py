import meta
import time

from obj import SysSetting
from obj import catch_exception

@catch_exception
def add_setting(name, value):
    res = get_sys_setting_by_name(name)
    if res:
        res.value = value
        meta.Session.add(res)
    return res

def get_sys_setting_by_name(name):
    r = meta.Session.query(SysSetting).filter(SysSetting.name == name).first()
    return r

def get_mer_id():
    r = get_sys_setting_by_name("mer_id")
    if r == None or r.value == "":
        return ""
    return r.value

def get_md5_key():
    r = get_sys_setting_by_name("md5_key")
    if r == None or r.value == "":
        return ""
    return r.value

def get_callback_url():
    r = get_sys_setting_by_name("callback_url")
    if r == None or r.value == "":
        return ""
    return r.value

def get_expand_txt():
    r = get_sys_setting_by_name("expand_txt")
    if r == None or r.value == "":
        return ""
    return r.value

def get_expand_rate():
    r = get_sys_setting_by_name("expand_rate")
    if r == None or r.value == "":
        return ""
    return r.value

def get_expand_return():
    r = get_sys_setting_by_name("expand_return")
    if r == None or r.value == "":
        return ""
    return r.value
    
def get_aliapy_security_code():
    r = get_sys_setting_by_name("aliapy_security_code")
    if r == None or r.value == "":
        return ""
    return r.value

def get_aliapy_seller_email():
    r = get_sys_setting_by_name("aliapy_seller_email")
    if r == None or r.value == "":
        return ""
    return r.value

def get_aliapy_partner_id():
    r = get_sys_setting_by_name("aliapy_partner_id")
    if r == None or r.value == "":
        return ""
    return r.value

def get_home_url():
    r = get_sys_setting_by_name("home_url")
    if r == None or r.value == "":
        return ""
    return r.value

def get_interface_key():
    r = get_sys_setting_by_name("interface_key")
    if r == None or r.value == "":
        return ""
    return r.value

def get_interface_ip():
    r = get_sys_setting_by_name("interface_ip")
    if r == None or r.value == "":
        return ""
    return r.value

def get_alipay_used():
    r = get_sys_setting_by_name("alipay_used")
    if r == None or r.value == "":
        return "1"
    return r.value