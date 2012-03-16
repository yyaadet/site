#coding=utf-8
from feed import model

NAME="friendlink"

class Friendlink(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"url": {'sort': None, "default": ''},
                  "name": {'sort': None, "default": ''},    
                   "is_in_home": {'sort': None, "default": 0},
                   "is_hot":  {'sort': None, "default": 0},
                   "order": {'sort': "desc", "default": 0}, 
                   "timestamp": {'sort': None, "default": 0},
                 }