from webhanfeng.lib.utils import *
import meta

def get_treasure_count():
    m = meta.Session.query(Treasure).count()
    return m

@catch_exception
def get_all_treasure(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Treasure).order_by(Treasure.id.asc()).all()
    else:
        r = meta.Session.query(Treasure).order_by(Treasure.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def update_treasure(id,general_id,is_used,user_id,use_time,is_given,given_time,end_time):
    treasure = meta.Session.query(Treasure).filter(Treasure.id == id).first()
    if general_id != -1:
        treasure.general_id = general_id
    if is_used != -1:
        treasure.is_used = is_used
    if user_id != -1:
        treasure.user_id = user_id
    if use_time != -1:
        treasure.use_time = use_time
    if is_given != -1:
        treasure.is_given = is_given
    if given_time != -1:
        treasure.given_time = given_time
    if end_time != -1:
        treasure.end_time = end_time
    meta.Session.commit()
    return treasure

@catch_exception    
def delete_treasure_by_id(id):
    t = meta.Session.query(Treasure).filter(Treasure.id == id).first()
    meta.Session.delete(t)
    meta.Session.commit()

@catch_exception
def new_treasure(treasure_id,general_id,user_id,use_time,is_given,given_time,end_time):
    t = Treasure()
    t.treasure_id = treasure_id
    t.general_id = general_id
    t.user_id = user_id
    t.use_time = use_time
    t.is_given = is_given
    t.given_time = given_time
    t.end_time = end_time
    meta.Session.add(t)
    meta.Session.commit()
    return t

class Treasure(object): pass