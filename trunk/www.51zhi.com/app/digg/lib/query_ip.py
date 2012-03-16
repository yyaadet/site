#coding=utf-8

import time
import urllib2
import urllib

def get_ip_city(ip):
    if ip == "127.0.0.1":
        return "lan"
    try:
        params = urllib.urlencode({"action": "queryip", "ip_url": ip})
        url = "http://www.ip.cn/getip.php?%s" % params
        print url
        f = urllib2.urlopen(url)
        result = f.read()
        #print result
        tag = u"来自：".encode("GB2312")
        addr_pos = result.find(tag)
        if addr_pos == -1:
            return ""
        addr = result[addr_pos + len(tag):]
        city = unicode(addr.split(" ")[0], "GB2312")
        return city
    except Exception, e:
        print e
        return ""
        
#print get_ip_city("119.187.184.14")
