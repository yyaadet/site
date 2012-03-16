from webhanfeng.lib.utils import *
import meta

def get_army_count():
    m = meta.Session.query(Army).count()
    return m

@catch_exception
def get_all_army(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Army).order_by(Army.id.asc()).all()
    else:
        r = meta.Session.query(Army).order_by(Army.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def new_army(name, general_id, x, y, money, food, original, expedition_type):
    army = Army()
    army.name = name
    army.general_id = general_id
    army.x = x
    army.y = y
    army.money = money
    army.food = food
    army.original = original
    army.expedition_type = expedition_type
    meta.Session.add(army)
    meta.Session.commit()
    return army

@catch_exception    
def delete_army_by_id(id):
    t = meta.Session.query(Army).filter(Army.id == id).first()
    meta.Session.delete(t)
    meta.Session.commit()

@catch_exception
def update_army_all(id,name, general_id, x, y, money, food, original, expedition_type):
    army = meta.Session.query(Army).filter(Army.id == id).first()
    DIC = {"name":"","general_id":-1, \
        "x":-1,"y":-1,"money":-1, \
        "food":-1,"original":-1,"expedition_type":-1}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(gen,k,eval(k))
#            setattr(gen,k,locals().get(k))
    meta.Session.commit()
    return army

class Army(object): pass