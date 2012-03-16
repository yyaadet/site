from webhanfeng.lib.utils import *
import meta

def get_message_count():
    m = meta.Session.query(Message).count()
    return m

@catch_exception
def get_all_message(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Message).order_by(Message.id.asc()).all()
    else:
        r = meta.Session.query(Message).order_by(Message.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def new_message(receive_id,timestamp,content,is_read,flag,msg_type,msg_title,city_name):
    m = Message()
    m.receive_id = receive_id
    m.timestamp = timestamp
    m.content = content
    m.is_read = is_read
    m.flag = flag
    m.msg_type = msg_type
    m.msg_title = msg_title
    m.city_name = city_name
    meta.Session.add(m)
    meta.Session.commit()
    return m

class Message(object): pass