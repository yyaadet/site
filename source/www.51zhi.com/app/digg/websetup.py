"""Setup the digg application"""
import logging
import md5
import time

from digg.config.environment import load_environment
from digg import model

from digg.model.all_table import *

from lib.utils import *

#uwsgi --paste config:/usr/local/etc/webdigg.ini --socket :3031 -H ~/sites/apps

log = logging.getLogger(__name__)

def setup_app(command, conf, vars):
    """Place any commands to setup digg here"""
    load_environment(conf.global_conf, conf.local_conf)
    
    init_db_data()
    init_test_data()

    log.info("successfully setup")


def init_db_data():
    p = Admin.new_obj()
    p.name = 'admin'
    p.passwd = md5.md5("123456").hexdigest()
    Admin.put_data(p)
    
    if Setting.query_num({}) > 0:
        return
    setting = Setting.new_obj()
    setting.upload_dir = 'd:/flash_game'
    setting.static_addr = "http://localhost:800"
    Setting.put_data(setting)

def init_test_data():    
    pass