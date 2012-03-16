#include "hf.h"

static bool read_task_is_fin(Wubao *w, Task *t);
static bool build_level_up_task_is_fin(Wubao *w, Task *t);
static bool tech_level_up_task_is_fin(Wubao *w, Task *t);
static bool made_task_is_fin(Wubao *w, Task *t);
static bool use_gene_task_is_fin(Wubao *w, Task *t);
static bool prac_task_is_fin(Wubao *w, Task *t);
static bool buy_trea_task_is_fin(Wubao *w, Task *t);
static bool res_trade_task_is_fin(Wubao *w, Task *t);
static bool weap_trade_task_is_fin(Wubao *w, Task *t);
static bool config_sol_task_is_fin(Wubao *w, Task *t);
static bool box_task_is_fin(Wubao *w, Task *t);


typedef bool (*TASKISFINCB) (Wubao *, Task *);

typedef struct TaskIsFinInfo {
	int id;
	TASKISFINCB cb;
}TaskIsFinInfo;

static TaskIsFinInfo info[] = {
	{TASK_TYPE_READ, read_task_is_fin},
	{TASK_TYPE_BUILD_LEVEL_UP, build_level_up_task_is_fin},
	{TASK_TYPE_TECH_LEVEL_UP, tech_level_up_task_is_fin},
	{TASK_TYPE_MADE, made_task_is_fin},
	{TASK_TYPE_USE_GENE, use_gene_task_is_fin},
	{TASK_TYPE_PRAC, prac_task_is_fin},
	{TASK_TYPE_BUY_TREA, buy_trea_task_is_fin},
	{TASK_TYPE_RES_TRADE, res_trade_task_is_fin},
	{TASK_TYPE_WEAP_TRADE, weap_trade_task_is_fin},
	{TASK_TYPE_CONFIG_SOL, config_sol_task_is_fin},
	{TASK_TYPE_BOX, box_task_is_fin},
};


Task *task_new()
{
	int i = 0;
	Task *t = cache_pool_alloc(POOL_TASK);

	if (!t)
		return NULL;
	t->id = 0;
	t->before_id = 0;
	t->type = 0;
	for(i = 0; i < TASK_NUM; i++) {
		t->num[i] = 0;
	}
	t->prestige = 0;
	for(i = 0; i < RES_MAX - 1; i++) {
		t->res[i] = 0;
	}
	for(i = 0; i < TASK_TREA_NUM; i++) {
		t->trea[i] = 0;
	}

	return t;
}

void task_free(Task *t)
{
	if (!t)
		return;
	cache_pool_free(POOL_TASK, t);
}


bool task_fin(Wubao *w) 
{
	if (!w)
		return false;

	Game *g = GAME;
	int i = 0;
	Task *t = NULL;


	if (!(t = game_find_task(g, w->task_id))) 
		return false;

	if (!task_is_fin(w)) {
		return false;
	}

	/* prize */
	w->task_id = 0;
	w->task_is_fin = 0;
	wubao_add_task_fin(w, t);

	for (i = 0; i < RES_MAX - 1; i++) {
		w->res[i] += t->res[i];
	}
	w->prestige += t->prestige;
	
	w->sol += t->sol;

	send_nf_wubao_where(w, WHERE_ME);

	return true;
}

bool task_is_fin(Wubao *w)
{
	if (!w)
		return false;


	Game *g = GAME;
	Task *t = NULL;
	bool fin = false;
	TASKISFINCB cb = NULL;


	if (!(t = game_find_task(g, w->task_id))) {
		WARN(LOG_FMT"don't found task %d\n", LOG_PRE, w->task_id);
		return false;
	}
	
	if(t->type <= TASK_TYPE_NONE || t->type >= TASK_TYPE_MAX) {
		WARN(LOG_FMT"task type %d\n", LOG_PRE, t->type);
		return false;
	}

	cb = info[t->type].cb;

	fin = cb(w, t);

	return fin;
}

bool read_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;

	return true;
}

static bool build_level_up_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;

	int id = t->num[0];
	int level = t->num[1];
	int i = 0;


	if (id == 0) {
		for(i = 0; i < BUILDING_MAX - 1; i++) {
			if (w->build[i].level >= level)
				return true;
		}
	}
	else if (id > BUILDING_NONE && id < BUILDING_MAX) {
		if (w->build[id - 1].level >= level)
			return true;
	}

	return false;
}

static bool tech_level_up_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;
	
	int id = t->num[0];
	int level = t->num[1];
	int i = 0;


	if (id == 0) {
		for(i = 0; i < TECH_MAX - 1; i++) {
			if (w->tech[i].level >= level)
				return true;
		}
	}
	else if (id > TECH_NONE && id < TECH_MAX) {
		if (w->tech[id - 1].level >= level)
			return true;
	}

	return false;
}

static bool made_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;

	int id = t->num[0];
	int level = t->num[1];
	int num = t->num[2];
	int i = 0;

	if (!(level >= WEAP_LEVEL0 && level < WEAP_LEVEL_MAX)) 
		return false;
	
	if (id == 0) {
		for(i = 0; i < WEAP_MAX - 1; i++) {
			if (w->weap[i].num[level] >= num)
				return true;
		}
	}
	else if (id > WEAP_NONE && id < WEAP_MAX) {
		if (w->weap[id - 1].num[level] >= num)
			return true;
	}

	return false;
}

static bool use_gene_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;

	int id = t->num[0];
	int num = t->num[1];
	int mine = wubao_get_mine_gene_num(w);

	if (id == 0) {
		if (mine >= num)
			return true;
	}
	else {
		if (wubao_find_gene(w, id))
			return true;
	}

	return false;
}

static bool prac_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;

	return true;
}

static bool buy_trea_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;

	int count = 0;
	Key *k;
	Trea *tr = NULL;
	int id = t->num[0];
	int num = t->num[1];


	if (id == 0) {
		if (w->trea_num >= num)
			return true;
	}
	else {
		RB_FOREACH(k, KeyMap, &w->treas) {
			if (tr->id == id) 
				count++;
			if (count >= num)
				return true;
		}
	}
	
	return false;
}

static bool res_trade_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;

	return true;
}


static bool weap_trade_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;
	
	Key *k;
	SellOrder *o = NULL;
	Game *g = GAME;
	int id = t->num[0];
	int level = t->num[1];
	int num = t->num[2];

	if (id == 0) {
		RB_FOREACH(k, KeyMap, &w->sell_orders) {
			if ((o = game_find_sell_order(g, k->id))) {
				if (o->weap_level >= level && o->weap_num >= num)
					return true;
			}
		}
	}
	else if(id > WEAP_NONE && id < WEAP_MAX) {
		RB_FOREACH(k, KeyMap, &w->sell_orders) {
			if ((o = game_find_sell_order(g, k->id))) {
				if (o->weap_id == id && o->weap_level >= level && o->weap_num >= num)
					return true;
			}
		}
		
	}
	return false;
}

static bool config_sol_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;
	
	Key *k;
	Gene *gene = NULL;
	Game *g = GAME;
	int i = 0;
	int id = t->num[0];
	int level = t->num[1];
	int num = t->num[2];

	if (id == 0) {
		RB_FOREACH(k, KeyMap, &w->genes) {
			if ((gene = game_find_gene(g, k->id))) {
				for(i = 0; i < GENE_WEAP_NUM; i++) {
					if (gene->weap[i].level >= level && gene->sol_num + gene->hurt_num >= num)
						return true;
				}
			}
		}
	}
	else {
		RB_FOREACH(k, KeyMap, &w->genes) {
			if ((gene = game_find_gene(g, k->id))) {
				for(i = 0; i < GENE_WEAP_NUM; i++) {
					if (gene->weap[i].id == id && gene->weap[i].level >= level && \
							gene->sol_num + gene->hurt_num >= num)
						return true;
				}
			}
		}
	}

	return false;
}

static bool box_task_is_fin(Wubao *w, Task *t)
{
	if (!(w && t))
		return false;
	
	int box_level = t->num[0];

	if (box_level == 0) {
		if (w->box_level > 0) 
			return true;
	}
	else {
		if (w->box_level >= box_level) 
			return true;
	}

	return false;
}

