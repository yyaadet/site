#coding=utf-8

"""Helper functions

Consists of functions to typically be used within templates, but also
available to Controllers. This module is available to templates as 'h'.
"""
# Import helpers as desired, or define your own, ie:
#from webhelpers.html.tags import checkbox, password
from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from routes.util import *
from pylons import config

from zuan.model.setting import Setting
from zuan import lib


import time
import urllib
import re
import random
import os
from xml.dom.minidom import Document
from smtplib import SMTP
from email.MIMEText import MIMEText
from email.Header import Header
from email.Utils import parseaddr, formataddr
import threading
from PIL import Image


def set_header(name, value):
    response.headers[name] = value

def get_header(key, default):
    if request.headers.has_key(key):
        return request.headers[key]
    else:
        return default

def get_cookie(key,default=None):
    res = request.cookies.get(key)
    if res is None:
        res = default
    return res
    
def set_cookie(name, value, path="/", max_age=3600*24*7, domain=None):
    '''
    response.set_cookie(key = name, \
            value=value, max_age=max_age, path=path, domain=None, \
            secure=None, httponly=False, version=None, comment=None, \
            expires=None)
    '''
    response.set_cookie(key = name, value=value, max_age=max_age, path=path, domain = domain)
    
def remove_cookie(name):
    response.set_cookie(key = name, max_age=0, path = "/")
    
def fmt_time(t, fmt="%Y-%m-%d %H:%M:%S"):
    gm = time.localtime(t)
    return time.strftime(fmt, gm)

def diff_time(last, now):
     diff = now - last
     day = 0
     hour = 0
     minu = 0
     sec = 0
     #computer day
     if diff > 3600 * 24:
        day = diff / (3600 * 24)
     diff -= day *  (3600 * 24)
     #hour
     hour = diff / 3600
     diff -= hour * 3600
     #minu
     minu = diff / 60
     diff -= minu * 60
     #second
     sec = diff
     if day > 0:
        return u"%s天" % day
     if hour > 0:
        return u"%s小时" % hour
     if minu > 0:
        return u"%s分钟" % minu
     if sec > 0:
        return u"%s秒" % sec
     return u"刚刚"

def short_text(src, length = 100):
    if not src:
        return ''
    if len(src) <= length:
        return src
    src = remove_html_tag(src)
    new_src = src[0: length] + '...'
    return new_src

    
def remove_html_tag(src):
    re_cdata=re.compile('//<!\[CDATA\[[^>]*//\]\]>',re.I)
    re_script=re.compile('<\s*script[^>]*>[^<]*<\s*/\s*script\s*>',re.I)#Script
    re_style=re.compile('<\s*style[^>]*>[^<]*<\s*/\s*style\s*>',re.I)#style
    re_br=re.compile('<br\s*?/?>')#处理换行
    re_h=re.compile('</?\w+[^>]*>')#HTML标签
    re_comment=re.compile('<!--[^>]*-->')#HTML注释
    s=re_cdata.sub('',src)#去掉CDATA
    s=re_script.sub('',s) #去掉SCRIPT
    s=re_style.sub('',s)#去掉style
    s=re_br.sub('\n',s)#将br转换为换行
    s=re_br.sub('\r\n',s)#将br转换为换行
    s=re_h.sub('',s) #去掉HTML 标签
    s=re_comment.sub('',s)#去掉HTML注释
    #去掉多余的空行
    blank_line=re.compile('\n+')
    s=blank_line.sub('\n',s)
    s=replaceCharEntity(s)#替换实体
    #s = s.replace('\n', '<br />')
    return s
    
    
##替换常用HTML字符实体.
#使用正常的字符替换HTML中特殊的字符实体.
#你可以添加新的实体字符到CHAR_ENTITIES中,处理更多HTML字符实体.
#@param htmlstr HTML字符串.
def replaceCharEntity(htmlstr):
    CHAR_ENTITIES={'nbsp':' ','160':' ',
                'lt':'<','60':'<',
                'gt':'>','62':'>',
                'amp':'&','38':'&',
                'quot':'"','34':'"',}
    
    re_charEntity=re.compile(r'&#?(?P<name>\w+);')
    sz=re_charEntity.search(htmlstr)
    while sz:
        entity=sz.group()#entity全称，如&gt;
        key=sz.group('name')#去除&;后entity,如&gt;为gt
        try:
            htmlstr=re_charEntity.sub(CHAR_ENTITIES[key],htmlstr,1)
            sz=re_charEntity.search(htmlstr)
        except KeyError:
            #以空串代替
            htmlstr=re_charEntity.sub('',htmlstr,1)
            sz=re_charEntity.search(htmlstr)
    return htmlstr

def repalce(s,re_exp,repl_string):
    return re_exp.sub(repl_string,s)
    
def get_file_tail(name):
    name = os.path.basename(name)
    pos = name.rfind(".")
    if pos == -1:
        return ""
    return name[pos + 1:]

def is_img(tail):
    img_tails = ['jpg', 'jpeg', 'gif', 'bmp', 'png']
    for item in img_tails:
        if tail.lower() == item:
            return 1
    return 0
    
def goto_tip(tip):
    from zuan import lib
    domain = lib.config.get('domain', '')
    return redirect(domain + "/tip/index?tip=%s" % urllib.quote_plus(tip.encode('utf-8')))

def fmt_file_size(sz):
    if sz > 1024 * 1024:
        return "%.2f M" % (float(sz) / (1024 * 1024))
    if sz > 1024:
        return "%.2f K" % (float(sz) / 1024)
    return sz

def static_flash_game_detail_url(id):
    setting = c.setting
    if not setting or not setting.is_use_static_url:
        return site_url("/flash_game/detail?id=%s" % id)
    return site_url("/flash_game/detail/%s.html" % id)
    
def static_flash_game_play_url(id):
    setting = c.setting
    if not setting or not setting.is_use_static_url:
        return site_url("/flash_game/play?id=%s" % id)
    return site_url("/flash_game/play/flash_game_%s.html" % id)     
    
def static_flash_game_topic_url(id):
    setting = c.setting
    if not setting or not setting.is_use_static_url:
        return site_url("/flash_game_topic/detail?id=%s" % id)
    return site_url("/flash_game_topic/detail/%s.html" % id)     
    
def static_flash_game_group_url(group_id, page):
    setting = c.setting
    if not setting or not setting.is_use_static_url:
        return site_url("/flash_game/all?group_id=%s&page=%s" % (group_id, page))
    return site_url("/flash_game/all/flash_game_%s/%s.html" % (group_id, page))

def safe_url(url):
    if url[:7] != 'http://':
        return 'http://' + url
    return url
    
def site_url(url):
    from zuan import lib
    domain = lib.config.get('domain', '')
    return domain + url
        
def resize_img(src, dst, sz):
    if not os.path.exists(src):
        return
    try:
        img = Image.open(src)
        img = img.resize(sz, Image.ANTIALIAS)
        img.save(dst)
    except Exception, e:
        print e

def fmt_digit(digit):
    r=re.compile(r'(?<=\d)(?=(\d\d\d)+(?!\d))')
    return r.sub(r',', "%s" % digit)
