from webhanfeng.lib.utils import *
import meta


@catch_exception
def new_users(oid,name,flag=1):
    u    =    User()
    u.hash_id = ""
    u.oid = oid
    u.name = name
    u.money = 0
    u.last_login_time = int(time.time())
    u.first_login_time = int(time.time())
    u.consume = 0
    u.isonline = 1
    meta.Session.add(u)
    if flag == 1:
        meta.Session.commit()
    return u



@catch_exception
def new_user(oid, last_login_ip,referrer):
    u    =    User()
    u.hash_id = ""
    u.oid = oid
    u.name = ""
    u.money = 0
    u.last_login_time = int(time.time())
    u.last_login_ip = last_login_ip
    u.first_login_time = int(time.time())
    u.consume = 0
    u.isonline = 1
    u.referrer = referrer
    meta.Session.add(u)
    meta.Session.commit()
    u.hash_id = md5.md5(str(u.id) + str(u.first_login_time)).hexdigest()
    meta.Session.commit()
    return u

@catch_exception
def get_user_by_id(id):
    r = meta.Session.query(User).filter(User.id == id).first()
    return r

@catch_exception
def get_user_by_referrer(referrer,day=1):
    delay = 60*24*day
    r = meta.Session.query(User).filter(User.referrer == referrer).filter(User.referrer_flag == 0).filter(User.last_login_time - User.first_login_time >= delay).all()
    return r

@catch_exception
def get_user_by_ids(id, hash_id):
    r = meta.Session.query(User).filter(User.id == id).filter(User.hash_id == hash_id).first()
    return r

@catch_exception
def get_user_by_id_all(id):
    g = meta.Session.query(User).filter(User.id == id).all()
    return g

def get_user_count():
    m = meta.Session.query(User).count()
    return m

@catch_exception
def get_all_user(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(User).order_by(User.id.asc()).all()
    else:
        r = meta.Session.query(User).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return r


def get_gm_count():
    m = meta.Session.query(User).filter(User.is_gm == 1).count()
    return m

@catch_exception
def get_all_gm(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(User).filter(User.is_gm == 1).order_by(User.id.asc()).all()
    else:
        r = meta.Session.query(User).filter(User.is_gm == 1).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return r

def get_user_count_wid():
    m = meta.Session.query(User).filter(User.wid != 0).count()
    return m

@catch_exception
def get_all_user_wid(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(User).filter(User.wid != 0).order_by(User.id.asc()).all()
    else:
        r = meta.Session.query(User).filter(User.wid != 0).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def update_user_all(id,name,money, \
    last_login_time,last_login_ip,consume,isonline, \
    vip_total_hour,vip_used_hour,online_second,wid):
    user = meta.Session.query(User).filter(User.id == id).first()
    DIC = {"name":"","money":-1, \
        "last_login_time":0,"last_login_ip":"","consume":-1, \
        "isonline":-1,"vip_total_hour":-1,"vip_used_hour":-1,"online_second":0,"wid":0}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(user,k,eval(k))
#            setattr(user,k,locals().get(k))
    meta.Session.commit()
    return user

@catch_exception
def get_user_by_oid(oid):
    u = meta.Session.query(User).filter(User.oid == oid).first()
    return u

@catch_exception
def update_user_consume_moeny(id,count):
    user = meta.Session.query(User).filter(User.id == id).first()
    if user.gold >= count:
        user.gold -= count
    else:
        left = count - user.gold
        user.gold = 0
        user.money -= left
    user.consume += count
    meta.Session.commit()
    return user

@catch_exception
def update_user_consume(id,count):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.consume += count
    meta.Session.commit()
    return user

@catch_exception
def update_user_have_gift(id,num):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.have_gift += num
    meta.Session.commit()
    return user

@catch_exception
def user_speed(id,money):
    user = meta.Session.query(User).filter(User.id == id).first()
    if user.gold >= money:
        user.gold -= money
    else:
        left = money - user.gold
        user.gold = 0
        user.money -= left
    user.consume += money
    meta.Session.commit()
    return user

@catch_exception
def add_vip_hour(id,hour,money):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.vip_total_hour += hour
    user.money -= money
    meta.Session.commit()
    return user

############for web############
@catch_exception
def update_user_gm(id):
    user = meta.Session.query(User).filter(User.id == id).first()
    if user.is_gm == 1:
        user.is_gm = 0
    else:
        user.is_gm = 1
    meta.Session.commit()
    return user

@catch_exception
def update_user_referrer_flag(id):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.referrer_flag = 1
    meta.Session.commit()
    return user

@catch_exception
def update_user_locked(id):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.is_locked = 1
    meta.Session.commit()
    return user

@catch_exception
def update_user_unlocked(id):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.is_locked = 0
    meta.Session.commit()
    return user

@catch_exception
def update_user_moeny(id,count):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.gold += count
    meta.Session.commit()
    return user

@catch_exception
def update_user_rmb(id,count):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.money += count
    meta.Session.commit()
    return user

def update_user_activated(id):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.is_activated = 1
    meta.Session.commit()
    return user

@catch_exception
def new_user_pay_info(id, pay_password, question_type, question_answer):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.pay_password = md5.md5(pay_password).hexdigest()
    user.question_type = question_type
    user.question_answer = question_answer
    meta.Session.commit()
    return user

@catch_exception
def update_user_pay_password(id, pay_password):
    user = meta.Session.query(User).filter(User.id == id).first()
    user.pay_password = md5.md5(pay_password).hexdigest()
    meta.Session.commit()
    return user

class User(object): pass