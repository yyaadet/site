#include "hf.h"


#define CITY_TABLE "city"
#define WUBAO_TABLE "wubao"
#define GENERAL_TABLE "general"
#define TREASURE_TABLE "treasure"
#define SHOP_TABLE "shop"
#define DIPLOMACY_TABLE "diplomacy"
#define USER_TABLE "user"
#define SPHERE_TABLE "sphere"
#define CMD_TRANSFER_TABLE "cmd_transfer"
#define TASK_TABLE "task"
#define MAIL_TABLE "mail"
#define MSG_TABLE "msg"
#define BOX_TABLE "pk"
#define GUANKA_TABLE "guanka"
#define ZHANYI_TABLE "zhanyi"
#define BUY_WEAP "buy_weap"
#define ADD_GOLD "add_money"
#define SUB_GOLD "sub_money"
#define DONATE_TREA "add_treasure"
#define CLEAR_MAIL "clear_mail"
#define SELL_WEAPON "sell_weapon"

#define WEB_ADDR g_cycle->conf->core.webapi_addr
#define WEB_PORT g_cycle->conf->core.webapi_port
#define WEB_URL g_cycle->conf->core.webapi_url


#define ACTION "action"
#define START "start"
#define COUNT "count"
	
static dstring url = DSTRING_INITIAL;

void webapi_city(Game *g, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", CITY_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_wubao(Game *g, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", WUBAO_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}


void  webapi_general(Game *g, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", GENERAL_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}


 
void webapi_treasure(Game *g, Trea *tr, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else if (action == ACTION_ADD && tr) {
		http_param_add_int(&p, ACTION, ACTION_ADD);
		http_param_add_int(&p, "general_id", tr->gene_id);
		http_param_add_int(&p, "user_id", tr->uid);
		http_param_add_int(&p, "use_time", tr->use_time);
		http_param_add_int(&p, "is_used", tr->is_used);
		http_param_add_int(&p, "treasure_id", tr->trea_id);
	}
	else if (action == ACTION_DEL && tr) {
		http_param_add_int(&p, ACTION, ACTION_DEL);
		http_param_add_int(&p, "id", tr->id);
	}
	else if (action == ACTION_EDIT && tr) {
		http_param_add_int(&p, ACTION, ACTION_EDIT);
		http_param_add_int(&p, "id", tr->id);
		http_param_add_int(&p, "general_id", tr->gene_id);
		http_param_add_int(&p, "user_id", tr->uid);
		http_param_add_int(&p, "use_time", tr->use_time);
		http_param_add_int(&p, "is_used", tr->is_used);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", TREASURE_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_shop(Game *g, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", SHOP_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}


void webapi_cmd_transfer(Game *g, CmdTrans *cmd, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else if (action == ACTION_ADD && cmd) {
		http_param_add_int(&p, ACTION, ACTION_ADD);
		http_param_add_int(&p, "from_id", cmd->from_id);
		http_param_add_int(&p, "to_id", cmd->to_id);
		http_param_add_int(&p, "type", cmd->type);
		http_param_add_int(&p, "sphere_id", cmd->sph_id);
		http_param_add_int(&p, "goods_type", cmd->good_type);
		http_param_add_int(&p, "goods_id", cmd->good_id);
		http_param_add_int(&p, "goods_num", cmd->good_num);
		http_param_add_int(&p, "end_time", cmd->end);
	}
	else if (action == ACTION_DEL && cmd) {
		http_param_add_int(&p, ACTION, ACTION_DEL);
		http_param_add_int(&p, "id", cmd->id);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", CMD_TRANSFER_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

   
void webapi_user(Game *g, int uid, User *u, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;
	Wubao *w = NULL;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
		if (uid > 0) {
			http_param_add_int(&p, "id", uid);
		}
	}
	else if (action == ACTION_EDIT && u) {
		if (g && (w = game_find_wubao(g, u->wid))) {
			http_param_add_int(&p, "last_login_time", w->last_login_time);
		}
		http_param_add_int(&p, ACTION, ACTION_EDIT);
		http_param_add_int(&p, "id", u->id);
		http_param_add_string(&p, "name", u->name.buf);
		http_param_add_string(&p, "last_login_ip", u->last_login_ip.buf);
		http_param_add_int(&p, "isonline", u->isonline);
		http_param_add_int(&p, "vip_total_hour", u->vip_total_hour);
		http_param_add_int(&p, "vip_used_hour", u->vip_used_hour);
		http_param_add_int(&p, "online_second", u->online_second);
		http_param_add_int(&p, "wid", u->wid);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", USER_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

  
void webapi_sphere(Game *g, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", SPHERE_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_diplomacy(Game *g, Dipl *dipl, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else if (action == ACTION_ADD && dipl) {
		http_param_add_int(&p, ACTION, ACTION_ADD);
		http_param_add_int(&p, "self_id", dipl->self_id);
		http_param_add_int(&p, "target_id", dipl->target_id);
		http_param_add_int(&p, "start", dipl->start);
		http_param_add_int(&p, "end", dipl->end);
		http_param_add_int(&p, "type", dipl->type);
	}
	else if (action == ACTION_DEL && dipl) {
		http_param_add_int(&p, ACTION, ACTION_DEL);
		http_param_add_int(&p, "id", dipl->id);
	}
	else if (action == ACTION_EDIT && dipl) {
		http_param_add_int(&p, ACTION, ACTION_EDIT);
		http_param_add_int(&p, "id", dipl->id);
		http_param_add_int(&p, "self_id", dipl->self_id);
		http_param_add_int(&p, "target_id", dipl->target_id);
		http_param_add_int(&p, "start", dipl->start);
		http_param_add_int(&p, "end", dipl->end);
		http_param_add_int(&p, "type", dipl->type);

	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", DIPLOMACY_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_task(Game *g, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", TASK_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_box(Game *g, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", BOX_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_guanka(Game *g, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", GUANKA_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_zhanyi(Game *g, int action, HTTPCB cb, void *arg)
{
	const char *addr = WEB_ADDR;
	short port = WEB_PORT;
	const dstring *t = NULL;
	HttpParam p;


	http_param_init(&p);
	
    if (!(addr && port > 0))
		goto finish;
	if (!g)
		goto finish;


	if (action == ACTION_GET) {
		http_param_add_int(&p, ACTION, ACTION_GET);
		http_param_add_int(&p, START, g->start);
		http_param_add_int(&p, COUNT, GET_STEP_COUNT);
	}
	else {
		goto finish;
	}

	t = http_param_to_string(&p);
	if (!t) {
		goto finish;
	}

	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", ZHANYI_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);

	http_param_clear(&p);

	return;

finish:

	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}


void webapi_mail(Mail *mail, int action, HTTPCB cb, void *arg)
{
	char *addr = (char *) WEB_ADDR;
	short port = WEB_PORT;
	HttpParam p;
	const dstring *t = NULL;

	http_param_init(&p);
	
    if (!(addr && port > 0))
		goto finish;


	if (action == ACTION_ADD && mail) {
		http_param_add_int(&p, ACTION, ACTION_ADD);
		http_param_add_int(&p, "sender_id", mail->send_id);
		http_param_add_int(&p, "receive_id", mail->recv_id);
		http_param_add_int(&p, "send_time", mail->send_time);
		http_param_add_string(&p, "sender_name", mail->send_name.buf);
		http_param_add_string(&p, "receive_name", mail->recv_name.buf);
		http_param_add_string(&p, "title", mail->title.buf);
		http_param_add_string(&p, "content", mail->cont.buf);
		http_param_add_int(&p, "type", mail->type);
	}

	t = http_param_to_string(&p);
	if(!t) {
		goto finish;
	}
	
	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", MAIL_TABLE);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);
	http_param_clear(&p);
	return;
finish:
	
	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}


void webapi_buy_weap(int sell_uid, int buy_uid, int gold, HTTPCB cb, void *arg)
{
	char *addr = (char *) WEB_ADDR;
	short port = WEB_PORT;
	HttpParam p;
	const dstring *t = NULL;

	http_param_init(&p);
	
    if (!(addr && port > 0 && gold > 0))
		goto finish;


	http_param_add_int(&p, "sell_uid", sell_uid);
	http_param_add_int(&p, "buy_uid", buy_uid);
	http_param_add_int(&p, "gold", gold);

	t = http_param_to_string(&p);
	if(!t) {
		goto finish;
	}
	
	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s?", BUY_WEAP);
	dstring_append(&url, t->buf, t->offset);

	http_request(addr, port, url.buf, NULL, 0, cb, arg);
	http_param_clear(&p);
	return;
finish:
	
	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}


void webapi_add_gold(int uid, int gold, HTTPCB cb, void *arg)
{
	char *addr = (char *) WEB_ADDR;
	short port = WEB_PORT;
	HttpParam p;
	const dstring *t = NULL;

	http_param_init(&p);
	
    if (!(addr && port > 0 && gold > 0))
		goto finish;


	http_param_add_int(&p, "uid", uid);
	http_param_add_int(&p, "money", gold);

	t = http_param_to_string(&p);
	if(!t) {
		goto finish;
	}
	
	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", ADD_GOLD);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);
	http_param_clear(&p);
	return;
finish:
	
	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_sub_gold(int uid, int gold, HTTPCB cb, void *arg)
{
	char *addr = (char *) WEB_ADDR;
	short port = WEB_PORT;
	HttpParam p;
	const dstring *t = NULL;

	http_param_init(&p);
	
    if (!(addr && port > 0 && gold >= 0))
		goto finish;


	http_param_add_int(&p, "uid", uid);
	http_param_add_int(&p, "money", gold);

	t = http_param_to_string(&p);
	if(!t) {
		goto finish;
	}
	
	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", SUB_GOLD);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);
	http_param_clear(&p);
	return;
finish:
	
	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_donate_trea(Trea *tr, HTTPCB cb, void *arg)
{
	char *addr = (char *) WEB_ADDR;
	short port = WEB_PORT;
	HttpParam p;
	const dstring *t = NULL;

	http_param_init(&p);
	if (!(addr && port > 0 && tr))
		goto finish;


	http_param_add_int(&p, "general_id", tr->gene_id);
	http_param_add_int(&p, "user_id", tr->uid);
	http_param_add_int(&p, "use_time", tr->use_time);
	http_param_add_int(&p, "is_used", tr->is_used);
	http_param_add_int(&p, "treasure_id", tr->trea_id);

	t = http_param_to_string(&p);
	if(!t) {
		goto finish;
	}
	
	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", DONATE_TREA);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);
	http_param_clear(&p);
	return;
finish:
	
	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_clear_mail(HTTPCB cb, void *arg)
{
	char *addr = (char *) WEB_ADDR;
	short port = WEB_PORT;
	HttpParam p;
	const dstring *t = NULL;

	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;


	http_param_add_int(&p, "time", GAME_NOW);

	t = http_param_to_string(&p);
	if(!t) {
		goto finish;
	}
	
	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", CLEAR_MAIL);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);
	http_param_clear(&p);
	return;
finish:
	
	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

void webapi_sell_weapon(int uid, HTTPCB cb, void *arg)
{
	char *addr = (char *) WEB_ADDR;
	short port = WEB_PORT;
	HttpParam p;
	const dstring *t = NULL;

	http_param_init(&p);
	if (!(addr && port > 0))
		goto finish;


	http_param_add_int(&p, "uid", uid);

	t = http_param_to_string(&p);
	if(!t) {
		goto finish;
	}
	
	dstring_set(&url, WEB_URL);
	dstring_append_printf(&url, "%s", SELL_WEAPON);

	http_request(addr, port, url.buf, t->buf, t->offset, cb, arg);
	http_param_clear(&p);
	return;
finish:
	
	http_param_clear(&p);
	
	if (cb)
		cb(NULL, 0, arg, HTTP_ERR);
}

