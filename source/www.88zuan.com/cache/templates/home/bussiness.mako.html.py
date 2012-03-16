# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329911131.402777
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/home/bussiness.mako.html'
_template_uri = '/home/bussiness.mako.html'
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
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 6
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 23
        __M_writer(u'\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 8
        __M_writer(u'\r\n<div id="content">\r\n\r\n<div id="content_left">\r\n    <strong>\u5546\u52a1\u5408\u4f5c</strong>\r\n</div>\r\n<div id="content_right">\r\n   <div class="table" style="margin-left: 10px;">\r\n   \t\t<div class="row" style="height: 26px;">\u5e7f\u544a\u4e1a\u52a1\uff1a</div>\r\n        <div class="row" style="height: 26px;">Email\uff1a1134362918@qq.com; QQ: 1134362918;</div>\r\n        <div class="row" style="height: 26px;">\u7f51\u9875\u6e38\u620f\u6df7\u670d\uff1a</div>\r\n        <div class="row" style="height: 26px;">Email\uff1a1134362918@qq.com; QQ: 1134362918;</div>\r\n   </div>\r\n</div>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_title(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 4
        __M_writer(u'\r\n\u5546\u52a1\u5408\u4f5c\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


