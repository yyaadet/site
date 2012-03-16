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

from digg.model.setting import Setting
from digg import lib

import types
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
import datetime
import urllib2

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
    
def set_cookie(name, value, path="/", max_age=3600*24*7):
    '''
    response.set_cookie(key = name, \
            value=value, max_age=max_age, path=path, domain=None, \
            secure=None, httponly=False, version=None, comment=None, \
            expires=None)
    '''
    if type(value) != types.StringType:
        value = str(value)
    response.set_cookie(key = name, value=value, max_age=max_age, path=path, secure=False)
    
def remove_cookie(name):
    response.set_cookie(key = name, value="", max_age=0, path = "/")
    
def fmt_time(t, fmt="%Y-%m-%d %H:%M:%S"):
    gm = time.localtime(t)
    return time.strftime(fmt, gm)

def fmt_float(t):
    r = round(t, 2)
    return r

def diff_time(last, now):
     diff = now - last
     month = 0
     day = 0
     hour = 0
     minu = 0
     sec = 0
     #month
     if diff > 3600*24*30:
         month = diff / (3600*24*30)
     diff -= month *  (3600 * 24 * 30)
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
     if month > 0:
         return u"%s月" % month
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
    src = strip_tags(src)
    new_src = src[0: length] + '...'
    return new_src

from HTMLParser import HTMLParser

def strip_tags(html):
    html = html.strip()
    html = html.strip("\n")
    result = []
    parse = HTMLParser()
    parse.handle_data = result.append
    parse.feed(html)
    parse.close()
    return "".join(result)
    
def remove_html_tag(src):
    if not src:
        return ""
    re_cdata=re.compile('//<!\[CDATA\[[^>]*//\]\]>',re.I | re.M)
    re_script=re.compile('<\s*script[^>]*>[^<]*<\s*/\s*script\s*>', re.I | re.M)   #Script
    re_style=re.compile('<\s*style[^>]*>[^<]*<\s*/\s*style\s*>', re.I | re.M)       #style
    re_br=re.compile('<br\s*?/?>', re.I | re.M)                                                         #处理换行
    re_h=re.compile('<\w+[^>]*>', re.I | re.M)                                                    #HTML标签
    re_comment=re.compile('<!--[^>]*-->', re.I | re.M)                                          #HTML注释
    s=re_cdata.sub('',src)                                                                       #去掉CDATA
    s=re_script.sub('',s)                                                                          #去掉SCRIPT
    s=re_style.sub('',s)                                                                           #去掉style
    s=re_br.sub('\n',s)                                                                           #将br转换为换行
    s=re_br.sub('\r\n',s)                                                                        #将br转换为换行
    s=re_h.sub('',s)                                                                               #去掉HTML 标签
    s=re_comment.sub('',s)                                                                  #去掉HTML注释
    #去掉多余的空行
    blank_line=re.compile('\n+')
    s=blank_line.sub('\n',s)
    s=replaceCharEntity(s)                                                                  #替换实体
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

    
def get_self_host():
    host = get_header('Host', '')
    return host
    
def get_self_url():
    requested_url = request.environ.get('PATH_INFO')
    if request.environ.get('REQUEST_METHOD') == "GET":
        if request.environ['QUERY_STRING'] != "":
            requested_url += '?' + request.environ['QUERY_STRING']
    else:
        if len(request.params) > 0:
            try:
                maps = dict()
                for k, v in request.params.items():
                    if isinstance(v, basestring):
                        maps[k] = v
                params = urllib.urlencode(maps) 
                requested_url += '?' + params
            except Exception, e:
                print e
    return requested_url
    
def get_file_tail(name):
    name = os.path.basename(name)
    lst = name.split('.')
    if len(lst) >= 2:
        return lst[len(lst) - 1]
    return ''

def is_img(tail):
    img_tails = ['jpg', 'jpeg', 'gif', 'bmp', 'png']
    for item in img_tails:
        if tail.lower() == item:
            return 1
    return 0

def url_is_img(url):
    tail_pos = url.rfind(".")
    if tail_pos == -1:
        return False
    tail = url[tail_pos + 1:]
    return is_img(tail)

def get_img_size(url):
    if not url:
        return (0, 0)
    if "http://" != url[:7]:
        return (0, 0)

    try:
        path = "/tmp/" + os.path.basename(url)
        f = urllib2.urlopen(url)
        img_data = f.read()
        f.close()
        f = open(path, "w")
        f.write(img_data)
        f.close()

        img = Image.open(path)
        size = img.size
        os.remove(path)
        return size
    except Exception, e:
        print e
    return (0, 0)
        
def get_client_ip():
    ip = request.remote_addr
    x_forward = get_header('X-FORWARDED-FOR', '')
    if x_forward:
        l = x_forward.split(",")
        if len(l) > 0:
            ip = l[0]
    return ip

    
def goto_tip(tip):
    from digg import lib
    domain = lib.config.get('domain', '')
    return redirect(domain + "/tip/index?tip=%s" % urlencode(tip.encode('utf-8')))

def fmt_file_size(sz):
    if sz > 1024 * 1024:
        return "%.2f M" % (float(sz) / (1024 * 1024))
    if sz > 1024:
        return "%.2f K" % (float(sz) / 1024)
    return sz
    
def urlencode(src):
    return urllib.quote_plus(src)
    
def safe_url(url = ''):
    if not url:
        return ''
    if url[:7] != 'http://':
        return 'http://' + url
    return url
    
def site_url(url = ''):
    from digg import lib
    domain = lib.config.get('domain', '')
    return domain + url

def send_email_all(subject, body):
    t = threading.Thread(target=do_send_email_all, args=(subject, body))
    t.start()

def do_send_email_all(subject, body):
    all_u = User.get_all()
    for u in all_u:
        try:
            send_email(u.email, subject, body)
        except Exception, e:
            print e
            continue
            
def send_mail(recipient, subject, body):
    t = threading.Thread(target= _send_email, args=(recipient, subject, body))
    t.start()

def _send_email(recipient, subject, body):
    """Send an email.

    All arguments should be Unicode strings (plain ASCII works as well).

    Only the real name part of sender and recipient addresses may contain
    non-ASCII characters.

    The email will be properly MIME encoded and delivered though SMTP to
    localhost port 25.  This is easy to change if you want something different.

    The charset of the email will be the first one out of US-ASCII, ISO-8859-1
    and UTF-8 that can represent all the characters occurring in the email.
    """
    sender_name = u"巨游网"
    sender_addr = "robot@51zhi.com"
    body += u"<p><br /><br />------<br />"
    body += u"巨游网<a href='http://www.51zhi.com'>去看看</a></p>"

    # Header class is smart enough to try US-ASCII, then the charset we
    # provide, then fall back to UTF-8.
    header_charset = 'ISO-8859-1'

    # We must choose the body charset manually
    for body_charset in 'US-ASCII', 'ISO-8859-1', 'UTF-8':
        try:
            body.encode(body_charset)
        except UnicodeError:
            pass
        else:
            break

    # Split real name (which is optional) and email address parts
    #sender_name, sender_addr = parseaddr(sender)
    recipient_name, recipient_addr = parseaddr(recipient)

    # We must always pass Unicode strings to Header, otherwise it will
    # use RFC 2047 encoding even on plain ASCII strings.
    sender_name = str(Header(unicode(sender_name), header_charset))
    recipient_name = str(Header(unicode(recipient_name), header_charset))

    # Make sure email addresses do not contain non-ASCII characters
    sender_addr = sender_addr.encode('ascii')
    recipient_addr = recipient_addr.encode('ascii')

    # Create the message ('plain' stands for Content-Type: text/plain)
    msg = MIMEText(body.encode(body_charset), 'html', body_charset)
    msg['From'] = formataddr((sender_name, sender_addr))
    msg['To'] = formataddr((recipient_name, recipient_addr))
    msg['Subject'] = Header(unicode(subject), header_charset)

    try:
        # Send the message via SMTP to localhost:25
        smtp = SMTP("localhost")
        smtp.sendmail(sender_addr, recipient, msg.as_string())
        smtp.quit()
        return 1
    except Exception, e:
        print e
        return 0
        
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
    
def has_cn_char(src):
    for i in range(len(src)):
        c = src[i]
        if  0x4e00<=ord(c)<0x9fa6 :
            return True
    return False

def static_webgame_news_page_url(tag, group_id, page):
    url = "/webgame_news/%s?page=%s&group_id=%s" % (tag, page, group_id)
    if c.setting.is_use_static_url:
        url = "/webgame_news/%s/%s/%s.html" % (tag, group_id, page)
    return site_url(url)

def static_webgame_page_url(tag, group_id, page):
    url = "/webgame/%s?page=%s&group_id=%s" % (tag, page, group_id)
    if c.setting.is_use_static_url:
        url = "/webgame/%s/%s/%s.html" % (tag, group_id, page)
    return site_url(url)  

def static_webgame_detail_url(id, page = 1):
    url = "/webgame/detail?id=%s&page=%d" % (id, page)
    if c.setting.is_use_static_url:
        url = "/webgame/detail/%s/%s.html" % (id, page)
    return site_url(url)

def static_webgame_news_detail_url(id, page=1):
    url = "/webgame_news/detail?id=%s&page=%s" % (id, page)
    if c.setting.is_use_static_url:
        url = "/webgame_news/detail/%s/%s.html" % (id, page)
    return site_url(url)

def static_card_page_url(tag, webgame_id, page=1):
    url = "/card/%s?page=%s&webgame_id=%s" % (tag, page, webgame_id)
    if c.setting.is_use_static_url:
        url = "/card/%s/%s/%s.html" % (tag, webgame_id, page)
    return site_url(url)

def static_card_detail_url(id, page=1):
    url = "/card/detail?id=%s&page=%s" % (id, page)
    if c.setting.is_use_static_url:
        url = "/card/detail/%s/%s.html" % (id, page)
    return site_url(url)

def is_same_date(t1, t2):
    dt1 = datetime.datetime.fromtimestamp(t1)
    dt2 = datetime.datetime.fromtimestamp(t2)
    if dt1.date() != dt2.date():
        return False
    return True

def get_webgame_from_title(title):
    from digg.model.webgame import Webgame
    webgames = Webgame.query({})
    result = None
    for webgame in webgames:
        if webgame.name.upper() in title.upper():
            if result == None:
                result = webgame
            elif len(webgame.name) > len(result.name):
                result = webgame
    return result


