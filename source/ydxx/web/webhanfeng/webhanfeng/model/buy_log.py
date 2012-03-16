from webhanfeng.lib.utils import *
import meta

@catch_exception
def new_buy_log(user_id,total,buy_date):
    bl    =    BuyLog()
    bl.user_id = user_id
    bl.total = total
    bl.buy_date = buy_date
    meta.Session.add(bl)
    meta.Session.commit()
    return bl

class BuyLog(object): pass