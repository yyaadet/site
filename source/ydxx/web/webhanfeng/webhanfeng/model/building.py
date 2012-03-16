from webhanfeng.lib.utils import *
import meta

def get_building_count():
    m = meta.Session.query(Store).count()
    return m

@catch_exception
def get_all_building(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Building).order_by(Building.id.asc()).all()
    else:
        r = meta.Session.query(Building).order_by(Building.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def update_building_all(id,wubao_id,type,levle,end_time):
    building = meta.Session.query(Building).filter(Building.id == id).first()
    DIC = {"wubao_id":-1,"type":-1, \
        "level":-1,"end_time":-1}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(building,k,eval(k))
#            setattr(store,k,locals().get(k))
    meta.Session.commit()
    return building

class Building(object): pass