from webhanfeng.lib.utils import *
import meta

def new_authority(group_id, **argv):
    authority = Authority()
    authority.group_id = group_id
    prog = ""
    for (k, v) in argv.items():
        prog += "authority.%s=%s\n" % (k, v)
    exec(prog)
    meta.Session.add(authority)
    meta.Session.commit()
    return authority 

def update_authority(group_id, **args):
    auth = get_authority_by_group_id(group_id)
    if auth == None:
        auth = new_authority(group_id, **args)
        return auth
    clean_authority(auth.id)
    prog = ""
    for (k, v) in args.items():
        prog += "auth.%s=%s\n" % (k, v)
    exec(prog)
    meta.Session.commit()
    return auth

@catch_exception
def get_authority_by_id(id):
    au = meta.Session.query(Authority).filter(Authority.id == id).first()
    return au

def clean_authority(id):
    auth = get_authority_by_id(id)
    AUTHS = ["show_user","lock_user"]
    for i in AUTHS:
        setattr(auth,i,0)
    return auth

@catch_exception
def get_authority_by_group_id(group_id):
    au = meta.Session.query(Authority).filter(Authority.group_id == group_id).first()
    return au

class Authority(object): pass