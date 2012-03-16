import logging
import meta
import traceback
import md5
import time
import random

from webhanfeng.lib.utils import *

@catch_exception
def new_game_gift(money, date, is_oneoff, flag=0):
    game_gift = GameGift()
    key = random.random()
    string = str(time.clock()) + str(time.time()) + str(key)
    game_gift.code = md5.md5(string).hexdigest()
    game_gift.money = money
    game_gift.is_oneoff = is_oneoff
    game_gift.date = int(time.time()) + date*60*60*24
    meta.Session.add(game_gift)
    if flag == 0:
        meta.Session.commit()
    return game_gift

@catch_exception
def get_game_gift_by_id(id):
    g = meta.Session.query(GameGift).filter(GameGift.id == id).first()
    return g

@catch_exception
def get_game_gift_by_code(code):
    g = meta.Session.query(GameGift).filter(GameGift.code == code).first()
    return g

@catch_exception
def get_all_game_gift_not_used():
    g = meta.Session.query(GameGift).filter(GameGift.is_used == 0).all()
    return g

@catch_exception
def get_all_game_gift_geren():
    g = meta.Session.query(GameGift).filter(GameGift.is_used == 0).filter(GameGift.is_oneoff == 1).all()
    return g

@catch_exception
def get_all_game_gift_gonghui():
    g = meta.Session.query(GameGift).filter(GameGift.is_used == 0).filter(GameGift.is_oneoff == 2).all()
    return g

@catch_exception
def get_all_game_gift_huangjin():
    g = meta.Session.query(GameGift).filter(GameGift.is_used == 0).filter(GameGift.is_oneoff == 3).all()
    return g

@catch_exception
def get_game_gift(offset=None,limit=None):
    if offset is None or limit is None:
        gift = meta.Session.query(GameGift).order_by(GameGift.id.asc()).all()
    else:
        gift = meta.Session.query(GameGift).order_by(GameGift.id.asc()).limit(limit).offset(offset).all()
    return gift

def get_game_gift_count():
    m = meta.Session.query(GameGift).count()
    return m

@catch_exception
def update_game_gift(id):
    invite = get_game_gift_by_id(id)
    invite.is_used = 1
    meta.Session.commit()
    return invite

@catch_exception
def delete_game_gift_by_id(id):
    invite = meta.Session.query(GameGift).filter(GameGift.id == id).first()
    meta.Session.delete(invite)
    meta.Session.commit()
    
@catch_exception
def delete_game_gift_all():
    invite = meta.Session.query(GameGift).all()
    for i in invite:
        meta.Session.delete(i)
    meta.Session.commit()
    
    
class GameGift(object):pass