#coding=utf-8

__author__ = 'xiaotao'

import feedparser
import time
import random

from feed.model.all_table import *
from feed.lib.rank import *
from feed.lib.helpers import strip_html_tags, is_same_date
from utils import parse_url_page, remove_unused_info_from_title
from worker import *

import encodings
import urllib2
import urllib
import sys
import socket
import urlparse
import pymongo

from BeautifulSoup import BeautifulSoup


socket.setdefaulttimeout(30)
encodings.aliases.aliases['gb2312'] = 'gb18030'

ADS_DOMAINS = ["feedsportal.com"]
FETCH_NUM=10

def remove_ads(src):
    try:
        soup = BeautifulSoup(src)
        links = soup.findAll("a")
        for a in links:
            link = a['href']
            for ad in ADS_DOMAINS:
                if link.find(ad) != -1:
                    a.extract()
        return unicode(soup)
    except Exception, e:
        print e
        return src

def fetch_news():
    offset = 0
    limit = 50
    worker_num = 10
    
    while True:
        feeds = Rss.query({'is_del': 0}, skip = offset, limit = limit, sort = [('add_timestamp', pymongo.DESCENDING)])
        if not feeds:
            break
        wm = WorkerManager(worker_num)
        for f in feeds:
            wm.add_job(fetch_rss, f)
        wm.start()
        wm.wait_for_complete()
        offset += limit    
          

def fetch_rss(feed):
    url = feed['url']
    num = FETCH_NUM
    name = feed['name']
    count = 0
    entries = []
    
    print "ready to fetch rss from %s, %d" % (url, num)
    sys.stdout.flush()
    
    try:
        f = urllib2.urlopen(url)
        data = f.read()
        f.close()
        result = feedparser.parse(data)
        entries = result.entries
    except URLError:
        feed.fetch_timestamp = now
        feed.fetch_num += count
        Rss.put_data(feed)
        raise urllib2.URLError
    
    
    for en in entries:
        if count >= num:
            break
        #print en.updated_parsed
        if en.link.find("http://") == -1:
            en.link = urlparse.urljoin(url, en.link)
        old_obj = News.query({'url': en.link, 'uid': feed['uid']}, limit = 1)
        if old_obj:
            old_obj = old_obj[0] 
            if old_obj.pub_timestamp == 0:
                old_obj.pub_timestamp = time.mktime(en.updated_parsed)
                News.put_data(old_obj)
            continue
        title = "" 
        summary = ""
        if en.title:
            title = strip_html_tags(en.title)
        if en.summary:
            summary = remove_ads(en.summary)
        
        obj = News.new_obj()
        obj.uid = feed['uid']
        obj.uname = feed['uname']
        obj.feed_id = feed._id
        obj.feed_name = feed.name
        obj.group_id = feed.group_id
        obj.title = title
        obj.url = en.link
        obj.cnt = summary
        obj.timestamp = int(time.time())
        obj.pub_timestamp = time.mktime(en.updated_parsed)
        News.put_data(obj)
        count += 1
    
    now = int(time.time())
    if is_same_date(feed.fetch_timestamp, now):
        feed.today_fetch_num += count
    else:
        feed.today_fetch_num = count 
    feed.fetch_timestamp = now
    feed.fetch_num += count
    feed.fetch_error = "ok"
    Rss.put_data(feed)
    print "done fetch rss from %s, %d" % (url, count)
    return count


