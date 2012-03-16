from webhanfeng.lib.utils import *
import meta

def get_treasure_pic_count():
    m = meta.Session.query(TreasurePic).count()
    meta.Session.remove()
    return m

@catch_exception
def get_all_treasure_pic(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(TreasurePic).order_by(TreasurePic.id.asc()).all()
    else:
        r = meta.Session.query(TreasurePic).order_by(TreasurePic.id.asc()).limit(limit).offset(offset).all()
    meta.Session.remove()
    return r

class TreasurePic(object): pass