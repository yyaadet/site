from webhanfeng.lib.utils import *
import meta

def get_battle_info_count():
    m = meta.Session.query(BattleInfo).count()
    return m

@catch_exception
def get_all_battle_info(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(BattleInfo).order_by(BattleInfo.id.asc()).all()
    else:
        r = meta.Session.query(BattleInfo).order_by(BattleInfo.id.asc()).limit(limit).offset(offset).all()
    return r

class BattleInfo(object): pass