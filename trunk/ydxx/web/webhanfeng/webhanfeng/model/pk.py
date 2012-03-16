from webhanfeng.lib.utils import *
import meta

def get_pk_count():
    m = meta.Session.query(PK).count()
    return m

@catch_exception
def get_all_pk(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(PK).order_by(PK.id.asc()).all()
    else:
        r = meta.Session.query(PK).order_by(PK.id.asc()).limit(limit).offset(offset).all()
    return r

class PK(object): pass