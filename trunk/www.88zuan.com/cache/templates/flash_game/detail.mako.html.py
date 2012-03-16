# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329894945.3281391
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/flash_game/detail.mako.html'
_template_uri = '/flash_game/detail.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_description', 'get_content', 'get_title', 'ad_head']


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
        # SOURCE LINE 29
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 31
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 33
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 103
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_description(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 33
        __M_writer(escape(c.fg.info))
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        int = context.get('int', UNDEFINED)
        h = context.get('h', UNDEFINED)
        float = context.get('float', UNDEFINED)
        flash_game = _mako_get_namespace(context, 'flash_game')
        round = context.get('round', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 35
        __M_writer(u'\r\n')
        # SOURCE LINE 36

        from zuan.controllers.flash_game import get_group
        group = get_group(c.fg.group_id)
        
        
        # SOURCE LINE 39
        __M_writer(u'\r\n<div id="content">\r\n    <div id="content_left">\r\n    \t')
        # SOURCE LINE 42
        __M_writer(escape(flash_game.get_left_rank_list(c.fg.group_id)))
        __M_writer(u'\r\n    </div>\r\n    \r\n    <div id="content_right">\r\n    \r\n        <div class="table">\r\n            <div class="row">\r\n                <div id=\'div-gpt-ad-1325988314112-0\' style=\'width:336px; height:280px; margin-left: 200px;\'>\r\n                <script type=\'text/javascript\'>\r\n                googletag.cmd.push(function() { googletag.display(\'div-gpt-ad-1325988314112-0\'); });\r\n                </script>\r\n                </div>\r\n            </div>\r\n        </div>\r\n       \r\n\r\n        ')
        # SOURCE LINE 58

        from zuan.controllers.flash_game import get_flash_game_pic_url
        import time
        now = int(time.time())
        pic_url = get_flash_game_pic_url(c.fg, c.setting, False)
        
        
        # SOURCE LINE 63
        __M_writer(u'\r\n        \r\n  \t\t<div class="table" style="height: auto;">\r\n           <div class="row">\r\n               <div class="col" style="width: 300px;">\r\n                   <div class="col_line">\r\n                      <a href="')
        # SOURCE LINE 69
        __M_writer(escape(h.static_flash_game_detail_url(c.fg._id)))
        __M_writer(u'">\r\n                          <img width="300" height="200" class="fg_big_logo" src="')
        # SOURCE LINE 70
        __M_writer(escape(pic_url))
        __M_writer(u'" align="middle" alt="')
        __M_writer(escape(c.fg.name))
        __M_writer(u'" />\r\n                      </a>\r\n                   </div>\r\n                   <div class="col_line" style="text-align: center;">\r\n                       <a href="')
        # SOURCE LINE 74
        __M_writer(escape(h.static_flash_game_play_url(c.fg._id)))
        __M_writer(u'"><img src="/flash_game/start_game.png" /></a>\r\n                   </div>\r\n               </div>\r\n               <div class="col" style="width: 360px;">\r\n                   <div class="col_line"><h1>')
        # SOURCE LINE 78
        __M_writer(escape(c.fg.name))
        __M_writer(u'</h1></div>\r\n                   <div class="col_line"><b>\u73a9\u4f34\uff1a</b>\u6e38\u5ba2\u5728')
        # SOURCE LINE 79
        __M_writer(escape(h.diff_time(c.fg.last_play_timestamp, now)))
        __M_writer(u'\u524d\u4e5f\u73a9\u4e86\u8fd9\u4e2a\u5c0f\u6e38\u620f</div>\r\n                   <div class="col_line"><b>\u7c7b\u522b\uff1a</b>\u3010')
        # SOURCE LINE 80
        __M_writer(escape(group[1]))
        __M_writer(u'\u3011</div>\r\n                   <div class="col_line"><b>\u5f97\u5206\uff1a</b>')
        # SOURCE LINE 81
        __M_writer(escape(round(c.fg.score, 2)))
        __M_writer(u'</div>\r\n                   <div class="col_line"><b>\u4eba\u6c14\uff1a</b>')
        # SOURCE LINE 82
        __M_writer(escape(c.fg.total_play))
        __M_writer(u'</div>\r\n                   <div class="col_line"><b>\u6e38\u620f\u65f6\u957f\uff1a</b>')
        # SOURCE LINE 83
        __M_writer(escape(round(float(c.fg.total_play_time)/float(3600), 2)))
        __M_writer(u'</div>\r\n                   <div class="col_line"><b>\u7b80\u4ecb\uff1a</b>')
        # SOURCE LINE 84
        __M_writer(escape(c.fg.info))
        __M_writer(u'</div>\r\n                   <div class="col_line"><b>\u64cd\u4f5c\uff1a</b>')
        # SOURCE LINE 85
        __M_writer(escape(c.fg.operate_info))
        __M_writer(u'</div>\r\n')
        # SOURCE LINE 86
        if c.admin_name:
            # SOURCE LINE 87
            __M_writer(u'                   <div class="col_line">\r\n                       <a href="/admin/flash_game_edit?id=')
            # SOURCE LINE 88
            __M_writer(escape(c.fg._id))
            __M_writer(u'">\u7f16\u8f91</a> |\r\n                       <a href="/flash_game/rem?id=')
            # SOURCE LINE 89
            __M_writer(escape(c.fg._id))
            __M_writer(u'">\u5220\u9664</a>\r\n                   </div>\r\n')
            pass
        # SOURCE LINE 92
        __M_writer(u'               </div>\r\n           </div>\r\n         </div>\r\n         <!-- PingLun.La Begin -->\r\n\t\t <div id="pinglunla_here"></div><a href="http://pinglun.la/" id="logo-pinglunla">\u8bc4\u8bba\u5566</a><script type="text/javascript" src="http://static.pinglun.la/md/pinglun.la.js" charset="utf-8"></script>\r\n\t\t <!-- PingLun.La End -->\r\n     </div>\r\n     \r\n    <!-- right -->\r\n   </div>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_title(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 31
        __M_writer(escape(c.fg.name))
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_ad_head(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 6
        __M_writer(u"\r\n<script type='text/javascript'>\r\nvar googletag = googletag || {};\r\ngoogletag.cmd = googletag.cmd || [];\r\n(function() {\r\nvar gads = document.createElement('script');\r\ngads.async = true;\r\ngads.type = 'text/javascript';\r\nvar useSSL = 'https:' == document.location.protocol;\r\ngads.src = (useSSL ? 'https:' : 'http:') + \r\n'//www.googletagservices.com/tag/js/gpt.js';\r\nvar node = document.getElementsByTagName('script')[0];\r\nnode.parentNode.insertBefore(gads, node);\r\n})();\r\n</script>\r\n\r\n<script type='text/javascript'>\r\ngoogletag.cmd.push(function() {\r\ngoogletag.defineSlot('/13427485/88zuan_\u6e38\u620f\u4ecb\u7ecd\u9875_\u9876\u90e8\u65b9\u5757_336_280', [336, 280], 'div-gpt-ad-1325988314112-0').addService(googletag.pubads());\r\ngoogletag.pubads().enableSingleRequest();\r\ngoogletag.enableServices();\r\n});\r\n</script>\r\n")
        return ''
    finally:
        context.caller_stack._pop_frame()


