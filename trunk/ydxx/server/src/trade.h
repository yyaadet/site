#ifndef _TRADE_H_
#define _TRADE_H_

#define ORDER_LIFE 4320
#define SELL_ORDER_LIFE 21600

struct Order {
	int id;
	int uid;
	int type;
	int res;
	int num;
	int deal_num;
	int last_unit_money;
	int unit_money;
	int money;
	int ts;
	bool is_del;
	
	RB_ENTRY(Order) tlink;
};
typedef struct Order Order;


extern Order *order_new();
extern Order *order_new1(int uid, int type, int res, int num, int unit_money, int ts);
extern void order_free(Order *o);

struct SellOrder {
	int id;
	int uid;
	int weap_id;
	int weap_level;
	int weap_num;
	int gold;
	int ts;
	bool is_del;
	
	RB_ENTRY(SellOrder) tlink;
};
typedef struct SellOrder SellOrder;

extern SellOrder *sell_order_new();
extern SellOrder *sell_order_new1(int uid, int weap_id, int weap_level, int weap_num, int gold, int ts);
extern void sell_order_free(SellOrder *so);


extern bool remove_order(int uid, int type, int oid);

#endif


