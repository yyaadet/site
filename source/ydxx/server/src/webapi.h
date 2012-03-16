#ifndef _WEBAPI_H_
#define _WEBAPIH_H_
#include "http.h"
#include "game.h"
#include "mail.h"


enum {
	ACTION_NONE = 0, 
	ACTION_GET,
	ACTION_ADD,
	ACTION_DEL,
	ACTION_EDIT,
	ACTION_MAX,
};

extern void webapi_city(Game *game, int action, HTTPCB cb, void *arg);

extern void webapi_wubao(Game *g, int action, HTTPCB cb, void *arg);

extern void webapi_general(Game *game, int action, HTTPCB cb, void *arg);

extern void webapi_treasure(Game *game, Trea *t, int action, HTTPCB cb, void *arg);

extern void webapi_shop(Game *game, int action, HTTPCB cb, void *arg);

extern void webapi_diplomacy(Game *game, Dipl * dipl, int action, HTTPCB cb, void *arg);

extern void webapi_user(Game *game, int uid, User *u, int action, HTTPCB cb, void *arg);

extern void webapi_sphere(Game *game, int action, HTTPCB cb, void *arg);

extern void webapi_cmd_transfer(Game *game, CmdTrans *cmd, int action, HTTPCB cb, void *arg);

extern void webapi_task(Game *g, int action, HTTPCB cb, void *arg);

extern void webapi_box(Game *g, int action, HTTPCB cb, void *arg);

extern void webapi_guanka(Game *g, int action, HTTPCB cb, void *arg);

extern void webapi_zhanyi(Game *g, int action, HTTPCB cb, void *arg);

extern void webapi_mail(Mail *mail, int action, HTTPCB cb, void *arg);

extern void webapi_buy_weap(int sell_uid, int buy_uid, int gold, HTTPCB cb, void *arg);

extern void webapi_add_gold(int uid, int gold, HTTPCB cb, void *arg);

extern void webapi_sub_gold(int uid, int gold, HTTPCB cb, void *arg);

extern void webapi_donate_trea(Trea *t, HTTPCB cb, void *arg);

extern void webapi_clear_mail(HTTPCB cb, void *arg);

extern void webapi_sell_weapon(int uid, HTTPCB cb, void *arg);



#endif

