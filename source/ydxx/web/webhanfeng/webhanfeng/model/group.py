from webhanfeng.lib.utils import *
import meta

def new_group(name, description, **args):
    try:
        group = Group()
        group.name = name
        group.description = description
        meta.Session.add(group)
        meta.Session.commit()
        auth = new_authority(group.id,**args)
        return group
    except Exception, e:
        return None

def update_group(id,name,description, **args):
    group = get_group_by_id(id)
    group.name = name
    group.description = description
    meta.Session.commit()
    update_authority(group.id,**args)
    return group

@catch_exception
def get_group_by_id(id):
    g = meta.Session.query(Group).filter(Group.id == id).first()
    return g

@catch_exception
def get_group_by_name(name):
    g = meta.Session.query(Group).filter(Group.name == name).first()
    return g

@catch_exception
def get_all_group():
    g = meta.Session.query(Group).all()
    return g

@catch_exception
def del_group_by_id(id):
    g = get_group_by_id(id)
    meta.Session.delete(g)
    meta.Session.commit()

class Group(object): pass