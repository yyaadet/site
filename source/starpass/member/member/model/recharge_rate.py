import meta
import time

from obj import RechargeRate
from obj import catch_exception

def get_all_recharge_rates(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(RechargeRate).order_by(RechargeRate.id.asc()).all()
    else:
        data = meta.Session.query(RechargeRate).order_by(RechargeRate.id.asc()).limit(limit).offset(offset).all()
    return data


def get_recharge_rate_count():
    data = meta.Session.query(RechargeRate).count()
    return data

@catch_exception
def new_recharge_rate(rmb, rate):
    s = RechargeRate()
    s.rmb = rmb
    s.rate = rate
    meta.Session.add(s)
    return s

@catch_exception
def update_recharge_rate_all(id,rmb,rate):
    rr = meta.Session.query(RechargeRate).filter(RechargeRate.id == id).first()
    rr.rmb = rmb
    rr.rate = rate
    return rr

def get_recharge_rate_by_id(id):
    rr = meta.Session.query(RechargeRate).filter(RechargeRate.id == id).first()
    return rr

def get_really_rate(rmb):
    data = meta.Session.query(RechargeRate).all()
    dic = {}
    for i in data:
        dic[i.rmb] = i.rate
    dic_keys = dic.keys()
    dic_keys.sort()
    rate = 100
    for key in dic_keys:
        if rmb >= key:
            rate = dic[key]
            continue
        else:
            break
    return 100.0/rate

def get_rate_li():
    data = meta.Session.query(RechargeRate).all()
    dic = {}
    for i in data:
        dic[i.rmb] = i.rate
    li = [(k,dic[k]) for k in sorted(dic.keys())]
    return li