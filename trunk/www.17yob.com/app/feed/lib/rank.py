import time

from feed.model.all_table import *

def update_rank():
    from feed.lib.helpers import is_same_date
    
    #update news score 
    offset = 0
    limit = 100
    now = int(time.time())
    while True:
        objs = News.query({}, limit = limit, skip = offset)
        if not objs:
            break
        for obj in objs:
            obj.score = calc_news_rank(obj)
            News.put_data(obj)
        offset += limit
        print "news offset %s" % offset

def  calc_news_rank(obj):
    now = int(time.time())
    h = (now - obj.timestamp) / 3600
    score = _calc_news_rank(obj.view_num, obj.go_num, h)
    return score

        
def _calc_news_rank(view_num, go_num, h):
    '''news rank
    '''
    result = (view_num + go_num * 2 + 10)/pow(h + 2, 1.2)
    return result