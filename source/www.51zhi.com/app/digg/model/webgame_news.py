from digg import model


'''
define schema 
'''

NAME = "webgame_news"

class WebgameNews(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"uid": {'sort': None, "default": 0},
                  "uname": {'sort': None, "default": 0},    
                  "type": {'sort': None, "default": 0},  # 0: url | 1: text  
                   "title": {'sort': None, "default": ''},  
                   "url": {'sort': "desc", "default": ''},
                   "cnt": {'sort': None, "default": ''},
                   "view_num": {'sort': None, "default": 0},
                   "go_num": {'sort': None, "default": 0},
                   "comment_num": {'sort': None, "default": 0},
                   "webgame_id": {'sort': None, "default": 0},
                   "webgame_name": {'sort': None, "default": ''}, 
                   "group_id": {'sort': 'desc', "default": 0},
                   "good_num": {'sort': None, "default": 0},
                   "bad_num": {'sort': None, "default": 0},
                   "score": {'sort': "desc", "default": 0},
                   "ip": {'sort': None, "default": ''},
                   "city": {'sort': None, "default": ''},
                   "ips": {'sort': None, "default": []},
                   "imgs": {'sort': None, "default": []},
                   "timestamp": {'sort': None, "default": ''},
                 }
