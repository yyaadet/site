from digg import model


NAME = "webgame"

class Webgame(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"uid": {'sort': None, "default": 0},
                   "uname": {'sort': None, "default": 0},
                   "name": {'sort': 'asc', "default": ''},  
                   "info": {'sort': None, "default": ''},
                   "site": {'sort': None, "default": ''},
                   "author": {'sort': None, "default": ''},
                   "view_num": {'sort': 'desc', "default": 0},
                   "news_num": {'sort': None, "default": 0},
                   "card_num": {'sort': None, "default": 0},
                   "comment_num": {'sort': None, "default": 0},
                   "group_id": {'sort': 'desc', "default": 0},
                   "good_num": {'sort': None, "default": 0},
                   "bad_num": {'sort': None, "default": 0},
                   "score": {'sort': "desc", "default": 0},
                   "add_timestamp": {'sort': None, "default": 0},
                   "today_hot": {'sort': "desc", "default": 0},
                   "today": {'sort': None, "default": 0},
                 }

def today_click(game):
    import time
    from digg.lib.helpers import is_same_date

    if not game:
        return
    now = int(time.time())
    if not is_same_date(now, game.today):
        game.today = now
        game.today_hot = 1
    else:
        game.today_hot += 1
    Webgame.put_data(game)