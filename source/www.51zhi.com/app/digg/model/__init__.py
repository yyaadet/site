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
import memcache

from digg.lib.utils import *

import time
import hashlib
import random
import types

#memcachemodel object

def init_model(config = None):
    _mc = memcache.Client([config['memcached.url']], debug=0)
    _mc_timeout = int(config['memcached.timeout'])
    BaseModel.configure(_mc, _mc_timeout)
    #init memcached
    MemcacheModel.configure(_mc, "diggcache")
    #init mongo connection
    _mongo_conn = pymongo.Connection(config['mongo'])
    w = 1
    if 'mongo.w' in config:
        w = int(config['mongo.w'])
    MongoModel.configure(_mongo_conn, w)
    
def col_int(name = '', default=0, primary=False, is_big = False):
    ty = sa.types.Integer
    if is_big:
        ty = sa.types.BigInteger
    if default != None and primary == False:
        return sa.Column(name, ty, primary_key=primary, server_default=('%s' % default))
    else:
        return sa.Column(name, ty, primary_key=primary)

def col_str(name = '', length=4096, default=""):
    return sa.Column(name, sa.types.String(length), server_default=("%s" % default))

def col_text(name = ""):
    return sa.Column(name, sa.types.Text)

class BaseModel(object):
    meta = None
    table = ""
    is_multi = True
    pkey_name = "id"
    mc = None
    timeout = 3600
        
    @classmethod
    def configure(cls, mc, timeout):
        cls.mc = mc
        cls.timeout = timeout
        
    @classmethod
    def _get_cache_key(cls, pkey):
        if type(pkey) != types.StringType:
             pkey = "%s" % pkey
        pkey = pkey.strip()
        pkey = pkey.replace(" ", "_")
        ckey = "%s:%s" % (cls.table, pkey)
        #print "_get_cache_key: %s" % ckey 
        return str(ckey)
        
    @classmethod
    def _get_cache(cls, pkey):
        if not cls.mc:
            print "%s mc is %s" % (cls.table, cls.mc)
            return None
        ckey = cls._get_cache_key(pkey)
        return cls.mc.get(ckey)
    
    @classmethod
    def _set_cache(cls, pkey, data, timeout=None):
        if not cls.mc:
            print "%s mc is %s" % (cls.table, cls.mc)
            return None
        ckey = cls._get_cache_key(pkey)
        if timeout == None:
            return cls.mc.set(ckey, data, cls.timeout)
        else:
            return cls.mc.set(ckey, data, timeout) 
        
    @classmethod
    def _rem_cache(cls, pkey):
        if not cls.mc:
            return None
        ckey = cls._get_cache_key(pkey)
        return cls.mc.delete(ckey)   
        
    @classmethod
    def _get_max_id(cls):
        tb = cls.meta.tables[cls.table]
        max_id = 0
        if cls.is_multi:
            result = tb.select().limit(1).execute()
            rows = result.fetchall()
            if rows:
                max_id = rows[0].max_id
        else:
            result = cls.meta.bind.execute("select MAX(id) from %s" % cls.table)
            rows = result.fetchall()
            if rows:
                max_id = rows[0][0]
        return max_id
        
    @classmethod
    def _gen_pkey(cls):
        max_id = cls._get_max_id()
        tb = cls.meta.tables[cls.table]
        now = int(time.time())
        if max_id:
            max_id += 1
        else:
            max_id = 1
        if cls.is_multi:
            if max_id > 1:
                result = tb.update().values(max_id = max_id, timestamp = now).execute()
            else:
                result = tb.insert().values(max_id = max_id, timestamp = now).execute()
        return max_id
    
    @classmethod
    def _get_table_info(cls, pkey):
        '''
        pkey: primary key
        Return:
            table: Table
            name: table name
        '''
        name = ""
        tb = None
        if cls.is_multi:
            m = hashlib.md5()
            m.update("%s" % pkey)
            digest = m.hexdigest()
            name = cls.table + "_" + digest[0]
            tb = cls.meta.tables[name]
        else:
            name = cls.table
            tb = cls.meta.tables[cls.table]
        return tb, name
    
    @classmethod 
    def get_data(cls, pkey):
        #check cache
        result = cls._get_cache(pkey)
        if result:
            return result
        tb, name = cls._get_table_info(pkey)
        result = tb.select().where("%s=%s" % (cls.pkey_name, pkey)).execute().fetchone()
        #set cache
        if result:
            result = Storage(result)
            cls._set_cache(pkey, result)
        return result
    
    @classmethod    
    def put_data(cls, pkey, data, is_new=False):
        '''
        data: dict of table
        '''
        if is_new:
            pkey = cls._gen_pkey()
            tb, name = cls._get_table_info(pkey)
            data.update({cls.pkey_name: pkey})
            result = tb.insert().values(data).execute()
            if result.is_insert:
                data[cls.pkey_name] = pkey
                return data
            else:
                return False
        else:
            tb, name = cls._get_table_info(pkey)
            result = tb.update().values(data).where('%s=%s' % (cls.pkey_name, pkey)).execute()
            result.close()
            #remove old cache now
            cls._rem_cache(pkey)
            return data
    
    @classmethod
    def rem_data(cls, pkey):
        tb, name = cls._get_table_info(pkey)
        result = tb.delete().where("%s=%s" % (cls.pkey_name, pkey)).execute()
        if result.rowcount > 0:
            cls._rem_cache(pkey)
            return True
        else:
            return False        
                
    @classmethod
    @display_time
    def query(cls, cond, order_by="id"):
        '''
        Return:
            list of row: order by id desc
        '''
        result = []
        if cls.is_multi:
            for tb in cls.meta.sorted_tables:
                if tb.name[0: len(cls.table) + 1] != (cls.table + "_"):
                    continue
                rows = []
                if cond:    
                    rows = tb.select().where(cond).execute().fetchall()
                else:
                    rows = tb.select().execute().fetchall()
                for row in rows:
                    row = Storage(row)
                    result.append(row)
        else:
            tb = cls.meta.tables[cls.table]
            rows = []
            if cond:    
                rows = tb.select().where(cond).execute().fetchall()
            else:
                rows = tb.select().execute().fetchall()
            for row in rows:
                row = Storage(row)
                result.append(row)
                    
        result.sort(key=lambda x:x[order_by], reverse=True)
        return result
    
    @classmethod
    @display_time
    def query_page(cls, cond, page=0, limit=10, order_by="id"):
        #check cache
        pkey = "query_page_%s_%s_%s_%s" % (cond, page, limit, order_by)
        result = cls._get_cache(pkey)
        if result:
            return result
        result = cls.query(cond, order_by)
        start = page * limit
        end = (page + 1) * limit
        if end > len(result):
            end = len(result)
        if start >= len(result):
            return []
        result = result[start:end]
        #set cache
        cls._set_cache(pkey, result)
        return result
    
    @classmethod
    @display_time
    def query_num(cls, cond):
        '''
        Return:
            num of rows: int
        '''
        num = 0
        if cls.is_multi:
            for tb in cls.meta.sorted_tables:
                if tb.name[0: len(cls.table) + 1] != (cls.table + "_"):
                    continue
                row = tb.count().where(cond).order_by(tb.c.id).execute().fetchone()
                num += row[0]
        else:
            tb = cls.meta.tables[cls.table]
            if cond:
                row = tb.count().where(cond).order_by(tb.c.id).execute().fetchone()
                num += row[0]
            else:
                row = tb.count().order_by(tb.c.id).execute().fetchone()
                num += row[0]
        return num
            
    @classmethod
    @display_time
    def get_newest(cls, count=10, order_by="timestamp"):
        #check cache
        pkey = "get_newest_%d" % count
        result = cls._get_cache(pkey)
        if result:
            return result
        
        result = []
        max_id = cls._get_max_id()
        while True:
            if max_id <= 0:
                break
            obj = cls.get_data(max_id)
            max_id -= 1
            if not obj:
                continue
            result.append(obj)
            if len(result) >= count:
                break
            
        result.sort(key=lambda x:x[order_by], reverse=True)    
        cls._set_cache(pkey, result, 300)
        return result    
        
    @classmethod
    @display_time
    def get_random(cls, num):
        pkey = "get_random_%s" % num
        ret = cls._get_cache(pkey)
        if ret:
            return ret
            
        ret = []   
        max_id = cls._get_max_id()
        ids = range(1, max_id)
        if len(ids) == 0:
            return []
        sz = num
        if sz > len(ids):
            sz = len(ids)
        ids = random.sample(ids, sz)
        for i in ids:
            obj = cls.get_data(i)
            ret.append(obj)
        
        cls._set_cache(pkey, ret)
        return ret    
        
#mongo db interface
class MongoModel(object):
    doc_name = ""
    db_name = ""
    use_time_db = False #use $(db_name)_$year as real db name
    props = {} #field define
    _db = None
    _collection = None
    _conn = None
    _db_prefix = "d_"
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
    def update(cls, spec = {}, doc={}, multi = False, w=2):
        cls.get_collection().update(spec, doc, multi = multi, w = w)
    
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
        now = time.time()
        year = time.localtime(now)[0]
        if not cls.use_time_db:
            cls._db = cls._conn[cls._db_prefix + cls.db_name]
            cls._collection = cls._db[cls.doc_name]
        else:
            cls._db = cls._conn["%s%s_%s" % (cls._db_prefix, cls.db_name, year)]
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
        if indexes:
            cls.get_collection().ensure_index(indexes)

class MemcacheModel(object):
    _prefix = ""
    _mc = None
    
    @classmethod
    def configure(cls, mc, name):
        cls._prefix = name
        cls._mc = mc

    @classmethod
    def get_data(cls, key):
        real_key = cls._prefix + ":" + key
        return cls._mc.get(real_key)

    @classmethod
    def put_data(cls, key, value, timeout=360):
        real_key = cls._prefix + ":" + key
        return cls._mc.set(real_key, value)