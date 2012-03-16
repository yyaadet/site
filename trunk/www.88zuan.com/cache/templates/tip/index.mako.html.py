# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329903439.0904729
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/tip/index.mako.html'
_template_uri = '/tip/index.mako.html'
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
        # SOURCE LINE 25
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 9
        __M_writer(u'\r\n\r\n<div id="content">\r\n    <div id="content_left">\r\n    </div>\r\n    <div id="content_right">\r\n             \r\n        <!-- tips -->\r\n        <div class="table" style="border: solid 1px #ccc; margin-left: 10px;">\r\n            \t<div class="row" style="color: red; height: 40px;">\r\n                \t<h1>')
        # SOURCE LINE 19
        __M_writer(escape(c.tip))
        __M_writer(u'</h1>\r\n                </div>\r\n         </div>\r\n                \r\n    </div>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_title(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 7
        __M_writer(u'\u4e13\u6ce8\u7684\u5c0f\u6e38\u620f\u7f51\u7ad9')
        return ''
    finally:
        context.caller_stack._pop_frame()


