"""Setup the feed application"""
import logging
import md5
import time

from feed.config.environment import load_environment
from feed import model

from feed.model.all_table import *

from lib.utils import *

#uwsgi --paste config:/usr/local/etc/webfeed.ini --socket :3031 -H ~/sites/apps

log = logging.getLogger(__name__)

def setup_app(command, conf, vars):
    """Place any commands to setup feed here"""
    load_environment(conf.global_conf, conf.local_conf)
    
    init_db_data()

    log.info("successfully setup")


def init_db_data():
    p = User.new_obj()
    p.name = 'admin'
    p.passwd = md5.md5("xiaotao").hexdigest()
    p.is_admin = 1
    User.put_data(p)
    
    if Setting.query_num({}) > 0:
        return
    setting = Setting.new_obj()
    Setting.put_data(setting)