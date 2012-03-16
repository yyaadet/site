from webhanfeng.lib.utils import *
import meta

def get_task_count():
    m = meta.Session.query(Task).count()
    return m

@catch_exception
def get_all_task(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Task).order_by(Task.id.asc()).all()
    else:
        r = meta.Session.query(Task).order_by(Task.id.asc()).limit(limit).offset(offset).all()
    return r

class Task(object): pass