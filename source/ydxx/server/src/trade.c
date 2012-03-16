#include "hf.h"


Order *order_new()
{
	Order *o = cache_pool_alloc(POOL_ORDER);

	if (!o)
		return NULL;

	memset(o, 0, sizeof(*o));

	return o;
}

Order *order_new1(int uid, int type, int res, int num, int unit_money, int ts)
{
	Order *o = order_new();

	if (!o)
		return NULL;

	o->uid = uid;
	o->type = type;
	o->res = res;
	o->num = num;
	o->unit_money = unit_money;
	if (type == TRADE_BUY)
		o->money = num * unit_money;
	o->ts = ts;

	return o;
}

void order_free(Order *o)
{
	if (!o)
		return ;
	cache_pool_free(POOL_ORDER, o);
}


SellOrder *sell_order_new()
{
	SellOrder *o = cache_pool_alloc(POOL_SELL_ORDER);

	if (!o)
		return NULL;

	memset(o, 0, sizeof(*o));

	return o;
}

SellOrder *sell_order_new1(int uid, int weap_id, int weap_level, int weap_num, int gold, int ts)
{
	SellOrder *o = sell_order_new();

	if (!o)
		return NULL;
	o->uid = uid;
	o->weap_id = weap_id;
	o->weap_level = weap_level;
	o->weap_num = weap_num;
	o->gold = gold;
	o->ts = ts;

	return o;
}

void sell_order_free(SellOrder *so)
{
	if (!so)
		return ;
	cache_pool_free(POOL_SELL_ORDER, so);
}

bool remove_order(int uid, int type, int oid)
{
	Game *g = GAME;
	Order *o = NULL;
	SellOrder *so = NULL;
	Wubao *w = NULL;
    int res_id = 0;

	if (!(w = game_find_wubao_by_uid(g, uid))) {
		return false;
	}

	if (type == ORDER_NORM) {
		if (!(o = game_find_order(g, oid))) {
			return false;
		}
		if (o->uid != uid && uid != SYS_SEND_ID) {
			return false;
		}

		if (o->type == TRADE_BUY) {
			w->res[RES_MONEY - 1] += o->money;
		}
		else if (o->type == TRADE_SELL) {
			w->res[o->res - 1] += (o->num - o->deal_num);
		}

		game_del_order(g, o);
		send_nf_order_where(o, WHERE_ALL);
		order_free(o);
		o = NULL;
	}
	else if (type == ORDER_SPEC) {
		if (!(so = game_find_sell_order(g, oid))) {
			return false;
		}
		if (so->uid != uid && uid != SYS_SEND_ID) {
			return false;
		}
    
        if (so->weap_id < 100) 
		    w->weap[so->weap_id - 1].num[so->weap_level] += so->weap_num;
        else {
            res_id = so->weap_id - 100;
            w->res[res_id - 1] += so->weap_num;
        }

		game_del_sell_order(g, so);
		send_nf_sell_order_where(so, WHERE_ALL);
		sell_order_free(so);
		so = NULL;
	}
	else {
		return false;
	}

	send_nf_wubao_where(w, WHERE_ME);

	return true;
}

