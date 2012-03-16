from webhanfeng.lib.utils import *
import meta

def get_sell_count():
    m = meta.Session.query(Sell).count()
    return m

@catch_exception
def get_all_sell(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Sell).order_by(Sell.id.asc()).all()
    else:
        r = meta.Session.query(Sell).order_by(Sell.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def new_sell(uid, res_type, res_level, \
    res_num, res_price, date):
    t = Sell()
    t.uid = uid
    t.res_type = res_type
    t.res_level = res_level
    t.res_num = res_num
    t.res_price = res_price
    t.date = date
    meta.Session.add(t)
    meta.Session.commit()
    return t

@catch_exception
def delete_sell_by_id(id):
    r = meta.Session.query(Sell).filter(Sell.id == id).first()
    meta.Session.delete(r)
    meta.Session.commit()

@catch_exception
def update_sell_all(id,uid, res_type, res_level, res_num, res_price, date):
    sell = meta.Session.query(Sell).filter(Sell.id == id).first()
    DIC = {"uid":0,"res_type":0,"res_level":0,"res_num":0, \
        "res_price":0,"date":0}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(sell,k,eval(k))
#            setattr(user,k,locals().get(k))
    meta.Session.commit()
    return sell

class Sell(object): pass