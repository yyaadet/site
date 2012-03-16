from webhanfeng.lib.utils import *
import meta

def get_general_count():
    m = meta.Session.query(General).count()
    return m

@catch_exception
def get_all_general(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(General).order_by(General.id.asc()).all()
    else:
        r = meta.Session.query(General).order_by(General.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def new_genreal(user_id,type, first_name, last_name, \
        zi, sex, born_year, init_year, \
        place, place_id, kongfu, intelligence, \
        polity, speed, faith, face_id, is_dead, \
        mission_type, skill, zhen, \
        cur_used_zhen, solider_num, \
        hurt_num, level, solider_spirit, \
        experience, description, \
        w1_type, w1_level, \
        w2_type, w2_level, \
        w3_type, w3_level, \
        w4_type, w4_level):
    general = General()
    ATTRIBUTE= ["user_id","type", "first_name", "last_name", \
            "zi", "sex", "born_year", "init_year", \
            "place", "place_id", "kongfu", "intelligence", \
            "polity", "speed", "faith", "face_id", "is_dead", \
            "mission_type", "skill", "zhen", \
            "cur_used_zhen", "solider_num", \
            "hurt_num", "level", "solider_spirit", \
            "experience", "description", \
            "w1_type", "w1_level", \
            "w2_type", "w2_level", \
            "w3_type", "w3_level", \
            "w4_type", "w4_level"]
    for k in ATTRIBUTE:
        setattr(general,k,eval(k))
    meta.Session.add(general)
    meta.Session.commit()
    return general


@catch_exception
def update_genreal_all(user_id,type, first_name, last_name, \
        zi, sex, born_year, init_year, \
        place, place_id, kongfu, intelligence, \
        polity, speed, faith, face_id, is_dead, \
        mission_type, skill, zhen, \
        cur_used_zhen, solider_num, \
        hurt_num, level, solider_spirit, \
        experience, description, \
        w1_type, w1_level, \
        w2_type, w2_level, \
        w3_type, w3_level, \
        w4_type, w4_level):
    general = meta.Session.query(General).filter(General.id == id).first()
    DIC= {"user_id":-1,"type":-1, "first_name":"", "last_name":"", \
            "zi":"", "sex":-1, "born_year":-1, "init_year":-1, \
            "place":-1, "place_id":-1, "kongfu":-1, "intelligence":-1, \
            "polity":-1, "speed":-1, "faith":-1, "face_id":-1, "is_dead":-1, \
            "mission_type":-1, "skill":-1, "zhen":-1, \
            "cur_used_zhen":-1, "solider_num":-1, \
            "hurt_num":-1, "level":-1, "solider_spirit":-1, \
            "experience":-1, "description":"", \
            "w1_type":-1, "w1_level":-1, \
            "w2_type":-1, "w2_level":-1, \
            "w3_type":-1, "w3_level":-1, \
            "w4_type":-1, "w4_level":-1}
    for k,v in DIC.items():
        if eval(k) != v[0]:
            setattr(general,k,eval(k))
#            setattr(user,k,locals().get(k))
    meta.Session.commit()
    return general


@catch_exception    
def delete_general_by_id(id):
    t = meta.Session.query(General).filter(General.id == id).first()
    meta.Session.delete(t)
    meta.Session.commit()

class General(object): pass