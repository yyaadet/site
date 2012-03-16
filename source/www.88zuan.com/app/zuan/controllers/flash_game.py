#coding=utf-8

import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from pylons.decorators import *
from pylons.decorators.cache import beaker_cache

from zuan.lib.base import BaseController, render
from zuan.lib.helpers import *
from zuan.lib.utils import *
from zuan.lib.query_ip import *
from zuan.model.all_table import *

import md5
import os
import shutil
import glob
from PIL import Image
import pymongo

log = logging.getLogger(__name__)

SMALL_IMG_SIZE = (90, 70)
BIG_IMG_SIZE = (360, 260)
LOG_PLAY_INTERVAL = 10

GROUP_INFO = [
    	        [1, u'动作'],
    		[2, u'休闲'],
                [3, u'益智'],
                [4, u'冒险'],
                [5, u'体育'],
                [6, u'角色'],
                [7, u'战争'],
                [8, u'美女'],
                [9, u'棋牌'],
                [10, u'射击'],
                [11, u'运动'],
                [12, u'竞赛'],
                [13, u'儿童'],
                [14, u'经典'],
                [15, u'技能'],
                [16, u'多人'],
                [17, u'台球'],
                [18, u'做饭'],
                [19, u'越狱'],
                [20, u'足球'],
                [21, u'化妆'],
                [22, u'玛丽'],
                [23, u'迷你'],
                [24, u'音乐'],
                [25, u'画画'],
                [26, u'塔防'],
                [27, u"字谜"],
                [28, u"教育"],
                [29, u"拼图"],
                [30, u"策略"],
                [31, u"驾驶"],
             ]
             
def get_group(id):
    for item in GROUP_INFO:
        if item[0] == id:
            return item
    return None

#########################################
# 获取路径
#########################################    
def get_flash_game_path(setting, id, tail):
    updir = _get_flash_game_dir(setting, id)
    hash = _get_hash(id)
    return os.path.join(setting.upload_dir, updir, "flash_game_%s.%s" % (hash, tail))
    
def get_flash_game_pic_path(setting, id, tail):
    hash = _get_hash(id)
    updir = _get_flash_game_dir(setting, id)
    return os.path.join(setting.upload_dir, updir, "flash_game_pic_%s.%s" % (hash, tail))
    
def get_flash_game_small_pic_path(setting, id, tail):
    hash = _get_hash(id)
    updir = _get_flash_game_dir(setting, id)
    return os.path.join(setting.upload_dir, updir, "small_flash_game_pic_%s.%s" % (hash, tail))

#########################################
# 获取url
#########################################    
def get_flash_game_file_url(fg, setting):
    updir = _get_flash_game_dir(setting, fg._id)
    url = setting.static_addr + "/" +  updir + "/" + os.path.basename(fg.file_path)
    url = url.replace("\\", '/')
    return url
    
def get_flash_game_pic_url(fg, setting, small=True):
    updir = _get_flash_game_dir(setting, fg._id)
    if not small:
        url = setting.static_addr + "/" + updir + "/" + os.path.basename(fg.pic_path)
    else:
        small_path = get_flash_game_small_pic_path(setting, fg._id, get_file_tail(fg.pic_path)) 
        if not os.path.exists(small_path):
            resize_img(fg.pic_path, small_path, SMALL_IMG_SIZE)
        url = setting.static_addr + "/" + updir + "/small_" + os.path.basename(fg.pic_path)
    url = url.replace("\\", '/')
    return url

#########################################
# 散列目录等内部函数
#########################################        
def _get_flash_game_dir(setting, id):
    '''新版本的flash存储路径
    '''
    dirno = _get_hash(id)[:2]
    path = os.path.join("flash_game", dirno)
    full_path = os.path.join(setting.upload_dir, path)
    if not os.path.isdir(full_path):
        os.makedirs(full_path)
    return path
    
def _get_hash(src):
    return md5.md5("%s" % src).hexdigest()
#########################################
# end
#########################################    

def delete_flash_game(id):
    obj = FlashGame.get_data(id)
    if not obj:
        return False
    if os.path.exists(obj.pic_path):
        os.remove(obj.pic_path)
    if os.path.exists(obj.file_path):
        os.remove(obj.file_path)
    small_pic = "small_" + obj.pic_path
    if os.path.exists(small_pic):
        os.remove(small_pic)
    FlashGame.rem_data(obj)
    return True

class FlashGameController(BaseController):
    def all(self):
        limit = 48
        page_num = 10
        cond = ""
        c.group_id = request.params.get('group_id')
        if c.group_id:
            c.group_id = int(c.group_id)
        else:
            c.group_id = 0
        
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)
            
        skip = (c.page - 1) * limit
        cond = {}
        if c.group_id:
            cond = {"group_id": c.group_id}

        c.fgs = FlashGame.query(cond, skip = skip, limit = limit, sort = [("score", pymongo.DESCENDING)])
        c.total_pages = FlashGame.query_num() / limit + 1
        
        c.start_page = int((c.page -1) / page_num) * page_num + 1
        
        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        
        return render('/flash_game/all.mako.html')
      
    def search(self):
        limit = 30
        page_num = 10
        c.query = request.params.get('query') 
        
        c.page = request.params.get('page')
        if not c.page:
            c.page = 1
        else :
            c.page = int(c.page)
        
        skip = (c.page - 1) * limit
        
        if c.query:
            #使用正则查询  
            q = '.*' + c.query.encode("utf-8") + '.*' 
            c.fgs = FlashGame.query({"name": {'$regex': q, "$options": 'i'}}, limit=limit, skip = skip)
            c.total_num = FlashGame.query_num({"name":  {'$regex': q, "$options": 'i'}})
        else:    
            c.fgs = []
            c.total_num = 0
        
        c.total_pages = c.total_num / limit + 1
        
        c.start_page = int((c.page -1) / page_num) * page_num + 1
        
        c.end_page = c.start_page + page_num + 1
        if c.end_page > c.total_pages:
            c.end_page = c.total_pages
        
        return render('/flash_game/search.mako.html')
            
    def detail(self):
        id = request.params.get('id')
        c.fg = FlashGame.get_data(id)
        if not c.fg:
            return goto_tip(u"该游戏不存在")
        if c.fg.file_path and c.fg.file_size == 0:
            try:
                c.fg.file_size = os.path.getsize(c.fg.file_path)
                FlashGame.put_data(c.fg)
            except Exception,e:
                print e
        return render('/flash_game/detail.mako.html')
        
    def play(self):
        id = request.params.get('id')
        c.fg = FlashGame.get_data(id)
        
        if not c.fg:
            return goto_tip(u'游戏不存在了')
              
        return render('/flash_game/play.mako.html')

    def show(self):
        id = request.params.get('id')
        c.width = request.params.get("width")
        if not c.width:
            c.width = "100%"
        c.height = request.params.get("height")
        if not c.height:
            c.height="100%"
        c.fg = FlashGame.get_data(id)

        if not c.fg:
            return goto_tip(u'游戏不存在了')

        return render('/flash_game/show.mako.html')
        
    @jsonify
    def playing(self):
        id = request.params.get('id')
        c.fg = FlashGame.get_data(id)
        
        if not c.fg:
            return {'code': 0, 'url': '', 'name': ''}

        city = get_ip_city(request.ip)
            
        c.fg.total_play += 1
        c.fg.last_play_timestamp = int(time.time())
        c.fg.last_play_ip = request.ip
        c.fg.last_play_city = city
        c.fg.score = calc_game_rank(c.fg)
        FlashGame.put_data(c.fg)
        return {'code': 1}
            
    @jsonify
    def log_play_time(self):
        id = request.params.get('id')
        c.fg = FlashGame.get_data(id)
        
        if not c.fg:
            return {'code': 0, 'url': '', 'name': ''}
            
        c.fg.total_play_time += LOG_PLAY_INTERVAL
        c.fg.score = calc_game_rank(c.fg)
        FlashGame.put_data(c.fg)
        return {'code': 1}

    def rem(self):
        c.fg_id = request.params.get("id")
        return render("/flash_game/rem.mako.html")
        