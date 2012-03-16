import logging
import meta
import traceback
import md5
import time
import random

from webhanfeng.lib.utils import *

@catch_exception
def new_invite_code(flag=0):
    invite = InviteCode()
    key = random.random()
    string = str(time.clock()) + str(time.time()) + str(key)
    invite.code = md5.md5(string).hexdigest()
    meta.Session.add(invite)
    if flag == 0:
        meta.Session.commit()
    return invite



@catch_exception
def get_game_invite_code(offset=None,limit=None):
    if offset is None or limit is None:
        gift = meta.Session.query(InviteCode).order_by(InviteCode.id.asc()).all()
    else:
        gift = meta.Session.query(InviteCode).order_by(InviteCode.id.asc()).limit(limit).offset(offset).all()
    return gift

def get_game_invite_code_count():
    m = meta.Session.query(InviteCode).count()
    return m

@catch_exception
def get_invite_code_by_id(id):
    g = meta.Session.query(InviteCode).filter(InviteCode.id == id).first()
    return g

@catch_exception
def get_invite_code_to_allot():
    g = meta.Session.query(InviteCode).filter(InviteCode.user_id == 0).filter(InviteCode.is_alloted == 0).first()
    return g

@catch_exception
def get_invite_code_by_code(code):
    g = meta.Session.query(InviteCode).filter(InviteCode.code == code).first()
    return g

@catch_exception
def get_invite_code_by_code_used(code):
    g = meta.Session.query(InviteCode).filter(InviteCode.code == code).filter(InviteCode.user_id != 0).first()
    return g

@catch_exception
def get_invite_code_by_user_id(user_id):
    g = meta.Session.query(InviteCode).filter(InviteCode.user_id == user_id).first()
    return g

@catch_exception
def get_alloted_invite_code_no_used_by_user_id(user_id):
    g = meta.Session.query(InviteCode).filter(InviteCode.src_user == user_id).filter(InviteCode.user_id == 0).first()
    return g    

@catch_exception
def get_all_invite_code_not_used():
    g = meta.Session.query(InviteCode).filter(InviteCode.user_id == 0).all()
    return g

@catch_exception
def get_all_invite_code():
    g = meta.Session.query(InviteCode).all()
    return g

@catch_exception
def delete_invite_code_by_id(id):
    invite = meta.Session.query(InviteCode).filter(InviteCode.id == id).first()
    meta.Session.delete(invite)
    meta.Session.commit()

def update_invite_code(id):
    invite = get_invite_code_by_id(id)
    invite.is_alloted = 1
    meta.Session.commit()
    return invite
    
class InviteCode(object):pass