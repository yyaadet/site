#coding=utf-8
"""The application's model objects"""
import sqlalchemy as sa
from sqlalchemy import orm
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import *
from sqlalchemy.dialects import mysql
from sqlalchemy import engine_from_config
import pymongo
import bson

from zuan.model import cache
from zuan.lib.utils import *

import time
import hashlib
import random
import types

MAX_TABLE_NUM=16

_master_meta = MetaData()
_master_engine = None
#memcache instance
_mc = None

_mongo_conn  = None

def init_model(config = None):
    #init mongo connection
    _mongo_conn = pymongo.Connection(config['mongo'])
    MongoModel.configure(_mongo_conn, int(config['mongo.w']))
        
#mongo db interface
class MongoModel(object):
    doc_name = ""
    db_name = "zuan"
    use_time_db = False #use $(db_name)_$year as real db name
    props = {} #field define
    _db = None
    _collection = None
    _conn = None
    _w = 1
    _safe = False
        
    @classmethod
    def configure(cls, conn, w):
        cls._conn = conn
        cls._w = w
        
    @classmethod
    def get_data(cls, id):
        result = None
        try:
            result = cls.get_collection().find_one(bson.objectid.ObjectId(str(id)))
        except Exception, e:
            print e
        if not result:
            return None
        return cls.new_obj(result)
    
    @classmethod
    def put_data(cls, data):
        if '_id' in data and isinstance(data._id, types.StringTypes):
            data._id = bson.objectid.ObjectId(data._id)
        result = cls.get_collection().save(data, safe = cls._safe, w=cls._w)
        #check index
        cls.ensure_index()
        data._id = str(data._id)
        return data
    
    @classmethod
    def rem_data(cls, data):
        if isinstance(data, types.ListType):
            for obj in data:
                cls.get_collection().remove(bson.objectid.ObjectId(str(obj._id)))
        else:
            cls.get_collection().remove(bson.objectid.ObjectId(str(data._id)))
    
    @classmethod
    def query(cls, cond = {}, skip = 0, limit=0, sort=None):
        result = cls.get_collection().find(cond, skip = skip, limit = limit, sort = sort)
        return cls.to_storage(result)
    
    @classmethod
    def query_num(cls, cond = {}, skip = 0, limit=0, sort=None):
        result = cls.get_collection().find(cond, skip = skip, limit = limit, sort = sort).count()
        return result

    @classmethod
    def to_storage(cls, result):
        data = []
        for r in result:
            r  = cls.new_obj(r)
            data.append(r)
        return data

    @classmethod
    def get_collection(cls):
        now = time.time()
        year = time.localtime(now)[0]
        if not cls.use_time_db:
            cls._db = cls._conn[cls.db_name]
            cls._collection = cls._db[cls.doc_name]
        else:
            cls._db = cls._conn["%s_%s" % (cls.db_name, year)]
            cls._collection = cls._db[cls.doc_name]
        return cls._collection
        
    @classmethod
    def new_obj(cls, old_obj = {}):
        obj = Storage()
        #remove unexists prop
        for name, value in old_obj.iteritems():
            if name in cls.props or name == "_id":
                obj[name] = value
        #add new prop
        for name, info in cls.props.iteritems():
            if name in old_obj:
                continue
            obj[name] = info['default']
        #handle _id
        if '_id' in obj:
            obj._id = str(obj._id)
        return obj
        
    @classmethod
    def ensure_index(cls):
        indexes = []
        for name, info in cls.props.iteritems():
            sort = None
            if info['sort'] == 'asc':
                sort = pymongo.ASCENDING
            elif info['sort'] == 'desc':
                sort = pymongo.DESCENDING
            else:
                continue
            indexes.append((name, sort))
        if indexes:
            cls.get_collection().ensure_index(indexes)
