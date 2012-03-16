#coding=utf-8
from digg import model

NAME="feed"

class Feed(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"url": {'sort': None, "default": ''},
                  "name": {'sort': None, "default": ''},
                   "num": {'sort': "desc", "default": 0},
                   "timestamp": {'sort': None, "default": 0},
                 }