import meta
import time

from obj import OperationLog
from obj import catch_exception

def get_all_operation_logs(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(OperationLog).order_by(OperationLog.id.desc()).all()
    else:
        data = meta.Session.query(OperationLog).order_by(OperationLog.id.desc()).limit(limit).offset(offset).all()
    return data

def get_operation_log_count():
    data = meta.Session.query(OperationLog).count()
    return data

@catch_exception
def new_operation_log(admin_id, admin_name, description):
    s = OperationLog()
    s.admin_id = admin_id
    s.admin_name = admin_name
    s.description = description
    s.time = int(time.time())
    meta.Session.add(s)
    return s