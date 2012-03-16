# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329894949.6347201
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/flash_game/play.mako.html'
_template_uri = '/flash_game/play.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_description', 'get_content', 'get_title']


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
        # SOURCE LINE 110
        __M_writer(u'\r\n')
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
        __M_writer(u'\t')
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
        # SOURCE LINE 10
        __M_writer(u'\r\n')
        # SOURCE LINE 11

        from zuan.lib.helpers import fmt_time
        from zuan.lib.helpers import short_text
        from zuan.lib.helpers import static_flash_game_detail_url
        from zuan.controllers.flash_game import get_flash_game_pic_url
        from zuan.controllers.flash_game import get_flash_game_file_url
        from zuan.controllers.flash_game import get_group
        
        group = get_group(c.fg.group_id)
        
        
        # SOURCE LINE 20
        __M_writer(u'\r\n\r\n<script type="text/javascript">\r\nfunction fullscreen(id)\r\n{\r\n    window.open("/flash_game/show?id="+id, "", "fullscreen=1, menubar=no, toolbar=no, status=no, scrollbars=no, location=no, resizable=no");\r\n}\r\n\r\nfunction screen(id, width, height)\r\n{\r\n    window.open("/flash_game/show?id="+id+"&width="+width+"&height="+height, "", "fullscreen=1, menubar=no, toolbar=no, status=no, scrollbars=no, location=no, resizable=no");\r\n}\r\n\r\n\r\n</script>\r\n\r\n<div id="content">\r\n    <div id="content_left">\r\n    \t')
        # SOURCE LINE 38
        __M_writer(escape(flash_game.get_left_rank_list(c.fg.group_id)))
        __M_writer(u'\r\n    </div>\r\n    <div id="content_right">\r\n        <div class="table" style="margin-left: 5px; border: dotted 1px green; height: 500px;">\r\n            <iframe width="100%" height="100%" src="/flash_game/show?id=')
        # SOURCE LINE 42
        __M_writer(escape(c.fg._id))
        __M_writer(u'&height=500&width=700" scrolling="no" frameborder="0"></iframe>\r\n        </div>\r\n\r\n        <!-- end -->\r\n      <div class="table" style="margin-left: 5px;">\r\n          <div class="row">\r\n              <div class="col">\r\n                    <input value="\u5168\u5c4f\u6e38\u620f" onclick="fullscreen(\'')
        # SOURCE LINE 49
        __M_writer(escape(c.fg._id))
        __M_writer(u'\')" type="button" style="width: auto; height: 35px;" />\r\n              </div>\r\n              <div class="col">\r\n                    <input value="1024*768" onclick="screen(\'')
        # SOURCE LINE 52
        __M_writer(escape(c.fg._id))
        __M_writer(u'\', 800, 600)" type="button" style="width: auto; height: 35px;" />\r\n              </div>\r\n              <div class="col">\r\n                    <input value="1440*900" onclick="screen(\'')
        # SOURCE LINE 55
        __M_writer(escape(c.fg._id))
        __M_writer(u'\', 1000, 800)" type="button" style="width: auto; height: 35px;" />\r\n              </div>\r\n              <div class="col">\r\n                    <!-- JiaThis Button BEGIN -->\r\n                    <script type="text/javascript">\r\n\t\t\t\t\tvar jiathis_config = {\r\n\t\t\t\t\t\tshareImg:{\r\n\t\t\t\t\t\t\t"showType":"ALL",\r\n\t\t\t\t\t\t\t"bgColor":"",\r\n\t\t\t\t\t\t\t"txtColor":"",\r\n\t\t\t\t\t\t\t"text":"",\r\n\t\t\t\t\t\t\t"services":"",\r\n\t\t\t\t\t\t\t"position":"",\r\n\t\t\t\t\t\t\t"imgwidth":"",\r\n\t\t\t\t\t\t\t"imgheight":"",\r\n\t\t\t\t\t\t\t"divname":""\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t}\r\n\t\t\t\t\t</script>\r\n                    <div id="jiathis_style_32x32">\r\n                        <a class="jiathis_button_qzone"></a>\r\n                        <a class="jiathis_button_tsina"></a>\r\n                        <a class="jiathis_button_tqq"></a>\r\n                        <a class="jiathis_button_renren"></a>\r\n                        <a class="jiathis_button_kaixin001"></a>\r\n                        <a href="http://www.jiathis.com/share?uid=1501989" class="jiathis jiathis_txt jtico jtico_jiathis" target="_blank"></a>\r\n                        <a class="jiathis_counter_style"></a>\r\n                    </div>\r\n                    <script type="text/javascript">var jiathis_config = {data_track_clickback:true};</script>\r\n                    <script type="text/javascript" src="http://v2.jiathis.com/code/jia.js?uid=1501989" charset="utf-8"></script>\r\n                    <!-- JiaThis Button END -->\r\n               </div>\r\n          </div>\r\n\r\n      </div>\r\n           \r\n     <div class="table" style="margin-left: 5px;">\r\n         <div class="row" style="border-bottom: dotted 1px #ccc;">\r\n              <strong><a href="')
        # SOURCE LINE 93
        __M_writer(escape(h.static_flash_game_detail_url(c.fg._id)))
        __M_writer(u'">')
        __M_writer(escape(c.fg.name))
        __M_writer(u'</a> \u6e38\u620f\u4ecb\u7ecd</strong>\r\n          </div>\r\n          <div class="row">\r\n            <p>')
        # SOURCE LINE 96
        __M_writer(escape(c.fg.info))
        __M_writer(u'</p>\r\n          </div>\r\n        <div class="row" style="border-bottom: dotted 1px #ccc;"><strong>\u64cd\u4f5c\u8bf4\u660e</strong></div>\r\n        <div class="row">\r\n        \t<p>')
        # SOURCE LINE 100
        __M_writer(escape(c.fg.operate_info))
        __M_writer(u'</p>\r\n\t    </div>\r\n        <!-- PingLun.La Begin -->\r\n\t\t<div id="pinglunla_here"></div><a href="http://pinglun.la/" id="logo-pinglunla">\u8bc4\u8bba\u5566</a><script type="text/javascript" src="http://static.pinglun.la/md/pinglun.la.js" charset="utf-8"></script>\r\n\t\t<!-- PingLun.La End -->\r\n     </div>\r\n           \r\n    </div>\r\n</div>\r\n\r\n')
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


