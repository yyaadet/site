from digg import model


NAME = "card"

class Card(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"uid": {'sort': None, "default": 0},
                   "uname": {'sort': None, "default": 0},
                   "title": {'sort': 'asc', "default": ''},
                   "cnt": {'sort': None, "default": ''},
                   "url": {'sort': None, "default": ''},
                   "webgame_id": {'sort': 'desc', "default": 0},
                   "webgame_name": {'sort': 'desc', "default": ''},
                   "group_id": {'sort': 'desc', "default": 0},
                   "succ_num": {'sort': None, "default": 0},
                   "last_succ_timestamp": {'sort': None, "default": 0},
                   "fail_num": {'sort': None, "default": 0},
                   "last_fail_timestamp": {'sort': None, "default": 0},
                   "score": {'sort': "desc", "default": 0},
                   "add_timestamp": {'sort': None, "default": 0},
                   "city": {'sort': None, "default": ''},
                   "ip": {'sort': None, "default": ''},
                   "ips": {'sort': None, "default": []},
                 }
