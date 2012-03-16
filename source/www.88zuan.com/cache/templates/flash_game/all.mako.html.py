# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329895542.8893361
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/flash_game/all.mako.html'
_template_uri = '/flash_game/all.mako.html'
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
        # SOURCE LINE 15
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 40
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 69
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        flash_game = _mako_get_namespace(context, 'flash_game')
        __M_writer = context.writer()
        # SOURCE LINE 42
        __M_writer(u'\r\n')
        # SOURCE LINE 43
 
        from zuan.lib.helpers import fmt_time
        from zuan.lib.helpers import short_text
        from zuan.lib.helpers import static_flash_game_detail_url
        from zuan.lib.helpers import static_flash_game_group_url
        from zuan.controllers.flash_game import get_flash_game_pic_url
        from zuan.controllers.flash_game import GROUP_INFO
        
        
        # SOURCE LINE 50
        __M_writer(u'\r\n\r\n<div id="content">\r\n    <div id="content_left">\r\n    \t')
        # SOURCE LINE 54
        __M_writer(escape(flash_game.get_left_rank_list(c.group_id)))
        __M_writer(u'\r\n    </div>\r\n    <div id="content_right">\r\n\r\n        <!-- 88zuan_\u5168\u90e8\u6e38\u620f\u9875_\u9876\u90e8\u6a2a\u5e45_728_90 -->\r\n        <div id=\'div-gpt-ad-1325990841252-0\' style=\'width:728px; height:90px;\'>\r\n        <script type=\'text/javascript\'>\r\n        googletag.cmd.push(function() { googletag.display(\'div-gpt-ad-1325990841252-0\'); });\r\n        </script>\r\n        </div>\r\n            \r\n        ')
        # SOURCE LINE 65
        __M_writer(escape(flash_game.get_list(c.fgs, c.start_page, c.page, c.end_page, c.group_id)))
        __M_writer(u'\r\n\r\n    </div>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_title(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 7
        __M_writer(u'\r\n')
        # SOURCE LINE 8
        if c.group_id:
            # SOURCE LINE 9
            __M_writer(u'\t')
            from zuan.controllers.flash_game import get_group 
            
            __M_writer(u'\r\n    ')
            # SOURCE LINE 10
            group = get_group(c.group_id) 
            
            __M_writer(u'\r\n    ')
            # SOURCE LINE 11
            __M_writer(escape(group[1]))
            __M_writer(u'\u5c0f\u6e38\u620f\r\n')
            # SOURCE LINE 12
        else:
            # SOURCE LINE 13
            __M_writer(u'\u5c0f\u6e38\u620f\u96c6\u5408\r\n')
            pass
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_ad_head(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 17
        __M_writer(u"\r\n<script type='text/javascript'>\r\nvar googletag = googletag || {};\r\ngoogletag.cmd = googletag.cmd || [];\r\n(function() {\r\nvar gads = document.createElement('script');\r\ngads.async = true;\r\ngads.type = 'text/javascript';\r\nvar useSSL = 'https:' == document.location.protocol;\r\ngads.src = (useSSL ? 'https:' : 'http:') + \r\n'//www.googletagservices.com/tag/js/gpt.js';\r\nvar node = document.getElementsByTagName('script')[0];\r\nnode.parentNode.insertBefore(gads, node);\r\n})();\r\n</script>\r\n\r\n<script type='text/javascript'>\r\ngoogletag.cmd.push(function() {\r\ngoogletag.defineSlot('/13427485/88zuan_\u5168\u90e8\u6e38\u620f\u9875_\u9876\u90e8\u6a2a\u5e45_728_90', [728, 90], 'div-gpt-ad-1325990841252-0').addService(googletag.pubads());\r\ngoogletag.pubads().enableSingleRequest();\r\ngoogletag.enableServices();\r\n});\r\n</script>\r\n")
        return ''
    finally:
        context.caller_stack._pop_frame()


