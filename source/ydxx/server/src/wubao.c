#include "hf.h"

#define DEF_FRI 50


Wubao *wubao_new()
{
	int i = 0;
	Wubao *w = (Wubao *) cache_pool_alloc(POOL_WUBAO);

	if (!w)
		return NULL;

	memset(w, 0, sizeof(Wubao));

	w->gx = 100;

	w->jl = MAX_JL;

	w->max_gene = 1;
	
	w->gene_num = 0;
	RB_INIT(&w->genes); 

	w->fri_num = 0;
	RB_INIT(&w->fris);

	w->trea_num = 0;
	RB_INIT(&w->treas);

	w->order_num = 0;
	RB_INIT(&w->orders);
	
	w->sell_order_num = 0;
	RB_INIT(&w->sell_orders);

	w->task_fin_num = 0;
	RB_INIT(&w->task_fins);
	
	/* init weap */
	for(i = WEAP_NONE + 1; i <= WEAP_MAX - 1; i++) {
		w->weap[i-1].id = i;
	}
	/* init build */
	for(i = BUILDING_NONE + 1; i <= BUILDING_MAX - 1; i++ ) {
		w->build[i-1].id = i;
		w->build[i-1].level = 0;
		w->build[i-1].up_end_time = 0;
	}
	/* init tech */
	for(i = TECH_NONE + 1; i <= TECH_MAX - 1; i++ ) {
		w->tech[i-1].id = i;
		w->tech[i-1].level = 0;
		w->tech[i-1].up_end_time = 0;
	}
	
	return w;
}

void wubao_free(Wubao *w)
{
	if (!w)
		return;

	Key *k, *t;

	for(k = RB_MIN(KeyMap, &w->genes); k; k = t) {
		t = RB_NEXT(KeyMap, &w->genes, k);

		RB_REMOVE(KeyMap, &w->genes, k);
		key_free(k);
	}
	
	for(k = RB_MIN(KeyMap, &w->fris); k; k = t) {
		t = RB_NEXT(KeyMap, &w->fris, k);

		RB_REMOVE(KeyMap, &w->fris, k);
		key_free(k);
	}
	
	for(k = RB_MIN(KeyMap, &w->treas); k; k = t) {
		t = RB_NEXT(KeyMap, &w->treas, k);

		RB_REMOVE(KeyMap, &w->treas, k);
		key_free(k);
	}
	
	for(k = RB_MIN(KeyMap, &w->orders); k; k = t) {
		t = RB_NEXT(KeyMap, &w->orders, k);

		RB_REMOVE(KeyMap, &w->orders, k);
		key_free(k);
	}
	
	for(k = RB_MIN(KeyMap, &w->sell_orders); k; k = t) {
		t = RB_NEXT(KeyMap, &w->sell_orders, k);

		RB_REMOVE(KeyMap, &w->sell_orders, k);
		key_free(k);
	}
	
	for(k = RB_MIN(KeyMap, &w->task_fins); k; k = t) {
		t = RB_NEXT(KeyMap, &w->task_fins, k);

		RB_REMOVE(KeyMap, &w->task_fins, k);
		key_free(k);
	}
	
	cache_pool_free(POOL_WUBAO, w);
}


bool wubao_is_vip(Wubao *w)
{
	if (!w)
		return false;

	User *u = NULL;
	Game *g = GAME;

	if (!(u = game_find_user(g, w->uid)))
		return false;
	return user_is_vip(u);
}

bool wubao_add_gene(Wubao *w, Gene *gene)
{
	if (!(w && gene))
		return false;

	Key *k;

	if (wubao_find_gene(w, gene->id))
		return false;

	if (!(k = key_new(gene->id)))
		return false;

	if (RB_INSERT(KeyMap, &w->genes, k)) {
		key_free(k);
		return false;
	}

	w->gene_num++;

	return true;
}

bool wubao_del_gene(Wubao *w, Gene *gene)
{
	if (!(w && gene))
		return false;

	if (!wubao_find_gene(w, gene->id))
		return false;

	Key k;
	Key *r = NULL;

	k.id = gene->id;
	if (!(r = RB_FIND(KeyMap, &w->genes, &k))) {
		return false;
	}
	if ((r = RB_REMOVE(KeyMap, &w->genes, r)) == NULL) {
		return false;
	}
	
	w->gene_num --;
	
	return true;
}

Gene * wubao_find_gene(Wubao *w, int id)
{
	if(!w) 
		return NULL;

	Game *g = GAME;
	Key k;
	Key *r;

	k.id = id;
	if ((r = RB_FIND(KeyMap, &w->genes, &k)) == NULL) 
		return NULL;

	return game_find_gene(g, r->id);
}

Gene * wubao_get_wild_gene(Wubao *w)
{
	if (!w)
		return NULL;

	Key *k, *nxt;
	Gene *gene = NULL;
	Gene *ret = NULL;
	Game *g = GAME;

	for(k = RB_MIN(KeyMap, &w->genes); k; k = nxt) {
		nxt = RB_NEXT(KeyMap, &w->genes, k);

		if(!(gene = game_find_gene(g, k->id))) {
			continue;
		}
		if(gene->uid <= 0 && gene->place == GENE_PLACE_WUBAO && gene->type != GENE_TYPE_NAME) {
			if (ret == NULL)
				ret = gene;
			else {
				game_del_gene(g, gene);
			}
		}
	}

	return ret;
}

int wubao_get_mine_gene_num(Wubao *w)
{
	if (!w)
		return 0;

	Key *k;
	Gene *gene = NULL;
	Game *g = GAME;
	int num = 0;

	RB_FOREACH(k, KeyMap, &w->genes) {
		if(!(gene = game_find_gene(g, k->id))) {
			continue;
		}
		if(gene->uid == w->uid) {
			num++;
		}
	}

	return num;
}

int wubao_get_wild_gene_num(Wubao *w)
{
	if (!w)
		return 0;

	Key *k;
	Gene *gene = NULL;
	Game *g = GAME;
	int num = 0;

	RB_FOREACH(k, KeyMap, &w->genes) {
		if(!(gene = game_find_gene(g, k->id))) {
			continue;
		}
		if(gene->uid <= 0) {
			num++;
		}
	}

	return num;
}


int wubao_weap_id_num(Wubao *w)
{
	if (!w)
		return 0;

	int i = 0;
	int j = 0;
	int count = 0;

	for(i = 0; i < WEAP_MAX - 1; i++) {
		for(j = 0; j < WEAP_LEVEL_MAX; j++) {
			if (w->weap[i].num[j] > 0)
				count++;
		}
	}
	return count;
}

bool wubao_has_weap(Wubao *w, int weap_id, int weap_level)
{
	if (!w)
		return 0;

	if (w->weap[weap_id - 1].num[weap_level] > 0)
		return true;

	return false;
}



bool wubao_add_fri(Wubao *w, int gene_id, int fri)
{
	if(!(w && gene_id > 0))
		return false;

	Key *r = NULL;
	Key k;

	k.id = gene_id;
	if((r = RB_FIND(KeyMap, &w->fris, &k)))
		return false;

	if (!(r = key_new(gene_id))) 
		return false;
	r->arg = (void *)fri;

	if (RB_INSERT(KeyMap, &w->fris, r)) {
		key_free(r);
		return false;
	}

	w->fri_num++;
	
	DEBUG(LOG_FMT"wubao %d gene %d, fri %d, num %d\n", LOG_PRE, w->id, r->id, (int) r->arg, w->fri_num);

	return true;
}

int wubao_get_fri(Wubao *w, int gene_id)
{
	if (!w)
		return 0;

	Key k;
	Key *r = NULL;

	k.id = gene_id;
	if (!(r = RB_FIND(KeyMap, &w->fris, &k))) 
		return DEF_FRI;

	return (int)r->arg;
}

void wubao_change_fri(Wubao *w, int gene_id, int fri)
{
	if (!w)
		return;

	Key k;
	Key *r = NULL;

	k.id = gene_id;
	if (!(r = RB_FIND(KeyMap, &w->fris, &k))) {
		wubao_add_fri(w, gene_id, fri);
		return ;
	}

	r->arg = (void  *)(r->arg + fri);
	
	DEBUG(LOG_FMT"wubao %d, gene %d, fri %d, num %d\n", LOG_PRE, w->id, r->id, (int) r->arg, w->fri_num);
}

void wubao_set_fri(Wubao *w, int gene_id, int num)
{
	if (!w)
		return;

	Key k;
	Key *r = NULL;

	k.id = gene_id;
	if (!(r = RB_FIND(KeyMap, &w->fris, &k))) {
		return ;
	}

	r->arg = (void  *)num;
	
	DEBUG(LOG_FMT"wubao %d, gene %d, fri %d, num %d\n", LOG_PRE, w->id, r->id, (int) r->arg, w->fri_num);
}


bool wubao_add_trea(Wubao *w, Trea *t)
{
	if (!(w && t))
		return false;
	
	Key *k;

	if (wubao_find_trea(w, t->id))
		return false;
	if(!(k = key_new(t->id))) 
		return false;
	if (RB_INSERT(KeyMap, &w->treas, k)) {
		key_free(k);
		return false;
	}

	w->trea_num++;

	return true;
}

bool wubao_del_trea(Wubao *w, Trea *t)
{
	if (!(w && t))
		return false;

	if (!wubao_find_trea(w, t->id))
		return false;

	Key *r;
	Key k;

	k.id = t->id;
	if (!(r = RB_FIND(KeyMap, &w->treas, &k)))
		return false;

	if (RB_REMOVE(KeyMap, &w->treas, r) == NULL)
		return false;

	w->trea_num--;
	key_free(r);

	return true;
}

Trea *wubao_find_trea(Wubao *w, int id)
{
	if (!w)
		return NULL;

	Game *g = GAME;
	Key *r;
	Key k;

	k.id = id;
	if (!(r = RB_FIND(KeyMap, &w->treas, &k)))
		return NULL;

	return (game_find_trea(g, r->id));
}

bool wubao_add_order(Wubao *w, Order *o)
{
	if (!(w && o)) 
		return false;
	
	Key *k;

	if (wubao_find_order(w, o->id)) {
		WARN(LOG_FMT"wubao %d already have oid %d\n", LOG_PRE, w->id, o->id);
		return false;
	}
	
	if(!(k = key_new(o->id))) 
		return false;

	if (RB_INSERT(KeyMap, &w->orders, k)) {
		key_free(k);
		return false;
	}

	w->order_num++;
	
	DEBUG(LOG_FMT"oid %d, uid %d, left %d\n", LOG_PRE, o->id, o->uid, w->order_num);

	return true;
}

bool wubao_del_order(Wubao *w, Order *o)
{
	if (!(w && o))
		return false;

	Key *r;
	Key k;

	k.id = o->id;
	if (!(r = RB_FIND(KeyMap, &w->orders, &k)))
		return false;

	if (RB_REMOVE(KeyMap, &w->orders, r) == NULL)
		return false;
	key_free(r);

	w->order_num--;

	DEBUG(LOG_FMT"oid %d, uid %d, left %d\n", LOG_PRE, o->id, o->uid, w->order_num);

	return true;
}

Order * wubao_find_order(Wubao *w, int id)
{
	if (!w)
		return NULL;

	Game *g = GAME;
	Key *r;
	Key k;

	k.id = id;
	if (!(r = RB_FIND(KeyMap, &w->orders, &k)))
		return NULL;

	return (game_find_order(g, r->id));
}

bool wubao_add_sell_order(Wubao *w, SellOrder *o)
{
	if (!(w && o)) 
		return false;
	
	Key *k;

	if (wubao_find_sell_order(w, o->id))
		return false;
	if(!(k = key_new(o->id))) 
		return false;
	if (RB_INSERT(KeyMap, &w->sell_orders, k)) {
		key_free(k);
		return false;
	}

	w->sell_order_num++;

	return true;
}

bool wubao_del_sell_order(Wubao *w, SellOrder *o)
{
	if (!(w && o))
		return false;

	Key *r;
	Key k;

	k.id = o->id;
	if (!(r = RB_FIND(KeyMap, &w->sell_orders, &k)))
		return false;

	if (RB_REMOVE(KeyMap, &w->sell_orders, r) == NULL)
		return false;
	key_free(r);

	w->sell_order_num--;

	return true;
}

SellOrder * wubao_find_sell_order(Wubao *w, int id)
{
	if (!w)
		return NULL;

	Game *g = GAME;
	Key *r;
	Key k;

	k.id = id;
	if (!(r = RB_FIND(KeyMap, &w->sell_orders, &k)))
		return NULL;

	return (game_find_sell_order(g, r->id));
}


bool wubao_add_task_fin(Wubao *w, Task *t)
{
	if (!(t && w))
		return false;
	
	Key *k;

	if (wubao_find_task_fin(w, t->id))
		return false;

	if(!(k = key_new(t->id))) 
		return false;
	
	if (RB_INSERT(KeyMap, &w->task_fins, k)) {
		key_free(k);
		return false;
	}

	w->task_fin_num++;

	return true;
}

bool wubao_del_task_fin(Wubao *w, Task *t)
{
	if (!w)
		return false;

	Key *r;
	Key k;

	k.id = t->id;
	if (!(r = RB_FIND(KeyMap, &w->task_fins, &k)))
		return false;

	if (RB_REMOVE(KeyMap, &w->task_fins, r) == NULL)
		return false;
	key_free(r);

	w->task_fin_num--;

	return true;
}

Task * wubao_find_task_fin(Wubao *w, int id)
{
	if (!w)
		return NULL;

	Game *g = GAME;
	Key *r;
	Key k;

	k.id = id;
	if (!(r = RB_FIND(KeyMap, &w->task_fins, &k)))
		return NULL;

	return (game_find_task(g, r->id));
}

bool wubao_get_idle_xy(Wubao *w, int *x, int *y)
{
	if (!w)
		return false;

	Game *g = GAME;
	City *city = NULL;
	MapRegion *r = NULL;
	int i = 0;
	int j = 0;

	if (!(city = game_find_city(g, w->city_id)))
		return false;

	for (i = 0; i < MAX_DIS; i++) {
		j = MAX_DIS - i;
		
		if(!(r = get_global_region(city->x + i, city->y + j)))
			continue;
		if (r->m_reg == REGION_JIANGHAI)
			continue;

		if (game_find_army_by_xy(g, city->x + i, city->y + j))
			continue;

		if (x)
			(*x) = city->x + i;
		if (y)
			(*y) = city->y + j;

		return true;
	}

	return false;
}

bool wubao_get_xy(Wubao *w, int *x, int *y)
{
	if (!w)
		return false;

	Game *g = GAME;
	City *city = NULL;

	if (!(city = game_find_city(g, w->city_id)))
		return false;

    if (x)
        *x = city->x;
    if (y)
        *y = city->y;
    
    return true;
}

int wubao_add_prestige(Wubao *w, int num)
{
	if (!w)
		return 0;

	Game *g = GAME;
	Sph *sph = NULL;
	int fact = 0;
	int incr = 0;


	if (wubao_is_vip(w))
		fact = 1.2 * num;
	else 
		fact = num;
	
	w->left_prestige += fact;

	incr = w->left_prestige / WUBAO_PRES_OF_KILL;
	
	w->prestige += incr;

	w->left_prestige = w->left_prestige % WUBAO_PRES_OF_KILL;

	if ((sph = game_find_sph(g, w->sph_id))) {
		sph_add_prestige(sph, fact);
	}

	return incr;
}


bool wubao_check_level(Wubao *w, int now)
{
	if (!w)
		return 0;

	int i = 0;
	bool changed = false;

	for(i = 0; i < BUILDING_MAX - 1; i++) {
		if (w->build[i].up_end_time > 0 && w->build[i].up_end_time <= now) {
			changed = true;
			w->build[i].level++;
			w->build[i].up_end_time = 0;
		}
	}

	for(i = 0; i < TECH_MAX - 1; i++) {
		if (w->tech[i].up_end_time > 0 && w->tech[i].up_end_time <= now) {
			changed = true;
			w->tech[i].level++;
			w->tech[i].up_end_time = 0;
		}
	}

	return changed;
}


const char *weap_name(int id)
{
	switch(id) {
		case WEAP_JIAN:
			return "铁剑";
		case WEAP_JI:
			return "长戟";
		case WEAP_GONG:
			return "手弩";
		case WEAP_DUN:
			return "木盾";
		case WEAP_PIJIA:
			return "皮甲";
		case WEAP_TIEJIA:
			return "铁甲";
		case WEAP_CHONGCHE:
			return "甲车";
		case WEAP_ZHANCHUAN:
			return "弩车";
		case WEAP_ZHANMA:
			return "战马";
		default:
			return "特殊装备";
	}
}

const char *res_name(int id)
{
	switch(id) {
		case RES_FOOD:
			return "粮食";
		case RES_WOOD:
			return "木料";
		case RES_IRON:
			return "矿石";
		case RES_HORSE:
			return "马匹";
		case RES_SKIN:
			return "皮革";
		case RES_MONEY:
			return "钱币";
		default:
			return  "未知资源";
	}
}


int wubao_level_up_build(Wubao *w)
{
	if (!w)
		return 0;

	int i = 0;
	int cnt = 0;

	for(i = 0; i < BUILDING_MAX - 1; i++) {
		if (w->build[i].up_end_time > 0 && w->build[i].up_end_time > GAME_NOW) {
			cnt++;
		}
	}

	return cnt;
}

int wubao_level_up_tech(Wubao *w)
{
	if (!w)
		return 0;

	int i = 0;
	int cnt = 0;

	for(i = 0; i < TECH_MAX - 1; i++) {
		if (w->tech[i].up_end_time > 0 && w->tech[i].up_end_time > GAME_NOW) {
			cnt++;
		}
	}

	return cnt;
}

