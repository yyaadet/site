import meta
import time

from obj import RechargeLog
from obj import catch_exception

def get_all_recharge_logs(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(RechargeLog).order_by(RechargeLog.id.asc()).all()
    else:
        data = meta.Session.query(RechargeLog).order_by(RechargeLog.id.asc()).limit(limit).offset(offset).all()
    return data

def get_recharge_log_count():
    data = meta.Session.query(RechargeLog).count()
    return data

def get_all_recharge_logs_ok(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(RechargeLog).filter(RechargeLog.state == 1).order_by(RechargeLog.id.asc()).all()
    else:
        data = meta.Session.query(RechargeLog).filter(RechargeLog.state == 1).order_by(RechargeLog.id.asc()).limit(limit).offset(offset).all()
    return data

def get_recharge_log_count_ok():
    data = meta.Session.query(RechargeLog).filter(RechargeLog.state == 1).count()
    return data


def get_recharge_log_by_id(id):
    data = meta.Session.query(RechargeLog).filter(RechargeLog.id == id).first()
    return data

def get_recharge_logs_by_uid(uid, offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(RechargeLog).filter(RechargeLog.uid == uid).order_by(RechargeLog.id.asc()).all()
    else:
        data = meta.Session.query(RechargeLog).filter(RechargeLog.uid == uid).order_by(RechargeLog.id.asc()).limit(limit).offset(offset).all()
    return data

def get_recharge_log_count_uid(uid):
    data = meta.Session.query(RechargeLog).filter(RechargeLog.uid == uid).count()
    return data

@catch_exception
def new_recharge_log(uid,come_from,rmb,gold):
    rl = RechargeLog()
    rl.uid = uid
    rl.come_from = come_from
    rl.rmb = rmb
    rl.gold = gold
    rl.time = int(time.time())
    meta.Session.add(rl)
    return rl

@catch_exception
def update_recharge_log_state(id):
    rl = meta.Session.query(RechargeLog).filter(RechargeLog.id == id).first()
    rl.state = 1
    return rl