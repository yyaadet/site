import sqlalchemy as sa
from sqlalchemy import *

from digg import model

NAME="msg"

class Msg(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {"cnt": {'sort': None, "default": ''},
                 }   