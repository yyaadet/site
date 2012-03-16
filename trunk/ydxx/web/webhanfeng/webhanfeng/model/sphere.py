from webhanfeng.lib.utils import *
import meta

def get_sphere_count():
    m = meta.Session.query(Sphere).count()
    return m

@catch_exception
def get_all_sphere(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Sphere).order_by(Sphere.id.asc()).all()
    else:
        r = meta.Session.query(Sphere).order_by(Sphere.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def new_sphere(user_id,name,level,prestige,description):
    sphere = Sphere()
    sphere.user_id = user_id
    sphere.name = name
    sphere.level = level
    sphere.prestige = prestige
    sphere.is_npc = 0
    sphere.description = description
    meta.Session.add(sphere)
    meta.Session.commit()
    return sphere

@catch_exception    
def del_sphere_by_id(id):
    t = meta.Session.query(Sphere).filter(Sphere.id == id).first()
    meta.Session.delete(t)
    meta.Session.commit()

@catch_exception
def update_sphere_all(id,user_id,name,level,prestige,description):
    sphere = meta.Session.query(Sphere).filter(Sphere.id == id).first()
    DIC = {"user_id":0,"name":"", \
        "level":-1,"prestige":-1,"description":""}
    for k,v in DIC.items():
        if eval(k) != v:
            setattr(sphere,k,eval(k))
#            setattr(sphere,k,locals().get(k))
    meta.Session.commit()
    return sphere

class Sphere(object): pass