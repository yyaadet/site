#coding=utf-8
from zuan import model
import time
import math

NAME = "flash_game"

def check_disk():
    import os
    objs = FlashGame.query({})
    count = 0
    for obj in objs:
        if not os.path.exists(obj.file_path):
            if os.path.exists(obj.pic_path):
                os.remove(obj.pic_path)
            if os.path.exists(obj.file_path):
                os.remove(obj.file_path)
            small_pic = "small_" + obj.pic_path
            if os.path.exists(small_pic):
                os.remove(small_pic)
            FlashGame.rem_data(obj)
            print "delete %s, name %s" % (obj._id, obj.name)
        count += 1
        if count % 100 == 0:
            print count

def update_rank():
    offset = 0
    limit = 20
    now = int(time.time())
    while True:
        objs = FlashGame.query({}, limit = limit, skip = offset)
        if not objs:
            break
        for obj in objs:
            obj.score = calc_game_rank(obj)
            FlashGame.put_data(obj)
        offset += limit
    
def  calc_game_rank(obj):
    now = int(time.time())
    h = (now - obj.last_play_timestamp) / 3600
    score = _calc_game_rank(obj.total_play, obj.total_play_time, h)
    return score

def _calc_game_rank(view_num, view_time, h):
    '''排名
    '''
    result = (view_num + 10 + float(view_time)/float(view_num + 1))/pow(h + 2, 1.5)
    return result

class FlashGame(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"uid": {"sort": None, "default": 0},
                   "name": {'sort': 'asc', "default": ''}, 
                   "file_path": {'sort': None, "default": ''},
                   "file_size": {'sort': None, "default": 0}, 
                   "pic_path": {'sort': None, "default": ''}, 
                   "info": {'sort': None, "default": ''},
                   "operate_info": {'sort': None, "default": ''},
                   "author": {'sort': None, "default": ''},
                   "phone": {'sort': None, "default": ''},
                   "total_play": {'sort': 'desc', "default": 0},
                   "total_play_time": {'sort': None, "default": 0},
                   "group_id": {'sort': 'desc', "default": 0},
                   "is_fail": {'sort': None, "default": 0},
                   "is_del": {'sort': None, "default": 0},
                   "last_play_timestamp": {'sort': None, "default": 0},
                   "last_play_ip": {'sort': None, "default": ""},
                   "last_play_city": {'sort': None, "default": ""},
                   "timestamp": {'sort': 'desc', "default": 0},
                   "score": {'sort': 'desc', "default": 0},
                 }
