#coding=utf-8

"""Helper functions

Consists of functions to typically be used within templates, but also
available to Controllers. This module is available to templates as 'h'.
"""
# Import helpers as desired, or define your own, ie:
#from webhelpers.html.tags import checkbox, password
from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect
from zuan.model.all_table import *
from zuan.controllers.flash_game import *
from zuan.lib.helpers import *


import time
import urllib
import re
import random
import os
from xml.dom.minidom import Document
from smtplib import SMTP
from email.MIMEText import MIMEText
from email.Header import Header
from email.Utils import parseaddr, formataddr
import threading


 
def move_old_flash():
    setting = Setting.get()
    objs = FlashGame.get_all()
    for obj in objs:
        if obj.file_path:
            new_path = get_flash_game_path(setting, obj.id)
            if new_path == obj.file_path:
                continue
            tail = get_file_tail(obj.file_path)
            try:
                if os.path.exists(obj.file_path) and (not os.path.exists(new_path)):
                    shutil.move(obj.file_path, new_path)
                    obj.file_path = new_path
                if tail == '':
                    disk_files = glob.glob(obj.file_path + "*")
                    print disk_files
                    if len(disk_files) == 1:
                        obj.file_path = disk_files[0]
                obj.save()
            except Exception, e:
                print e
        
        if obj.pic_path:    
            tail = get_file_tail(obj.pic_path)
            if not tail:
                disk_files = glob.glob(obj.pic_path + "*")
                print disk_files
                if len(disk_files) == 1:
                     obj.pic_path = disk_files[0]
                     tail = get_file_tail(obj.pic_path)
                     obj.save()
            new_pic_path = get_flash_game_pic_path(setting, obj.id, tail)
            if new_pic_path == obj.pic_path:
                continue
            try:
                shutil.move(obj.pic_path, new_pic_path)
                obj.pic_path = new_pic_path
                obj.save()
            except Exception, e:
                print e
                
        break
        
def resize_all_img():
    setting = Setting.get()
    offset = 0
    num = 50
    while True:
        objs = FlashGame.get_cond('').slice(offset, offset + num).all()
        if not objs:
            break
        offset += num
        print offset
        for fg in objs:
            try:
                path = fg.pic_path
                if not os.path.exists(path):
                    pass
                im = Image.open(path)
                if im.size != BIG_IMG_SIZE:
                    resize_img(path, path, BIG_IMG_SIZE)
                    
                small_path = get_flash_game_small_pic_path(setting, fg.id, get_file_tail(fg.pic_path)) 
                if not os.path.exists(small_path):
                    resize_img(path, small_path, SMALL_IMG_SIZE)
                im = Image.open(small_path)
                if im.size != SMALL_IMG_SIZE:
                    resize_img(small_path, small_path, SMALL_IMG_SIZE)
            except Exception, e:
                print e
            
def move_to_mongodb():
    #move admin
    old_objs = AdminMysql.query(None)
    for obj in old_objs:
        new_obj = Admin.new_obj()
        new_obj.name = obj.name
        new_obj.password = obj.password
        Admin.put_data(new_obj)
    #move friendlink
    old_objs = FriendlinkMysql.query(None)
    for obj in old_objs:
        new_obj = Friendlink.new_obj()
        new_obj.name = obj.name
        new_obj.url = obj.url
        new_obj.is_in_home = obj.is_in_home
        new_obj.add_timestamp = obj.add_timestamp
        Friendlink.put_data(new_obj)
    #move setting
    obj = SettingMysql.get()
    new_obj = Setting.new_obj()
    new_obj.upload_dir = obj.upload_dir
    new_obj.static_addr = obj.static_addr
    new_obj.is_use_static_url = obj.is_use_static_url
    new_obj.seo_title = obj.seo_title
    new_obj.seo_desc = obj.seo_desc
    new_obj.seo_keywords = obj.seo_keywords
    Setting.put_data(new_obj)
