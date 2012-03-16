from webhanfeng.lib.utils import *
import meta

def get_diplomacy_count():
    m = meta.Session.query(Diplomacy).count()
    return m

@catch_exception
def get_all_diplomacy(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Diplomacy).order_by(Diplomacy.id.asc()).all()
    else:
        r = meta.Session.query(Diplomacy).order_by(Diplomacy.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def update_diplomacy_all(id,type,self_id,target_id,start,end):
    g = meta.Session.query(Diplomacy).filter(Diplomacy.id == id).first()
    if type != -1:
        g.type = type
    if self_id != -1:
        g.self_id = self_id
    if target_id != -1:
        g.target_id = target_id
    if start != -1:
        g.start = start
    if end != -1:
        g.end = end
    meta.Session.commit()
    return g

@catch_exception
def new_diplomacy(type,self_id,target_id,start,end):
    diplomacy = Diplomacy()
    diplomacy.type = type
    diplomacy.self_id = self_id
    diplomacy.target_id = target_id
    diplomacy.start = start
    diplomacy.end = end
    meta.Session.add(diplomacy)
    meta.Session.commit()
    return diplomacy

@catch_exception
def delete_diplomacy_by_id(id):
    g = meta.Session.query(Diplomacy).filter(Diplomacy.id == id).first()
    meta.Session.delete(g)
    meta.Session.commit()

class Diplomacy(object): pass