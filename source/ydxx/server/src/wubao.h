#ifndef _WUBAO_H_
#define _WUBAO_H_

#define MAX_DIS 7

#include "trade.h"

struct Task;

enum RES_ID {
	RES_NONE,
	RES_FOOD,
	RES_WOOD,
	RES_IRON ,
	RES_HORSE,
	RES_SKIN,
	RES_MONEY,
	RES_MAX,
};


enum BUILDING_ID {
	BUILDING_NONE,
	BUILDING_SHUYUAN,
	BUILDING_MINJU,
	BUILDING_KUFANG,
	BUILDING_GONGFANG,
	BUILDING_RONGTIAN,
	BUILDING_FAMUCHANG,
	BUILDING_KUANGSHAN,
	BUILDING_MUCHANG,
	BUILDING_GEFANG,
	BUILDING_JISHI,
	BUILDING_YISHITANG,
	BUILDING_YIGUAN,
	BUILDING_JUNYIN,	
	BUILDING_MAX,
};

enum TECH_ID {
	TECH_NONE,
	TECH_ZHUJIAN,
	TECH_ZHIJI,
	TECH_JIKUA,
	TECH_ZHIDUN,
	TECH_GEPI,
	TECH_JIAOZHU,
	TECH_JIXIE,
	TECH_ZAOCHUAN,
	TECH_XUNMA,
	TECH_ZHONGZHI,
	TECH_FAMU,
	TECH_CAIKUANG,
	TECH_FANGMU,
	TECH_ZHIGE,
	TECH_MAOYU,
	TECH_MAX,
};

enum WEAP_ID {
	WEAP_NONE,
	WEAP_JIAN,
	WEAP_JI,
	WEAP_GONG,
	WEAP_DUN,
	WEAP_PIJIA,
	WEAP_TIEJIA,
	WEAP_CHONGCHE,
	WEAP_ZHANCHUAN,
	WEAP_ZHANMA,
	WEAP_1,
	WEAP_2,
	WEAP_3,
	WEAP_4,
	WEAP_5,
	WEAP_6,
	WEAP_7,
	WEAP_8,
	WEAP_9,
	WEAP_10,
	WEAP_11,
	WEAP_12,
	WEAP_13,
	WEAP_14,
	WEAP_15,
	WEAP_16,
	WEAP_17,
	WEAP_18,
	WEAP_19,
	WEAP_20,
	WEAP_MAX,
};

enum WEAP_LEVEL {
	WEAP_LEVEL0,
	WEAP_LEVEL1,
	WEAP_LEVEL2,
	WEAP_LEVEL3,
	WEAP_LEVEL4,
	WEAP_LEVEL5,
	WEAP_LEVEL6,
	WEAP_LEVEL7,
	WEAP_LEVEL8,
	WEAP_LEVEL9,
	WEAP_LEVEL10,
	WEAP_LEVEL_MAX,
};


struct Building {
	int id;
	int level;
	int up_end_time;
};
typedef struct Building Building;


struct Tech {
	int id;
	int level;
	int up_end_time;
};
typedef struct Tech Tech;

struct Weap {
	int id;
	int num[WEAP_LEVEL_MAX];
};
typedef struct Weap Weap;

struct Wubao {
	int id;
	int uid;
	int people;
	int family;
	int prestige;
	int left_prestige;
	int city_id;
	int sph_id;
	int dig_id;
	int off_id;
	int sol;
	int got_sol;
	int used_made;
	int cure_sol;
	int max_gene;
	int task_id;
	int task_is_fin;
	int last_visit_time;
	int last_welfare_time;
	int last_login_time;
	int been_plunder_num;
	int use_gx_trea_num;
	int box_level;
	int rank;
	int war_sleep_end_time;
	int train_sleep_end_time;
	int gx;
	int jl;
	int fresh_step;

	int res[RES_MAX - 1];
	Weap weap[WEAP_MAX - 1];
	Tech tech[TECH_MAX - 1];
	Building build[BUILDING_MAX - 1];

	int gene_num;
	struct KeyMap genes;

	int fri_num;
	struct KeyMap fris;

	int trea_num;
	struct KeyMap treas;

	int order_num;
	struct KeyMap orders;

	int sell_order_num;
	struct KeyMap sell_orders;

	int task_fin_num;
	struct KeyMap task_fins;
	
	RB_ENTRY(Wubao) tlink;
};
typedef struct Wubao Wubao;


extern Wubao *wubao_new();

extern void wubao_free(Wubao *w);

extern bool wubao_is_vip(Wubao *w);

extern bool wubao_add_gene(Wubao *w, Gene *gene);
extern bool wubao_del_gene(Wubao *w, Gene *gene);
extern Gene * wubao_find_gene(Wubao *w, int id);
extern Gene * wubao_get_wild_gene(Wubao *w);
extern int wubao_get_mine_gene_num(Wubao *w);
extern int wubao_get_wild_gene_num(Wubao *w);

extern int wubao_weap_id_num(Wubao *w);
extern bool wubao_has_weap(Wubao *w, int weap_id, int weap_level);

extern bool wubao_add_fri(Wubao *w, int gene_id, int fri);
extern int  wubao_get_fri(Wubao *w, int gene_id);
extern void wubao_change_fri(Wubao *w, int gene_id, int num);
extern void wubao_set_fri(Wubao *w, int gene_id, int num);

extern bool wubao_add_trea(Wubao *w, Trea *t);
extern bool wubao_del_trea(Wubao *w, Trea *t);
extern Trea *wubao_find_trea(Wubao *w, int id);

extern bool wubao_add_order(Wubao *w, Order *o);
extern bool wubao_del_order(Wubao *w, Order *o);
extern Order * wubao_find_order(Wubao *w, int id);

extern bool wubao_add_sell_order(Wubao *w, SellOrder *o);
extern bool wubao_del_sell_order(Wubao *w, SellOrder *o);
extern SellOrder * wubao_find_sell_order(Wubao *w, int id);

extern bool wubao_add_task_fin(Wubao *w, struct Task *t);
extern bool wubao_del_task_fin(Wubao *w, struct Task *t);
extern struct Task * wubao_find_task_fin(Wubao *w, int id);

extern bool wubao_get_idle_xy(Wubao *w, int *x, int *y);

extern bool wubao_get_xy(Wubao *w, int *x, int *y);

extern int wubao_add_prestige(Wubao *w, int num);

extern bool wubao_check_level(Wubao *w, int now);

extern int wubao_level_up_build(Wubao *w);

extern int wubao_level_up_tech(Wubao *w);

extern const char *weap_name(int id);

extern const char *res_name(int id);

#endif

