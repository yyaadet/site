"""The application's model objects"""
import sqlalchemy as sa
from sqlalchemy import orm,types,Table
from webhanfeng.lib.utils import *
from sqlalchemy.orm import join
from sqlalchemy import and_, or_, func
from pylons import g

from webhanfeng.model import meta

from admin import *
from army import *
from authority import *
from buy_log import *
from city import *
from cmd_transfer import *
from diplomacy import *
from face import *
from general import *
from group import *
from mail import *
from shop import *
from sphere import *
from sys_setting import *
from trade import *
from treasure import *
from user import *
from wubao import *
from store import *
from building import *
from tech import *
from game_gift import *
from report import *
from invite_code import *
from apply_for import *
from sell import *
from task import *
from helps import *
from pk import *
from plunder import *
from zhanyi import *
from guanka import *
from battle_info import *
from chongzhi import *
from filter import *

def init_model(engine):
    """Call me before using any of the tables or classes in the model"""
    map_all_tables(engine)
    meta.Session.configure(bind=engine)
    meta.engine = engine


def map_all_tables(engine):
    map_one_table('hf_admin', Admin, meta.metadata, engine)
    map_one_table('hf_army', Army, meta.metadata, engine)
    map_one_table('hf_authority', Authority, meta.metadata, engine)
    map_one_table('hf_buy_log', BuyLog, meta.metadata, engine)
    map_one_table('hf_city', City, meta.metadata, engine)
    map_one_table('hf_cmd_transfer', CmdTransfer, meta.metadata, engine)
    map_one_table('hf_diplomacy', Diplomacy, meta.metadata, engine)
    map_one_table('hf_face', Face, meta.metadata, engine)
    map_one_table('hf_general', General, meta.metadata, engine)
    map_one_table('hf_group', Group, meta.metadata, engine)
    map_one_table('hf_mail', Mail, meta.metadata, engine)
    map_one_table('hf_shop', Shop, meta.metadata, engine)
    map_one_table('hf_sphere', Sphere, meta.metadata, engine)
    map_one_table('hf_sys_setting', SysSetting, meta.metadata, engine)
    map_one_table('hf_trade', Trade, meta.metadata, engine)
    map_one_table('hf_treasure', Treasure, meta.metadata, engine)
    map_one_table('hf_user', User, meta.metadata, engine)
    map_one_table('hf_wubao', Wubao, meta.metadata, engine)
    map_one_table('hf_store', Store, meta.metadata, engine)
    map_one_table('hf_building', Building, meta.metadata, engine)
    map_one_table('hf_tech', Tech, meta.metadata, engine)
    map_one_table('hf_game_gift', GameGift, meta.metadata, engine)
    map_one_table('hf_report', Report, meta.metadata, engine)
    map_one_table('hf_invite_code', InviteCode, meta.metadata, engine)
    map_one_table('hf_apply_for', ApplyFor, meta.metadata, engine)
    map_one_table('hf_sell', Sell, meta.metadata, engine)
    map_one_table('hf_task', Task, meta.metadata, engine)
    map_one_table('hf_helps', Helps, meta.metadata, engine)
    map_one_table('hf_pk', PK, meta.metadata, engine)
    map_one_table('hf_plunder', Plunder, meta.metadata, engine)
    map_one_table('hf_zhanyi', ZhanYi, meta.metadata, engine)
    map_one_table('hf_guanka', GuanKa, meta.metadata, engine)
    map_one_table('hf_battle_info', BattleInfo, meta.metadata, engine)
    map_one_table('hf_chongzhi', ChongZhi, meta.metadata, engine)
    map_one_table('hf_filter', Filter, meta.metadata, engine)
    
def map_one_table(table_name, table_object, metadata, engine):
    try:
        table = Table(table_name, metadata, autoload=True, autoload_with=engine)
        orm.mapper(table_object, table)
        return table
    except Exception, e:
        log.warning("map_one_table: %s", e)
        return None