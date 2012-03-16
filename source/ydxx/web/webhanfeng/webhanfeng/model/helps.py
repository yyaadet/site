from webhanfeng.lib.utils import *
import meta

def get_helps_count():
    m = meta.Session.query(Helps).count()
    return m

@catch_exception
def get_all_helps(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Helps).order_by(Helps.id.asc()).all()
    else:
        r = meta.Session.query(Helps).order_by(Helps.id.asc()).limit(limit).offset(offset).all()
    return r

def get_helps_count_father(fid):
    m = meta.Session.query(Helps).filter(Helps.father_id == fid).count()
    return m

@catch_exception
def get_all_helps_father(fid):
    r = meta.Session.query(Helps).filter(Helps.father_id == fid).order_by(Helps.id.asc()).all()
    return r

class Helps(object): pass