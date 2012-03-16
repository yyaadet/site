#coding=utf-8
'''
qq2.py

qq开放平台api - auth 2.0
'''
import time
import urllib
import urllib2
import hashlib
import hmac
import base64
import random
import simplejson
import socket
from types import *

APP_ID="100248590"
APP_KEY="ee2e963aa4e69933720e1bc328f98551"

socket.setdefaulttimeout(30)

def get_normalized_string(params):
    keys = sorted(params.keys())
    result = ""
    for k in keys:
        if type(k) == UnicodeType:
            k = k.encode("utf-8")
        if type(params[k]) == UnicodeType :
            params[k] = params[k].encode("utf-8")
        result += "%s=%s&" % (k, params[k])
    result = result[:len(result) - 1]
    return urllib.quote_plus(result)

def get_signature(src, key):
    h = hmac.new(key, src, hashlib.sha1)
    result = base64.b64encode(h.digest())
    print result
    return result

def parse_http_resp(src):
    result = {}
    lst = src.split("&")
    for nv in lst:
        [k, v] = nv.split("=")
        result[k] = v
    return result

class QQ(object):
    app_id = APP_ID
    app_key = APP_KEY

    @classmethod
    def _do_get(cls, url, token, token_secret, openid):
        sigstr = "GET&" + urllib.quote_plus(url) + "&"
        params = {}
        params['oauth_consumer_key'] = cls.app_id
        params['oauth_nonce'] = 20000
        params['oauth_timestamp'] = str(int(time.time()))
        params['oauth_version'] = str(1.0)
        params['oauth_signature_method'] = 'HMAC-SHA1'
        params['oauth_token'] = token
        params['openid'] = openid
        norm_str = get_normalized_string(params)
        sigstr += norm_str
        key = cls.app_key + "&" + token_secret
        signature = get_signature(sigstr, key)
        params['oauth_signature'] = signature
        url += "?" + urllib.urlencode(params)

        f = urllib2.urlopen(url)
        result = f.read()
        f.close()
        return result
        
    @classmethod
    def _do_post(cls, url, token, token_secret, openid, other_params={}):
        sigstr = "POST&" + urllib.quote_plus(url) + "&"
        params = other_params
        params['oauth_consumer_key'] = cls.app_id
        params['oauth_nonce'] = 20000
        params['oauth_timestamp'] = str(int(time.time()))
        params['oauth_version'] = str(1.0)
        params['oauth_signature_method'] = 'HMAC-SHA1'
        params['oauth_token'] = token
        params['openid'] = openid
        norm_str = get_normalized_string(params)
        sigstr += norm_str
        key = cls.app_key + "&" + token_secret
        signature = get_signature(sigstr, key)
        params['oauth_signature'] = signature

        data = urllib.urlencode(params)
        req = urllib2.Request(url, data)
        resp = urllib2.urlopen(req)
        result = resp.read()
        resp.close()
        return result
        
    
    @classmethod
    def get_request_token(cls):
        url = "http://openapi.qzone.qq.com/oauth/qzoneoauth_request_token"
        params = {}
        params['oauth_consumer_key'] = cls.app_id
        params['oauth_nonce'] = 20000
        params['oauth_timestamp'] = str(int(time.time()))
        params['oauth_version'] = str(1.0)
        params['oauth_signature_method'] = 'HMAC-SHA1'

        norm_str = get_normalized_string(params)
        sigstr = "GET&" + urllib.quote_plus(url) + "&" + norm_str
        key = cls.app_key + "&"
        signature = get_signature(sigstr, key)
        params['oauth_signature'] = signature
        url += "?" + urllib.urlencode(params)

        f = urllib2.urlopen(url)
        result = f.read()
        f.close()

        return parse_http_resp(result)

    @classmethod
    def get_access_token_url(cls, token, callback_url):
        url = "http://openapi.qzone.qq.com/oauth/qzoneoauth_authorize"
        params = {}
        params['oauth_consumer_key'] = cls.app_id
        params['oauth_token'] = token
        params['oauth_callback'] =callback_url
        url += "?" + urllib.urlencode(params)
        return url
    
    @classmethod
    def get_access_token(cls, redirect_uri):
        url = " https://graph.qq.com/oauth2.0/authorize"
        params = {}
        params['response_type '] = "code"
        params['client_id'] = cls.app_id
        params['redirect_uri '] = redirect_uri 
        params['scope '] = "get_user_info,add_share"
        params['state '] = "%d" % int(time.time())

        url += "?" + urllib.urlencode(params)
    
        f = urllib2.urlopen(url)
        result = f.read()
        f.close()
        
        print "get_access_token: %s" % result

        return parse_http_resp(result)

    @classmethod
    def get_user_info(cls, token, token_secret, openid):
        url = "http://openapi.qzone.qq.com/user/get_user_info"
        result = cls._do_get(url, token, token_secret, openid)
        print "get_user_info: %s" % result
        return simplejson.loads(result)
        
    @classmethod
    def add_share(cls, token, token_secret, openid, title, url, summary):
        app_url = "http://openapi.qzone.qq.com/share/add_share"
        params = {}
        params['title'] = title
        params['url'] = url
        params['summary'] = summary
        result = cls._do_post(app_url, token, token_secret, openid, params)
        print "add_share: %s" % result
        return simplejson.loads(result)


   
