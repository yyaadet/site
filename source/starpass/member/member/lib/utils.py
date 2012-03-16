# -*- coding: utf-8 -*-

import time
import socket
import struct
import sys
import datetime
import urllib
import md5

import smtplib
from email.MIMEText import MIMEText
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email import Utils, Encoders
import mimetypes
import urllib

from pylons import request, response

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
#    print response.headers['Set-Cookie']

def remove_cookie(key):
    response.delete_cookie(key)

def get_env(key, default):
    if request.environ.has_key(key):
        return request.environ[key]
    else:
        return default

def get_client_referer():
    referer = get_header('Referer', '')
    return referer

def get_self_host():
    host = get_header('Host', '')
    return host

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

def readable_time(t, format="%Y-%m-%d %H:%M:%S"):
    gmt = time.localtime(t)
    res = time.strftime(format, gmt)
    return res

def force_int(num):
    try:
        num = int(num)
        return num
    except:
        return 0

def force_utf8(s):
    try:
        r = s.encode("utf-8")
        return r
    except:
        return s


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


def get_last_month():
    now = time.localtime()
    year,month = now[0],now[1]
    print year,month
    if month == 0:
        l_year = year - 1
        l_month = month
    else:
        l_year = year
        l_month = month -1
    start_str = "%s-%s-1 00:00:00" %(year,month)
    last_str = "%s-%s-1 00:00:00" %(l_year,l_month)
    
    try:
        s_time = time.mktime(time.strptime(start_str,"%Y-%m-%d %H:%M:%S"))
    except:
        s_time = 0
    
    try:
        l_time = time.mktime(time.strptime(last_str,"%Y-%m-%d %H:%M:%S"))
    except:
        l_time = 0
    
    return l_time, s_time

def get_local_month(date=""):
    if date == "":
        now = time.localtime()
        year,month = now[0],now[1]
    else:
        year,month = date.split("-")
        year = force_int(year)
        month = force_int(month)
    if month == 12:
        n_year = year + 1
        n_month = 1
    else:
        n_year = year
        n_month = month + 1
    start_str = "%s-%s-1 00:00:00" %(year,month)
    next_str = "%s-%s-1 00:00:00" %(n_year,n_month)
    
    try:
        s_time = time.mktime(time.strptime(start_str,"%Y-%m-%d %H:%M:%S"))
    except:
        s_time = 0
    
    try:
        n_time = time.mktime(time.strptime(next_str,"%Y-%m-%d %H:%M:%S"))
    except:
        n_time = 0
    
    return s_time, n_time

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

def create_url(params, pay_key, post_url, sign_type='MD5'):   
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
            M.update(unsigned_data)  
            sign = M.hexdigest()  
        else:  
            sign = ''  
        request_data = post_url + '?'  
        for key in param_keys:  
            request_data += urllib.urlencode({key: params[key]})
            request_data += '&'  
        request_data += 'sign=' + sign + '&sign_type=' + sign_type  
        return request_data

def genpart(data, contenttype):
    maintype, subtype = contenttype.split('/')
    if maintype == "text":
        retval = MIMEText(data, _subtype=subtype)
    else:
        retval = MIMEBase(maintype, subtype)
        retval.set_payload(fd.read())
        Encoders.encode_base64(retval)
    return retval

def attachment(filename):
    fd = open(filename, 'rb')
    mimetype, mimeencoding = mimetypes.guess_type(filename)
    if mimeencoding or (mimetype is None):
        mimetype = "application/octet-stream"
    maintype, subtype = mimetype.split('/')
    if maintype == "text":
        retval = MIMEText(fd.read(), _subtype=subtype)
    else:
        retval = MIMEBase(maintype, subtype)
        retval.set_payload(fd.read())
        Encoders.encode_base64(retval)
    retval.add_header("Content-Disposition", "attachment", filename=filename)
    fd.close()
    return retval

def send_email(toaddr,message_text,subject):
    fromaddr = "no_reply@51zhi.com"
#    fromaddr = "shuke11@sina.com"
    msg = MIMEMultipart()
    msg["To"] = toaddr
    msg["From"] = fromaddr
    msg["Subject"] = subject
    msg["Date"] = Utils.formatdate(localtime=1)
    msg["Message-ID"] = Utils.make_msgid()
    
    body = MIMEMultipart('alternative')
    
    body.attach(MIMEText(message_text, 'plain', 'utf-8'))
    msg.attach(body)
    message = msg.as_string()
    
    s = smtplib.SMTP()
    s.connect()
    
#    server = 'smtp.sina.com'
#    user = 'shuke11'
#    passwd = ''
#    s.connect(server)
#    s.login(user, passwd)
    
    
    s.sendmail(fromaddr, toaddr, message)
    s.quit()

if __name__ == "__main__":
#    s,e = get_last_month()
#    s1,e1 = get_local_month()
#    print s,e
#    print s1,e1
#    get_local_month("2010-11")
#    host = "192.168.36.12"
#    port = 4010
#    uid = 22
#    trea_id = 20
#    res = donate(host, port, uid, trea_id)
#    print 1 == res
    send_email("gmouren@gmail.com","hehe","subject")