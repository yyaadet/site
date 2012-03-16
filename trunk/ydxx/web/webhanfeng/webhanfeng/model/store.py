from webhanfeng.lib.utils import *
import meta

def get_store_count():
    m = meta.Session.query(Store).count()
    return m

@catch_exception
def get_all_store(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Store).order_by(Store.id.asc()).all()
    else:
        r = meta.Session.query(Store).order_by(Store.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def new_store(wubao_id,type,level,num):
    store = Store()
    store.wubao_id = wubao_id
    store.type = type
    store.level = level
    store.num = num
    meta.Session.add(store)
    meta.Session.commit()
    return store

@catch_exception
def update_store_all(wubao_id,type,level,num):
    store = meta.Session.query(Store).filter(Store.id == id).first()
    DIC = {"wubao_id":-1,"type":-1, \
        "level":-1,"num":-1}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(store,k,eval(k))
#            setattr(store,k,locals().get(k))
    meta.Session.commit()
    return store

class Store(object): pass