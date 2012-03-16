from webhanfeng.lib.utils import *
import meta

def get_guanka_count():
    m = meta.Session.query(GuanKa).count()
    return m

@catch_exception
def get_all_guanka(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(GuanKa).order_by(GuanKa.id.asc()).all()
    else:
        r = meta.Session.query(GuanKa).order_by(GuanKa.id.asc()).limit(limit).offset(offset).all()
    return r

class GuanKa(object): pass