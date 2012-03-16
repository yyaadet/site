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

from feed.model.setting import Setting
from feed import lib

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
import datetime
import urllib2
from HTMLParser import HTMLParser

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
    
def set_cookie(name, value, path="/", max_age=3600*24):
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
    src = strip_html_tags(src)
    new_src = src[0: length] + '...'
    return new_src

def strip_html_tags(html):
    html = html.strip()
    html = html.strip("\n")
    result = []
    parse = HTMLParser()
    parse.handle_data = result.append
    parse.feed(html)
    parse.close()
    return "".join(result)
   
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
        
def get_client_ip():
    ip = request.remote_addr
    x_forward = get_header('X-FORWARDED-FOR', '')
    if x_forward:
        l = x_forward.split(",")
        if len(l) > 0:
            ip = l[0]
    return ip

    
def goto_tip(tip):
    from feed import lib
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
    from feed import lib
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
    r=re.comPile(r'(?<=\d)(?=(\d\d\d)+(?!\d))')
    return r.sub(r',', "%s" % digit)
    
def has_cn_char(src):
    for i in range(len(src)):
        c = src[i]
        if  0x4e00<=ord(c)<0x9fa6 :
            return True
    return False

def static_news_detail_url(id):
    url = "/news/detail?id=%s" % (id)
    if c.setting.is_use_static_url:
        url = "/news/detail/%s.html" % (id)
    return site_url(url)

def is_same_date(t1, t2):
    dt1 = datetime.datetime.fromtimestamp(t1)
    dt2 = datetime.datetime.fromtimestamp(t2)
    if dt1.date() != dt2.date():
        return False
    return True

def split_url(url):
    import urllib
    proto, rest = urllib.splittype(url)
    host, rest = urllib.splithost(rest)
    host, port = urllib.splitport(host)
    return (proto, host, port)

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
    sender_name = u"悦读会"
    sender_addr = "robot@17yob.com"
    body += u"<p><br /><br />------<br />"
    body += u"悦读汇<a href='http://www.17yob.com'>去看看</a></p>"

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