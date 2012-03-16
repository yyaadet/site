#coding=utf-8

from digg import model

NAME="stat"

class Stat(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {
        "today_news_num": {'sort': None, "default": 0},
        "today_news_timestamp": {'sort': None, "default": 0},
        }

    @classmethod
    def current(cls):
        objs = cls.query({})
        obj = None
        if not objs:
            obj = cls.new_obj()
            cls.put_data(obj)
        else:
            obj = objs[0]
        return obj