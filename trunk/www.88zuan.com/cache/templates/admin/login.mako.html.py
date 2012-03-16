# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329912521.39486
_template_filename = '/root/sites/www.88zuan.com/app/zuan/templates/admin/login.mako.html'
_template_uri = '/admin/login.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_content']


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
    return runtime._inherit_from(context, u'/admin/base.mako.html', _template_uri)
def render_body(context,**pageargs):
    context.caller_stack._push_frame()
    try:
        __M_locals = __M_dict_builtin(pageargs=pageargs)
        __M_writer = context.writer()
        # SOURCE LINE 2
        __M_writer(u'\r\n')
        # SOURCE LINE 3
        __M_writer(u'\r\n\r\n\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_content(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 6
        __M_writer(u'\r\n')
        # SOURCE LINE 7
        if c.reason:
            # SOURCE LINE 8
            __M_writer(u'    <div style="color:#FF6666; width: 300px; font-size: 16px; margin: 0 auto 10px;">\u9519\u8bef\u63d0\u793a\uff1a')
            __M_writer(escape(c.reason))
            __M_writer(u'</div>\r\n')
            pass
        # SOURCE LINE 10
        __M_writer(u'<form action="/admin/do_login" method="post">\r\n<table width="300px" height="50px" style="margin: 0 auto;">\r\n\t<tr>\r\n    \t<td>\u7528\u6237\u540d\uff1a</td>\r\n        <td><input class="text" name="username" type="text" value=""/></td>\r\n    </tr>\r\n\t<tr>\r\n    \t<td>\u5bc6\u7801\uff1a</td>\r\n        <td><input class="text" name="passwd" type="password" value="" /></td>\r\n\t</tr>\r\n\t<tr>\r\n    \t<td></td>\r\n        <td><input type="submit" value="\u767b \u5f55" /></td>\r\n    </tr>\r\n</table>\r\n</form>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


