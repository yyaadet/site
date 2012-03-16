#coding=utf-8

import time
import urllib
import socket
import traceback
import sys

def get_ip_city(ip):
    if ip == "127.0.0.1":
        return "lan"

    try:
        socket.setdefaulttimeout(5)
        params = urllib.urlencode({"action": "queryip", "ip_url": ip})
        url = "http://www.ip.cn/getip.php?%s" % params
        f = urllib.urlopen(url)
        result = f.read()
        #print result
        tag = u"来自：".encode("GB2312")
        addr_pos = result.find(tag)
        if addr_pos == -1:
            return ""
        addr = result[addr_pos + len(tag):]
        city = unicode(addr.split(" ")[0], "GB2312")
        #print url, city
        return city
    except Exception, e:
        traceback.print_exc(file=sys.stdout)
        return ""
        
#print get_ip_city("119.187.184.14")
