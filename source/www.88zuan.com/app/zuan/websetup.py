"""Setup the zuan application"""
import logging
import md5
import time

from zuan.config.environment import load_environment
from zuan import model

from zuan.model.all_table import *

from lib.utils import *

#uwsgi --paste config:/usr/local/etc/webzuan.ini --socket :3031 -H ~/sites/apps

log = logging.getLogger(__name__)

def setup_app(command, conf, vars):
    """Place any commands to setup zuan here"""
    load_environment(conf.global_conf, conf.local_conf)

    log.info("create tables")
    # Create the tables if they don't already exist

    #model._flash_game_log_meta.drop_all()
    #model._flash_game_post_meta.drop_all()
    #model._flash_game_love_meta.drop_all()
    #model._flash_game_meta.drop_all()
    model._master_meta.drop_all()
    
    #model._flash_game_log_meta.create_all()
    #model._flash_game_post_meta.create_all()
    #model._flash_game_love_meta.create_all()
    #model._flash_game_meta.create_all()
    model._master_meta.create_all()
    
    init_db_data()
    #init_test_data()

    log.info("successfully setup")


def init_db_data():
    p = Storage()
    p.name = 'admin'
    p.password = md5.md5("123456").hexdigest()
    Admin.put_data(None, p, is_new = True)
    
    setting = Storage()
    setting.upload_dir = 'd:/flash_game'
    setting.static_addr = "http://localhost"
    Setting.put_data(None, setting, is_new = True)

def init_test_data():    
    for i in range(0, 30):
        u = Storage()
        u.name = 'xiaotao%d' % i
        u.passwd = md5.md5('xiaotao').hexdigest()
        u.email = "164504252@qq.com"
        u.sex = i % 2
        u.point = 600
        User.put_data(None, u, is_new = True)
        
    for j in range(1, 3):
        for i in range(100):
            obj = Storage()
            obj.uid = (i % 8) + 1
            obj.name = "flash_%d_%d" % (i, j)
            obj.group_id = j
            obj.info = "good"
            obj.operate_info = "good"
            obj.author = "hao"
            obj.phone = "ddd"
            obj.timestamp = int(time.time())
            FlashGame.put_data(None, obj, is_new = True)