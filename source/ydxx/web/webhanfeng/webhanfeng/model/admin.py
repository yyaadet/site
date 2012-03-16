from webhanfeng.lib.utils import *
import meta

@catch_exception
def new_admin(username,password,group_id):
    admin = Admin()
    admin.username = username
    admin.password = md5.md5(password).hexdigest()
    admin.group_id = group_id
    meta.Session.add(admin)
    meta.Session.commit()
    return admin

@catch_exception
def get_admin_by_name(name):
    admin = meta.Session.query(Admin).filter(Admin.username == name).first()
    return admin

@catch_exception
def update_admin_password(id,password):
    admin = get_admin_by_id(id)
    admin.password = md5.md5(password).hexdigest()
    meta.Session.commit()
    return admin

@catch_exception
def get_admin_by_id(id):
    g = meta.Session.query(Admin).filter(Admin.id == id).first()
    return g

@catch_exception
def update_admin(id,group_id):
    g = get_admin_by_id(id)
    g.group_id = group_id
    meta.Session.commit()
    return g

@catch_exception
def del_admin_by_id(id):
    r = get_admin_by_id(id)
    meta.Session.delete(r)
    meta.Session.commit()

class Admin(object): pass