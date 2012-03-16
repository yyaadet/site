import meta
import md5

from obj import GameGift
from obj import catch_exception

@catch_exception
def new_game_gifts(game_id, server_id, is_oneoff,li):
    for code in li:
        gg = GameGift()
        gg.game_id = game_id
        gg.server_id = server_id
        gg.code = code
        gg.is_oneoff = is_oneoff
        meta.Session.add(gg)

@catch_exception
def update_game_gift_uid(id, uid):
    data = meta.Session.query(GameGift).filter(GameGift.id == id).first()
    data.uid = uid
    return data

def get_game_gift_by_ids(game_id, server_id, uid, flag=0):
    if flag != 0:
        data = meta.Session.query(GameGift).filter(GameGift.game_id == game_id).filter(GameGift.server_id == server_id).filter(GameGift.uid == uid).filter(GameGift.is_oneoff == 3).first()
        if data is None:
            data = meta.Session.query(GameGift).filter(GameGift.game_id == game_id).filter(GameGift.server_id == server_id).filter(GameGift.uid == uid).first()
    else:
        data = meta.Session.query(GameGift).filter(GameGift.game_id == game_id).filter(GameGift.server_id == server_id).filter(GameGift.uid == uid).first()
    return data
