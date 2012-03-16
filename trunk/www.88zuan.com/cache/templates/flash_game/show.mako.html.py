# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329894950.255239
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/flash_game/show.mako.html'
_template_uri = '/flash_game/show.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_search_box', 'get_title', 'get_top', 'get_description', 'get_content', 'get_tail']


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
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 6
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 8
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 10
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 12
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 14
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 84
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_search_box(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_title(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 6
        __M_writer(escape(c.fg.name))
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_top(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_description(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 8
        __M_writer(escape(c.fg.operate_info))
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 16
        __M_writer(u'\r\n')
        # SOURCE LINE 17

        from zuan.lib.helpers import fmt_time
        from zuan.lib.helpers import short_text
        from zuan.lib.helpers import static_flash_game_detail_url
        from zuan.controllers.flash_game import get_flash_game_pic_url
        from zuan.controllers.flash_game import get_flash_game_file_url
        from zuan.controllers.flash_game import get_group
        
        group = get_group(c.fg.group_id)
        
        
        # SOURCE LINE 26
        __M_writer(u'\r\n        <div class="table" style="background-color: #000;">\r\n            <div class="row" style="height: ')
        # SOURCE LINE 28
        __M_writer(escape(c.height))
        __M_writer(u'; width: ')
        __M_writer(escape(c.width))
        __M_writer(u'; text-align:center; ">\r\n                <div id="flash_game_file" style="margin: 0 auto; height: ')
        # SOURCE LINE 29
        __M_writer(escape(c.height))
        __M_writer(u'; width: ')
        __M_writer(escape(c.width))
        __M_writer(u'; text-align:center; ">\r\n                </div>\r\n            </div>\r\n        </div>\r\n\r\n<script type="text/javascript">\r\nvar g_logo_time = 10000;\r\nvar g_log_interval = 10000;\r\n\r\nfunction get_logo()\r\n{\r\n\tif (g_logo_time <= 0) {\r\n\t\tshow_swf();\r\n\t\treturn;\r\n\t}\r\n\tg_logo_time = g_logo_time - 1000;\r\n\t$("#left_time").html("\u90fd\u6709')
        # SOURCE LINE 45
        __M_writer(escape(c.fg.total_play))
        __M_writer(u'\u4eba\u73a9\u8fc7\u4e86\uff01\u52a0\u8f7d\u6e38\u620f\u4e2d\uff0c\u5269\u4f59\u65f6\u95f4\uff1a" + (g_logo_time/1000) + "\u79d2");\r\n\tsetTimeout("get_logo()", 1000);\r\n}\r\n\r\nfunction show_swf()\r\n{\r\n\t$("#pre_play").remove();\r\n\t$("#left_time").remove();\r\n        get_swf();\r\n}\r\n\r\nfunction log_play_time()\r\n{\r\n    $.getJSON("/flash_game/log_play_time", {\'id\': \'')
        # SOURCE LINE 58
        __M_writer(escape(c.fg._id))
        __M_writer(u'\'}, function(data) {\r\n        setTimeout("log_play_time()", g_log_interval);\r\n\treturn;\r\n     });\r\n}\r\n\r\nfunction get_swf()\r\n{\r\n    var flashvars={};\r\n    var params = {"menu": "false", "allowFullScreen": true, \'quality\': \'high\'};\r\n    var attrs={};\r\n\tswfobject.embedSWF("')
        # SOURCE LINE 69
        __M_writer(escape(get_flash_game_file_url(c.fg, c.setting)))
        __M_writer(u'", "flash_game_file", "')
        __M_writer(escape(c.width))
        __M_writer(u'", "')
        __M_writer(escape(c.height))
        __M_writer(u'", "9.0.0", "expressInstall.swf", flashvars, params, attrs);\r\n\t$.getJSON("/flash_game/playing", {\'id\': \'')
        # SOURCE LINE 70
        __M_writer(escape(c.fg._id))
        __M_writer(u'\'}, function(data) {\r\n            setTimeout("log_play_time()", g_log_interval);\r\n\t    return;\r\n\t});\r\n}\r\n\r\n$(document).ready(function() {\r\n\tvar ad = "<div id=\'pre_play\' style=\'width: 100%;height: 500px; margin: 10px auto; padding-left: 180px;\'><iframe align=\\"center\\" width=\\"100%\\" height=\\"100%\\" src=\\"/ad/play_top_336_280.html\\" frameborder=\\"0\\" scrolling=\\"no\\" marginheight=\\"0\\" marginwidth=\\"0\\"></iframe></div>";\r\n\tvar left = "<div id=\\"left_time\\" style=\\"margin: 5px auto; width: 100%; height: 25px; color: #fff; font-size: 14px;\\"></div>";\r\n\t$("#flash_game_file").append(left);\r\n\t$("#flash_game_file").append(ad);\r\n\tget_logo();\r\n});\r\n</script>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_tail(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        return ''
    finally:
        context.caller_stack._pop_frame()


