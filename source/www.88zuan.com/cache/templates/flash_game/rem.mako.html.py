# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1330204595.8427751
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/flash_game/rem.mako.html'
_template_uri = '/flash_game/rem.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_content', 'get_title']


def _mako_get_namespace(context, name):
    try:
        return context.namespaces[(__name__, name)]
    except KeyError:
        _mako_generate_namespaces(context)
        return context.namespaces[(__name__, name)]
def _mako_generate_namespaces(context):
    pass
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
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 5
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 24
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 7
        __M_writer(u'\r\n<div id="content">\r\n    <div id="content_left">\r\n    \t\r\n    </div>\r\n    <div id="content_right">\r\n        <div class="table">\r\n            <div class="row">\r\n                <div class="col"> \u771f\u7684\u8981\u5220\u9664\u6e38\u620f\uff1a')
        # SOURCE LINE 15
        __M_writer(escape(c.fg_id))
        __M_writer(u'\uff1f</div>\r\n                <div class="col">\r\n                    <a href="/admin/flash_game_rem?id=')
        # SOURCE LINE 17
        __M_writer(escape(c.fg_id))
        __M_writer(u'">\u786e\u8ba4\u5220\u9664</a>\r\n                </div>\r\n            </div>\r\n        </div>\r\n    <!-- right -->\r\n</div>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_title(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 5
        __M_writer(u'\u5220\u9664\u786e\u8ba4')
        return ''
    finally:
        context.caller_stack._pop_frame()


