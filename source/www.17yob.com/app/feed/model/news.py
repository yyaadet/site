from feed import model


'''
define schema 
'''

NAME = "news"

class News(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"uid": {'sort': None, "default": 0},
                  "uname": {'sort': None, "default": ""},
                  "feed_id": {'sort': None, "default": 0},
                  "feed_name": {'sort': None, "default": ""},       
                   "title": {'sort': None, "default": ''},  
                   "url": {'sort': "desc", "default": ''},
                   "cnt": {'sort': None, "default": ''},
                   "view_num": {'sort': None, "default": 0},
                   "go_num": {'sort': None, "default": 0},
                   "group_id": {'sort': 'desc', "default": 0},
                   "timestamp": {'sort': 'asc', "default": 0},
                   "pub_timestamp": {'sort': None, "default": 0},
                 }
