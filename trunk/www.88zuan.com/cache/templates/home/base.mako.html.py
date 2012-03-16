# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329894889.787776
_template_filename = u'/root/sites/www.88zuan.com/app/zuan/templates/home/base.mako.html'
_template_uri = u'/home/base.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_search_box', 'get_title', 'get_top', 'get_description', 'get_content', 'get_tail', 'get_header', 'ad_head']


def render_body(context,**pageargs):
    context.caller_stack._push_frame()
    try:
        __M_locals = __M_dict_builtin(pageargs=pageargs)
        self = context.get('self', UNDEFINED)
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 2
        __M_writer(u'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\r\n<html xmlns="http://www.w3.org/1999/xhtml">\r\n  <head>\r\n    <title>')
        # SOURCE LINE 5
        __M_writer(escape(self.get_title()))
        __M_writer(u' ')
        __M_writer(escape(c.setting.seo_title))
        __M_writer(u'</title>\r\n    <meta name="keywords" content="')
        # SOURCE LINE 6
        __M_writer(escape(self.get_title()))
        __M_writer(u' ')
        __M_writer(escape(c.setting.seo_keywords))
        __M_writer(u'" />\r\n    <meta name="description" content="')
        # SOURCE LINE 7
        __M_writer(escape(self.get_description()))
        __M_writer(u' ')
        __M_writer(escape(c.setting.seo_desc))
        __M_writer(u'" />\r\n    <link rel="stylesheet" type="text/css" media="screen" href="/home/home.css" />\r\n    ')
        # SOURCE LINE 9
        __M_writer(escape(self.get_header()))
        __M_writer(u'\r\n    ')
        # SOURCE LINE 10
        __M_writer(escape(self.ad_head()))
        __M_writer(u'\r\n  </head>\r\n  <body>\r\n        ')
        # SOURCE LINE 13
        __M_writer(escape(self.get_top()))
        __M_writer(u'\r\n        \r\n        ')
        # SOURCE LINE 15
        __M_writer(escape(self.get_search_box()))
        __M_writer(u'\r\n\t\t\r\n        ')
        # SOURCE LINE 17
        __M_writer(escape(self.get_content()))
        __M_writer(u'\r\n\t\t\r\n        ')
        # SOURCE LINE 19
        __M_writer(escape(self.get_tail()))
        __M_writer(u'\r\n        \r\n  </body>\r\n</html>\r\n\r\n')
        # SOURCE LINE 24
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 26
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 28
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 42
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 70
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 85
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 90
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 156
        __M_writer(u'\r\n\r\n\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_search_box(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 72
        __M_writer(u'\r\n<div class="search_box">\r\n\t<div class="table" style="height: 28px; border-bottom: solid 1px #cccccc;">\r\n    \t<form action="/flash_game/search" method="get">\r\n    \t<div class="row">\r\n            <div class="col">\u5c0f\u6e38\u620f\u641c\u7d22</div>\r\n            <div class="col"><input type="text" name="query" class="text" value="')
        # SOURCE LINE 78
        __M_writer(escape(c.query))
        __M_writer(u'" /></div>\r\n            <div class="col"><input type="submit" value="\u641c\u7d22" class="button" /></div>\r\n            <div class="col">\u8bf7\u8bb0\u4f4f\u672c\u7ad9\u7f51\u5740www.88zuan.com,\u70b9\u51fb<a style="color: red;" onclick="addBookmark();return false;" href="#">\u6536\u85cf88zuan</a>,\u65b9\u4fbf\u4e0b\u6b21\u518d\u73a9</div>\r\n        </div>\r\n        </form>\r\n    </div>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_title(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_top(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 44
        __M_writer(u'\r\n<div id="top">\r\n    <div id="top_tip">\r\n        <div id="top_left">\r\n        \u6b22\u8fce\u60a8\u6765\u5230\u516b\u516b\u5c0f\u6e38\u620f\uff01\r\n        </div>\r\n        <div id="top_right">\r\n            <!-- JiaThis Button BEGIN -->\r\n            <div id="ckepop">\r\n                <a href="http://www.jiathis.com/share?uid=1501989" class="jiathis jiathis_txt jialike" target="_blank"><img src="http://v2.jiathis.com/code_mini/images/btn/v1/jialike1.gif" border="0" />\t<a class="jiathis_counter_style"></a>\r\n            </a>\r\n                <a class="jiathis_like_qzone" data="width=100"></a>\r\n                <a class="jiathis_like_renren" data="width=100"></a>\r\n                <a class="jiathis_like_kaixin001"></a>\r\n            </div>\r\n            <script type="text/javascript">var jiathis_config = {data_track_clickback:true};</script>\r\n            <script type="text/javascript" src="http://v2.jiathis.com/code_mini/jia.js?uid=1501989" charset="utf-8"></script>\r\n            <!-- JiaThis Button END -->\r\n        </div>\r\n    </div>\r\n\r\n    <div id="top_logo">\r\n    \t<div class="col"><a href="/">\u516b\u516b\u5c0f\u6e38\u620f</a></div>\r\n        <div class="col"><a href="/flash_game/all">\u5c0f\u6e38\u620f\u5927\u5168</a></div>\r\n    </div>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_description(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 87
        __M_writer(u'\r\n<div id="content" >\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_tail(context,is_in_home=1):
    context.caller_stack._push_frame()
    try:
        int = context.get('int', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 92
        __M_writer(u'\r\n<div id="tail" >\r\n    <div class="table" style="height: auto">\r\n    \t<div class="row" style="height: 25px;">\r\n        \t<div class="col"><a target="_blank" href="/home/friend_link">\u66f4\u591a\u53cb\u60c5\u94fe\u63a5>></a></div>\r\n        \t<div class="col" style="width: auto;">\u7533\u8bf7\u53cb\u60c5\u94fe\u63a5\uff0c\u8bf7\u8054\u7cfbQQ\uff1a1134362918</div>\r\n        </div>\r\n        <div class="row">\r\n        ')
        # SOURCE LINE 100

        from zuan.model.friendlink import Friendlink
        objs = Friendlink.query()
        
        
        # SOURCE LINE 103
        __M_writer(u'\r\n')
        # SOURCE LINE 104
        for link in objs:
            # SOURCE LINE 105
            if int(link.is_in_home) == is_in_home:
                # SOURCE LINE 106
                __M_writer(u'        <a target="_blank" href="')
                __M_writer(escape(link.url))
                __M_writer(u'">')
                __M_writer(escape(link.name))
                __M_writer(u'</a> | \r\n')
                pass
            pass
        # SOURCE LINE 109
        __M_writer(u'        </div>\r\n    </div>\r\n    <div class="table" style="border-bottom: none;">\r\n    \t<div class="row" style="height: 26px;">\r\n            <div class="col"><a href="#">\u516b\u516b\u5c0f\u6e38\u620f</a></div>\r\n\r\n            <div class="col"><a href="/admin/login">\u6570\u636e\u5f55\u5165</a></div>\r\n            \r\n            <div class="col"><a href="/home/bussiness">\u5546\u52a1\u5408\u4f5c</a></div>\r\n            \r\n            <div class="col"><a href="#">\u4f1a\u5458\u7ec6\u5219</a></div>\r\n            \r\n            <div class="col"><a href="#">\u7f51\u7ad9\u5730\u56fe</a></div>\r\n            \r\n            <div class="col"><a href="http://www.miibeian.gov.cn/" target="_blank">\u4eacICP\u590711011403\u53f7</a></div>\r\n        </div>\r\n\r\n        \r\n        <div class="row" style="height: 26px; text-align: center;">\r\n        \u8bf7\u8bb0\u4f4f\u672c\u7ad9\u7f51\u5740www.88zuan.com,\u70b9\u51fb<a style="color: red;" onclick="addBookmark();return false;" href="#">\u6536\u85cf88zuan</a>,\u65b9\u4fbf\u4e0b\u6b21\u518d\u73a9\r\n        </div>\r\n        \r\n        <div class="row" style="height: 26px; text-align: center;">\r\n        \u4f5c\u54c1\u7248\u6743\u5f52\u4f5c\u8005\u6240\u6709\uff0c\u5982\u679c\u65e0\u610f\u4e4b\u4e2d\u4fb5\u72af\u4e86\u60a8\u7684\u7248\u6743\uff0c\u8bf7\u6765\u4fe1\u544a\u77e5\uff0c\u672c\u7ad9\u5c06\u57287\u4e2a\u5de5\u4f5c\u65e5\u5185\u5220\u9664\r\n        </div>\r\n        <!-- baidu ads -->\r\n        <div class="row">\r\n            <script type="text/javascript">/*120*270\uff0c\u521b\u5efa\u4e8e2011-4-11*/ var cpro_id = \'u441992\';</script><script src="http://cpro.baidu.com/cpro/ui/f.js" type="text/javascript"></script>\r\n        </div>\r\n    </div>\r\n</div>\r\n\r\n<!-- UJian Button BEGIN -->\r\n<script type="text/javascript" src="http://v1.ujian.cc/code/ujian.js?type=slide&btn=2"></script>\r\n<!-- UJian Button END -->\r\n\r\n<div style="display: none;">\r\n<!-- 51.la -->\r\n<script language="javascript" type="text/javascript" src="http://js.users.51.la/4503459.js"></script>\r\n<noscript><a href="http://www.51.la/?4503459" target="_blank"><img alt="&#x6211;&#x8981;&#x5566;&#x514D;&#x8D39;&#x7EDF;&#x8BA1;" src="http://img.users.51.la/4503459.asp" style="border:none" /></a></noscript>\r\n<!-- end -->\r\n\r\n<!-- tongji.baidu.com -->\r\n<script type="text/javascript">var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cscript src=\'" + _bdhmProtocol + "hm.baidu.com/h.js%3F083ed74a80df7e3b6c3e59dc357a3d6e\' type=\'text/javascript\'%3E%3C/script%3E"));</script>\r\n\r\n<!-- end -->\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_header(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 30
        __M_writer(u'\r\n    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />\r\n    <meta name="google-site-verification" content="XS6WoMPXFpO-oWpi6a3-4OsZ9UBqnoK57X2waiyjvkM" />\r\n    <meta name="y_key" content="24293ac723a2b91a" />\r\n    <meta name="chinaz-site-verification" content="25426d5a-1aaa-4640-befa-b8e960c2ae53" />\r\n    <meta name="baidu_union_verify" content="fc1fe81f692238273d115d11c9a59f0b">\r\n    <link href="/favicon.ico" type="image/x-icon" rel="shortcut icon" />\r\n    \r\n    <script type="text/javascript" src="/jquery-1.3.2.min.js" ></script>\r\n    <script type="text/javascript" src="/jquery.form.js" ></script>\r\n    <script type="text/javascript" src="/swfobject.js" ></script>\r\n    <script type="text/javascript" src="/tools.js"  charset="UTF-8"></script>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_ad_head(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        return ''
    finally:
        context.caller_stack._pop_frame()


