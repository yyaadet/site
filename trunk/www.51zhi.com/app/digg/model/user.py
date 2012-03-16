from digg import model
from digg.lib.helpers import is_same_date
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
                  "game_num": {'sort': None, "default": 0},
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
    

class Action(object):
    @classmethod
    def add_news(cls, u):
        if u:
            u.news_num += 1
            u.score += 5
            User.put_data(u)

        #modify stat
        from stat import Stat
        now = int(time.time())
        cur_stat = Stat.current()
        if is_same_date(now, cur_stat.today_news_timestamp):
            cur_stat.today_news_num += 1
        else:
            cur_stat.today_news_num = 1
            cur_stat.today_news_timestamp = int(time.time())
        Stat.put_data(cur_stat)
        
    @classmethod
    def del_news(cls, u):
        if not u:
            return
        u.news_num -= 1
        u.score -= 4
        User.put_data(u)

    @classmethod
    def add_comment(cls, u):
        if not u:
            return
        u.comment_num += 1
        u.score += 2
        User.put_data(u)

    @classmethod
    def del_comment(cls, u):
        if not u:
            return
        u.comment_num -= 1
        u.score -= 1
        User.put_data(u)

    @classmethod
    def add_game(cls, u):
        if not u:
            return
        u.game_num += 1
        u.score += 8
        User.put_data(u)

    @classmethod
    def del_game(cls, u):
        if not u:
            return
        u.game_num -= 1
        u.score -= 7
        User.put_data(u)

    @classmethod
    def visit_my(cls, u):
        if not u:
            return
        u.visited_num += 1
        User.put_data(u)
        