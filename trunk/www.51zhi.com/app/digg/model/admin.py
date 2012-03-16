from digg import model

NAME="admin"


class Admin(model.MongoModel):
    doc_name = NAME
    db_name = NAME
    #sort: asc | desc | none
    props = {
                  "name": {'sort': None, "default": ''},    
                   "passwd": {'sort': None, "default": ''},  
                 }