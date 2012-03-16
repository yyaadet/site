# -*- coding: utf-8 -*-  
# author: Starx-cn 

from pylons import request, response
from pylons import config
from member.lib.utils import *

import md5
import time

import urllib

SECIROTU_CODE = "w6q192l3hbjljmm6ix0evg8t43cbcdqo"
SELLER_EMAIL = "xuan_bingan@yahoo.com.cn"
PARTNER_ID = "2088201457844050"

class Alipay(object):  
    def __init__(self, security_code, seller_email, partner_id,notify_url,return_url,show_url):  
        self.params = {}  
        # 支付宝gateway   
        self.pay_gate_way = 'https://www.alipay.com/cooperate/gateway.do'  
        # 安全码 ***处请填具体安全码  
        self.security_code = security_code
        self.seller_email = seller_email
        self.partner_id = partner_id
        self.notify_url = notify_url
        self.return_url = return_url
        self.show_url = show_url
        self.notify_gate_way = "http://notify.alipay.com/trade/notify_query.do"
          
    #---------------------------------------------------------------------------  
    # 根据订单生成支付宝接口URL  
    # <<<<< Protocol Param >>>>>  
    # @ input_charset: 编码方式  
    # @ service: 接口名称, 有两种方式 =>  
    #            1. trade_create_by_buyer (担保付款)   
    #            2. create_direct_pay_by_user (直接付款)  
    # @ partner : 商户在支付宝的用户ID  
    # @ show_url: 商品展示网址  
    # @ return_url: 交易付款成功后，显示给客户的页面  
    # @ sign_type: 签名方式  
    #  
    # <<<<< Business Param >>>>>  
    # @ subject: 商品标题  
    # @ body: 商品描述  
    # @ out_trade_no: 交易号（确保在本系统中唯一）  
    # @ price: 商品单价  
    # @ discount: 折扣 -**表示抵扣**元  
    # @ quantity: 购买数量  
    # @ payment_type: 支付类型  
    # @ logistics_type: 物流类型 => 1. POST (平邮) 2. EMS 3. EXPRESS (其他快递)  
    # @ logistics_fee: 物流费  
    # @ logistics_payment: 物流支付类型 =>   
    #                      1. SELLER_PAY (卖家支付) 2. BUYER_PAY (买家支付)  
    # @ seller_email: 卖家支付宝帐户email  
    #   
    # @return   
    #---------------------------------------------------------------------------  
    def create_order_alipay_url(self,     
                                sign_type,    
                                out_trade_no,   
                                total_fee    
                                ):                                
        self.params['_input_charset'] = 'utf-8'  
        self.params['service'] = 'create_direct_pay_by_user'  
        self.params['partner'] = self.partner_id  
        self.params['show_url'] = self.show_url
        self.params['return_url'] = self.return_url
        self.params['notify_url'] = self.notify_url
        self.params['subject'] = "gold"
        self.params['body'] = "starcn"  
        self.params['out_trade_no'] = out_trade_no
        #self.params['price'] = "1"  
        self.params['total_fee'] = total_fee
        self.params['discount'] = "0.00"  
        #self.params['quantity'] = quantity 
        self.params['payment_type'] = "1"  
        self.params['logistics_type'] = "EXPRESS"  
        self.params['logistics_fee'] = "0.00"  
        self.params['logistics_payment'] = "BUYER_PAY"  
        self.params['seller_email'] = self.seller_email
        # 返回结果  
        return self._create_url(self.params, sign_type)  
    
        
    def _create_url(self, params, sign_type='MD5'):   
        param_keys = params.keys()  
        # 支付宝参数要求按照字母顺序排序  
        param_keys.sort()  
        # 初始化待签名的数据  
        unsigned_data = ''  
        # 生成待签名数据  
        for key in param_keys:  
            unsigned_data += key + '=' + params[key]  
            if key != param_keys[-1]:  
                unsigned_data += '&'  
        # 添加签名密钥  
        unsigned_data += self.security_code  
        # 计算sign值  
        if sign_type == 'MD5':  
            M = md5.new()  
            M.update(unsigned_data)  
            sign = M.hexdigest()  
        else:  
            sign = ''  
        request_data = self.pay_gate_way + '?'  
        for key in param_keys:  
            #request_data += key + '=' + params[key]
            request_data += urllib.urlencode({key: params[key]})
#            request_data += key + '=' + params[key].decode('utf8').encode(params['_input_charset'])  
            request_data += '&'  
        request_data += 'sign=' + sign + '&sign_type=' + sign_type  
        # 返回结果  
        return request_data
    
    def create_notify_verify_url(self, msg_id):
        request_data = self.notify_gate_way + '?'  
        request_data += "partner=" + self.partner_id
        request_data += "&notify_id=" + msg_id
        return request_data  
    
    def validate_notify_url(self, params,sign_type="MD5"):
        param_keys = params.keys()  
        # 支付宝参数要求按照字母顺序排序  
        param_keys.sort()  
        # 初始化待签名的数据  
        unsigned_data = ''  
        # 生成待签名数据  
        for key in param_keys:  
            unsigned_data += key + '=' + params[key]  
            if key != param_keys[-1]:  
                unsigned_data += '&'  
        # 添加签名密钥  
        unsigned_data += self.security_code  
        # 计算sign值  
        if sign_type == 'MD5':  
            M = md5.new()  
            M.update(unsigned_data.encode("utf-8"))  
            sign = M.hexdigest()  
        else:  
            sign = ''
        return sign