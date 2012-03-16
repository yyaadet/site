from webhanfeng.lib.utils import *
import meta

def get_trade_count():
    m = meta.Session.query(Trade).count()
    return m

@catch_exception
def get_all_trade(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Trade).order_by(Trade.id.asc()).all()
    else:
        r = meta.Session.query(Trade).order_by(Trade.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def new_trade(uid, type, res, \
    num, deal_num, price, timestamp):
    t = Trade()
    t.uid = uid
    t.type = type
    t.res = res
    t.num = num
    t.deal_num = deal_num
    t.price = price
    t.timestamp = timestamp
    meta.Session.add(t)
    meta.Session.commit()
    return t

@catch_exception
def delete_trade_by_id(id):
    r = meta.Session.query(Trade).filter(Trade.id == id).first()
    meta.Session.delete(r)
    meta.Session.commit()

@catch_exception
def update_trade_all(id,uid, type, res, num, deal_num, price, timestamp):
    trade = meta.Session.query(Trade).filter(Trade.id == id).first()
    DIC = {"uid":0,"type":0,"res":0,"num":0, \
        "deal_num":0,"price":0,"timestamp":0}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(trade,k,eval(k))
#            setattr(user,k,locals().get(k))
    meta.Session.commit()
    return trade

class Trade(object): pass