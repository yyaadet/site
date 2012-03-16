from webhanfeng.lib.utils import *
import meta

def get_city_count():
    m = meta.Session.query(City).count()
    return m

@catch_exception
def get_all_city(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(City).order_by(City.id.asc()).all()
    else:
        r = meta.Session.query(City).order_by(City.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def update_city_all(id,sphere_id,defense,is_alloted):
    city = meta.Session.query(City).filter(City.id == id).first()
    DIC = {"sphere_id":-1,"defense":-1,"is_alloted":-1}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(city,k,eval(k))
#            setattr(city,k,locals().get(k))
    meta.Session.commit()
    return city

class City(object): pass