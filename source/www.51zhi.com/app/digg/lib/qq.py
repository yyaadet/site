#coding=utf-8
'''
qq.py

qq开放平台api
'''
import time
import urllib
import urllib2
import hashlib
import hmac
import base64
import random
import simplejson

APP_ID="214213"
APP_KEY="2d04346e5266ba55f5ae5d9692553236"

def get_normalized_string(params):
    keys = sorted(params.keys())
    result = ""
    for k in keys:
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

        f = urllib.urlopen(url)
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
    def get_access_token(cls, token, token_secret, vericode):
        url = "http://openapi.qzone.qq.com/oauth/qzoneoauth_access_token"
        params = {}
        params['oauth_consumer_key'] = cls.app_id
        params['oauth_nonce'] = 20000
        params['oauth_timestamp'] = str(int(time.time()))
        params['oauth_version'] = str(1.0)
        params['oauth_signature_method'] = 'HMAC-SHA1'
        params['oauth_token'] = token
        params['oauth_vericode'] = vericode

        norm_str = get_normalized_string(params)
        sigstr = "GET&" + urllib.quote_plus(url) + "&" + norm_str
        key = cls.app_key + "&" + token_secret
        signature = get_signature(sigstr, key)
        params['oauth_signature'] = signature
        url += "?" + urllib.urlencode(params)
    
        f = urllib.urlopen(url)
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


    

