"""Routes configuration extend"""

def set_site_route(map):
    mc = map.connect
    #home 
    mc("/", controller="home", action="index")
    mc("/user_center", controller="home", action="user_center")
    mc("/load_game", controller="home", action="game")
    mc("/error", controller="home", action="error")
    mc("/rank", controller='home', action='rank')
    mc("/new_game", controller='home', action='new_game')
    mc("/maintenance", controller='home', action='maintenance')
    mc("/get_invite_code_to_allot", controller="home", action="get_invite_code_to_allot")
    
    #site api
    mc("/api/shop", controller="api", action="shop")
    