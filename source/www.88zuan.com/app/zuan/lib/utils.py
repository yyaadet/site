#coding=utf-8

import time


class Storage(dict):
    """
    A Storage object is like a dictionary except `obj.foo` can be used
    in addition to `obj['foo']`.
    
        >>> o = storage(a=1)
        >>> o.a
        1
        >>> o['a']
        1
        >>> o.a = 2
        >>> o['a']
        2
        >>> del o.a
        >>> o.a
        Traceback (most recent call last):
            ...
        AttributeError: 'a'
    
    """
    def __getattr__(self, key): 
        try:
            return self[key]
        except KeyError, k:
            raise AttributeError, k

    def __setattr__(self, key, value): 
        self[key] = value

    def __delattr__(self, key):
        try:
            del self[key]
        except KeyError, k:
            raise AttributeError, k

    def __repr__(self):     
        return '<Storage ' + dict.__repr__(self) + '>'



def display_time(func):
    def cal_time(*args):
        # 记录开始时间
        start = time.time()
        # 回调原函数
        result = func(*args)
        passtime = time.time() - start
        # 在结果输出追加计时信息
        if passtime >= 0.5:
            print "warning: %s %s spend %f ms" % (func, args, passtime)
        # 返回结果
        return result
    # 返回重新装饰过的函数句柄
    return cal_time