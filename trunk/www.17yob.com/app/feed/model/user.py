from feed import model
from feed.lib.helpers import is_same_date
import time

NAME="user"

class User(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {
                  "name": {'sort': None, "default": ''},
                  "nickname": {'sort': None, "default": ''},
                  "passwd": {'sort': None, "default": ''},
                  "email": {'sort': None, "default": ''},
                  "reg_ip": {'sort': None, "default": ''}, 
                  "reg_timestamp": {'sort': None, "default": 0}, 
                  "is_admin": {'sort': None, "default": 0},  
                  "news_num": {'sort': None, "default": 0},
                  "comment_num": {'sort': None, "default": 0},
                  "feed_num": {'sort': None, "default": 0},
                  "score": {'sort': None, "default": 0},
                  "visited_num": {'sort': None, "default": 0},
                  "last_login_timestamp": {'sort': None, "default": 0},
                  "find_passwd_timestamp": {'sort': None, "default": 0},
                  #for qq
                  "token": {'sort': None, "default": ''},
                  "openid": {'sort': "asc", "default": ''},
                  "token_secret": {'sort': None, "default": ''},
                  #end for qq
            }
    
