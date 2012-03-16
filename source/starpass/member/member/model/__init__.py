"""The application's model objects"""
import logging
import traceback

import sqlalchemy as sa
from sqlalchemy import orm,Table

from member.model import meta
from member.model import obj
from admin import *
from user import *
from game import *
from line import *
from server import *
from recharge_log import *
from exchange_log import *
from operation_log import *
from sys_setting import *
from expand_people import *
from expand_log import *
from game_gift import *
from recharge_rate import *

log = logging.getLogger(__name__)

def init_model(engine):
    """Call me before using any of the tables or classes in the model"""
    ## Reflected tables must be defined and mapped here
    #global reflected_table
    #reflected_table = sa.Table("Reflected", meta.metadata, autoload=True,
    #                           autoload_with=engine)
    #orm.mapper(Reflected, reflected_table)
    #
    map_all_tables(engine)
    meta.Session.configure(bind=engine)
    meta.engine = engine


## Non-reflected tables may be defined and mapped at module level
#foo_table = sa.Table("Foo", meta.metadata,
#    sa.Column("id", sa.types.Integer, primary_key=True),
#    sa.Column("bar", sa.types.String(255), nullable=False),
#    )
#
#class Foo(object):
#    pass
#
#orm.mapper(Foo, foo_table)


## Classes for reflected tables may be defined here, but the table and
## mapping itself must be done in the init_model function
#reflected_table = None
#
#class Reflected(object):
#    pass
def map_all_tables(engine):
    map_one_table('admin', obj.Admin, meta.metadata, engine)
    map_one_table('user', obj.User, meta.metadata, engine)
    map_one_table('game', obj.Game, meta.metadata, engine)
    map_one_table('line', obj.Line, meta.metadata, engine)
    map_one_table('server', obj.Server, meta.metadata, engine)
    map_one_table('recharge_log', obj.RechargeLog, meta.metadata, engine)
    map_one_table('exchange_log', obj.ExchangeLog, meta.metadata, engine)
    map_one_table('operation_log', obj.OperationLog, meta.metadata, engine)
    map_one_table('sys_setting', obj.SysSetting, meta.metadata, engine)
    map_one_table('expand_people', obj.ExpandPeople, meta.metadata, engine)
    map_one_table('expand_log', obj.ExpandLog, meta.metadata, engine)
    map_one_table('game_gift', obj.GameGift, meta.metadata, engine)
    map_one_table('recharge_rate', obj.RechargeRate, meta.metadata, engine)

def map_one_table(table_name, table_object, metadata, engine):
    try:
        table = Table(table_name, metadata, autoload=True, autoload_with=engine)
        orm.mapper(table_object, table)
        return table
    except Exception, e:
        log.warning("map_one_table: %s", e)
        return None
