#coding=utf-8
"""The application's model objects"""

from digg.model.admin import *
from digg.model.user import *
from digg.model.setting import *
from digg.model.msg import *
from digg.model.friendlink import *
from digg.model.webgame import *
from digg.model.webgame_news import *
from digg.model.webgame_comment import *
from digg.model.stat import *
from digg.model.card import *
from digg.model.feed import *
import time


def update_rank():
    import time
    from digg.lib.helpers import get_webgame_from_title,is_same_date
    #update webgame news score 
    offset = 0
    limit = 100
    now = int(time.time())
    while True:
        objs = WebgameNews.query({}, limit = limit, skip = offset)
        if not objs:
            break
        for obj in objs:
            obj.score = calc_news_rank(obj)
            if not obj.webgame_id:
                game = get_webgame_from_title(obj.title)
                if game:
                    obj.webgame_id = game._id
                    obj.webgame_name = game.name
                    game.news_num += 1
                    Webgame.put_data(game)
            WebgameNews.put_data(obj)
        offset += limit
        print "news offset %s" % offset
    offset = 0
    while True:
        objs = Webgame.query({}, limit = limit, skip = offset)
        if not objs:
            break
        for obj in objs:
            obj.score = calc_game_rank(obj)
            if not is_same_date(obj.today, now):
                obj.today_hot = 0
                obj.today = now
            Webgame.put_data(obj)
        offset += limit
        print "game offset %s" % offset

def  calc_news_rank(obj):
    now = int(time.time())
    h = (now - obj.timestamp) / 3600
    score = _calc_news_rank(obj.good_num, obj.bad_num, obj.view_num, obj.comment_num, obj.go_num, h)
    return score

def  calc_game_rank(obj):
    now = int(time.time())
    m = (now - obj.add_timestamp) / (3600*24*30)
    d = (now - obj.add_timestamp) / (3600*24)
    score = _calc_game_rank(obj.good_num, obj.bad_num, obj.view_num, obj.comment_num, obj.news_num, m, d)
    return score

def calc_card_score(obj):
    percent = 0
    if obj.succ_num + obj.fail_num > 0:
        percent = float(obj.succ_num) / float((obj.succ_num + obj.fail_num))
    return percent * 100
        
def _calc_news_rank(good_num, bad_num, view_num, comment_num, go_num, h):
    '''新闻排名
    '''
    result = (abs(good_num - bad_num) + view_num + 1.25 * comment_num + go_num * 2 + 10)/pow(h + 2, 1.2)
    return result
    
def _calc_game_rank(good_num, bad_num, view_num, comment_num, news_num, m, d):
    '''游戏排名
    '''
    factor = 0.5
    result = (abs(good_num - bad_num) + view_num + comment_num + 1.2 * news_num + 10)/pow(d + 2, 1.4 + factor)
    return result