from digg import model


NAME = "webgame_comment"

class WebgameComment(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"uid": {'sort': "asc", "default": 0},
                  "uname": {'sort': None, "default": 0},    
                   "cnt": {'sort': None, "default": ''},
                   "webgame_news_id": {'sort': "asc", "default": 0},
                   "ip": {'sort': None, "default": ''},
                   "city": {'sort': None, "default": ''},
                   "timestamp": {'sort': None, "default": ''},
                 }
