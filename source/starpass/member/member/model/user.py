import meta
import md5
import time

from obj import User
from obj import catch_exception

def get_all_users(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(User).order_by(User.id.asc()).all()
    else:
        data = meta.Session.query(User).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return data

def get_user_count():
    data = meta.Session.query(User).count()
    return data

@catch_exception
def lock_user_by_id(id):
    data = meta.Session.query(User).filter(User.id == id).first()
    if data.state == 1:
        data.state = 0
    else:
        data.state = 1
    return data

def get_user_by_name(name):
    data = meta.Session.query(User).filter(User.name == name).first()
    return data

def get_user_by_id(id):
    data = meta.Session.query(User).filter(User.id == id).first()
    return data

def get_users_by_id(id):
    data = meta.Session.query(User).filter(User.id == id).all()
    return data

def get_users_by_expand_id(expand_id):
    data = meta.Session.query(User).filter(User.expand_id == expand_id).count()
    return data

@catch_exception
def new_user(name, password, email, sex, real_name, id_card,reg_ip, last_ip,expand_id,referer=""):
    obj = User()
    obj.name = name
    obj.password = md5.md5(password).hexdigest()
    obj.email = email
    obj.sex = sex
    obj.real_name = real_name
    obj.id_card = id_card
    obj.reg_ip = reg_ip
    obj.last_ip = last_ip
    obj.referer = referer
    obj.expand_id = expand_id
    obj.reg_time = int(time.time())
    meta.Session.add(obj)
    meta.Session.commit()
    obj.hash_id = md5.md5(str(obj.id + obj.reg_time)).hexdigest()
    meta.Session.add(obj)
    return obj


@catch_exception
def update_user_password(id,password):
    admin = get_user_by_id(id)
    admin.password = md5.md5(password).hexdigest()
    return admin

@catch_exception
def update_user_last_server(id,last_server):
    admin = get_user_by_id(id)
    admin.last_server = last_server
    return admin


@catch_exception
def exchange_gold_to_money(id, num):
    us = get_user_by_id(id)
    us.gold -= num
    return us

@catch_exception
def recharge_gold(id, rmb, gold):
    us = get_user_by_id(id)
    us.gold += gold
    us.total_rmb += rmb
    us.score += rmb
    return us

def get_users_name_like(name,offset=None,limit=None):
    if limit is None or offset is None:
        m = meta.Session.query(User).filter(User.name.like(name)).order_by(User.id.asc()).all()
    else:
        m = meta.Session.query(User).filter(User.name.like(name)).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return m

def get_users_name_like_count(name):
    m = meta.Session.query(User).filter(User.name.like(name)).count()
    return m