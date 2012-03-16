#coding=utf-8
"""The application's model objects"""
import pymongo
import bson

from feed.lib.utils import *

import time
import hashlib
import random
import types


def init_model(config = None):
    _mongo_conn = pymongo.Connection(config['mongo'])
    w = 1
    if 'mongo.w' in config:
        w = int(config['mongo.w'])
    MongoModel.configure(_mongo_conn, w)
        
#mongo db interface
class MongoModel(object):
    doc_name = ""
    db_name = ""
    props = {} #field define
    _db = None
    _collection = None
    _conn = None
    _db_prefix = "feed_"
    _w = 1
        
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
        result = cls.get_collection().save(data, safe=True, w = cls._w)
        #check index
        cls.ensure_index()
        data._id = unicode(str(data._id), "utf-8")
        return data
    
    @classmethod
    def rem_data(cls, data):
        if isinstance(data, types.ListType):
            for obj in data:
                cls.get_collection().remove(bson.objectid.ObjectId(str(obj._id)))
        else:
            cls.get_collection().remove(bson.objectid.ObjectId(str(data._id)))
    
    @classmethod
    def update(cls, spec = {}, doc={}, multi = False):
        cls.get_collection().update(spec, doc, multi = multi, w = cls._w)
    
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
            obj  = cls.new_obj(r)
            data.append(obj)
        return data

    @classmethod
    def get_collection(cls):
        cls._db = cls._conn["%s%s" % (cls._db_prefix, cls.db_name)]
        cls._collection = cls._db[cls.doc_name]
        return cls._collection
        
    @classmethod
    def new_obj(cls, old_obj = {}):
        obj = Storage()
        #remove unexists prop
        for name, value in old_obj.iteritems():
            if type(value) == bson.objectid.ObjectId:
                value = unicode(str(value), "utf-8")
            if name in cls.props or name == "_id":
                obj[name] = value
        #add new prop
        for name, info in cls.props.iteritems():
            if name in old_obj:
                continue
            obj[name] = info['default']
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
        if len(indexes) > 0:
            cls.get_collection().ensure_index(indexes)