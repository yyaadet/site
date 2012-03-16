import meta
import time

from obj import Line
from obj import catch_exception

def get_all_lines(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(Line).order_by(Line.id.desc()).all()
    else:
        data = meta.Session.query(Line).order_by(Line.id.desc()).limit(limit).offset(offset).all()
    return data

def get_line_count():
    data = meta.Session.query(Line).count()
    return data


def get_line_by_id(id):
    data = meta.Session.query(Line).filter(Line.id == id).first()
    return data

@catch_exception
def new_line(name, game_id):
    s = Line()
    s.name = name
    s.game_id = game_id
    meta.Session.add(s)
    return s

@catch_exception
def edit_line(id, name, game_id):
    s = meta.Session.query(Line).filter(Line.id == id).first()
    s.name = name
    s.game_id = game_id
    return s

def get_lines_by_game_id(game_id,offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(Line).filter(Line.game_id == game_id).order_by(Line.id.desc()).all()
    else:
        data = meta.Session.query(Line).filter(Line.game_id == game_id).order_by(Line.id.desc()).limit(limit).offset(offset).all()
    return data


@catch_exception
def del_line_by_id(id):
    line = meta.Session.query(Line).filter(Line.id == id).first()
    meta.Session.delete(line)