# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 7
_modified_time = 1329894889.765209
_template_filename = u'/root/sites/www.88zuan.com/app/zuan/templates/flash_game/func.mako.html'
_template_uri = u'/flash_game/func.mako.html'
_source_encoding = 'utf-8'
from webhelpers.html import escape
_exports = ['get_group', 'get_list', 'get_top_ads', 'get_big_ads', 'get_matrix_ads', 'get_left_rank_list']


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
        # SOURCE LINE 17
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 54
        __M_writer(u'\r\n\r\n\r\n')
        # SOURCE LINE 129
        __M_writer(u'\r\n\r\n\r\n')
        # SOURCE LINE 136
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 150
        __M_writer(u'\r\n\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_group(context,id):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 5
        __M_writer(u'\r\n')
        # SOURCE LINE 6

        from zuan.controllers.flash_game import GROUP_INFO
        
        
        # SOURCE LINE 8
        __M_writer(u'\r\n')
        # SOURCE LINE 9
        for item in GROUP_INFO:
            # SOURCE LINE 10
            if id != item[0]:
                # SOURCE LINE 11
                __M_writer(u'\t<input type="radio" name="group" value="')
                __M_writer(escape(item[0]))
                __M_writer(u'" />\r\n')
                # SOURCE LINE 12
            else:
                # SOURCE LINE 13
                __M_writer(u'    <input type="radio" name="group" value="')
                __M_writer(escape(item[0]))
                __M_writer(u'" checked="checked" />\r\n')
                pass
            # SOURCE LINE 15
            __M_writer(u'<label>')
            __M_writer(escape(item[1]))
            __M_writer(u'</label>\r\n')
            pass
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_list(context,objs,start_page=1,page=1,end_page=1,group_id=0,show_header=True,show_footer=True):
    context.caller_stack._push_frame()
    try:
        h = context.get('h', UNDEFINED)
        c = context.get('c', UNDEFINED)
        range = context.get('range', UNDEFINED)
        len = context.get('len', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 57
        __M_writer(u'\r\n    ')
        # SOURCE LINE 58

        from zuan.controllers.flash_game import get_flash_game_pic_url, get_group
        from zuan.controllers.flash_game import GROUP_INFO
        
        
        # SOURCE LINE 61
        __M_writer(u'\r\n')
        # SOURCE LINE 62
        if show_header:
            # SOURCE LINE 63
            __M_writer(u'   <div class="table" style="height: 115px; border-bottom: solid 1px #ccc;">\r\n        <div class="row">\r\n            <div class="col">\r\n')
            # SOURCE LINE 66
            for i in range(len(GROUP_INFO)):
                # SOURCE LINE 67
                __M_writer(u'                <a href="')
                __M_writer(escape(h.static_flash_game_group_url(GROUP_INFO[i][0], 1)))
                __M_writer(u'" title="')
                __M_writer(escape(GROUP_INFO[i][1]))
                __M_writer(u'">\r\n')
                # SOURCE LINE 68
                if group_id == GROUP_INFO[i][0]:
                    # SOURCE LINE 69
                    __M_writer(u'                        <strong>')
                    __M_writer(escape(GROUP_INFO[i][1]))
                    __M_writer(u'\u5c0f\u6e38\u620f</strong>\r\n')
                    # SOURCE LINE 70
                else:
                    # SOURCE LINE 71
                    __M_writer(u'                        ')
                    __M_writer(escape(GROUP_INFO[i][1]))
                    __M_writer(u'\u5c0f\u6e38\u620f\r\n')
                    pass
                # SOURCE LINE 73
                __M_writer(u'                </a> | \r\n')
                pass
            # SOURCE LINE 75
            __M_writer(u'           </div>\r\n        </div>\r\n   </div>\r\n')
            pass
        # SOURCE LINE 79
        __M_writer(u'\r\n    ')
        # SOURCE LINE 80
        i = 0 
        
        __M_writer(u'\r\n')
        # SOURCE LINE 81
        while i < len(objs):
            # SOURCE LINE 82
            __M_writer(u'\r\n    <div class="table">\r\n        <div class="row" style="line-height: 20px;">\r\n')
            # SOURCE LINE 85
            for j in range(3):
                # SOURCE LINE 86
                __M_writer(u'            ')

                if i >= len(objs):
                    break
                obj = objs[i]
                pic_url = get_flash_game_pic_url(obj, c.setting)
                
                
                # SOURCE LINE 91
                __M_writer(u'\r\n            <div class="col" style="width: 80px;">\r\n                <div class="col_line">\r\n                    <a href="')
                # SOURCE LINE 94
                __M_writer(escape(h.static_flash_game_detail_url(obj._id)))
                __M_writer(u'" target="_blank"><img border="0" class="fg_logo" src="')
                __M_writer(escape(pic_url))
                __M_writer(u'" align="middle" alt="')
                __M_writer(escape(obj.name))
                __M_writer(u'" /></a>\r\n                </div>\r\n            </div>\r\n            <div class="col" style="width: 144px">\r\n                <!--<div class="col_line">\u3010')
                # SOURCE LINE 98
                __M_writer(escape(get_group(obj.group_id)[1]))
                __M_writer(u'\u5c0f\u6e38\u620f\u3011</div> -->\r\n                <div class="col_line" style="font-size: 1.2em;">')
                # SOURCE LINE 99
                __M_writer(escape(h.short_text(obj.name, 15)))
                __M_writer(u'</div>\r\n                <div class="col_line tip_text">\u4eba\u6c14\uff1a')
                # SOURCE LINE 100
                __M_writer(escape(obj.total_play))
                __M_writer(u'</div>\r\n                <div class="col_line tip_text">\u5927\u5c0f\uff1a')
                # SOURCE LINE 101
                __M_writer(escape(h.fmt_file_size(obj.file_size)))
                __M_writer(u'</div>\r\n            </div>\r\n            ')
                # SOURCE LINE 103
                i += 1
                
                __M_writer(u'\r\n')
                pass
            # SOURCE LINE 105
            __M_writer(u'        </div>\r\n        <div class="interval"></div>\r\n    </div>\r\n')
            pass
        # SOURCE LINE 109
        __M_writer(u'\r\n')
        # SOURCE LINE 110
        if show_footer:
            # SOURCE LINE 111
            __M_writer(u'    <div class="table">\r\n        <div class="row">\r\n')
            # SOURCE LINE 113
            if c.start_page != 1:
                # SOURCE LINE 114
                __M_writer(u'            <div class="col" style="width: 50px;"><a href="')
                __M_writer(escape(h.static_flash_game_group_url(group_id, start_page - 1)))
                __M_writer(u'">\u4e0a\u4e00\u9875</a></div>\r\n')
                pass
            # SOURCE LINE 116
            for i in range(start_page, end_page + 1):
                # SOURCE LINE 117
                __M_writer(u'            <div class="col" style="min-width: 0;width: 20px;">\r\n')
                # SOURCE LINE 118
                if i == page:
                    # SOURCE LINE 119
                    __M_writer(u'                <strong><a href="')
                    __M_writer(escape(h.static_flash_game_group_url(group_id, i)))
                    __M_writer(u'">[')
                    __M_writer(escape(i))
                    __M_writer(u']</a></strong>\r\n')
                    # SOURCE LINE 120
                else:
                    # SOURCE LINE 121
                    __M_writer(u'                <a href="')
                    __M_writer(escape(h.static_flash_game_group_url(group_id, i)))
                    __M_writer(u'">')
                    __M_writer(escape(i))
                    __M_writer(u'</a>\r\n')
                    pass
                # SOURCE LINE 123
                __M_writer(u'            </div>\r\n')
                pass
            # SOURCE LINE 125
            __M_writer(u'            <div class="col" style="width: 50px;"><a href="')
            __M_writer(escape(h.static_flash_game_group_url(group_id, end_page + 1)))
            __M_writer(u'">\u4e0b\u4e00\u9875</a></div>\r\n        </div>\r\n    </div>\r\n')
            pass
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_top_ads(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 132
        __M_writer(u'\r\n<div class="table" style="height: 90px; overflow:hidden; margin-left: 5px;">\r\n    <iframe width="100%" height="100%" src="/ad/bu_top.html" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>\r\n</div>\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_big_ads(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 138
        __M_writer(u'\r\n<!-- bd ads -->\r\n<div class="table" style="height: 250px; overflow:hidden;">\r\n  <iframe width="100%" height="100%" src="/ad/bd_right.html" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>\r\n</div>\r\n<!-- end -->\r\n\r\n<!-- google ads -->\r\n<div class="table" style="height: 250px; overflow:hidden;">\r\n  <iframe width="100%" height="100%" src="/ad/gg_right.html" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>\r\n</div>\r\n<!-- end -->\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_matrix_ads(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 152
        __M_writer(u'\r\n')
        # SOURCE LINE 153

        import random
        r = random.randint(0, 1)
        bd_style = ""
        gg_style=""
        if r == 0:
            bd_style="hidden"
        else:
            gg_style="hidden"
        
        
        # SOURCE LINE 162
        __M_writer(u'\r\n<!-- bd ads -->\r\n<div class="table ')
        # SOURCE LINE 164
        __M_writer(escape(bd_style))
        __M_writer(u'" style="height: 250px; overflow:hidden;">\r\n  <iframe width="100%" height="100%" src="/ad/bd_right.html" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>\r\n</div>\r\n<!-- end -->\r\n\r\n<!-- google ads -->\r\n<div class="table ')
        # SOURCE LINE 170
        __M_writer(escape(gg_style))
        __M_writer(u'" style="height: 250px; overflow:hidden;">\r\n  <iframe width="100%" height="100%" src="/ad/gg_right.html" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>\r\n</div>\r\n<!-- end -->\r\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_get_left_rank_list(context,group_id=0):
    context.caller_stack._push_frame()
    try:
        h = context.get('h', UNDEFINED)
        c = context.get('c', UNDEFINED)
        round = context.get('round', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 19
        __M_writer(u'\r\n    ')
        # SOURCE LINE 20

        from zuan.model.flash_game import FlashGame
        from zuan.controllers.flash_game import get_flash_game_pic_url, get_group
        import pymongo
        
        fgs = []
        if not group_id:
            fgs = FlashGame.query({}, limit=80, sort=[('score', pymongo.DESCENDING)])
        else:
            fgs = FlashGame.query({"group_id": group_id}, limit=20, sort=[('score', pymongo.DESCENDING)])
           
        
        # SOURCE LINE 30
        __M_writer(u'\r\n\r\n')
        # SOURCE LINE 32
        for obj in fgs:
            # SOURCE LINE 33
            __M_writer(u'    ')

            pic_url = get_flash_game_pic_url(obj, c.setting)
            
            
            # SOURCE LINE 35
            __M_writer(u'\r\n    <div class="table">\r\n        <div class="row" style="line-height: 22px;">\r\n            <div class="col" style="width: 80px;">\r\n                <div class="col_line">\r\n                    <a href="')
            # SOURCE LINE 40
            __M_writer(escape(h.static_flash_game_detail_url(obj._id)))
            __M_writer(u'"><img border="0" class="fg_logo" src="')
            __M_writer(escape(pic_url))
            __M_writer(u'" align="middle" alt="')
            __M_writer(escape(obj.name))
            __M_writer(u'" /></a>\r\n                </div>\r\n            </div>\r\n            <div class="col" style="width: 130px">\r\n                <!--<div class="col_line">\u3010')
            # SOURCE LINE 44
            __M_writer(escape(get_group(obj.group_id)[1]))
            __M_writer(u'\u5c0f\u6e38\u620f\u3011</div>-->\r\n                <div class="col_line">')
            # SOURCE LINE 45
            __M_writer(escape(h.short_text(obj.name, 10)))
            __M_writer(u'</div>\r\n                <div class="col_line tip_text">\u4eba\u6c14\uff1a')
            # SOURCE LINE 46
            __M_writer(escape(obj.total_play))
            __M_writer(u'</div>\r\n                <div class="col_line tip_text">\u5f97\u5206\uff1a')
            # SOURCE LINE 47
            __M_writer(escape(round(obj.score, 2)))
            __M_writer(u'</div>\r\n                <!--<div class="col_line tip_text">\u5927\u5c0f\uff1a')
            # SOURCE LINE 48
            __M_writer(escape(h.fmt_file_size(obj.file_size)))
            __M_writer(u'</div>-->\r\n            </div>\r\n        </div>\r\n        <div class="interval"></div>\r\n    </div>\r\n')
            pass
        return ''
    finally:
        context.caller_stack._pop_frame()


