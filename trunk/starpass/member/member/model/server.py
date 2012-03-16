import meta
import time

from obj import Server
from obj import catch_exception

def get_all_servers(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(Server).order_by(Server.id.desc()).all()
    else:
        data = meta.Session.query(Server).order_by(Server.id.desc()).limit(limit).offset(offset).all()
    return data

def get_server_count():
    data = meta.Session.query(Server).count()
    return data


def get_server_by_id(server_id):
    data = meta.Session.query(Server).filter(Server.id == server_id).first()
    return data

@catch_exception
def new_server(name, game_id, url, recharge_url, rate, pay_key,line):
    s = Server()
    s.name = name
    s.game_id = game_id
    s.url = url
    s.recharge_url = recharge_url
    s.rate = rate
    s.pay_key = pay_key
    s.line = line
    s.start_time = int(time.time())
    meta.Session.add(s)
    return s

@catch_exception
def edit_server(server_id, name, game_id, url, recharge_url, rate, pay_key,line):
    s = meta.Session.query(Server).filter(Server.id == server_id).first()
    s.name = name
    s.game_id = game_id
    s.url = url
    s.recharge_url = recharge_url
    s.rate = rate
    s.pay_key = pay_key
    s.line = line
    return s

def get_servers_by_game_id(game_id,offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(Server).filter(Server.game_id == game_id).order_by(Server.id.desc()).all()
    else:
        data = meta.Session.query(Server).filter(Server.game_id == game_id).order_by(Server.id.desc()).limit(limit).offset(offset).all()
    return data

@catch_exception
def del_server_by_id(id):
    ser = meta.Session.query(Server).filter(Server.id == id).first()
    meta.Session.delete(ser)