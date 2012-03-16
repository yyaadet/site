from webhanfeng.lib.utils import *
import meta

def get_tech_count():
    m = meta.Session.query(Store).count()
    return m

@catch_exception
def get_all_tech(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Tech).order_by(Tech.id.asc()).all()
    else:
        r = meta.Session.query(Tech).order_by(Tech.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def update_tech_all(id,wubao_id,type,levle,end_time):
    tech = meta.Session.query(Tech).filter(Tech.id == id).first()
    DIC = {"wubao_id":-1,"type":-1, \
        "level":-1,"end_time":-1}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(tech,k,eval(k))
#            setattr(tech,k,locals().get(k))
    meta.Session.commit()
    return tech

class Tech(object): pass