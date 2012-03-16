from webhanfeng.lib.utils import *
import meta


def get_cmd_transfer_count():
    m = meta.Session.query(CmdTransfer).count()
    return m

@catch_exception
def get_all_cmd_transfer(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(CmdTransfer).order_by(CmdTransfer.id.asc()).all()
    else:
        r = meta.Session.query(CmdTransfer).order_by(CmdTransfer.id.asc()).limit(limit).offset(offset).all()
    return r

@catch_exception
def new_cmd_transfer(from_id, to_id, type, \
                sphere_id, goods_type, goods_id, goods_num, \
                end_time):
    cmds = CmdTransfer()
    cmds.from_id = from_id
    cmds.to_id = to_id
    cmds.type = type
    cmds.sphere_id = sphere_id
    cmds.goods_type = goods_type
    cmds.goods_id = goods_id
    cmds.goods_num = goods_num
    cmds.end_time = end_time
    meta.Session.add(cmds)
    meta.Session.commit()
    return cmds

@catch_exception    
def delete_cmd_transfer_by_id(id):
    t = meta.Session.query(CmdTransfer).filter(CmdTransfer.id == id).first()
    meta.Session.delete(t)
    meta.Session.commit()

class CmdTransfer(object): pass