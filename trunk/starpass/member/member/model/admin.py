import meta
import md5

from obj import Admin
from obj import catch_exception

def get_admin_by_id(id):
    admin = meta.Session.query(Admin).filter(Admin.id == id).first()
    return admin

@catch_exception
def new_admin(name, password, level, game_id):
    admin = Admin()
    admin.name = name
    admin.password = md5.md5(password).hexdigest()
    admin.level = level
    admin.game_id = game_id
    meta.Session.add(admin)
    return admin

def get_admin_count():
    data = meta.Session.query(Admin).count()
    return data

def get_all_admins(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(Admin).order_by(Admin.id.asc()).all()
    else:
        data = meta.Session.query(Admin).order_by(Admin.id.asc()).limit(limit).offset(offset).all()
    return data

def get_admin_by_name(name):
    data = meta.Session.query(Admin).filter(Admin.name == name).first()
    return data

@catch_exception
def del_admin_by_id(id):
    data = meta.Session.query(Admin).filter(Admin.id == id).first()
    meta.Session.delete(data)

@catch_exception
def update_admin_password(id,password):
    admin = get_admin_by_id(id)
    admin.password = md5.md5(password).hexdigest()
    meta.Session.commit()
    return admin