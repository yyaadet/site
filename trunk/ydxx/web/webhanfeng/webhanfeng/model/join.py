from webhanfeng.lib.utils import *
from webhanfeng.model import *
import meta

def get_treasure_count_exist():
    num = meta.Session.query("count")\
    .from_statement("SELECT count(*) as count FROM hf_shop s, hf_treasure t where \
    s.id = t.treasure_id and (s.one_off = 0 or (s.one_off = 1 and t.is_used = 0))").all()
    return num

@catch_exception
def get_all_treasure_exist(offset=None,limit=None):
    if limit is None or offset is None:
        num = meta.Session.query(Treasure)\
        .from_statement("SELECT t.* as treasure FROM hf_shop s, hf_treasure t where \
        s.id = t.treasure_id and (s.one_off = 0 or (s.one_off = 1 and t.is_used = 0)) \
        order by t.id").all()
        return num
    else:
        num = meta.Session.query(Treasure)\
        .from_statement("SELECT t.* as treasure FROM hf_shop s, hf_treasure t where \
        s.id = t.treasure_id and (s.one_off = 0 or (s.one_off = 1 and t.is_used = 0)) \
        order by t.id limit :offset, :limit").params(offset=offset, limit=limit).all()
        return num
    return num

def weapon_trade(sell_uid, buy_uid, gold, tax=0.1):
    seller = get_user_by_id(sell_uid)
    if seller is None:
        return "1"
    buyer = get_user_by_id(buy_uid)
    if buyer is None:
        return "2"
    if buyer.money < gold:
        return "3"
    else:
        seller.money += gold*(1 - tax)
        buyer.money -= gold
        meta.Session.commit()
        return "0"

##############for web##############
#user_list
@catch_exception
def get_userlist_sort(flag,sort,offset=None,limit=None):
    if limit is None or offset is None:
        m = meta.Session.query(User).filter(User.is_locked == 0).order_by(User.id.asc()).all()
    else:
        query = "select * from hf_user where is_locked = 0 order by %s %s limit %d,%d" %(flag,sort,offset,limit)
        m = meta.Session.query(User).from_statement(query).all()
    return m
    
@catch_exception
def get_userlist_name_like(name,offset=None,limit=None):
    if limit is None or offset is None:
        m = meta.Session.query(User).filter(or_(User.oid.like(name), User.name.like(name))).order_by(User.id.asc()).all()
    else:
        m = meta.Session.query(User).filter(or_(User.oid.like(name), User.name.like(name))).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return m

def get_userlist_name_like_count(name):
    m = meta.Session.query(User).filter(or_(User.oid.like(name), User.name.like(name))).count()
    return m

@catch_exception
def get_userlist_locked(offset=None,limit=None):
    if limit is None or offset is None:
        m = meta.Session.query(User).filter(User.is_locked == 1).order_by(User.id.asc()).all()
    else:
        m = meta.Session.query(User).filter(User.is_locked == 1).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return m

def get_userlist_locked_count():
    m = meta.Session.query(User).filter(User.is_locked == 1).count()
    return m

@catch_exception
def get_userlist_onlinetime(offset=None,limit=None):
    if limit is None or offset is None:
        m = meta.Session.query(User).order_by(User.online_second.desc()).all()
    else:
        m = meta.Session.query(User).order_by(User.online_second.desc()).limit(limit).offset(offset).all()
    return m

#recharege_records
@catch_exception
def get_pay_count():
    g = meta.Session.query(ChongZhi,User).filter(ChongZhi.uid == User.id).count()
    return g

@catch_exception
def get_pay():
    g = meta.Session.query(ChongZhi,User).filter(ChongZhi.uid == User.id).order_by(ChongZhi.id.asc()).all()
    return g

@catch_exception
def get_pay_name_like_count(name):
    m = meta.Session.query(ChongZhi,User).filter(ChongZhi.uid == User.id).filter(User.oid.like(name)).count()
    return m

@catch_exception
def get_pay_name_like(name):
    m = meta.Session.query(ChongZhi,User).filter(ChongZhi.uid == User.id).filter(User.oid.like(name)).order_by(ChongZhi.id.asc()).all()
    return m

#search_registed_users
@catch_exception
def get_userlist_regist_time(start_time,end_time,limit=None,offset=None):
    if limit is None or offset is None:
        g = meta.Session.query(User).filter(User.first_login_time >= start_time).filter(User.first_login_time <= end_time).order_by(User.id.asc()).all()
    else:
        g = meta.Session.query(User).filter(User.first_login_time >= start_time).filter(User.first_login_time <= end_time).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return g

def get_userlist_regist_time_count(start_time,end_time):
    m = meta.Session.query(User).filter(User.first_login_time >= start_time).filter(User.first_login_time <= end_time).count()
    return m

#user_statistics
@catch_exception
def get_user_regist_count(start_time,end_time,format):
    reg = meta.Session.query("times","count")\
    .from_statement("SELECT FROM_UNIXTIME(first_login_time, :format) as times,count(*) as count FROM hf_user where first_login_time >= :start_time \
    and first_login_time <= :end_time GROUP BY FROM_UNIXTIME(first_login_time, :format)")\
    .params(start_time=start_time,end_time=end_time,format=format).all()
    return reg

@catch_exception
def get_user_login_count(start_time,end_time,format):
    login = meta.Session.query("times","count")\
    .from_statement("SELECT FROM_UNIXTIME(last_login_time, :format) as times,count(*) as count FROM hf_user where last_login_time >= :start_time \
    and last_login_time <= :end_time GROUP BY FROM_UNIXTIME(last_login_time, :format)")\
    .params(start_time=start_time,end_time=end_time,format=format).all()
    return login

@catch_exception
def get_maintainer(offset,limit):
    if offset is None or limit is None:
        g = meta.Session.query(Admin,Group).outerjoin((Group,Admin.group_id == Group.id)).order_by(Admin.id.asc()).all()
    else:
        g = meta.Session.query(Admin,Group).outerjoin((Group,Admin.group_id == Group.id)).order_by(Admin.id.asc()).limit(limit).offset(offset).all()
    return g

def get_maintainer_count():
    g = meta.Session.query(Admin,Group).outerjoin((Group,Admin.group_id == Group.id)).count()
    return g

@catch_exception
def get_maintainer_by_id(id):
    g = meta.Session.query(Admin,Group).outerjoin((Group,Admin.group_id == Group.id)).filter(Admin.id == id).first()
    return g

@catch_exception
def get_group(offset,limit):
    if offset is None or limit is None:
        g = meta.Session.query(Group).order_by(Group.id.asc()).all()
    else:
        g = meta.Session.query(Group).order_by(Group.id.asc()).limit(limit).offset(offset).all()
    return g

def get_group_count():
    counts = meta.Session.query(Group).count()
    return counts

@catch_exception
def validate_group(id,name):
    g = meta.Session.query(Group).filter(Group.id != id).filter(Group.name == name).first()
    return g

@catch_exception
def get_apply_for_search(name,offset=None,limit=None):
    if limit is None or offset is None:
        m = meta.Session.query(ApplyFor,User).outerjoin((User,ApplyFor.user_id == User.id)).filter(User.oid.like(name)).order_by(User.id.asc()).all()
    else:
        m = meta.Session.query(ApplyFor,User).outerjoin((User,ApplyFor.user_id == User.id)).filter(User.oid.like(name)).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return m

def get_apply_for_search_count(name):
    m = meta.Session.query(ApplyFor,User).outerjoin((User,ApplyFor.user_id == User.id)).filter(User.oid.like(name)).count()
    print m
    return m

#GM
@catch_exception
def get_gmlist_name_like(name,offset=None,limit=None):
    if limit is None or offset is None:
        m = meta.Session.query(User).filter(User.is_gm == 1).filter(or_(User.oid.like(name), User.name.like(name))).order_by(User.id.asc()).all()
    else:
        m = meta.Session.query(User).filter(User.is_gm == 1).filter(or_(User.oid.like(name), User.name.like(name))).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return m

def get_gmlist_name_like_count(name):
    m = meta.Session.query(User).filter(User.is_gm == 1).filter(or_(User.oid.like(name), User.name.like(name))).count()
    return m

def get_gm_count():
    m = meta.Session.query(User).filter(User.is_gm == 1).count()
    return m

@catch_exception
def get_all_gm(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(User).filter(User.is_gm == 1).order_by(User.id.asc()).all()
    else:
        r = meta.Session.query(User).filter(User.is_gm == 1).order_by(User.id.asc()).limit(limit).offset(offset).all()
    return r

############################chongzhi############################

def user_chongzhi(uid,rmb,gold):
    user = meta.Session.query(User).filter(User.id == uid).first()
    chongzhi = ChongZhi()
    chongzhi.uid = uid
    chongzhi.rmb = rmb
    chongzhi.gold = gold
    chongzhi.cz_time = int(time.time())
    user.money += gold
    meta.Session.add(chongzhi)
    meta.Session.commit()

@catch_exception
def get_cztj(format):
    cztj = meta.Session.query("times","rmb","gold","cnt")\
    .from_statement("SELECT FROM_UNIXTIME(cz_time, :format) as times,sum(rmb) as rmb, sum(gold) as gold,count(*) as cnt FROM hf_chongzhi  \
    GROUP BY FROM_UNIXTIME(cz_time, :format)")\
    .params(format=format).all()
    return cztj

@catch_exception
def get_cztj_counts():
    cztj = meta.Session.query("rmb","gold","cnt")\
    .from_statement("SELECT sum(rmb) as rmb, sum(gold) as gold,count(*) as cnt FROM hf_chongzhi").first()
    return cztj