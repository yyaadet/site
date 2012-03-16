from webhanfeng.lib.utils import *
import meta

def get_zhanyi_count():
    m = meta.Session.query(ZhanYi).count()
    return m

@catch_exception
def get_all_zhanyi(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(ZhanYi).order_by(ZhanYi.id.asc()).all()
    else:
        r = meta.Session.query(ZhanYi).order_by(ZhanYi.id.asc()).limit(limit).offset(offset).all()
    return r

class ZhanYi(object): pass