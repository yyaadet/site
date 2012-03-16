from webhanfeng.lib.utils import *
import meta

def get_plunder_count():
    m = meta.Session.query(Plunder).count()
    return m

@catch_exception
def get_all_plunder(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Plunder).order_by(Plunder.id.asc()).all()
    else:
        r = meta.Session.query(Plunder).order_by(Plunder.id.asc()).limit(limit).offset(offset).all()
    return r

def get_plunder_count_uid(uid):
    m = meta.Session.query(Plunder).filter(Plunder.from_id == uid).count()
    return m

@catch_exception
def get_all_plunder_uid(uid):
    r = meta.Session.query(Plunder).filter(Plunder.from_id == uid).order_by(Plunder.id.asc()).all()
    return r

def new_plunder(general_id,from_id, to_id, \
        res1,res2,res3,res4,res5,res6,\
        start_time,end_time):
    plunder = Plunder()
    plunder.general_id = general_id
    plunder.from_id = from_id
    plunder.to_id = to_id
    plunder.res1 = res1
    plunder.res2 = res2
    plunder.res3 = res3
    plunder.res4 = res4
    plunder.res5 = res5
    plunder.res6 = res6
    plunder.start_time = start_time
    plunder.end_time = end_time
    meta.Session.add(plunder)
    meta.Session.commit()
    return plunder

@catch_exception
def del_plunder_by_id(id):
    r = meta.Session.query(Plunder).filter(Plunder.id == id).first()
    meta.Session.delete(r)
    meta.Session.commit()

class Plunder(object): pass