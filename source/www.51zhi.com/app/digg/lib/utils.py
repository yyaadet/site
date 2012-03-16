#coding=utf-8

import time
import urllib2
from BeautifulSoup import BeautifulSoup

class Storage(dict):
    """
    A Storage object is like a dictionary except `obj.foo` can be used
    in addition to `obj['foo']`.
    
        >>> o = storage(a=1)
        >>> o.a
        1
        >>> o['a']
        1
        >>> o.a = 2
        >>> o['a']
        2
        >>> del o.a
        >>> o.a
        Traceback (most recent call last):
            ...
        AttributeError: 'a'
    
    """
    def __getattr__(self, key): 
        try:
            return self[key]
        except KeyError, k:
            raise AttributeError, k

    def __setattr__(self, key, value): 
        self[key] = value

    def __delattr__(self, key):
        try:
            del self[key]
        except KeyError, k:
            raise AttributeError, k

    def __repr__(self):     
        return '<Storage ' + dict.__repr__(self) + '>'

def is_news_img(w, h):
    all_sz = [(550, 367), (338, 336), (550, 409), (320, 480), (1000, 666), (416, 312)]
    diff = 50

    for sz in all_sz:
        diff_w = abs(sz[0] - w)
        diff_h = abs(sz[1] - h)
        if diff_w <= diff and diff_h <= diff:
            return True
    return False

def parse_url_page(url):
    from helpers import get_img_size
    
    max_img_num = 4
    f = urllib2.urlopen(url)
    page = f.read()
    f.close()
    bs = BeautifulSoup(page, fromEncoding="gbk")
    if not bs:
        return None, None
    title = bs.html.head.title.string
    summary = title
    summary_tag = bs.find('meta', {'name': 'description'})
    if summary_tag:
        summary = summary_tag['content']
    imgs = []
    img_tags = bs.findAll("img")
    for img in img_tags:
        attrs = dict(img.attrs)
        if not 'src' in attrs:
            continue
        w = 0
        h = 0
        if 'width' in attrs and 'height' in attrs:
            w = int(img['width'])
            h = int(img['height'])
        if not is_news_img(w, h):
            continue
        if image_readable(img['src']):
            imgs.append(img['src'])
            if len(imgs) >= max_img_num:
                break
    
    title = title.strip()
    summary = summary.strip()
    return title, summary, imgs
    
    
def image_readable(url):
    try:
        f = urllib2.urlopen(url)
        data = f.read()
        f.close()
        return True
    except:
        return False
    
def remove_unused_info_from_title(title):
    chars = ["_", "-", "|",]
    pos = -1
    for ch in chars:
        pos = title.find(ch)
        if pos > -1:
            break
    if pos == -1:
        return title
    return title[:pos]

def display_time(func):
    def cal_time(*args):
        # 记录开始时间
        start = time.time()
        # 回调原函数
        result = func(*args)
        passtime = time.time() - start
        # 在结果输出追加计时信息
        print "%s %s spend %f ms" % (func, args, passtime)
        # 返回结果
        return result
    # 返回重新装饰过的函数句柄
    return cal_time
