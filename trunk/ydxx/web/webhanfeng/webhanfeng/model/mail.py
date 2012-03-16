from webhanfeng.lib.utils import *
import meta

def get_mail_count():
    m = meta.Session.query(Mail).count()
    return m

@catch_exception
def get_all_mail(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Mail).order_by(Mail.id.asc()).all()
    else:
        r = meta.Session.query(Mail).order_by(Mail.id.asc()).limit(limit).offset(offset).all()
    return r

def get_mail_count_five_days(receive_id,now):
    five_days = now - 5*12*360
    m = meta.Session.query(Mail).filter(Mail.receive_id == receive_id).filter(Mail.send_time >= five_days).count()
    return m

@catch_exception
def get_all_mail_five_days(receive_id,now):
    five_days = now - 5*12*360
    r = meta.Session.query(Mail).filter(Mail.receive_id == receive_id).filter(Mail.send_time >= five_days).order_by(Mail.id.asc()).all()
    return r

@catch_exception    
def delete_mail_by_id(id):
    t = meta.Session.query(Mail).filter(Mail.id == id).first()
    meta.Session.delete(t)
    meta.Session.commit()
 
def delete_mail_by_time(now):
    five_days = now - 3*12*360
    ms = meta.Session.query(Mail).filter(Mail.send_time < five_days).all()
    for m in ms:
        meta.Session.delete(m)
    meta.Session.commit()

@catch_exception
def read_mail_by_ids(id,receive_id):
    m = meta.Session.query(Mail).filter(Mail.id == id).filter(Mail.receive_id == receive_id).first()
    m.is_read = 1
    meta.Session.commit()
    return m

def delete_mail_by_ids(id,receive_id):
    t = meta.Session.query(Mail).filter(Mail.id == id).filter(Mail.receive_id == receive_id).first()
    meta.Session.delete(t)
    meta.Session.commit()

@catch_exception
def new_mail(sender_id,sender_name,receive_id,receive_name,title, \
    content,is_read,type,send_time):
    m = Mail()
    m.sender_id = sender_id
    m.sender_name = sender_name
    m.receive_id = receive_id
    m.receive_name = receive_name
    m.title = title
    m.content = content
    m.is_read = is_read
    m.type = type
    m.send_time = send_time
    meta.Session.add(m)
    meta.Session.commit()
    return m

class Mail(object): pass