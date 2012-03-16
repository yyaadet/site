import meta
import time

from obj import ExpandLog
from obj import catch_exception

@catch_exception
def new_expand_log(uid,expand_id,rmb):
    data = ExpandLog()
    data.uid = uid
    data.expand_id = expand_id
    data.rmb = rmb
    data.time = int(time.time())
    meta.Session.add(data)
    return data
