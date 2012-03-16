import meta
from obj import ExchangeLog
from obj import catch_exception
from sqlalchemy import func
import time

from member.lib.utils import get_local_month

def get_all_exchange_logs(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(ExchangeLog).order_by(ExchangeLog.id.asc()).all()
    else:
        data = meta.Session.query(ExchangeLog).order_by(ExchangeLog.id.asc()).limit(limit).offset(offset).all()
    return data

def get_exchange_log_count():
    data = meta.Session.query(ExchangeLog).count()
    return data

#def get_all_gold_by_game_id(game_id):
#    sum = meta.Session.query(func.sum(ExchangeLog.gold)).filter(ExchangeLog.game_id == game_id).first()
#    return sum[0]

def get_all_gold_by_game_id(game_id):
    sums = meta.Session.query("sums")\
    .from_statement("SELECT SUM(gold) as sums FROM exchange_log WHERE game_id = :game_id")\
    .params(game_id=game_id).first()
    return sums[0]

def get_all_gold_by_game_id_time(game_id, start_time, end_time):
    sums = meta.Session.query("sums")\
    .from_statement("SELECT SUM(gold) as sums FROM exchange_log WHERE game_id = :game_id \
    and time >= :start_time and time < :end_time")\
    .params(game_id=game_id,start_time=start_time,end_time=end_time).first()
    return sums[0]


def get_all_gold_by_server_id(server_id):
    sums = meta.Session.query("sums")\
    .from_statement("SELECT SUM(gold) as sums FROM exchange_log WHERE server_id = :server_id")\
    .params(server_id=server_id).first()
    return sums[0]

def get_all_gold_by_server_id_date(server_id,date):
    start_time,end_time = get_local_month(date)
    sums = meta.Session.query("sums")\
    .from_statement("SELECT SUM(gold) as sums FROM exchange_log WHERE server_id = :server_id \
    and time >= :start_time and time < :end_time")\
    .params(server_id=server_id,start_time=start_time,end_time=end_time).first()
    return sums[0]

def get_exchange_log_count_by_server_id(server_id):
    data = meta.Session.query(ExchangeLog).filter(ExchangeLog.server_id == server_id).count()
    return data

def get_exchange_log_count_by_server_id_date(server_id, date):
    start_time,end_time = get_local_month(date)
    data = meta.Session.query(ExchangeLog).filter(ExchangeLog.server_id == server_id) \
    .filter(ExchangeLog.time >= start_time).filter(ExchangeLog.time < end_time).count()
    return data

def get_exchange_logs_by_server_id(server_id,offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(ExchangeLog).filter(ExchangeLog.server_id == server_id).order_by(ExchangeLog.id.asc()).all()
    else:
        data = meta.Session.query(ExchangeLog).filter(ExchangeLog.server_id == server_id).order_by(ExchangeLog.id.asc()).limit(limit).offset(offset).all()
    return data

def get_exchange_logs_by_server_id_date(server_id,date,offset=None,limit=None):
    start_time,end_time = get_local_month(date)
    if limit is None or offset is None:
        data = meta.Session.query(ExchangeLog).filter(ExchangeLog.server_id == server_id)\
        .filter(ExchangeLog.time >= start_time).filter(ExchangeLog.time < end_time)\
        .order_by(ExchangeLog.id.asc()).all()
    else:
        data = meta.Session.query(ExchangeLog).filter(ExchangeLog.server_id == server_id)\
        .filter(ExchangeLog.time >= start_time).filter(ExchangeLog.time < end_time)\
        .order_by(ExchangeLog.id.asc()).limit(limit).offset(offset).all()
    return data

def get_exchange_log_count_by_game_id_date(game_id, date):
    start_time,end_time = get_local_month(date)
    data = meta.Session.query(ExchangeLog).filter(ExchangeLog.game_id == game_id) \
    .filter(ExchangeLog.time >= start_time).filter(ExchangeLog.time < end_time).count()
    return data

def get_exchange_logs_by_uid(uid, offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(ExchangeLog).filter(ExchangeLog.uid == uid).order_by(ExchangeLog.id.asc()).all()
    else:
        data = meta.Session.query(ExchangeLog).filter(ExchangeLog.uid == uid).order_by(ExchangeLog.id.asc()).limit(limit).offset(offset).all()
    return data

def get_exchange_log_count_uid(uid):
    data = meta.Session.query(ExchangeLog).filter(ExchangeLog.uid == uid).count()
    return data

@catch_exception
def new_exchange_log(uid, game_id, server_id,gold,game_money):
    ex = ExchangeLog()
    ex.uid = uid
    ex.game_id = game_id
    ex.server_id = server_id
    ex.gold = gold
    ex.game_money = game_money
    ex.time = int(time.time())
    meta.Session.add(ex)
    return ex