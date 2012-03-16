#coding=utf-8

import sqlalchemy as sa
from sqlalchemy import orm
from sqlalchemy import *

from zuan import model

NAME="friendlink"

    
class Friendlink(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    _safe = True
    #sort: asc | desc | none
    props = {
                   "url": {"sort": None, "default": ''},
                   "name": {'sort': None, "default": ''}, 
                   "is_in_home": {'sort': None, "default": 0},
                   "add_timestamp": {'sort': 'asc', 'default': 0},
                 }