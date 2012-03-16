import meta
import time

from obj import Game
from obj import catch_exception

def get_all_games(offset=None,limit=None):
    if limit is None or offset is None:
        data = meta.Session.query(Game).order_by(Game.id.asc()).all()
    else:
        data = meta.Session.query(Game).order_by(Game.id.asc()).limit(limit).offset(offset).all()
    return data

def get_game_count():
    data = meta.Session.query(Game).count()
    return data

def get_game_by_id(game_id):
    date = meta.Session.query(Game).filter(Game.id == game_id).first()
    return date

def get_all_games_by_id(game_id):
    date = meta.Session.query(Game).filter(Game.id == game_id).all()
    return date

@catch_exception
def new_game(name, developer,website,description,pic_url):
    game = Game()
    game.name = name
    game.developer = developer
    game.website = website
    game.description = description
    game.pic_url = pic_url
    game.access_time = int(time.time())
    meta.Session.add(game)
    return game

@catch_exception
def edit_game(game_id,name, developer,website,description,pic_url):
    game = meta.Session.query(Game).filter(Game.id == game_id).first()
    game.name = name
    game.developer = developer
    game.website = website
    game.description = description
    game.pic_url = pic_url
    return game

@catch_exception
def del_game_by_id(game_id):
    game = meta.Session.query(Game).filter(Game.id == game_id).first()
    meta.Session.delete(game)