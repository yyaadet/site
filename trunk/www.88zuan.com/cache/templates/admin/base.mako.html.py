# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329912521.416224
_template_filename = u'/root/sites/www.88zuan.com/app/zuan/templates/admin/base.mako.html'
_template_uri = u'/admin/base.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_time', 'get_content', 'get_tail']


def render_body(context,**pageargs):
    context.caller_stack._push_frame()
    try:
        __M_locals = __M_dict_builtin(pageargs=pageargs)
        c = context.get('c', UNDEFINED)
        self = context.get('self', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 2
        __M_writer(u'\r\n<html>\r\n  <head>\r\n    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />\r\n    <link rel="stylesheet" type="text/css" media="screen" href="/admin/admin.css" />\r\n    <link rel="stylesheet" type="text/css" media="screen" href="/editor/index.css" />\r\n    <script type="text/javascript" src="/admin/jquery.min.js" ></script>\r\n    <script type="text/javascript" src="/tools.js" ></script>\r\n    <title>\u540e\u53f0\u7ba1\u7406\u4e2d\u5fc3</title>\r\n  </head>\r\n  ')
        # SOURCE LINE 12

        menus = [
            {'url': '/', 'name': u'回首页'},
            {'url': '/admin/flash_game', 'name': u'小游戏'},
            {'url': '/admin/friendlink', 'name': u'友情链接'},
            {'url': '/admin/setting', 'name': u'系统设置'},
            {'url': '/admin/it', 'name': u'运营'},
            {'url': '/admin/reset_passwd', 'name': u'修改密码'},
            {'url': '/admin/logout', 'name': u'退出'},
        ]
        
        
        __M_locals_builtin_stored = __M_locals_builtin()
        __M_locals.update(__M_dict_builtin([(__M_key, __M_locals_builtin_stored[__M_key]) for __M_key in ['menus'] if __M_key in __M_locals_builtin_stored]))
        # SOURCE LINE 22
        __M_writer(u'\r\n  \r\n  <body>     \r\n    <div id="top">\r\n        <div class="table">\r\n')
        # SOURCE LINE 27
        if c.admin_name:
            # SOURCE LINE 28
            for menu in menus:
                # SOURCE LINE 29
                __M_writer(u'                <div class="col"><a href="')
                __M_writer(escape(menu['url']))
                __M_writer(u'">')
                __M_writer(escape(menu['name']))
                __M_writer(u'</a></div>\r\n')
                pass
            pass
        # SOURCE LINE 32
        __M_writer(u'    </div>\r\n    </div>\r\n     <div id="content" >\r\n                ')
        # SOURCE LINE 35
        __M_writer(escape(self.get_content()))
        __M_writer(u'\r\n    </div>\r\n\t\t\r\n     ')
        # SOURCE LINE 38
        __M_writer(escape(self.get_tail()))
        __M_writer(u'\r\n  </body>\r\n</html>\r\n\r\n')
        # SOURCE LINE 43
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 49
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 57
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_time(context,t):
    context.caller_stack._push_frame()
    try:
        h = context.get('h', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 51
        __M_writer(u'\r\n')
        # SOURCE LINE 52
        if t:
            # SOURCE LINE 53
            __M_writer(escape(h.fmt_time(t, "%Y-%m-%d")))
            __M_writer(u'\r\n')
            # SOURCE LINE 54
        else:
            # SOURCE LINE 55
            __M_writer(u'\u672a\u77e5\r\n')
            pass
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 42
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_tail(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 45
        __M_writer(u'\r\n<div id="tail" >\r\n      <span>\u8363\u8a89\u51fa\u54c1</span>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


