from webhanfeng.lib.utils import *
import meta

@catch_exception
def get_all_filter(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Filter).order_by(Filter.id.asc()).all()
    else:
        r = meta.Session.query(Filter).order_by(Filter.id.asc()).limit(limit).offset(offset).all()
    return r

class Filter(object): pass