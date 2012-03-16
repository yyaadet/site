#coding=utf-8

from feed import model

NAME="setting"

class Setting(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {
                   "is_use_static_url": {'sort': None, "default": 0},  
                   "seo_title": {'sort': None, "default": u'巨游'},
                   "seo_desc": {'sort': 'desc', "default": u''},
                   "seo_keywords": {'sort': None, "default": u'巨游'},
                 }    