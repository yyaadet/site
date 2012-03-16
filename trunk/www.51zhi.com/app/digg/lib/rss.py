#coding=utf-8

__author__ = 'xiaotao'

import feedparser
import time
import random
from digg.model.all_table import *
from utils import parse_url_page, remove_unused_info_from_title
from helpers import get_webgame_from_title
import encodings
import urllib2
import sys
import socket


socket.setdefaulttimeout(30)
encodings.aliases.aliases['gb2312'] = 'gb18030'

def fetch_news():
    urls = Feed.query()
    if not urls:
        return
    for url in urls:
        try:
            print "ready to fetch rss from %s, %s" % (url['url'], url['num'])
            sys.stdout.flush()
            fetch_rss(url['url'], url['num'], url['name'])
        except Exception, e:
            print e



def fetch_rss(url, num, name=""):
    f = urllib2.urlopen(url)
    data = f.read()
    f.close()
    result = feedparser.parse(data)
    entries = result.entries
    count = 0
    
    for en in entries:
        #print en
        if WebgameNews.query_num({'url': en.link}) > 0:
            continue
        title, summary, imgs = parse_url_page(en.link)
        if not title:
            continue
        if en.title:
            title = en.title
        if en.summary:
            summary = en.summary
        webgame = get_webgame_from_title(title)
        
        obj = WebgameNews.new_obj()
        obj.type = 0
        obj.uname = name
        obj.title = title
        obj.url = en.link
        obj.cnt = summary
        obj.city = "beijing"
        obj.ip = "127.0.0.1"
        obj.timestamp = int(time.time())
        obj.score = calc_news_rank(obj)
        obj.imgs = imgs
        if webgame:
            obj.webgame_id = webgame._id
            obj.webgame_name = webgame.name
            obj.group_id = webgame.group_id
            webgame.news_num += 1
            Webgame.put_data(webgame)
        WebgameNews.put_data(obj)

        Action.add_news(None)
        
        count += 1
        if count >= num:
            return


