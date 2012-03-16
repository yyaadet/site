import meta
import time
import md5

from obj import ExpandPeople
from obj import catch_exception

def get_expand_people_by_uid(uid):
    data = meta.Session.query(ExpandPeople).filter(ExpandPeople.uid == uid).first()
    return data

def get_expand_people_by_id(id):
    data = meta.Session.query(ExpandPeople).filter(ExpandPeople.id == id).first()
    return data

def get_expand_people_by_code(code):
    data = meta.Session.query(ExpandPeople).filter(ExpandPeople.code == code).first()
    return data

@catch_exception
def update_expand_people(id,rmb):
    data = meta.Session.query(ExpandPeople).filter(ExpandPeople.id == id).first()
    data.rmb += rmb
    return data



def get_all_expand_peoples(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(ExpandPeople).order_by(ExpandPeople.id.asc()).all()
    else:
        data = meta.Session.query(ExpandPeople).order_by(ExpandPeople.id.asc()).limit(limit).offset(offset).all()
    return data

def get_expand_people_count():
    data = meta.Session.query(ExpandPeople).count()
    return data

@catch_exception
def new_expand_people(uid,email,real_name,id_card,alipay):
    data = ExpandPeople()
    data.uid = uid
    data.email = email
    data.real_name = real_name
    data.id_card = id_card
    data.alipay = alipay
    data.code = md5.md5(str(uid)+str(time.time())).hexdigest()
    data.reg_time = int(time.time())
    meta.Session.add(data)
    return data