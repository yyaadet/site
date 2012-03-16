from webhanfeng.lib.utils import *
import meta
import time


@catch_exception
def new_apply_for(user_id, age, sex, profession, \
        email, place, game_hour, income, know_from, reason):
    apply_for = ApplyFor()
    apply_for.user_id = user_id
    apply_for.age = age
    apply_for.sex = sex
    apply_for.profession = profession
    apply_for.email = email
    apply_for.place = place
    apply_for.game_hour = game_hour
    apply_for.income = income
    apply_for.know_from = know_from
    apply_for.reason = reason
    apply_for.date = int(time.time())
    meta.Session.add(apply_for)
    meta.Session.commit()
    return apply_for

@catch_exception
def get_apply_for_by_id(id):
    r = meta.Session.query(ApplyFor).filter(ApplyFor.id == id).first()
    return r

@catch_exception
def get_apply_for_by_user_id(user_id):
    r = meta.Session.query(ApplyFor).filter(ApplyFor.user_id == user_id).first()
    return r

@catch_exception
def get_all_apply_for(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(ApplyFor).order_by(ApplyFor.id.asc()).all()
    else:
        r = meta.Session.query(ApplyFor).order_by(ApplyFor.id.asc()).limit(limit).offset(offset).all()
    return r

def get_apply_for_count():
    m = meta.Session.query(ApplyFor).count()
    return m

def get_apply_for_count_less_than(id):
    m = meta.Session.query(ApplyFor).filter(ApplyFor.id < id).count()
    return m

@catch_exception
def delete_apply_for_by_id(id):
    apply_for = meta.Session.query(ApplyFor).filter(ApplyFor.id == id).first()
    meta.Session.delete(apply_for)
    meta.Session.commit()

@catch_exception
def delete_apply_for_all():
    apply_for = meta.Session.query(ApplyFor).all()
    for i in apply_for:
        meta.Session.delete(i)
    meta.Session.commit()

@catch_exception
def update_apply_for_state(id,state):
    r = meta.Session.query(ApplyFor).filter(ApplyFor.id == id).first()
    r.state = state
    meta.Session.commit()
    return r


class ApplyFor(object): pass