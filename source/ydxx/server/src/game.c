#include "hf.h"

static void parse_all_shop(const char *data, int len, void *arg, int code);

static void parse_all_city(const char *data, int len, void *arg, int code);

static void parse_all_treasure(const char *data, int len, void *arg, int code);

static void parse_all_sphere(const char *data, int len, void *arg, int code);

static void parse_all_general(const char *data, int len, void *arg, int code);

static void parse_all_diplomacy(const char *data, int len, void *arg, int code);

static void parse_all_task(const char *data, int len, void *arg, int code);

static void parse_all_box(const char *data, int len, void *arg, int code);

static void parse_all_guanka(const char *data, int len, void *arg, int code);

static void parse_all_zhanyi(const char *data, int len, void *arg, int code);


static int res_cmp(Key *k1, Key *k2);

static void game_init_running(Game *game);

static void game_init_cb(const char *buf, int len, void *arg, int code) ;

static void game_init_done(Game *g) ;

RB_GENERATE(GameTreaInfoMap, TreaInfo,  tlink, game_trea_info_map_cmp);

RB_GENERATE(GameCityMap, City,  tlink, game_city_map_cmp);

RB_GENERATE(GameGeneMap, Gene, tlink, game_gene_map_cmp);

RB_GENERATE(GameArmyMap, Army, tlink, game_army_map_cmp);

RB_GENERATE(GameSphMap, Sph, tlink, game_sph_map_cmp);

RB_GENERATE(GameUserMap, User, tlink, game_user_map_cmp);

RB_GENERATE(GameTreaMap, Trea, tlink, game_treasure_map_cmp);

RB_GENERATE(GameDiplMap, Dipl, tlink, game_dipl_map_cmp);

RB_GENERATE(GameCmdTransferMap, CmdTrans, tlink, game_cmd_transfer_map_cmp);

RB_GENERATE(GameWubaoMap, Wubao, tlink, game_wubao_map_cmp);

RB_GENERATE(GameOrderMap, Order, tlink, game_order_map_cmp);

RB_GENERATE(GameSellOrderMap, SellOrder, tlink, game_sell_order_map_cmp);

RB_GENERATE(GameTaskMap, Task, tlink, game_task_map_cmp);

RB_GENERATE(GameBoxMap, Box, tlink, game_box_map_cmp);

RB_GENERATE(GameGuankaMap, Guanka, tlink, game_guanka_map_cmp);

RB_GENERATE(GameZhanyiMap, Zhanyi, tlink, game_zhanyi_map_cmp);

RB_GENERATE(GameRoomMap, Room, tlink, game_room_map_cmp);



Game * game_new()
{
	int i =0;
	Game *g = (Game *) xmalloc(sizeof(Game));
	if (!g) 
		return NULL;

	g->init_state = GAME_INIT_NONE;
	g->start = 1;

	g->time = GAME_START_YEAR * YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR;

	RB_INIT(&g->trea_infos);
	RB_INIT(&g->cities);
	RB_INIT(&g->armies);
	RB_INIT(&g->genes);
	RB_INIT(&g->sphs);
	RB_INIT(&g->users);
	RB_INIT(&g->treas);
	RB_INIT(&g->dipls);
	RB_INIT(&g->cmd_trans);
	RB_INIT(&g->orders);
	RB_INIT(&g->sell_orders);
	RB_INIT(&g->tasks);
	RB_INIT(&g->boxes);
	RB_INIT(&g->guankas);
	RB_INIT(&g->zhanyis);
	RB_INIT(&g->rooms);

	RB_INIT(&g->user_names);
	RB_INIT(&g->sph_names);


	g->trea_info_total = 0;
	g->city_total = 0 ;
	g->gene_total  = 0;
	g->army_total = 0;
	g->sph_total  = 0;
	g->user_total = 0;
	g->trea_total = 0;
	g->cmd_transfer_total = 0;
	g->order_total = 0;
	g->sell_order_total = 0;
	g->task_total = 0;
	g->box_total = 0;
	g->guanka_total = 0;
	g->zhanyi_total = 0;
	g->room_total = 0;


	g->trea_info_num = 0;
	g->city_num = 0 ;
	g->gene_num  = 0;
	g->army_num = 0;
	g->sph_num  = 0;
	g->user_num = 0;
	g->trea_num = 0;
	g->cmd_transfer_num = 0;
	g->order_num = 0;
	g->sell_order_num = 0;
	g->task_num = 0;
	g->box_num = 0;
	g->guanka_num = 0;
	g->zhanyi_num = 0;
	g->room_num = 0;

	g->max_army_id = 0;
	g->max_gene_id = 0;
	g->max_face_id = 0;
	g->max_sph_id = 0;
	g->max_stage_id = 0;
	g->max_cmd_trans_id = 0;
	g->max_order_id = 0;
	g->max_sell_order_id = 0;
	g->max_room_id = 0;

	memset(g->rank, 0, sizeof(g->rank));

	for ( i = 0; i < RES_MAX - 1; i++) {
		key_list_init(&g->res_buy_orders[i], res_cmp);
		key_list_init(&g->res_sell_orders[i], res_cmp);
	}

	g->job_num = 0;
	TAILQ_INIT(&g->jobs);

	return g;
}

void game_free(Game *g)
{
	if (!g) 
		return ;

	safe_free(g);
}


TreaInfo * game_find_trea_info(Game *g, int id)
{
	if (!g) 
		return NULL;

	TreaInfo k;
	k.id = id;
	
	return (RB_FIND(GameTreaInfoMap, &g->trea_infos, &k));
}

bool game_add_trea_info(Game *g, TreaInfo *t)
{
	if (!(g && t))
		return false;
	if (game_find_trea_info(g, t->id)) {
		return false;
	}

	if (RB_INSERT(GameTreaInfoMap, &g->trea_infos, t))
		return false;
	g->trea_info_num++;

	return true;
}

bool game_del_trea_info(Game *g, TreaInfo *t)
{
	if (!(g && t)) 
		return false;

	if (!game_find_trea_info(g, t->id))
		return false;

	if (!RB_REMOVE(GameTreaInfoMap, &g->trea_infos, t))
		return false;
	g->trea_info_num--;

	return true;
}


City *game_find_city(Game *g, int city_id)
{
	if (!g) 
		return NULL;

	City k;
	City *r = NULL;
	
	k.id = city_id;
	if ((r = RB_FIND(GameCityMap, &g->cities, &k)))
		return r;
	return NULL;
}



City *game_find_city_by_pos(Game *g, int x, int y)
{
	if (!g) 
		return NULL;	
	City *p;

	RB_FOREACH(p, GameCityMap, &g->cities) {
		if (pos_in_city_region(x, y, p, 0)) {
			return p;
		}		
	}
	return NULL;
}


bool game_add_city(Game *g, City *city)
{
	if (!(g && city && city->id > 0))
		return false;

	Sph *sph = NULL;
	
	if (game_find_city(g, city->id)) 
		return false;

	if (RB_INSERT(GameCityMap, &g->cities, city))
		return false;

	g->city_num++;

	if (g->max_city_id < city->id) 
		g->max_city_id = city->id;

	if ((sph = game_find_sph(g, city->sph_id))) 
		sph_add_city(sph, city->id);

	return true;
}

City *game_get_random_city(Game *g)
{
	int ran  = 0;
	
	ran = gen_random(1, g->max_city_id);

	return game_find_city(g, ran);
}

bool game_add_sph(Game *g, Sph *sph)
{
	if (!(g && sph && sph->id > 0)) 
		return false;

	Name *n = NULL;

	if (game_find_sph(g, sph->id))
		return false;

	if (RB_INSERT(GameSphMap, &g->sphs, sph))
		return false;
	
	g->max_sph_id = MAX(g->max_sph_id, sph->id);
	g->sph_num++;

	if (sph->name.offset > 0 && sph->name.buf && (n = name_new(sph->name.buf))) {
		n->arg = (void *)sph->id;
		if (RB_INSERT(NameMap, &g->sph_names, n)) {
			name_free(n);
		}
	}
	return true;
}


Sph * game_find_sph_by_name(Game *g, const char *name) 
{

	if (!(g && name)) 
		return NULL;

	static Name k;
	Name *n = NULL;

	dstring_set(&k.c, name);
	if (!(n = RB_FIND(NameMap, &g->sph_names, &k)))
		return NULL;

	return game_find_sph(g, (int)n->arg);
}

bool game_del_sph(Game *g, Sph *sph)
{
	if (!(g && sph)) 
		return false;

	Name *n;
	static Name k;
    Room *r = NULL;


	if (!game_find_sph(g, sph->id))
		return false;

	if (!RB_REMOVE(GameSphMap, &g->sphs, sph))
		return false;
	g->sph_num--;

	dstring_set(&k.c, sph->name.buf);
	if ((n = RB_FIND(NameMap, &g->sph_names, &k))) {
		if(RB_REMOVE(NameMap, &g->sph_names, n)) {
			name_free(n);
		}
		
	}

    if ((r = game_find_room_by_attack_sph_id(g, sph->id))) {
        game_del_room(g, r);
        room_free(r);
        r = NULL;
    }

	return true;
}

Sph *game_find_sph(Game *g, int id)
{
	if (!g) 
		return NULL;

	Sph *r = NULL;
	Sph k;
	k.id = id;
	if (!(r = RB_FIND(GameSphMap, &g->sphs, &k))) 
		return NULL;
	return r;
}


Sph * game_find_sph_by_uid(Game *g, int uid) 
{
	if (!(g)) 
		return NULL;

	User *u = NULL;
	Wubao *w = NULL;
	Sph *sph = NULL;

	if (!(u = game_find_user(g, uid))) 
		return NULL;

	if (u->wid > 0) {
		if (!(w = game_find_wubao(g, u->wid)))
			return NULL;
		return game_find_sph(g, w->sph_id);
	} 
	else {
		RB_FOREACH(sph, GameSphMap, &g->sphs) {
			if (sph->uid == u->id)
				return sph;
		}
		return NULL;
	}

}


bool game_add_army(Game *g, Army *army)
{
	if (!(g && army))
		return false;

	if (army->state == ARMY_DEAD || army->id <= 0)
		return false;

	if (game_find_army(g, army->id))
		return false;

	if (RB_INSERT(GameArmyMap, &g->armies, army))
		return false;
	g->army_num++;

	if (army->id > g->max_army_id) 
		g->max_army_id = army->id;

	DEBUG(LOG_FMT"army %d, gene %d, state %d\n", LOG_PRE, army->id, army->gene_id, army->state);

	return true;
}

Army * game_find_army(Game *g, int id)
{
	if (!g) 
		return NULL;

	Army a ;

	a.id = id;
	return RB_FIND(GameArmyMap, &g->armies, &a);
}

Army * game_find_army_by_xy(Game *g, int x, int y)
{
	Army *a = NULL;

	RB_FOREACH(a, GameArmyMap, &g->armies) {
		if (a->x == x && a->y == y)
			return a;
	}

	return NULL;
}

bool game_del_army(Game *g, Army *a)
{
	if (!( g && a))
		return false;

	Gene *gene = NULL;
	City *city = NULL;
	Wubao *w = NULL;


	if (!game_find_army(g, a->id)) 
		return false;

	if (RB_REMOVE(GameArmyMap, &g->armies, a) == NULL) 
		return false;

	a->state = ARMY_DEAD;

	g->army_num--;
	

	if ((gene = game_find_gene(g, a->gene_id))) {
		w = game_find_wubao_by_uid(g, gene->uid);
		if (w) {
			w->res[RES_MONEY - 1] += a->money;
			w->res[RES_FOOD - 1] += a->food;
			send_nf_wubao_where(w, WHERE_ME);
		}

		if (gene->place == GENE_PLACE_ARMY && gene->place_id == a->id) {
            if (gene->sol_spirit > 100)
                gene->sol_spirit = 100;
            else if (gene->sol_spirit < 50)
                gene->sol_spirit = 50;

			if (w) {
				if (a->from_place == GENE_PLACE_CITY &&  \
						(city = game_find_city(g, a->from_place_id)) && \
						city->sph_id == w->sph_id && w->sph_id > 0) {
					gene_change_place(gene, a->from_place, a->from_place_id);
				}
				else {
					gene_change_place(gene, GENE_PLACE_WUBAO, w->id);
				}

				send_nf_gene_where(gene, WHERE_ALL);
			}
		}
	}
	
	if (a->id == g->max_army_id) 
		g->max_army_id--;
	
	DEBUG(LOG_FMT"army %d, gene id %d, state %d, from place %d:%d\n", LOG_PRE, \
			a->id, a->gene_id, a->state, a->from_place, a->from_place_id);

	return true;
}


bool game_add_gene(Game *g, Gene *gene)
{
	if (!(g && gene)) 
		return false;

	Wubao *w = NULL;
	City *city = NULL;


	if (game_find_gene(g, gene->id))
		return false;
	if (RB_INSERT(GameGeneMap, &g->genes, gene))
		return false;
	
	g->gene_num++;

	if (gene->id > g->max_gene_id)
		g->max_gene_id = gene->id;

	if (gene->face_id > g->max_face_id) 
		g->max_face_id = gene->face_id;

	
	if ((w = game_find_wubao_by_uid(g, gene->uid))) {
		wubao_add_gene(w, gene);
	}	
	
	if(gene->place == GENE_PLACE_CITY && gene->place_id > 0) {
		if ((city = game_find_city(g, gene->place_id))) {
			city_add_general(city, gene);
		}
	}
	else if (gene->place == GENE_PLACE_WUBAO && gene->place_id > 0) {
		if ((w = game_find_wubao(g, gene->place_id))) {
			wubao_add_gene(w, gene);
		}
	}

	return true;
}

Gene *game_find_gene(Game *g, int gene_id)
{
	if (!g) 
		return NULL;

	Gene *r;
	Gene k;

	k.id = gene_id;
	if (!(r = RB_FIND(GameGeneMap, &g->genes, &k))) 
		return NULL;
	return r;
}



bool game_del_gene(Game *g, Gene *gene)
{
	if (!(g && gene)) 
		return false;

	City *city = NULL;
	Trea *trea = NULL;
	Wubao *w = NULL;
	Key *k, *next;

	if (!game_find_gene(g, gene->id))
		return false;
	if (RB_REMOVE(GameGeneMap, &g->genes, gene) == NULL) 
		return false;
	g->gene_num--;

	if (gene->id == g->max_gene_id)
		g->max_gene_id--;

	if (gene->place == GENE_PLACE_CITY && (city = game_find_city(g, gene->place_id))) {
		city_del_general(city, gene);
	} 
	else if (gene->place == GENE_PLACE_WUBAO && (w = game_find_wubao(g, gene->place_id))) {
		wubao_del_gene(w, gene);
	}

	for(k = RB_MIN(KeyMap, &gene->treas); k != NULL; k = next) {
		next = RB_NEXT(KeyMap, &gene->treas, k);

		trea = game_find_trea(g, k->id);
		if (!trea) 
			continue;
		trea_recycle(trea);
		webapi_treasure(g, trea, ACTION_EDIT, NULL, NULL);
	}
	return true;
}

#define MIN_PROP 70
#define RAND_GENE_MAX_ID 600

void game_update_gene_for_wubao(Game *g, Gene *gene, Wubao *w)
{
	if (!(g && gene && w))
		return;

	if (gene->type != GENE_TYPE_NORM)
		return;

	Gene *t = NULL;
	int r, r1;
	int face_id = gene_gen_face();
	int is_vip = wubao_is_vip(w);
	int skill_id = 0;
	

	r = gen_random(0, RAND_GENE_MAX_ID);
	r1 = gen_random(0, RAND_GENE_MAX_ID);

	if ((t = game_find_gene(g, r))) {
		dstring_set(&gene->first_name, t->first_name.buf);
	}
	if ((t = game_find_gene(g, r1))) {
		dstring_set(&gene->last_name, t->last_name.buf);
	}
	
	gene->born_year = game_time_year(GAME_NOW) - gen_random(20, 40);
	gene->init_year = game_time_year(GAME_NOW);
	gene->sex = gen_random(0, 1);
	gene->face_id = face_id;
	gene->faith = 100;
	gene->speed = DEFAULT_SPEED;

	if (lua_get_init_gene(is_vip, &gene->kongfu, &gene->intel, &gene->polity, &skill_id) && \
            skill_id > SKILL_NONE && skill_id < SKILL_MAX) {
		gene->skill = 0;
		set_bit((int *)&gene->skill, skill_id - 1, 1);
	}
}

Gene *game_gen_new_gene(Game *g, Wubao *w)
{
	if (!(w && g))
		return NULL;

	Gene *gene = NULL;

	if (!(gene = gene_new()))
		return NULL;

	gene->id = g->max_gene_id + 1;
	gene->place = GENE_PLACE_WUBAO;
	gene->place_id = w->id;
	gene->fol = 2000;

	game_update_gene_for_wubao(g, gene, w);
	
	if (!game_add_gene(g, gene)){
		gene_free(gene);
		return NULL;
	}

	return gene;
}
	

bool game_add_user(Game *g, User *u)
{
	if (!(g && u)) 
		return false;
	
	Name *n = NULL;


	if (game_find_user(g, u->id))
		return false;
	if (RB_INSERT(GameUserMap, &g->users, u))
		return false;
	g->user_num++;

	
	if (u->name.offset > 0 && (n = name_new(u->name.buf))) {
		n->arg = (void *)u->id;
		if(RB_INSERT(NameMap, &g->user_names, n)) {
			name_free(n);
		}
	}
	
	return true;
}

User *game_find_user(Game *g, int id)
{
	if (!g)
		return NULL;

	User k;

	k.id = id;
	return (RB_FIND(GameUserMap, &g->users, &k));
}


bool game_del_user(Game *g, User *u)
{
	return true;
}

User * game_find_user_by_name(Game *g, const char *name)
{
	if (!(g && name)) 
		return NULL;

	static Name k;
	Name *n = NULL;

	dstring_set(&k.c, name);
	if (!(n = RB_FIND(NameMap, &g->user_names, &k)))
		return NULL;

	return game_find_user(g, (int)n->arg);

}


bool game_add_dipl(Game *g, Dipl *dipl)
{
	if (!(g && dipl)) 
		return false;

	Sph *sph = NULL;
	Sph *tar = NULL;

	if (game_find_dipl(g, dipl->id)) {
		return false;
	}
	if (RB_INSERT(GameDiplMap, &g->dipls, dipl)) 
		return false;
	g->dipl_num++;
	//insert for self sphere's diplomacy
	if ((sph = game_find_sph(g, dipl->self_id))){
		sph_add_dipl(sph, dipl->target_id, dipl->id);
	}
	if ((tar = game_find_sph(g, dipl->target_id))) {
		sph_add_dipl(tar, dipl->self_id, dipl->id);
	}
	return true;
}

Dipl *game_find_dipl(Game *g, int id)
{
	if (!g) 
		return NULL;

	Dipl k;

	k.id = id;
	return (RB_FIND(GameDiplMap, &g->dipls, &k));
}

bool game_del_dipl(Game *g, Dipl *dipl)
{
	if (!(g && dipl))
		return false;

	Sph *sph = NULL;
	Sph *tar = NULL;
	
	if (!game_find_dipl(g, dipl->id))
		return false;
	if (NULL == RB_REMOVE(GameDiplMap, &g->dipls, dipl)) {
		return false;
	}
	g->dipl_num--;

	webapi_diplomacy(g, dipl, ACTION_DEL, NULL, NULL);
	//remove diplomacy from self sphere
	if ((sph = game_find_sph(g, dipl->self_id))) {
		sph_del_dipl(sph, dipl->target_id);
	}
	if ((tar = game_find_sph(g, dipl->target_id))) {
		sph_del_dipl(tar, dipl->self_id);
	}
	return true;
}



bool game_add_cmd_trans(Game *g, CmdTrans *cmd)
{
	if (!(g && cmd)) 
		return false;

	if (game_find_cmd_trans(g, cmd->id)) 
		return false;
	if (RB_INSERT(GameCmdTransferMap, &g->cmd_trans, cmd)) {
		return false;
	}
	g->cmd_transfer_num++;

	if (cmd->id > g->max_cmd_trans_id) 
		g->max_cmd_trans_id = cmd->id;

	return true;
}
bool game_del_cmd_trans(Game *g, CmdTrans *cmd) 
{
	if (!(g && cmd)) 
		return false;

	if (!game_find_cmd_trans(g, cmd->id))
		return false;
	if (!RB_REMOVE(GameCmdTransferMap, &g->cmd_trans, cmd)) {
		return false;
	}
	g->cmd_transfer_num--;

	if (g->max_cmd_trans_id == cmd->id) 
		g->max_cmd_trans_id --;

	return true;
}
CmdTrans *game_find_cmd_trans(Game *g, int id)
{
	if (!g) 
		return NULL;

	CmdTrans k;
	k.id = id;

	return (RB_FIND(GameCmdTransferMap, &g->cmd_trans, &k));
}


bool game_add_trea(Game *g, Trea * t)
{
	if (!(g && t))
		return false;

	Gene *gene = NULL;
	Wubao *w = NULL;
	User *u = NULL;
	//int type = 0;

	if (game_find_trea(g, t->id)) 
		return false;

	/*
	type = trea_get_type(t);
	if (type == TREA_FRIE) {
		if (t->is_used == 1) {
			return false;
		}
	}
	*/

	if (RB_INSERT(GameTreaMap, &g->treas, t))
		return false;

	g->trea_num++;

	if ((gene = game_find_gene(g, t->gene_id))) {
		gene_add_trea(gene, t);
	}
	if ((u = game_find_user(g, t->uid))) {
		if((w = game_find_wubao(g, u->wid))) {
			wubao_add_trea(w, t);
		}
	}
	return true;
}

Trea * game_find_trea(Game *g, int id)
{
	if (!g)
		return NULL;
	Trea k;
	k.id = id;

	return RB_FIND(GameTreaMap, &g->treas, &k);
}

bool game_del_trea(Game *g, Trea *t)
{
	if (!(g && t))
		return false;

	Wubao *w = NULL;
	User *u = NULL;
	Gene *gene = NULL;

	if (!game_find_trea(g, t->id))
		return false;
	if (!RB_REMOVE(GameTreaMap, &g->treas, t))
		return false;
	g->trea_num--;
	
	if ((gene = game_find_gene(g, t->gene_id))) {
		gene_del_trea(gene, t);
	}
	if ((u = game_find_user(g, t->uid))) {
		if((w = game_find_wubao(g, u->wid))) {
			wubao_del_trea(w, t);
		}
	}
	return true;
}

bool game_add_wubao(Game * g, Wubao * w)
{
	if (!(g && w))
		return false;

	City *c = NULL;
	User *u = NULL;
	Sph *sph = NULL;

	if(game_find_wubao(g, w->id))
		return false;

	if (RB_INSERT(GameWubaoMap, &g->wubaos, w))
		return false;
	g->wubao_num++;


	if ((c = game_find_city(g, w->city_id))) {
		city_add_wubao(c, w);
	}
	
	if (w->uid > 0 && (u = game_find_user(g, w->uid))) {
		u->wid = w->id;
	}

	if (w->sph_id > 0 && (sph = game_find_sph(g, w->sph_id))) 
		sph_add_wubao(sph, w);
	
	if (w->rank > 0 && w->rank <= MAX_RANK && u) {
		if (g->rank[w->rank - 1] > 0) 
			w->rank = 0;
		else
			g->rank[w->rank - 1] = w->uid;
	}
	
	return true;
}

bool game_del_wubao(Game *g, Wubao *w) 
{
	if (!(g && w))
		return false;

	City *c = NULL;
	User *u = NULL;
	Sph *sph = NULL;

	if(!game_find_wubao(g, w->id))
		return false;

	if (!RB_REMOVE(GameWubaoMap, &g->wubaos, w))
		return false;
	g->wubao_num--;


	if ((c = game_find_city(g, w->city_id))) {
		city_del_wubao(c, w);
	}
	
	if (w->uid > 0 && (u = game_find_user(g, w->uid))) {
		u->wid = 0;
		webapi_user(g, 0, u, ACTION_EDIT, NULL, NULL);
	}

	if (w->sph_id > 0 && (sph = game_find_sph(g, w->sph_id))) 
		sph_del_wubao(sph, w);
	
	if (w->rank > 0 && w->rank <= MAX_RANK && u) {
		if (g->rank[w->rank - 1] > 0) 
			w->rank = 0;
		else
			g->rank[w->rank - 1] = 0;
	}
	
	return true;
}

Wubao * game_find_wubao(Game * g, int id)
{
	if (!g)
		return NULL;

	Wubao k;
	k.id = id;
	return RB_FIND(GameWubaoMap, &g->wubaos, &k);
}

Wubao * game_find_wubao_by_uid(Game *g, int id)
{
	User *u = NULL;

	if (!(u = game_find_user(g, id)))
		return NULL;
	return game_find_wubao(g, u->wid);
}

void game_reset_wubao(Game *g, Wubao *w)
{
    if (!(g && w))
        return;

    game_del_wubao(g, w);

    wubao_free(w);

}

bool game_add_order(Game *g, Order *o)
{
	Key *k = NULL;
	Wubao *w = NULL;
	
	if (!(g && o && o->res > RES_NONE && o->res < RES_MAX))
		return false;

	if (game_find_order(g, o->id))
		return false;

	if (RB_INSERT(GameOrderMap, &g->orders, o))
		return false;

	g->order_num++;

	if (g->max_order_id < o->id)
		g->max_order_id = o->id;
	
	if ((w = game_find_wubao_by_uid(g, o->uid))) {
		wubao_add_order(w, o);
	}

	if (!(k = key_new(o->id)))
		return false;
	k->arg = (void *) o->unit_money;

	if (o->type == TRADE_BUY)
		key_list_add(&g->res_buy_orders[o->res - 1], k);
	else if (o->type == TRADE_SELL) 
		key_list_add(&g->res_sell_orders[o->res - 1], k);

	DEBUG(LOG_FMT"oid %d, uid %d, type %d, res %d\n", LOG_PRE, o->id, o->uid, o->type, o->res);

	return true;
}

bool game_del_order(Game *g, Order *o)
{
	Key *k = NULL;
	Wubao *w = NULL;
	
	if (!(g && o))
		return false;

	if (!game_find_order(g, o->id))
		return false;

	if (!RB_REMOVE(GameOrderMap, &g->orders, o))
		return false;

	g->order_num--;

	if (g->max_order_id == o->id) 
		g->max_order_id --;

	o->is_del = true;
	
	if (o->type == TRADE_BUY) {
		if ((k = key_list_get(&g->res_buy_orders[o->res - 1], o->id))) {
			key_list_del(&g->res_buy_orders[o->res - 1], k);
			key_free(k);
		}
	}
	else if (o->type == TRADE_SELL) {
		if ((k = key_list_get(&g->res_sell_orders[o->res - 1], o->id))) {
			key_list_del(&g->res_sell_orders[o->res - 1], k);
			key_free(k);
		}
	}
	
	if ((w = game_find_wubao_by_uid(g, o->uid))) {
		wubao_del_order(w, o);
	}
	
	DEBUG(LOG_FMT"oid %d, uid %d, type %d, res %d\n", LOG_PRE, o->id, o->uid, o->type, o->res);
	
	return true;
}

Order * game_find_order(Game *g, int id)
{
	if (!g)
		return NULL;

	Order k;
	k.id = id;
	return RB_FIND(GameOrderMap, &g->orders, &k);
}


bool game_add_sell_order(Game *g, SellOrder *o)
{
	if (!(g && o))
		return false;

	Wubao *w = NULL;

	if (game_find_sell_order(g, o->id))
		return false;

	if (RB_INSERT(GameSellOrderMap, &g->sell_orders, o))
		return false;

	g->sell_order_num++;

	if (o->id > g->max_sell_order_id)
		g->max_sell_order_id = o->id;

	if ((w = game_find_wubao_by_uid(g, o->uid)))
		wubao_add_sell_order(w, o);


	return true;
}

bool game_del_sell_order(Game *g, SellOrder *o)
{
	if (!(g && o))
		return false;

	Wubao *w = NULL;

	if (!game_find_sell_order(g, o->id))
		return false;

	if (!RB_REMOVE(GameSellOrderMap, &g->sell_orders, o))
		return false;

	g->sell_order_num--;
	
	o->is_del = true;
	
	if (o->id == g->max_sell_order_id)
		g->max_sell_order_id--;

	if ((w = game_find_wubao_by_uid(g, o->uid)))
		wubao_del_sell_order(w, o);

	return true;
}

SellOrder * game_find_sell_order(Game *g, int id)
{
	if (!g)
		return NULL;

	SellOrder k;
	k.id = id;
	return RB_FIND(GameSellOrderMap, &g->sell_orders, &k);
}


bool game_add_task(Game *g, Task *t)
{
	if (!(g && t))
		return false;

	if (game_find_task(g, t->id))
		return false;

	if (RB_INSERT(GameTaskMap, &g->tasks, t)) 
		return false;

	g->task_num++;
	
	return true;
}

bool game_del_task(Game *g, Task *t)
{
	if (!(g && t))
		return false;

	if (!game_find_task(g, t->id))
		return false;
	
	if (!RB_REMOVE(GameTaskMap, &g->tasks, t))
		return false;

	g->task_num--;

	return true;
}

Task * game_find_task(Game *g, int id)
{
	if (!g)
		return NULL;

	Task k ;

	k.id = id;
	return RB_FIND(GameTaskMap, &g->tasks, &k);
}

bool game_add_box(Game *g, Box *t)
{
	if (!(g && t))
		return false;

	if (game_find_box(g, t->id))
		return false;

	if (RB_INSERT(GameBoxMap, &g->boxes, t)) 
		return false;

	g->box_num++;
	
	return true;
}

bool game_del_box(Game *g, Box *t)
{
	if (!(g && t))
		return false;

	if (!game_find_box(g, t->id))
		return false;
	
	if (!RB_REMOVE(GameBoxMap, &g->boxes, t))
		return false;

	g->box_num--;

	return true;
}

Box * game_find_box(Game *g, int id)
{
	if (!g)
		return NULL;

	Box k ;

	k.id = id;
	return RB_FIND(GameBoxMap, &g->boxes, &k);
}

bool game_add_guanka(Game *g, Guanka *t)
{
	if (!(g && t))
		return false;

	if (game_find_guanka(g, t->id))
		return false;

	if (RB_INSERT(GameGuankaMap, &g->guankas, t)) 
		return false;

	g->guanka_num++;
	
	return true;
}

bool game_del_guanka(Game *g, Guanka *t)
{
	if (!(g && t))
		return false;

	if (!game_find_guanka(g, t->id))
		return false;
	
	if (!RB_REMOVE(GameGuankaMap, &g->guankas, t))
		return false;

	g->guanka_num--;

	return true;
}

Guanka * game_find_guanka(Game *g, int id)
{
	if (!g)
		return NULL;

	Guanka k ;

	k.id = id;
	return RB_FIND(GameGuankaMap, &g->guankas, &k);
}

bool game_add_zhanyi(Game *g, Zhanyi *t)
{
	if (!(g && t))
		return false;

	if (game_find_zhanyi(g, t->id))
		return false;

	if (RB_INSERT(GameZhanyiMap, &g->zhanyis, t)) 
		return false;

	g->zhanyi_num++;
	
	return true;
}

bool game_del_zhanyi(Game *g, Zhanyi *t)
{
	if (!(g && t))
		return false;

	if (!game_find_zhanyi(g, t->id))
		return false;
	
	if (!RB_REMOVE(GameZhanyiMap, &g->zhanyis, t))
		return false;

	g->zhanyi_num--;

	return true;
}

Zhanyi * game_find_zhanyi(Game *g, int id)
{
	if (!g)
		return NULL;

	Zhanyi k ;

	k.id = id;
	return RB_FIND(GameZhanyiMap, &g->zhanyis, &k);
}

bool game_add_room(Game *g, Room *t)
{
	if (!(g && t))
		return false;

	if (game_find_room(g, t->id))
		return false;

	if (RB_INSERT(GameRoomMap, &g->rooms, t)) 
		return false;

    if (t->id > g->max_room_id)
        g->max_room_id = t->id;

	g->room_num++;
	
	return true;
}

bool game_del_room(Game *g, Room *t)
{
	if (!(g && t))
		return false;

	if (!game_find_room(g, t->id))
		return false;
	
	if (!RB_REMOVE(GameRoomMap, &g->rooms, t))
		return false;

	g->room_num--;

	return true;
}

Room * game_find_room(Game *g, int id)
{
	if (!g)
		return NULL;

	Room k;

	k.id = id;
	return RB_FIND(GameRoomMap, &g->rooms, &k);
}

void game_find_room_num_by_uid(Game *g, int uid, int *attack_num, int *defense_num)
{
    if (!g)
        return;

    Room *r = NULL;
    int attack = 0;
    int defense = 0;
    int i = 0;

    RB_FOREACH(r, GameRoomMap, &g->rooms) {
        for (i = 0; i < ROOM_USER_NUM; i++) {
            if (r->attack_uid[i] == uid)
                attack++;
        }
        for (i = 0; i < ROOM_USER_NUM; i++) {
            if (r->defense_uid[i] == uid)
                defense++;
        }
    }

    if (attack_num)
        *attack_num = attack;
    if (defense_num)
        *defense_num = defense;
}

Room * game_find_room_by_city_id(Game *g, int city_id)
{
    if (!g)
        return NULL;

    Room *r = NULL;

    RB_FOREACH(r, GameRoomMap, &g->rooms) {
        if (r->city_id == city_id)
            return r;
    }

    return NULL;
}

Room * game_find_room_by_attack_sph_id(Game *g, int sph_id)
{
    if (!g)
        return NULL;

    Room *r = NULL;

    RB_FOREACH(r, GameRoomMap, &g->rooms) {
        if (r->attack_sph_id == sph_id)
            return r;
    }

    return NULL;
}

int game_find_room_num_by_defense_sph_id(Game *g, int sph_id)
{
    if (!g)
        return 0;

    Room *r = NULL;
    int num = 0;

    RB_FOREACH(r, GameRoomMap, &g->rooms) {
        if (r->defense_sph_id == sph_id)
            num++;
    }

    return num;
}



void game_rerank(Game *g)
{
	if (!g)
		return;

	Wubao *w;
	User *u = NULL;
	int rank = 0;

	if ((rank = game_get_rank(g)) > 0) {
		RB_FOREACH(w, GameWubaoMap, &g->wubaos) {
			if (!(u = game_find_user(g, w->uid))) {
				w->rank = 0;
				continue;
			}

			if (w->rank <= 0) {
				if(!game_alloc_rank(g, w))
					break;
			}
		}
	}

}

int game_get_rank(Game *g)
{
	int i = 0;

	for(i = 0; i < MAX_RANK; i++) {
		if (g->rank[i] <= 0) 
			return i + 1;
	}

	return 0;
}

bool game_alloc_rank(Game *g, Wubao *w)
{
	if (!(g && w && w->rank <= 0))
		return false;

	int r = 0;

	if ((r = game_get_rank(g)) <= 0) 
		return false;

	if (r > MAX_RANK) 
		return false;

	w->rank = r;
	g->rank[r-1] = w->uid;
	return true;
}

void game_trans_rank(Game *g, Wubao *w, Wubao *w1)
{
	if (!(g && w && w1))
		return;

	int rank = 0;

	rank = w->rank;
	w->rank = w1->rank;
	if (w->rank > 0 && w->rank<= MAX_RANK) 
		g->rank[w->rank - 1] = w->uid;

	w1->rank = rank;
	if (w1->rank > 0 && w1->rank<= MAX_RANK) 
		g->rank[w1->rank - 1] = w1->uid;
}

bool game_add_job(Game *g, Job *p)
{
	if (!(g && p))
		return false;

	TAILQ_INSERT_TAIL(&g->jobs, p, link);
	g->job_num++;

	return true;
}


static  void game_init_cb(const char *buf, int len, void *arg, int code) 
{
	bool go_next = false;
	Game *g = GAME;

	if (code != HTTP_OK) {
		WARN(LOG_FMT"failed to run %d\n", LOG_PRE, g->init_state);
		game_init_running(g);
		return;
	}

	DEBUG(LOG_FMT"run %d\n", LOG_PRE, g->init_state);
	switch (g->init_state) {
		case GAME_INIT_SHOP:
			parse_all_shop(buf, len, NULL, code);
			DEBUG(LOG_FMT"load shop data, total %d, now %d\n",  \
						LOG_PRE, g->trea_info_total, g->trea_info_num);
			if (g->trea_info_total <= g->trea_info_num) {
				go_next = true;
			}
			break;
		case GAME_INIT_USER:
			parse_all_user(buf, len, NULL, code);
			if (g->user_total <= g->user_num){
				DEBUG(LOG_FMT"finish load user data, total %d, now %d\n", \
						LOG_PRE, g->user_total, g->user_num);
				go_next = true;
			}
			break;
		case GAME_INIT_SPHERE:
			parse_all_sphere(buf, len, NULL, code);
			DEBUG(LOG_FMT"load sphere data, total %d, now %d\n",  \
						LOG_PRE, g->sph_total, g->sph_num);
			if (g->sph_total <= g->sph_num){
				go_next = true;
			}
			break;
		case GAME_INIT_CITY :
			parse_all_city(buf, len, NULL, code);
			if (g->city_total <= g->city_num){
				DEBUG(LOG_FMT"finish load city data, total %d, now %d\n",  \
						LOG_PRE, g->city_total, g->city_num);
				go_next = true;
			}
			break;
		case GAME_INIT_WUBAO:
			parse_all_wubao(buf, len, NULL, code);
			DEBUG(LOG_FMT"load wubao data, total %d, now %d\n", \
					LOG_PRE, g->wubao_total, g->wubao_num);
			if (g->wubao_total <= g->wubao_num) {
				DEBUG(LOG_FMT"finish load wubao data, total %d, now %d\n", \
					LOG_PRE, g->wubao_total, g->wubao_num);
				go_next = true;
			}
			break;
		case GAME_INIT_GENE:
			parse_all_general(buf, len, NULL, code);
			if (g->gene_total <= g->gene_num){
				DEBUG(LOG_FMT"finish load general data, total %d, now %d\n", 
								LOG_PRE, g->gene_total, g->gene_num);
				go_next = true;
			}
			break;
		case GAME_INIT_ARMY:
			if (g->army_total <= g->army_num){
				DEBUG(LOG_FMT"finish load army data, total %d, now %d\n", 
								LOG_PRE, g->army_total, g->army_num);
				go_next = true;
			}
			break;
		case GAME_INIT_TREA:
			parse_all_treasure(buf, len, NULL, code);
			if (g->trea_total <= g->trea_num){
				DEBUG(LOG_FMT"finish load treasure data, total %d, now %d\n",  \
								LOG_PRE, g->trea_total, g->trea_num);
				go_next = true;
			}
			break;
		case GAME_INIT_DIPL:
			parse_all_diplomacy(buf, len, NULL, code);
			if (g->dipl_total <= g->dipl_num){
				DEBUG(LOG_FMT"finish load diplomacy data, total %d\n",  \
								LOG_PRE, g->dipl_total);
				go_next = true;
			}
			break;
		case GAME_INIT_CMD_TRANSFER:
			if (g->cmd_transfer_total <= g->cmd_transfer_num){
				DEBUG(LOG_FMT"finish load cmd transfer data, total %d\n",  \
								LOG_PRE, g->cmd_transfer_total);
				go_next = true;
			}
			break;
		case GAME_INIT_ORDER:
			if (g->order_total <= g->order_num){
				DEBUG(LOG_FMT"finish load order data, total %d, num %d\n", \
								LOG_PRE, g->order_total, g->order_num);
				go_next = true;
			}
			break;
		case GAME_INIT_SELL_ORDER:
			if (g->sell_order_total <= g->sell_order_num){
				DEBUG(LOG_FMT"finish load sell order data, total %d, num %d\n",  \
								LOG_PRE, g->sell_order_total, g->sell_order_num);
				go_next = true;
			}
			break;
		case GAME_INIT_TASK:
			parse_all_task(buf, len, NULL, code);
			if (g->task_total <= g->task_num){
				DEBUG(LOG_FMT"finish load task data, total %d, num %d\n",  \
								LOG_PRE, g->task_total, g->task_num);
				go_next = true;
			}
			break;
		case GAME_INIT_GUANKA:
			parse_all_guanka(buf, len, NULL, code);
			if (g->guanka_total <= g->guanka_num){
				parse_sdb(SDB_GUANKA, &g_cycle->sdb_shm[SDB_GUANKA - 1], g);

				DEBUG(LOG_FMT"finish load guanka data, total %d, num %d\n",  \
								LOG_PRE, g->guanka_total, g->guanka_num);
				go_next = true;
			}
			break;
		case GAME_INIT_BOX:
			parse_all_box(buf, len, NULL, code);
			if (g->box_total <= g->box_num){
				DEBUG(LOG_FMT"finish load box data, total %d, num %d\n",  \
								LOG_PRE, g->box_total, g->box_num);
				go_next = true;
			}
			break;
		case GAME_INIT_ZHANYI:
			parse_all_zhanyi(buf, len, NULL, code);
			if (g->zhanyi_total <= g->zhanyi_num){
				DEBUG(LOG_FMT"finish load zhanyi data, total %d, num %d\n",  \
								LOG_PRE, g->zhanyi_total, g->zhanyi_num);
				go_next = true;
			}
			break;
		case GAME_INIT_ROOM:
			if (g->room_total <= g->room_num){
				DEBUG(LOG_FMT"finish load room data, total %d, num %d\n",  \
								LOG_PRE, g->room_total, g->room_num);
				go_next = true;
			}
			break;
		default:
			break;
	}
	
	if (go_next) {
		g->start = 1;
		g->init_state ++;
	} 
	else {
		if (buf == NULL || len == 0) 
			g->start = 1;
		else
			g->start += GET_STEP_COUNT;
	}
	
	game_init_running(g);
}

static void game_init_running(Game *game)
{
	if (!game)
		return;
	

	if (game->init_state == GAME_INIT_SHOP) {
		webapi_shop(game, ACTION_GET, game_init_cb, game);
	}
	else if (game->init_state == GAME_INIT_SPHERE) {
		if (parse_sdb(SDB_SPH, &g_cycle->sdb_shm[SDB_SPH - 1], game) == false) {
			webapi_sphere(game, ACTION_GET, game_init_cb, game);
			return;
		}
		game_init_cb(NULL, 0, game, 200);
	} 
	else if (game->init_state == GAME_INIT_USER) {
		webapi_user(game, 0, NULL, ACTION_GET, game_init_cb, game);
	} 
	else if (game->init_state == GAME_INIT_CITY) {
		if (parse_sdb(SDB_CITY, &g_cycle->sdb_shm[SDB_CITY - 1], game) == false) {
			webapi_city(game, ACTION_GET, game_init_cb, game);
			return;
		}
		game_init_cb(NULL, 0, game, 200);
	}
	else if (game->init_state == GAME_INIT_WUBAO) {
		if (parse_sdb(SDB_WUBAO, &g_cycle->sdb_shm[SDB_WUBAO - 1], game) == false) {
			webapi_wubao(game, ACTION_GET, game_init_cb, game);
			return;
		}
		game_init_cb(NULL, 0, game, 200);
	}
	else if (game->init_state == GAME_INIT_GENE) {
		if (parse_sdb(SDB_GENE, &g_cycle->sdb_shm[SDB_GENE - 1], game) == false) {
			webapi_general(game, ACTION_GET, game_init_cb, game);
			return;
		}
		game_init_cb(NULL, 0, game, 200);
	} 
	else if (game->init_state == GAME_INIT_TREA) {
		webapi_treasure(game, NULL, ACTION_GET, game_init_cb, game);
	} 
	else if (game->init_state == GAME_INIT_ARMY) {
		
		parse_sdb(SDB_ARMY, &g_cycle->sdb_shm[SDB_ARMY - 1], game);

		game_init_cb(NULL, 0, game, 200);
	} 
	else if (game->init_state == GAME_INIT_DIPL) {
		webapi_diplomacy(game, NULL, ACTION_GET, game_init_cb, game);
    } 
	else if (game->init_state == GAME_INIT_CMD_TRANSFER) {
		parse_sdb(SDB_CMD_TRANS, &g_cycle->sdb_shm[SDB_CMD_TRANS - 1], game);

		game_init_cb(NULL, 0, game, 200);
	} 
	else if (game->init_state == GAME_INIT_ORDER) {
		parse_sdb(SDB_ORDER, &g_cycle->sdb_shm[SDB_ORDER - 1], game);

		game_init_cb(NULL, 0, game, 200);
	} 
	else if (game->init_state == GAME_INIT_SELL_ORDER) {
		parse_sdb(SDB_SELL_ORDER, &g_cycle->sdb_shm[SDB_SELL_ORDER - 1], game);

		game_init_cb(NULL, 0, game, 200);
	} 
	else if (game->init_state == GAME_INIT_TASK) {
		webapi_task(game, ACTION_GET, game_init_cb, game);
	}
	else if (game->init_state == GAME_INIT_GUANKA) {
		webapi_guanka(game, ACTION_GET, game_init_cb, game);
	}
	else if (game->init_state == GAME_INIT_BOX) {
		webapi_box(game, ACTION_GET, game_init_cb, game);
	}
	else if (game->init_state == GAME_INIT_ZHANYI) {
		webapi_zhanyi(game, ACTION_GET, game_init_cb, game);
	}
	else if (game->init_state == GAME_INIT_ROOM) {
		parse_sdb(SDB_ROOM, &g_cycle->sdb_shm[SDB_ROOM - 1], game);

		game_init_cb(NULL, 0, game, 200);
	}
	else if (game->init_state == GAME_INIT_FIN) {
		game_init_done(game);
	}
}

void game_init(Game *g)
{
	if (!g) 
		return;
	if (g->init_state != GAME_INIT_NONE) 
		return;

	/*
	 * first get game time
	 */
	parse_sdb(SDB_TIME, &g_cycle->sdb_shm[SDB_TIME - 1], g);

	g->init_state = GAME_INIT_NONE + 1;

	game_init_running(g);
}

static void game_init_done(Game *g) 
{
	GameConn *conn = NULL;
	FlexConn *flex_conn = NULL;
	int fd = -1;
	Conf *c = g_cycle->conf;
	
	if (!g)
		return;

	DEBUG(LOG_FMT"game init done, %d\n", LOG_PRE, g->init_state);

	if (g_opt_up_shm) {
		worker_exit();
		return;
	}

	game_rerank(g);

	/*
	 * listen game connection
	 */

	if ( -1 == (fd = network_listen(c->core.addr, c->core.port))) {
		ERROR(LOG_FMT"listen game connection %s:%d: %s\n", LOG_PRE, \
				c->core.addr, c->core.port, error_string());
		goto error;
	}
	if (!(conn = game_conn_new(fd, DEF_EV_TIMEOUT, CONN_LISTEN, game_conn_accept, NULL, NULL, NULL))) {
		goto error;
	}
	cycle_add_game_conn(g_cycle, conn);


	/*
	 * listen flex secure connection
	 */
	if ( -1 == (fd = network_listen(c->flex.addr, c->flex.port))) {
		ERROR(LOG_FMT"listen flex connection %s:%d error\n", LOG_PRE, \
				c->flex.addr, c->flex.port, error_string());
		goto error;
	}
	if (!(flex_conn = flex_conn_new(fd, DEF_EV_TIMEOUT, CONN_LISTEN, flex_conn_accept, NULL, NULL, NULL))) {
		goto error;
	}
	cycle_add_flex_conn(g_cycle, flex_conn);

	if(!job_run())
		goto error;

	up_reg();

	return;

error:

	worker_exit();
}


static void parse_all_shop(const char * data, int len, void * arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	TreaInfo *tr= NULL;

	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->trea_info_total <= 0) {
		g->trea_info_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {
		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(tr = xmalloc(sizeof(TreaInfo)))) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");
		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;
	
	
			if (!strcasecmp(name, "id")) 
				tr->id = atoi(value);
			else if (!strcasecmp(name, "type"))
				tr->type = atoi(value);
			else if (!strcasecmp(name, "level"))
				tr->level = atoi(value);
			else if (!strcasecmp(name, "name"))
				tr->name = strdup_safe(name);
			else if (!strcasecmp(name, "num"))
				tr->num = atoi(value);

		}
		if (game_add_trea_info(g, tr) == false) {
			free(tr);
		} 
	}
}


static void parse_all_treasure(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	Trea *tr= NULL;

	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->trea_total <= 0) {
		g->trea_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {
		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(tr = trea_new(0, 0, 0))) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");
		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;
	
	
			if (!strcasecmp(name, "id")) 
				tr->id = atoi(value);
			else if (!strcasecmp(name, "treasure_id"))
				tr->trea_id = atoi(value);
			else if (!strcasecmp(name, "general_id"))
				tr->gene_id = atoi(value);
			else if (!strcasecmp(name, "user_id"))
				tr->uid = atoi(value);
			else if (!strcasecmp(name, "is_used"))
				tr->is_used = atoi(value);
			else if (!strcasecmp(name, "use_time"))
				tr->use_time = atoi(value);

		}
		if (game_add_trea(g, tr) == false) {
			trea_free(tr);
		} 
	}
}

static void parse_all_sphere(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	Sph *sph = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->sph_total <= 0) {
		g->sph_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {
		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(sph = sph_new())) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");
		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;
	
			if (!strcasecmp(name, "id")) 
				sph->id = atoi(value);
			else if (!strcasecmp(name, "user_id")) 
				sph->uid = atoi(value);
			else if (!strcasecmp(name,"name"))
				dstring_set(&sph->name, value);
			else if (!strcasecmp(name, "level")) 
				sph->level = atoi(value);
			else if (!strcasecmp(name, "prestige")) 
				sph->prestige = atoi(value);
			else if (!strcasecmp(name, "is_npc"))
				sph->is_npc = atoi(value);
			else if (!strcasecmp(name, "description")) 
				dstring_set(&sph->desc, value);
		}
		if (game_add_sph(g, sph) == false) {
			sph_free(sph);
		} 
	}
}


static void parse_all_diplomacy(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	Dipl *dipl = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->dipl_total <= 0) {
		g->dipl_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {
		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(dipl = dipl_new(0, 0, 0, 0, 0))) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");
		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;
			
			if (!strcasecmp(name, "id")) 
				dipl->id = atoi(value);
			else if (!strcasecmp(name,"type"))
				dipl->type = atoi(value);
			else if (!strcasecmp(name,"self_id"))
				dipl->self_id = atoi(value);
			else if (!strcasecmp(name,"target_id"))
				dipl->target_id = atoi(value);
			else if (!strcasecmp(name,"start"))
				dipl->start = atoi(value);
			else if (!strcasecmp(name,"end"))
				dipl->end = atoi(value);


		}
		if (game_add_dipl(g, dipl) == false) {
			dipl_free(dipl);
		} 
	}
}

static void parse_all_city(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	City *city = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->city_total <= 0) {
		g->city_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {
		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(city = city_new())) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");
		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;

			if (!strcasecmp(name, "id")) 
				city->id = atoi(value);
			else if (!strcasecmp(name,"name"))
				dstring_set(&city->name, value);
			else if (!strcasecmp(name,"level"))
				city->level = atoi(value);
			else if (!strcasecmp(name,"jun_name"))
				dstring_set(&city->jun_name, value);
			else if (!strcasecmp(name,"zhou_name"))
				dstring_set(&city->zhou_name, value);
			else if (!strcasecmp(name, "description"))
				dstring_set(&city->desc, value);
			else if (!strcasecmp(name,"sphere_id"))
				city->sph_id = atoi(value);
			else if (!strcasecmp(name,"defense"))
				city->defense = atof(value);
			else if (!strcasecmp(name,"x"))
				city->x = atoi(value);
			else if (!strcasecmp(name,"y"))
				city->y = atoi(value);
			else if (!strcasecmp(name, "zhou_code")) 
				city->zhou_code = atoi(value);
			else if (!strcasecmp(name, "jun_code"))
				city->jun_code = atoi(value);
			else if (!strcasecmp(name, "is_alloted"))
				city->is_alloted = atoi(value);
		}

		city->sol = city->level * CITY_SOL;
		city->defense = city->level * CITY_DEFENSE;
	
		if (!game_add_city(g, city)) {
			city_free(city);
		} 
	}
}


void parse_all_wubao(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	Wubao*w = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->wubao_total <= 0) {
		g->wubao_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {
		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(w = wubao_new())) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");
		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;

			if (!strcasecmp(name, "id")) 
				w->id = atoi(value);
			else if (!strcasecmp(name,"user_id"))
				w->uid = atoi(value);
			else if (!strcasecmp(name, "people"))
				w->people = atoi(value);
			else if (!strcasecmp(name, "family"))
				w->family = atoi(value);
			else if (!strcasecmp(name, "prestige"))
				w->prestige= atoi(value);
			else if (!strcasecmp(name, "city_id"))
				w->city_id = atoi(value);
			else if (!strcasecmp(name, "sphere_id"))
				w->sph_id = atoi(value);
			else if (!strcasecmp(name, "dig_id"))
				w->dig_id = atoi(value);
			else if (!strcasecmp(name, "off_id"))
				w->off_id = atoi(value);
			else if (!strcasecmp(name, "money"))
				w->res[RES_MONEY - 1] = atoi(value);
			else if (!strcasecmp(name, "food"))
				w->res[RES_FOOD - 1]= atoi(value);
			else if (!strcasecmp(name, "wood"))
				w->res[RES_WOOD - 1]= atoi(value);
			else if (!strcasecmp(name, "iron"))
				w->res[RES_IRON - 1]= atoi(value);
			else if (!strcasecmp(name, "skin"))
				w->res[RES_SKIN - 1]= atoi(value);
			else if (!strcasecmp(name, "horse"))
				w->res[RES_HORSE - 1]= atoi(value);
			else if (!strcasecmp(name, "used_made"))
				w->used_made = atoi(value);
			else if (!strcasecmp(name, "gongxun"))
				w->gx = atoi(value);
		}
		if (game_add_wubao(g, w) == false) {
			wubao_free(w);
		} 
	}

}


void parse_all_user(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	User *user= NULL;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	User *old = NULL;

	//get total
	if (!data)
		return;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return;
	if (g->user_total <= 0) {
		g->user_total = atoi(t->buf);
	}
	offset += t->offset;
	for((t = read_line(start + offset, len - offset)); \
					t && offset <=  len; \
					t = read_line(start + offset, len - offset)) {
		char *token = NULL;
		char *last = NULL;
		
		offset += t->offset;
		dstring_strip((dstring *)t, "\r\n\t ");
		
		if (!(user = user_new())) 
			continue;
		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;

			if (!strcasecmp(name, "id")) 
				user->id = atoi(value);
			if (!strcasecmp(name, "name"))
				dstring_set(&user->name, value);
			else if (!strcasecmp(name, "vip_total_hour")) 
				user->vip_total_hour = atoi(value);
			else if (!strcasecmp(name, "vip_used_hour")) 
				user->vip_used_hour = atoi(value);
			else if (!strcasecmp(name, "online_second")) {
				user->online_second = (uint) strtoul(value, NULL, 10);
            }
			else if (!strcasecmp(name, "is_locked")) {
				user->is_locked = atoi(value);
			}
		}
		if ((old = game_find_user(g, user->id))) {
			old->vip_total_hour = user->vip_total_hour;
			user_free(user);
		}
		else if (!game_add_user(g, user)) {
			user_free(user);
		}
	}
}


static void parse_all_general(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	Gene *general = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->gene_total <= 0) {
		g->gene_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {
		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(general = gene_new())) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");

		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				continue;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			if(!(value = decode_uri(v)))
				continue;

			if (!strcasecmp(name, "id")) {
				general->id = atoi(value);
			}
			else if (!strcasecmp(name,"user_id")) {
				general->uid = atoi(value);
			}
			else if (!strcasecmp(name,"type")) {
				general->type = atoi(value);
			}
			else if (!strcasecmp(name,"first_name")) {
				dstring_set(&general->first_name, value);
			}
			else if (!strcasecmp(name,"last_name")) {
				dstring_set(&general->last_name, value);
			}
			else if (!strcasecmp(name,"zi")) {
				dstring_set(&general->zi, value);
			} 
			else if (!strcasecmp(name,"sex")) {
				general->sex = atoi(value);
			}
			else if (!strcasecmp(name,"born_year")) {
				general->born_year = atoi(value); 
			}
			else if (!strcasecmp(name, "init_year")) {
				general->init_year = atoi(value);
			}
			else if (!strcasecmp(name,"place")) {
				general->place = atoi(value);
			}
			else if (!strcasecmp(name,"place_id")) {
				general->place_id = atoi(value);
			}
			else if (!strcasecmp(name,"kongfu")) {
				general->kongfu = atoi(value);
			}
			else if (!strcasecmp(name,"polity")) {
				general->polity = atoi(value);
			}
			else if (!strcasecmp(name,"intelligence")) {
				general->intel = atoi(value);
			}
			else if (!strcasecmp(name,"speed")) {
				general->speed = atoi(value);
			}  
			else if (!strcasecmp(name,"faith")) {
				general->faith = atoi(value);
			}  
			else if (!strcasecmp(name,"face_id")) {
				general->face_id = atoi(value);
			}
			else if (!strcasecmp(name,"is_dead")) {
				general->is_dead = atoi(value);
			}
			else if (!strcasecmp(name,"friendly")) {
				general->fri = atoi(value);
			}
			else if (!strcasecmp(name, "skill")) {
				general->skill = strtoul(value, 0, 10);
			}
			else if (!strcasecmp(name, "zhen")) {
				general->zhen = strtoul(value, 0, 10);
			}
			else if (!strcasecmp(name, "cur_used_zhen")) {
				general->used_zhen = atoi(value);
			}
			else if (!strcasecmp(name, "solider_num")) {
				general->sol_num = atoi(value);
			}
			else if (!strcasecmp(name, "solider_spirit")) {
				general->sol_spirit = atoi(value);
			}
			else if (!strcasecmp(name, "hurt_num")) {
				general->hurt_num = atoi(value);
			}
			else if (!strcasecmp(name, "level")) {
				general->level = atoi(value);
			}
			else if (!strcasecmp(name, "experience")) {
				general->level_percent = atoi(value);
			}
			else if (!strcasecmp(name, "w1_type")) {
				general->weap[0].id = atoi(value);
			}
			else if (!strcasecmp(name, "w1_level")) {
				general->weap[0].level = atoi(value);
			}
			else if (!strcasecmp(name, "w2_type")) {
				general->weap[1].id = atoi(value);
			}
			else if (!strcasecmp(name, "w2_level")) {
				general->weap[1].level = atoi(value);
			}
			else if (!strcasecmp(name, "w3_type")) {
				general->weap[2].id = atoi(value);
			}
			else if (!strcasecmp(name, "w3_level")) {
				general->weap[2].level = atoi(value);
			}
			else if (!strcasecmp(name, "w4_type")) {
				general->weap[3].id = atoi(value);
			}
			else if (!strcasecmp(name, "w4_level")) {
				general->weap[3].level = atoi(value);
			}
		}
		if (!game_add_gene(g, general)) {
			gene_free(general);
		} 
	}
}

#if 0
static void parse_cmd_transfer(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	CmdTrans *cmd = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->cmd_transfer_total <= 0) {
		g->cmd_transfer_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {

		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(cmd = cmd_trans_new1())) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");

		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;

			if (!strcasecmp(name, "id")) 
				cmd->id = atoi(value);
			else if (!strcasecmp(name,"from__id"))
				cmd->from_id= atoi(value);
			else if (!strcasecmp(name,"to_id"))
				cmd->to_id= atoi(value);
			else if (!strcasecmp(name, "type")) 
				cmd->type = atoi(value);
			else if (!strcasecmp("sphere_id", name)) 
				cmd->sph_id = atoi(value); 
			else if (!strcasecmp("goods_type", name)) 
				cmd->good_type = atoi(value); 
			else if (!strcasecmp("goods_id", name)) 
				cmd->good_id = atoi(value); 
			else if (!strcasecmp("goods_num", name)) 
				cmd->good_num = atoi(value); 
			else if (!strcasecmp(name, "end_time"))
				cmd->end = atoi(value);

		}
		if (game_add_cmd_trans(g, cmd) == false) {
			cmd_trans_free(cmd);
		} 
	}
}

#endif

static void parse_all_task(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	Task *ta = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->task_total <= 0) {
		g->task_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {

		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(ta = task_new())) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");

		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;

			if (!strcasecmp(name, "id")) 
				ta->id = atoi(value);
			else if (!strcasecmp(name,"before_id"))
				ta->before_id = atoi(value);
			else if (!strcasecmp(name,"type"))
				ta->type = atoi(value);
			else if (!strcasecmp("num1", name)) 
				ta->num[0] = atoi(value); 
			else if (!strcasecmp("num2", name)) 
				ta->num[1] = atoi(value); 
			else if (!strcasecmp("num3", name)) 
				ta->num[2] = atoi(value); 
			else if (!strcasecmp("prestige", name)) 
				ta->prestige = atoi(value); 
			else if (!strcasecmp("res1", name)) 
				ta->res[0] = atoi(value); 
			else if (!strcasecmp("res2", name)) 
				ta->res[1] = atoi(value); 
			else if (!strcasecmp("res3", name)) 
				ta->res[2] = atoi(value); 
			else if (!strcasecmp("res4", name)) 
				ta->res[3] = atoi(value); 
			else if (!strcasecmp("res5", name)) 
				ta->res[4] = atoi(value); 
			else if (!strcasecmp("res6", name)) 
				ta->res[5] = atoi(value); 
			else if (!strcasecmp("tre1", name)) 
				ta->trea[0] = atoi(value); 
			else if (!strcasecmp("tre2", name)) 
				ta->trea[1] = atoi(value); 
			else if (!strcasecmp("tre3", name)) 
				ta->trea[2] = atoi(value); 
			else if (!strcasecmp("tre4", name)) 
				ta->trea[3] = atoi(value); 
			else if (!strcasecmp("tre5", name)) 
				ta->trea[4] = atoi(value); 
			else if (!strcasecmp("solider", name)) 
				ta->sol = atoi(value); 
			else if (!strcasecmp("gold", name)) 
				ta->gold = atoi(value); 

		}
		if (!game_add_task(g, ta)) {
			task_free(ta);
		} 
	}
}

static void parse_all_box(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	Box *b = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->box_total <= 0) {
		g->box_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {

		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(b = box_new())) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");

		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;

			if (!strcasecmp(name, "id")) 
				b->id = atoi(value);
			else if (!strcasecmp(name,"name"))
				dstring_set(&b->name, value);
			else if (!strcasecmp(name,"level"))
				b->level = atoi(value);
			else if (!strcasecmp("face_id", name)) 
				b->face_id = atoi(value); 
			else if (!strcasecmp("skill", name)) 
				b->skill = strtoul(value, NULL, 10); 
			else if (!strcasecmp("zhen", name)) 
				b->zhen = atoi(value); 
			else if (!strcasecmp("kongfu", name)) 
				b->kongfu = atoi(value); 
			else if (!strcasecmp("intelligence", name)) 
				b->intel = atoi(value); 
			else if (!strcasecmp("polity", name)) 
				b->polity = atoi(value); 
			else if (!strcasecmp("solider", name)) 
				b->sol = atoi(value); 
			else if (!strcasecmp("spirit", name)) 
				b->spirit = atof(value); 
			else if (!strcasecmp("train", name)) 
				b->train = atof(value); 
			else if (!strcasecmp(name, "w1_type")) {
				b->weap[0].id = atoi(value);
			}
			else if (!strcasecmp(name, "w1_level")) {
				b->weap[0].level = atoi(value);
			}
			else if (!strcasecmp(name, "w2_type")) {
				b->weap[1].id = atoi(value);
			}
			else if (!strcasecmp(name, "w2_level")) {
				b->weap[1].level = atoi(value);
			}
			else if (!strcasecmp(name, "w3_type")) {
				b->weap[2].id = atoi(value);
			}
			else if (!strcasecmp(name, "w3_level")) {
				b->weap[2].level = atoi(value);
			}
			else if (!strcasecmp(name, "w4_type")) {
				b->weap[3].id = atoi(value);
			}
			else if (!strcasecmp(name, "w4_level")) {
				b->weap[3].level = atoi(value);
			}
			else if (!strcasecmp("cd", name)) 
				b->sleep_hour = atoi(value); 

		}
		if (!game_add_box(g, b)) {
			box_free(b);
		} 
	}
}

static void parse_all_guanka(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	Guanka *b = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->guanka_total <= 0) {
		g->guanka_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {

		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(b = guanka_new())) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");

		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;

			if (!strcasecmp(name, "id")) 
				b->id = atoi(value);
			else if (!strcasecmp(name,"name"))
				dstring_set(&b->name, value);
			else if (!strcasecmp("prestige", name)) 
				b->gx = atoi(value); 
			else if (!strcasecmp("type", name)) 
				b->weap_id = atoi(value); 
			else if (!strcasecmp("level", name)) 
				b->weap_level = atoi(value); 
			else if (!strcasecmp("num", name)) 
				b->weap_num = atoi(value); 
			else if (!strcasecmp("times", name)) 
				b->total = atoi(value); 
			else if (!strcasecmp("percent", name)) 
				b->percent = atoi(value); 
			else if (!strcasecmp("cd", name)) 
				b->cd = atoi(value); 
			else if (!strcasecmp("x", name)) 
				b->x = atoi(value); 
			else if (!strcasecmp("y", name)) 
				b->y = atoi(value); 
			else if (!strcasecmp("zy_id", name)) 
				b->zy_id = atoi(value); 

		}
		if (!game_add_guanka(g, b)) {
			guanka_free(b);
		} 
	}
}

static void parse_all_zhanyi(const char *data, int len, void *arg, int code)
{
	Game *g = GAME;
	const dstring *t = NULL;
	char *start = NULL;
	int offset = 0;
	Zhanyi *b = NULL;


	//get total
	if (!data)
		return ;
	start = (char *)data;
	if ((t = read_line(start, len)) == 0) 
		return ;
	offset += t->offset;
	if (g->zhanyi_total <= 0) {
		g->zhanyi_total = atoi(t->buf);
	}

	for((t = read_line(start + offset, len - offset)); \
			t && offset <= len; \
			t = read_line(start + offset, len - offset)) {

		char *token = NULL;
		char *last = NULL;

		offset += t->offset;

		if (!(b = zhanyi_new())) {
			continue;
		}

		dstring_strip((dstring *)t, "\r\n\t ");

		for (token = strtok_r(t->buf, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
			char *name, *last1, *v;
			const char *value = NULL;

			name = last1 = NULL;
			if (NULL == (name = strtok_r(token, "=", &last1))) 
				break;
			if (NULL == (v = strtok_r(NULL, "=", &last1))) 
				continue;
			value = decode_uri(v);
			if(!value)
				continue;

			if (!strcasecmp(name, "id")) 
				b->id = atoi(value);
			else if (!strcasecmp(name,"pic_u1"))
				dstring_set(&b->pic_u1, value);
			else if (!strcasecmp("title", name)) 
				dstring_set(&b->title, value);
			else if (!strcasecmp("info", name)) 
				dstring_set(&b->info, value);
			else if (!strcasecmp("site", name)) 
				b->site = atoi(value); 
		}
		if (!game_add_zhanyi(g, b)) {
			zhanyi_free(b);
		} 
	}
}

int game_trea_info_map_cmp(TreaInfo*p1, TreaInfo *p2)
{
	return (p1->id - p2->id);
}
int game_city_map_cmp(City *p1, City *p2)
{
	return (p1->id - p2->id);
}
int game_gene_map_cmp(Gene *p1, Gene *p2)
{
	return (p1->id - p2->id);
}
int game_army_map_cmp(Army *p1, Army *p2)
{
	return (p1->id - p2->id);
}
int game_sph_map_cmp(Sph *p1, Sph *p2)
{
	return (p1->id - p2->id);
}
int game_user_map_cmp(User *p1, User *p2)
{
	return (p1->id - p2->id);
}
int game_treasure_map_cmp(Trea *p1, Trea *p2)
{
	return (p1->id - p2->id);
}
int game_dipl_map_cmp(Dipl *p1, Dipl *p2)
{
	return (p1->id - p2->id);
}
int game_cmd_transfer_map_cmp(CmdTrans *p1, CmdTrans *p2)
{
	return (p1->id - p2->id);
}

int game_wubao_map_cmp(Wubao *w1, Wubao *w2)
{
	return w1->id - w2->id;
}

int game_order_map_cmp(Order *o1, Order *o2)
{
	return o1->id - o2->id;
}

int game_sell_order_map_cmp(SellOrder *o1, SellOrder *o2)
{
	return o1->id - o2->id;
}

int game_task_map_cmp(Task *t1, Task *t2)
{
	return t1->id - t2->id;
}

int game_box_map_cmp(Box *t1, Box *t2)
{
	return t1->id - t2->id;
}

int game_guanka_map_cmp(Guanka *t1, Guanka *t2)
{
	return t1->id - t2->id;
}

int game_zhanyi_map_cmp(Zhanyi *t1, Zhanyi *t2)
{
	return t1->id - t2->id;
}

int game_room_map_cmp(Room *t1, Room *t2)
{
	return t1->id - t2->id;
}

static int res_cmp(Key *k1, Key *k2)
{
	return k1->arg - k2->arg;
}


