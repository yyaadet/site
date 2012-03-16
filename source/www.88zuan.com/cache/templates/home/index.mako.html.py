# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329894889.7315819
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/home/index.mako.html'
_template_uri = '/home/index.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_content', 'ad_head']


def _mako_get_namespace(context, name):
    try:
        return context.namespaces[(__name__, name)]
    except KeyError:
        _mako_generate_namespaces(context)
        return context.namespaces[(__name__, name)]
def _mako_generate_namespaces(context):
    # SOURCE LINE 32
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
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 27
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 66
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        h = context.get('h', UNDEFINED)
        c = context.get('c', UNDEFINED)
        flash_game = _mako_get_namespace(context, 'flash_game')
        __M_writer = context.writer()
        # SOURCE LINE 29
        __M_writer(u'\r\n<div id="content">\r\n    <div id="content_left">\r\n        ')
        # SOURCE LINE 32
        __M_writer(u'\r\n        ')
        # SOURCE LINE 33
        __M_writer(escape(flash_game.get_left_rank_list(0)))
        __M_writer(u'\r\n    </div>\r\n\r\n    <div id="content_right">\r\n        <div class="table" style="height: 90px; overflow:hidden; margin-left: 5px;">\r\n            <!-- 88zuan_\u9996\u9875_728_90 -->\r\n            <div id=\'div-gpt-ad-1325985846574-0\' style=\'width:728px; height:90px;\'>\r\n            <script type=\'text/javascript\'>\r\n            googletag.cmd.push(function() { googletag.display(\'div-gpt-ad-1325985846574-0\'); });\r\n            </script>\r\n            </div>\r\n            <!--\r\n            <iframe width="100%" height="100%" src="/ad/home-top.html" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>\r\n            -->\r\n        </div>\r\n        \r\n        ')
        # SOURCE LINE 49
        from zuan.controllers.flash_game import GROUP_INFO 
        
        __M_writer(u'\r\n')
        # SOURCE LINE 50
        for info in GROUP_INFO:
            # SOURCE LINE 51
            __M_writer(u'        <div class="table" style="border-bottom: dotted 1px #999;">\r\n            <div class="row">\r\n                <div class="col">\r\n                    ')
            # SOURCE LINE 54
            __M_writer(escape(info[1]))
            __M_writer(u'\r\n                </div>\r\n                <div class="col">\r\n                    <a href="')
            # SOURCE LINE 57
            __M_writer(escape(h.static_flash_game_group_url(info[0], 1)))
            __M_writer(u'" title="')
            __M_writer(escape(info[1]))
            __M_writer(u'">\u66f4\u591a\u7cbe\u5f69')
            __M_writer(escape(info[1]))
            __M_writer(u'\u5c0f\u6e38\u620f...</a>\r\n                </div>\r\n            </div>\r\n        </div>\r\n        \r\n        ')
            # SOURCE LINE 62
            __M_writer(escape(flash_game.get_list(c.fgs[info[0]], show_header=False, show_footer=False)))
            __M_writer(u'\r\n')
            pass
        # SOURCE LINE 64
        __M_writer(u'    </div>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_ad_head(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 4
        __M_writer(u"\r\n<script type='text/javascript'>\r\nvar googletag = googletag || {};\r\ngoogletag.cmd = googletag.cmd || [];\r\n(function() {\r\nvar gads = document.createElement('script');\r\ngads.async = true;\r\ngads.type = 'text/javascript';\r\nvar useSSL = 'https:' == document.location.protocol;\r\ngads.src = (useSSL ? 'https:' : 'http:') + \r\n'//www.googletagservices.com/tag/js/gpt.js';\r\nvar node = document.getElementsByTagName('script')[0];\r\nnode.parentNode.insertBefore(gads, node);\r\n})();\r\n</script>\r\n\r\n<script type='text/javascript'>\r\ngoogletag.cmd.push(function() {\r\ngoogletag.defineSlot('/13427485/88zuan_\u9996\u9875_728_90', [728, 90], 'div-gpt-ad-1325985846574-0').addService(googletag.pubads());\r\ngoogletag.pubads().enableSingleRequest();\r\ngoogletag.enableServices();\r\n});\r\n</script>\r\n")
        return ''
    finally:
        context.caller_stack._pop_frame()


