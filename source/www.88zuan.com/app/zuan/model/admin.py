import sqlalchemy as sa
from sqlalchemy import *

from zuan import model

NAME="admin"
    
class Admin(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    _safe = True
    #sort: asc | desc | none
    props = {
                   "uid": {"sort": None, "default": 0},
                   "name": {'sort': 'asc', "default": ''}, 
                   "password": {'sort': None, "default": ''},
                 }