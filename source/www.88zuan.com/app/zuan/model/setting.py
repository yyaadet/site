#coding=utf-8

import sqlalchemy as sa
from sqlalchemy import orm
from sqlalchemy import *

from zuan import model
from zuan import lib

NAME="setting"

        
class Setting(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {
                   "upload_dir": {"sort": None, "default": ''},
                   "static_addr": {'sort': None, "default": ''}, 
                   "is_use_static_url": {'sort': None, "default": '0'},
                   "seo_title": {'sort': None, "default": ''},
                   "seo_desc": {'sort': None, "default": ''},
                   "seo_keywords": {'sort': None, "default": ''},
                 }
        
    @classmethod
    def get(cls):
        ret = cls.query({})[0]
        if 'static_addr' in lib.config:
            ret.static_addr = lib.config['static_addr']
        ret.domain = lib.config['domain']
        return ret