from webhanfeng.lib.utils import *
import meta

@catch_exception
def get_shop_by_id(id):
    r = meta.Session.query(Shop).filter(Shop.id == id).first()
    return r

@catch_exception
def get_shop_by_name(name):
    r = meta.Session.query(Shop).filter(Shop.name == name).first()
    return r

def get_shop_count():
    m = meta.Session.query(Shop).count()
    return m

@catch_exception
def get_all_shop(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Shop).order_by(Shop.id.asc()).all()
    else:
        r = meta.Session.query(Shop).order_by(Shop.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def sell_treasure(id):
    shop = meta.Session.query(Shop).filter(Shop.id == id).first()
    shop.sold += 1 
    meta.Session.commit()
    return shop


class Shop(object): pass