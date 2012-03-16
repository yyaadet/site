from webhanfeng.lib.utils import *
import meta
import time


@catch_exception
def new_chongzhi(uid,rmb,gold):
    bl    =    ChongZhi()
    bl.uid = uid
    bl.rmb = rmb
    bl.gold = gold
    bl.cz_time = int(time.time())
    bl.type = 1
    meta.Session.add(bl)
    meta.Session.commit()
    return bl


class ChongZhi(object): pass