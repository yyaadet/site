#coding=utf-8

from digg import model

NAME="setting"

class Setting(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"upload_dir": {'sort': None, "default": '/data'},
                  "static_addr": {'sort': None, "default": 'http://1.static.88zuan.com'},    
                   "is_use_static_url": {'sort': None, "default": 0},  
                   "seo_title": {'sort': None, "default": u'巨游'},
                   "seo_desc": {'sort': 'desc', "default": u''},
                   "seo_keywords": {'sort': None, "default": u'巨游'},
                 }    