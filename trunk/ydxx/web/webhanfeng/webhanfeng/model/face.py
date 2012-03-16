from webhanfeng.lib.utils import *
import meta

def get_face_count():
    m = meta.Session.query(Face).count()
    return m

@catch_exception
def get_all_face(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Face).order_by(Face.id.asc()).all()
    else:
        r = meta.Session.query(Face).order_by(Face.id.asc()).limit(limit).offset(offset).all()
    return r

class Face(object): pass