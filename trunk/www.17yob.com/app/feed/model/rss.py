#coding=utf-8
from feed import model

NAME="rss"

class Rss(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {
                  "uid": {'sort': "asc", "default": ''},
                  "uname": {'sort': "", "default": ''},
                  "url": {'sort': "asc", "default": ''},
                  "name": {'sort': None, "default": ''},
                  "group_id": {'sort': None, "default": 0},
                  "add_timestamp": {'sort': None, "default": 0},
                  "edit_timestamp": {'sort': None, "default": 0},
                  "fetch_timestamp": {'sort': None, "default": 0},
                  "fetch_num": {'sort': None, "default": 0},
                  "today_fetch_num": {'sort': None, "default": 0},
                  "fetch_error": {'sort': None, "default": 0},
                  "is_del": {'sort': None, "default": 0},
                  "visited_num": {'sort': None, "default": 0},
                  "go_num": {'sort': None, "default": 0},
                 }