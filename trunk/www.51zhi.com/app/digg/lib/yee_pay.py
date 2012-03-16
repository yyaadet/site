# -*- coding: utf-8 -*-

import urllib
import hmac

#商户编号
_MerId = "10001126856"
#密钥
_MD5Key = "69cl522AV6q613Ii4W6u8K6XuW8vM1N6bFgyv769220IuYe9u37N4y7rI4Pl"
#支付url
#_PayURL = "http://tech.yeepay.com:8080/robot/debug.action"#测试地址
_PayURL = "https://www.yeepay.com/app-merchant-proxy/node"
#支付成功回调url
_CallbackURL = "http://192.168.36.88:5000/home/recharge_callback"


class Yeepay(object):
    def __init__(self, mer_id, md5_key, callback, way=''):
        self.params = {}
        self.mer_id = mer_id
        self.md5_key = md5_key
        self.pay_url = _PayURL
        self.call_back_url = callback
        self.way = way

    def create_order_yeepay_url(self, transid, fee):
        self.params['p0_Cmd'] = 'Buy'
        self.params['p1_MerId'] = self.mer_id
        self.params['p2_Order'] = str(transid)
        self.params['p3_Amt'] = str(fee)
        self.params['p4_Cur'] = 'CNY'
        self.params['p5_Pid'] = 'B'
        self.params['p6_Pcat'] = 'youxi'
        self.params['p7_Pdesc'] = 'youxi'
        self.params['p8_Url'] = self.call_back_url
        self.params['p9_SAF'] = '0'
        self.params['pa_MP'] = 'youxi'
        self.params['pd_FrpId'] = self.way
        self.params['pr_NeedResponse'] = '1'
        
        param_keys = self.params.keys()
        param_keys.sort()
        m = hmac.new(self.md5_key)
        for k in param_keys:
            m.update(self.params[k])
        
        hash_key = m.hexdigest()
        
        request_data = self.pay_url + '?'
        for key in param_keys:
            request_data += urllib.urlencode({key:self.params[key].decode("utf8").encode("gbk")})
            request_data += '&'
        request_data += urllib.urlencode({"hmac":hash_key})
        return request_data

    def validate_callback_url(self, dic):
        used_keys = ['p1_MerId', 'r0_Cmd', 'r1_Code', \
            'r2_TrxId', 'r3_Amt', 'r4_Cur', 'r5_Pid', \
            'r6_Order', 'r7_Uid', 'r8_MP', 'r9_BType']
        origin = ""
        for key in used_keys:
            origin += urllib.unquote(dic[key])
        m = hmac.new(self.md5_key)
        m.update(origin)
        hmac_key = m.hexdigest()
        if hmac_key == dic["hmac"]:
            return True
        else:
            return False

if __name__ == "__main__":
    yeepay = Yeepay("10004455234", "474ggr90ef1h8904Ta6L14IQ9K39j89v0o9pH51WBoZsWIa583F6Z9h4P9jy",_CallbackURL)
    print yeepay.create_order_yeepay_url(100,100)
    
    yeepay2 = Yeepay(_MerId, _MD5Key,_CallbackURL)
    print yeepay2.create_order_yeepay_url(5,100)