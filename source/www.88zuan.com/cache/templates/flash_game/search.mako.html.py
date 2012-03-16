# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329916169.0131431
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/flash_game/search.mako.html'
_template_uri = '/flash_game/search.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_content', 'get_title', 'ad_head']


def _mako_get_namespace(context, name):
    try:
        return context.namespaces[(__name__, name)]
    except KeyError:
        _mako_generate_namespaces(context)
        return context.namespaces[(__name__, name)]
def _mako_generate_namespaces(context):
    # SOURCE LINE 4
    ns = runtime.TemplateNamespace(u'flash_game', context._clean_inheritance_tokens(), templateuri=u'/flash_game/func.mako.html', callables=None, calling_uri=_template_uri)
    context.namespaces[(__name__, u'flash_game')] = ns

def _mako_inherit(template, context):
    _mako_generate_namespaces(context)
    return runtime._inherit_from(context, u'/home/base.mako.html', _template_uri)
def render_body(context,**pageargs):
    context.caller_stack._push_frame()
    try:
        __M_locals = __M_dict_builtin(pageargs=pageargs)
        __M_writer = context.writer()
        # SOURCE LINE 2
        __M_writer(u'\r\n')
        # SOURCE LINE 3
        __M_writer(u'\r\n')
        # SOURCE LINE 4
        __M_writer(u'\r\n\r\n\r\n')
        # SOURCE LINE 7
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 32
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 110
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        int = context.get('int', UNDEFINED)
        h = context.get('h', UNDEFINED)
        flash_game = _mako_get_namespace(context, 'flash_game')
        len = context.get('len', UNDEFINED)
        range = context.get('range', UNDEFINED)
        round = context.get('round', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 34
        __M_writer(u'\r\n')
        # SOURCE LINE 35

        import urllib
        from zuan.controllers.flash_game import get_flash_game_pic_url
        from zuan.controllers.flash_game import GROUP_INFO
        
        
        # SOURCE LINE 39
        __M_writer(u'\r\n<div id="content">\r\n    <div id="content_left">\r\n    \t')
        # SOURCE LINE 42
        __M_writer(escape(flash_game.get_left_rank_list()))
        __M_writer(u'\r\n    </div>\r\n    <div id="content_right">\r\n    \t\r\n        <!-- 88zuan_\u641c\u7d22\u6e38\u620f\u7ed3\u679c\u9875_\u9876\u90e8\u6a2a\u5e45_728_90 -->\r\n        <div id=\'div-gpt-ad-1325991298711-0\' style=\'width:728px; height:90px;\'>\r\n        <script type=\'text/javascript\'>\r\n        googletag.cmd.push(function() { googletag.display(\'div-gpt-ad-1325991298711-0\'); });\r\n        </script>\r\n        </div>\r\n        \r\n    \t<div id="content_right_top">\r\n         \t<h3>\u641c\u7d22\u5173\u952e\u5b57:<label style="color: red;"> ')
        # SOURCE LINE 54
        __M_writer(escape(c.query))
        __M_writer(u' </label>\uff0c\u641c\u7d22\u7ed3\u679c\uff1a<label style="color: red;"> ')
        __M_writer(escape(c.total_num))
        __M_writer(u' </label>\u6761\u8bb0\u5f55</h3>\r\n        </div>\r\n        \t\r\n       <!-- flash game container -->\r\n      <div class="table">\r\n        \t<div class="row" style="height: 30px; margin-top: 5px; border-bottom: dotted 1px #ccc;">\u672c\u9875\u603b\u5171\u6709 ')
        # SOURCE LINE 59
        __M_writer(escape(len(c.fgs)))
        __M_writer(u' \u5c0f\u6e38\u620f</div>\r\n')
        # SOURCE LINE 60
        for obj in c.fgs:
            # SOURCE LINE 61
            __M_writer(u'            <div class="row" style="height: 80px; margin-top: 5px; border-bottom: dotted 1px #ccc;">\r\n              ')
            # SOURCE LINE 62

            name = h.short_text(obj.name, 30)
            pic = get_flash_game_pic_url(obj, c.setting)
            info = h.short_text(obj.info, 100)
            
            
            # SOURCE LINE 66
            __M_writer(u'\r\n              <div class="col" style="width: 80px;">\r\n                  <a target="_blank" href="')
            # SOURCE LINE 68
            __M_writer(escape(h.static_flash_game_detail_url(obj._id)))
            __M_writer(u'" title="')
            __M_writer(escape(obj.name))
            __M_writer(u'">\r\n                    <img border="0" class="fg_logo" src="')
            # SOURCE LINE 69
            __M_writer(escape(pic))
            __M_writer(u'" align="middle" alt="')
            __M_writer(escape(obj.name))
            __M_writer(u'" />\r\n                  </a>\r\n              </div>\r\n              <div class="col" style="width: 600px;">\r\n              ')
            # SOURCE LINE 73

            from zuan.controllers.flash_game import get_group
            import time
            now = int(time.time())
            group = get_group(obj.group_id)
            
            
            # SOURCE LINE 78
            __M_writer(u'\r\n                <div class="col_line">\r\n                  <a target="_blank" href="')
            # SOURCE LINE 80
            __M_writer(escape(h.static_flash_game_detail_url(obj._id)))
            __M_writer(u'" title="')
            __M_writer(escape(obj.name))
            __M_writer(u'">')
            __M_writer(escape(obj.name))
            __M_writer(u'</a>\r\n                   \u603b\u4eba\u6c14\uff1a')
            # SOURCE LINE 81
            __M_writer(escape(obj.total_play))
            __M_writer(u'\uff0c \u603b\u6e38\u620f\u65f6\u957f: ')
            __M_writer(escape(round(obj.total_play_time/3600, 2)))
            __M_writer(u' \u5c0f\u65f6\uff0c\u5f97\u5206\uff1a')
            __M_writer(escape(round(obj.score, 2)))
            __M_writer(u'\uff0c\u6700\u8fd1\u6e38\u620f\u65f6\u95f4\uff1a')
            __M_writer(escape(h.diff_time(obj.last_play_timestamp, now)))
            __M_writer(u'\u524d\r\n                </div>\r\n                <div class="col_line">')
            # SOURCE LINE 83
            __M_writer(escape(info))
            __M_writer(u'</div>\r\n              </div>\r\n            </div>\r\n')
            pass
        # SOURCE LINE 87
        __M_writer(u'        </div>\r\n            \r\n            \r\n            <!-- flash game page -->\r\n            <div class="table">\r\n            \t<div class="row">\r\n')
        # SOURCE LINE 93
        if c.start_page != 1:
            # SOURCE LINE 94
            __M_writer(u'                    <div class="col" style="width: 50px;"><a href="/flash_game/search?query=')
            __M_writer(escape(urllib.quote(c.query.encode("utf-8"))))
            __M_writer(u'&page=')
            __M_writer(escape(c.start_page - 1))
            __M_writer(u'">\u4e0a\u4e00\u9875</a></div>\r\n')
            pass
        # SOURCE LINE 96
        for i in range(c.start_page, c.end_page + 1):
            # SOURCE LINE 97
            __M_writer(u'                   \t<div class="col" style="width: 20px; min-width: 0; margin-left: 0;">\r\n')
            # SOURCE LINE 98
            if i == c.page:
                # SOURCE LINE 99
                __M_writer(u'                        <strong><a href="/flash_game/search?query=')
                __M_writer(escape(urllib.quote(c.query.encode("utf-8"))))
                __M_writer(u'&page=')
                __M_writer(escape(i))
                __M_writer(u'">')
                __M_writer(escape(i))
                __M_writer(u'</a></strong>\r\n')
                # SOURCE LINE 100
            else:
                # SOURCE LINE 101
                __M_writer(u'                        <a href="/flash_game/search?query=')
                __M_writer(escape(urllib.quote(c.query.encode("utf-8"))))
                __M_writer(u'&page=')
                __M_writer(escape(i))
                __M_writer(u'">')
                __M_writer(escape(i))
                __M_writer(u'</a>\r\n')
                pass
            # SOURCE LINE 103
            __M_writer(u'                    </div>\r\n')
            pass
        # SOURCE LINE 105
        __M_writer(u'                    <div class="col" style="width: 50px;"><a href="/flash_game/search?query=')
        __M_writer(escape(urllib.quote(c.query.encode("utf-8"))))
        __M_writer(u'&page=')
        __M_writer(escape(c.end_page + 1))
        __M_writer(u'">\u4e0b\u4e00\u9875</a></div>\r\n                </div>\r\n            </div>\r\n    </div>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_title(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 7
        __M_writer(u'\u641c\u7d22\uff1a')
        __M_writer(escape(c.query))
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_ad_head(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 9
        __M_writer(u"\r\n<script type='text/javascript'>\r\nvar googletag = googletag || {};\r\ngoogletag.cmd = googletag.cmd || [];\r\n(function() {\r\nvar gads = document.createElement('script');\r\ngads.async = true;\r\ngads.type = 'text/javascript';\r\nvar useSSL = 'https:' == document.location.protocol;\r\ngads.src = (useSSL ? 'https:' : 'http:') + \r\n'//www.googletagservices.com/tag/js/gpt.js';\r\nvar node = document.getElementsByTagName('script')[0];\r\nnode.parentNode.insertBefore(gads, node);\r\n})();\r\n</script>\r\n\r\n<script type='text/javascript'>\r\ngoogletag.cmd.push(function() {\r\ngoogletag.defineSlot('/13427485/88zuan_\u641c\u7d22\u6e38\u620f\u7ed3\u679c\u9875_\u9876\u90e8\u6a2a\u5e45_728_90', [728, 90], 'div-gpt-ad-1325991298711-0').addService(googletag.pubads());\r\ngoogletag.pubads().enableSingleRequest();\r\ngoogletag.enableServices();\r\n});\r\n</script>\r\n")
        return ''
    finally:
        context.caller_stack._pop_frame()


