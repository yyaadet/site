# -*- coding: utf-8 -*-
import logging
import traceback
import time
import socket
import sys

import os
import re
import md5
from xml.dom.minidom import parseString
import struct
import urllib


import email
import mimetypes
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEImage import MIMEImage
import smtplib

from pylons import request, response

from webhanfeng.model import meta


log = logging.getLogger(__name__)


def remove_re_list(seq):
    return list(set(seq))

def force_str(s):
    try:
        r = str(s)
        return r
    except:
        return s
    
def force_int_bool(s):
    try :
        r = int(s)
        if r > 0:
            r = 1
        else:
            r = 0
        return r
    except:
        return -1

def force_int(s):
    try :
        r = int(s)
        return r
    except:
        return 0

def force_float(s):
    try :
        r = float(s)
        return r
    except:
        return 0
    
def force_utf8(s):
    try:
        r = s.encode("utf-8")
        return r
    except:
        return s

def get_self_url():
    requested_url = request.environ.get('PATH_INFO')
    if request.environ.get('REQUEST_METHOD') == "GET":
        if request.environ['QUERY_STRING'] != "":
            requested_url += '?' + request.environ['QUERY_STRING']
    else:
        if len(request.params) > 0:
            requested_url += '?' + urllib.urlencode(request.params)
    return requested_url


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
    
def set_cookie(name, value, path, max_age):
    response.set_cookie(key = name, \
            value=value, max_age=max_age, path=path, domain=None, \
            secure=None, httponly=False, version=None, comment=None, \
            expires=None)
    print response.headers['Set-Cookie']

    
def remove_cookie(key):
    response.delete_cookie(key)

def get_env(key, default):
    if request.environ.has_key(key):
        return request.environ[key]
    else:
        return default
        
def get_client_ip():
    ip = request.remote_addr
    x_forward = get_header('X-FORWARDED-FOR', '')
    if x_forward:
        l = x_forward.split(",")
        if len(l) > 0:
            ip = l[0]
    return ip
    
def get_browse_info():
    return request.user_agent

def get_params(key, default):
    if request.params.has_key(key):
        return request.params[key]
    else:
        return default
    
def get_all_params():
    return request.params
    
def catch_exception(fun):
    def _func(*arg):
        try:
            ret = fun(*arg)
            return ret
        except:
            traceback.print_exc(10)
            meta.Session.rollback()
            return None
    return _func

def readable_time(t, format="%Y-%m-%d %H:%M:%S"):
    if t == "":
        return 
    gmt = time.localtime(t)
    res = time.strftime(format, gmt)
    return res

def donate(host, port, uid, trea_id):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    except socket.error, e:
        print "Strange error creating socket: %s" % e
        sys.exit(1)

    try:
        s.connect((host, port))
    except socket.error, e:
        print "Connection error: %s" % e
        sys.exit(1)

    b = struct.pack("!ii", uid, trea_id)
    h = struct.pack("!iiii", 16 + len(b), 901, -1, 0)

    try:
        s.sendall(h)
        s.sendall(b)
    except socket.error, e:
        print "Error sending data: %s " % e
        sys.exit(1)

    try:
        resp = s.recv(16)
    except socket.error, e:
        print "Error receiving data: %s" % e
        sys.exit(1)
    
    (total, code, sid, mid) = struct.unpack("!iiii", resp)
    s.close()

    if code == 300:
        return 1
    return 0



def read_game_time(t):
    DAY = 12
    MONTH = 30 * 12
    YEAR = 12 * 30 * 12
    year = t / YEAR;
    month = (t - year * YEAR) / MONTH
    day = (t - year * YEAR - month * MONTH) / DAY
    hour = t - year * YEAR - month * MONTH - day * DAY
    str_time = ("%s年%s月%s日%s时") %(year+1,month+1,day+1,hour+1)
    return str_time


def match_time(t,year,month):
    if t == "":
        return 
    gmt = time.localtime(t)
    cur_year = time.strftime("%Y", gmt)
    cur_month = time.strftime("%m", gmt)
    if year == 0 or int(cur_year) == year:
        test_year = True
    else:
        test_year = False
    if month == 0 or int(cur_month) == month:
        test_month = True
    else:
        test_month = False
    return test_year and test_month
        
def remove_repeat_list(seq):
    return {}.fromkeys(seq).keys()

def cut_string(src, max_len=50):
    if len(src) > max_len:
        return src[0:max_len] + "..."
    return src

def remove_html(s):
    s = re.sub("\s", '', s)
    s = re.sub("&nbsp;", ' ', s)
    s = re.sub("<[^>]*>", '', s)
    return s

def connect_server(ip, port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
        sock.connect((ip, port))
        print "connected %s:%d" % (ip, port)
        return sock    
    except Exception, e:
        print e
        return None
    
def send_imserver_sys_msg(ip, port, content):
    try:
        sock = connect_server(ip, port)
        total = socket.htonl(16 + len(content))
        msgtype = socket.htonl(121)
        send = socket.htonl(0)
        msgid = socket.htonl(0)
        header = struct.pack("IIII", total, msgtype, send, msgid)
        sock.send(header)
        sock.send(content)
        sock.close()
        return 1
    except Exception, e:
        print e
        return 0
        
def gettexts(nodelist):
    rc = ""
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            rc = rc + node.data
    return rc

def validate_url(params,pay_key,sign_type="MD5"):
        param_keys = params.keys()  
        param_keys.sort()  
        unsigned_data = ''  
        for key in param_keys:  
            unsigned_data += key + '=' + params[key]  
            if key != param_keys[-1]:  
                unsigned_data += '&'  
        unsigned_data += pay_key 
        if sign_type == 'MD5':  
            M = md5.new()  
            M.update(unsigned_data.encode("utf-8"))  
            sign = M.hexdigest()  
        else:  
            sign = ''
        return sign
        
def sendEmail(fromAdd,toAdd,plainText,subject):
#    server = 'smtp.sina.com'
#    user = 'shuke11'
#    passwd = ''
#    fromAdd = 'shuke11@sina.com'
#    fromAdd = 'sggame@51zhi.com'
    
    msgRoot = email.MIMEMultipart.MIMEMultipart('related')
    msgRoot['Subject'] = subject
    msgRoot['From'] = fromAdd
    msgRoot['To'] = ','.join(toAdd)
    
    msgAlternative = MIMEMultipart('alternative')
    msgRoot.attach(msgAlternative)
    
    msgText = MIMEText(plainText, 'plain', 'utf-8')
    msgAlternative.attach(msgText)
    
    smtp = smtplib.SMTP()
    smtp.set_debuglevel(1)
    smtp.connect()
    
#    smtp.connect(server)
#    smtp.login(user, passwd)
    
    
    smtp.sendmail(fromAdd, toAdd, msgRoot.as_string())
    smtp.quit()

def split_two(str):
    try:
        float_str = ("%.2f" % (float(str)))
        return float_str
    except:
        return 0

#def new_mail(fromAdd, toAdd, content, subject):
#    sendmail_location = "/usr/sbin/sendmail" # sendmail location
#    p = os.popen("%s -t" % sendmail_location, "w")
#    p.write("From: %s\n" % fromAdd)
#    p.write("To: %s\n" % toAdd)
#    p.write("Subject: %s\n" % subject)
#    p.write("\n") # blank line separating headers from body
#    p.write("%s" % content)
#    status = p.close()
#    if status != 0:
#        print "Sendmail exit status", status

def send_a_mail(fromAdd,toAdd,plainText,subject):
#    server = 'smtp.sina.com'
#    user = 'shuke11'
#    passwd = ''
#    fromAdd = 'shuke11@sina.com'
#    fromAdd = 'sggame@51zhi.com'
    
    msgRoot = email.MIMEMultipart.MIMEMultipart('related')
    msgRoot['Subject'] = subject
    msgRoot['From'] = fromAdd
    msgRoot['To'] = toAdd
    
    msgAlternative = MIMEMultipart('alternative')
    msgRoot.attach(msgAlternative)
    
    msgText = MIMEText(plainText, 'plain', 'utf-8')
    msgAlternative.attach(msgText)
    
    smtp = smtplib.SMTP()
    smtp.set_debuglevel(1)
    smtp.connect()
    
#    smtp.connect(server)
#    smtp.login(user, passwd)
    
    
    smtp.sendmail(fromAdd, toAdd, msgRoot.as_string())
    smtp.quit()


