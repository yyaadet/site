import logging
import time

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from beaker.cache import cache_region
from pylons.decorators.cache import beaker_cache

from zuan.lib.base import BaseController, render
from zuan.lib.helpers import *
from zuan.model.all_table import *

import pymongo

log = logging.getLogger(__name__)

class ApiController(BaseController):
    def get_play_num(self):
        objs = FlashGame.query({})
        num = 0
        play_time = 0
        for obj in objs:
            num += obj.total_play
            play_time += obj.total_play_time
        ret = "<pre>\n"
        ret += "num:%d\n" % num
        ret += "time:%d\n" % play_time
        ret += "</pre>"
        return ret