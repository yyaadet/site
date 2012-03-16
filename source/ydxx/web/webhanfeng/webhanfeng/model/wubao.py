from webhanfeng.lib.utils import *
import meta

def get_wubao_count():
    m = meta.Session.query(Wubao).count()
    return m

@catch_exception
def get_all_wubao(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Wubao).order_by(Wubao.id.asc()).all()
    else:
        r = meta.Session.query(Wubao).order_by(Wubao.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def update_wubao_all(id,user_id,people,family,prestige,sphere_id,dig_id,off_id,sol_num,moeny, \
        food,wood,iron,skin,horse,get_sol,used_made,cure_solider):
    wubao = meta.Session.query(Wubao).filter(Wubao.id == id).first()
    DIC = {"user_id":-1,"people":-1, \
        "family":-1,"prestige":-1,"sphere_id":-1, \
        "dig_id":0,"off_id":0,"sol_num":-1, \
        "money":-1,"food":-1,"iron":-1, \
        "skin":-1,"horse":-1,"get_sol":-1,"used_made":-1,"cure_solider":-1}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(wubao,k,eval(k))
#            setattr(wubao,k,locals().get(k))
    meta.Session.commit()
    return wubao

@catch_exception
def new_wubao(user_id,people,family,prestige,city_id,x,y, \
    sphere_id,dig_id,off_id,sol_num, \
    money,food,iron,skin,horse,get_sol,used_made,flag=1):
    wubao = Wubao()
    ATTRIBUTE= ["user_id","people", \
        "family","prestige","city_id", \
        "x", "y", "sphere_id", \
        "dig_id","off_id","sol_num", \
        "money","food","iron", \
        "skin","horse","get_sol","used_made"]
    for k in ATTRIBUTE:
        setattr(wubao,k,eval(k))
    meta.Session.add(wubao)
    if flag == 1:
        meta.Session.commit()
    return wubao

class Wubao(object): pass