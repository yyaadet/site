#include "hf.h"

#define CHECK_UP_LIST 10

#define USER_UP_NUM 10000
#define SPH_UP_NUM 1000
#define DIPL_UP_NUM 1000
#define GENE_UP_NUM 10000
#define WUBAO_UP_NUM 10000
#define CMD_TRANS_UP_NUM 5000
#define ORDER_UP_NUM 5000
#define SELL_ORDER_UP_NUM 5000
#define ROOM_UP_NUM 5000

#define DO_UP_TIME 1

#define WUBAO_FLUSH_HOUR 5

enum UP_TYPE {
	UP_NONE,
	UP_WUBAO, 
	UP_GENE,
	UP_CMD_TRANS, 
	UP_USER, 
	UP_SPH,
	UP_DIPL,
	UP_CITY,
	UP_ORDER,
	UP_SELL_ORDER,
	UP_ROOM,
	UP_ONLINE,
	UP_OTHER,
	UP_MAX,
};

typedef struct {
	int type;
	int id;
}UpStatu;

static void up_reg_ev(int fd, short flag, void *arg);

static void check_up_list(int fd, short flag, void *arg);

static void do_up(int fd, short flag, void *arg);

/* 
 * core function of game runtime
 */

static void update_game_user(bool step);

static void update_game_sphere(bool step);

static void update_game_dipl(bool step);

static void update_game_wubao(bool step);

static void update_game_general(bool step);

static void update_game_city(bool step);

static void update_game_cmd_trans(bool step);

static void update_game_order(bool step);

static void update_game_sell_order(bool step);

static void update_game_room(bool step);

static void update_game_other();

static void update_game_online();


/*
 * *****************************
 */

static KeyList *g_up_list = NULL;
static int g_up_num = 0;

static Key *g_up_node = NULL;

static UpStatu *g_up_st = NULL;

static Ev *g_up_ev = NULL;

bool up_init()
{
	if(!(g_up_list = key_list_new(NULL)))
		return false;

	if (!(g_up_st = xmalloc(sizeof(UpStatu)))) { 
		return false;
	}

	if (!(g_up_ev = ev_new(g_cycle->evbase)))
		return false;

	return true;
}


void up_uninit()
{
	bool done = false;

	while((g_up_node && g_up_num > 0)) {
		
		done = false;

		while(g_up_st->type < UP_MAX) {
			switch(g_up_st->type) {
				case UP_NONE:
					WARN(LOG_FMT"up statu can't equal UP_NONE\n", LOG_PRE);
					break;
				case UP_USER:
					update_game_user(false);
					break;
				case UP_SPH:
					update_game_sphere(false);
					break;
				case UP_DIPL:
					update_game_dipl(false);
					break;
				case UP_WUBAO:
					update_game_wubao(false);
					break;
				case UP_GENE:
					update_game_general(false);
					break;
				case UP_CITY:
					update_game_city(false);
                    break;
                case UP_ROOM:
                    update_game_room(false);
                    break;
				default:
					done = true;
					break;
			}
			if (done) 
				break;
		}
		key_free(g_up_node);
		
		if (!(g_up_node = TAILQ_FIRST(&g_up_list->keys)))
			break;
		TAILQ_REMOVE(&g_up_list->keys, g_up_node, link);
		g_up_num--;

		g_up_st->type = UP_USER;
		g_up_st->id = 0;

		DEBUG(LOG_FMT"up ev num %d\n", LOG_PRE, g_up_num);
	}

	key_list_free(g_up_list);

	safe_free(g_up_st);

	ev_free(g_up_ev);
}


void up_reg()
{
	Key *k = NULL;
	int real_time = 0;


	if (!g_up_list)
		return;

	real_time = time(NULL);
	if (!(k = key_new(real_time))) 
		return ;

	TAILQ_INSERT_TAIL(&g_up_list->keys, k, link);
	g_up_num++;

	check_up_list(-1, 0, NULL);
}

static void check_up_list(int fd, short flag, void *arg)
{
	if (g_up_node)
		return;

	/* get head event */
	if (!(g_up_node = TAILQ_FIRST(&g_up_list->keys)))
		return;
	TAILQ_REMOVE(&g_up_list->keys, g_up_node, link);
	g_up_num--;

	g_up_st->type = UP_NONE + 1;
	g_up_st->id = 0;
	ev_update(g_up_ev, -1, 0, do_up, NULL, DO_UP_TIME);

	DEBUG(LOG_FMT"up ev num %d\n", LOG_PRE, g_up_num);
}

static void up_reg_ev(int fd, short flag, void *arg)
{
	up_reg();
}

static void do_up(int fd, short flag, void *arg)
{
	int real_now = time(NULL);
	int last_reg = 0;
	int inter = 0;

	ev_update(g_up_ev, -1, 0, do_up, NULL, DO_UP_TIME);

	switch(g_up_st->type) {
		case UP_USER:
			update_game_user(true);
			break;
		case UP_SPH:
			update_game_sphere(true);
			break;
		case UP_DIPL:
			update_game_dipl(true);
			break;
		case UP_WUBAO:
			update_game_wubao(true);
			break;
		case UP_GENE:
			update_game_general(true);
			break;
		case UP_CITY:
			update_game_city(true);
			break;
		case UP_CMD_TRANS:
			update_game_cmd_trans(true);
			break;
		case UP_ORDER:
			update_game_order(true);
			break;
		case UP_SELL_ORDER:
			update_game_sell_order(true);
			break;
        case UP_ROOM:
            update_game_room(true);
            break;
		case UP_OTHER:
			update_game_other();
			break;
		case UP_ONLINE:
			update_game_online();
			break;
		default:
			break;
	}

	if (g_up_st->type >= UP_MAX) {
		if (g_up_node) {
			last_reg = g_up_node->id;
			key_free(g_up_node);
			g_up_node = NULL;
		}

		g_up_st->type = 0;
		g_up_st->id = 0;

		inter = real_now - last_reg;
		if (inter <= 0) 
			inter = GAME_HOUR_PER_SEC;
		else if (inter >= GAME_HOUR_PER_SEC) 
			inter = 1;
		else if (inter < GAME_HOUR_PER_SEC) 
			inter = GAME_HOUR_PER_SEC - inter;

		ev_update(g_up_ev, -1, 0, up_reg_ev, NULL, inter);
		return;
	}
}


static void update_game_user(bool step)
{
	if (!(g_up_node && g_up_st->type == UP_USER))
		return;

	Game *g = GAME;
	User *u = NULL;
	User *cur = NULL;
	User *next = NULL;
	int now = GAME_NOW;
	int count = 0;


	if(g_up_st->id > 0 && (cur = game_find_user(g, g_up_st->id))) {
		u = cur;
	}
	else {
		u = RB_MIN(GameUserMap, &g->users);
	}


	/* 
	 * foreach all user
	 */
	for(; u; u = next) {
		next = RB_NEXT(GameUserMap, &g->users, u);

		if (u->vip_used_hour < u->vip_total_hour && u->vip_total_hour > 0) {
			u->vip_used_hour++;

			if (u->vip_used_hour == u->vip_total_hour) {
				webapi_user(g, 0, u, ACTION_EDIT, NULL, NULL);
			}

			send_nf_user_where(u, WHERE_ME);
		}

		count++;
		if (next)
			g_up_st->id = next->id;

		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > USER_UP_NUM && step) {
			return;
		}
	}

	g_up_st->type++;
	g_up_st->id = 0;

}



static void update_game_sphere(bool step)
{
	if (!(g_up_node && g_up_st->type == UP_SPH))
		return;

	Game *g = GAME;
	Sph *sph, *sph_t, *cur;
	int now = GAME_NOW;
	int count = 0;

	if (!game_time_is_month_end(now))
		goto fin;

	if(g_up_st->id > 0 && (cur = game_find_sph(g, g_up_st->id))) {
		sph = cur;
	}
	else {
		sph = RB_MIN(GameSphMap, &g->sphs);
	}

	for (; sph; sph = sph_t) {
		sph_t = RB_NEXT(GameSphMap, &g->sphs, sph);

		if (lua_get_sphere_change(sph, &sph->level, &sph->max_member)) {
			send_nf_sph_where(sph, WHERE_ALL);
		}

		/*
		if (sph->is_npc == 1 && sph->city_num <= 0) {
			game_del_sph(g, sph);
			sph_free(sph);
			sph = NULL;
		}
		*/


		count++;
		if (sph_t)
			g_up_st->id = sph_t->id;
		
		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > SPH_UP_NUM && step) {
			return;
		}
	}

fin:
	g_up_st->type++;
	g_up_st->id = 0;
	
	if (game_time_is_day_end(now))
		cycle_flush_to_shm(g_cycle, SDB_SPH);
}


static void update_game_dipl(bool step)
{
	if (!(g_up_node && g_up_st->type == UP_DIPL))
		return;

	Game *g = GAME;
	int now = GAME_NOW;
	int count = 0;
	Dipl *d, *d_t, *cur;
	

	if (!game_time_is_day_end(now))
		goto fin;
	
	if(g_up_st->id > 0 && (cur = game_find_dipl(g, g_up_st->id))) {
		d = cur;
	}
	else {
		d = RB_MIN(GameDiplMap, &g->dipls);
	}


	for (; d; d = d_t) {
		d_t = RB_NEXT(GameDiplMap, &g->dipls, d);
		
		if (d->end <= now) {
			send_dipl_talk_msg(d);

			game_del_dipl(g, d);
			dipl_free(d);
			d = NULL;
		}

		count++;
		if (d_t)
			g_up_st->id = d_t->id;
		
		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > DIPL_UP_NUM && step) {
			return;
		}
	}

fin:
	g_up_st->type++;
	g_up_st->id = 0;
}


static void update_game_wubao(bool step)
{
	if (!(g_up_node && g_up_st->type == UP_WUBAO))
		return;


	Game *g = GAME;
	Wubao *w, *cur, *next;
	int res[RES_MAX - 1];
	int people = 0;
	int family = 0;
	int sol = 0;
	int dig = 0;
	int max_gene = 0;
	int made = 0;
	int cure = 0;
	int i =0;
	Gene *gene = NULL;
	GameConn *c = NULL;
	bool changed = false;
	int now = GAME_NOW;
	int count = 0;



	if (!game_time_is_day_end(now)) 
		goto fin;
	

	if(g_up_st->id > 0 && (cur = game_find_wubao(g, g_up_st->id))) {
		w = cur;
	}
	else {
		w = RB_MIN(GameWubaoMap, &g->wubaos);
	}

	for(;w; w = next) {
		next = RB_NEXT(GameWubaoMap, &g->wubaos, w);

		if(w->uid > 0) {

			changed = wubao_check_level(w, now);

			if (game_time_is_day_end(now)) {

				if (lua_get_wubao_change(w, res, &people, &family, &sol, &dig, &max_gene, &made, &cure)) {

					for(i = 0; i < RES_MAX - 1; i ++)
						safe_add(w->res[i], res[i]);

					safe_add(w->people, people);

					safe_add(w->family, family);

					safe_add(w->sol, sol);

					safe_add(w->dig_id, dig);
					if (dig > 0) {
						send_new_dignitie_mail(w);
					}

					w->max_gene = max_gene;

					w->used_made = made;

					w->cure_sol = cure;

					changed = true;
				}
			}

			if (changed)
				send_nf_wubao_where(w, WHERE_ME);

			if (game_time_is_month_end(now)) {
				if ((gene = wubao_get_wild_gene(w))) {
					game_update_gene_for_wubao(g, gene, w);
				}
				else {
					gene = game_gen_new_gene(g, w);
				}

				if (gene && w && (c = cycle_find_game_conn_by_uid(g_cycle, w->uid)))
					send_nf_gene(gene, c);
			}
		}
		
		count++;
		if (next)
			g_up_st->id = next->id;
		
		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > WUBAO_UP_NUM && step) {
			return;
		}
	}
	
fin:

	g_up_st->type++;
	g_up_st->id = 0;

	if (game_time_is_day_end(now))
		cycle_flush_to_shm(g_cycle, SDB_WUBAO);
}

static void update_game_general(bool step)
{
	if (!(g_up_node && g_up_st->type == UP_GENE))
		return;
	
	Game *g = GAME;
	Gene *gene, *cur, *next;
	Wubao *w = NULL;
	Army *a = NULL;
	User *u = NULL;
	Sph *sph = NULL;
	int money = 0;
	int food = 0;
	float faith = 0;
	int fol = 0;
	float spi = 0;
	float tra = 0;
	int sol = 0;
	int num = 0;
	int now = GAME_NOW;
	int count = 0;
	City *city = NULL;


	if (!game_time_is_day_end(now))
		goto fin ;

	if(g_up_st->id > 0 && (cur = game_find_gene(g, g_up_st->id))) {
		gene = cur;
	}
	else {
		gene = RB_MIN(GameGeneMap, &g->genes);
	}
	
	for(; gene; gene = next) {
		next = RB_NEXT(GameGeneMap, &g->genes, gene);
		sol = 0;

		if((u = game_find_user(g, gene->uid))) {
			w = game_find_wubao(g, u->wid);
			if (w)
				sph = game_find_sph(g, w->sph_id);
		}
		else {
			w = NULL;
			sph = NULL;
		}


		if (!user_is_npc(u) && lua_get_gene_wubao(gene, w, u, &money, &food, &faith, &fol, &spi, &tra, &sol)) {

			if (w) {
				safe_sub(w->res[RES_MONEY - 1], money);
				safe_sub(w->res[RES_FOOD- 1], food);
			}

			safe_add(gene->faith, faith);

			gene->fol = fol;

			gene_change_sol_spirit(gene, spi);

			num = MIN(sol, gene->sol_num);
			if (num > 0) {
				safe_sub(gene->sol_num, num);
				safe_add(gene->hurt_num, num);
			}
		}

		sol = 0;
		if (gene->place == GENE_PLACE_ARMY) {
			if ((a = game_find_army(g, gene->place_id)) && \
						lua_get_gene_army(gene, a, w, u, &money, &food, &faith, &fol, &spi, &tra, &sol)) {

				safe_sub(a->money, money);
					
				safe_sub(a->food, food);
					
				send_nf_army_where(a, WHERE_ALL);

				safe_add(gene->faith, faith);

				gene->fol = fol;
			
				gene_change_sol_spirit(gene, spi);

				num = MIN(sol, gene->sol_num);
				if (num > 0) {
					safe_sub(gene->sol_num, num);
					safe_add(gene->hurt_num, num);
				}

				if (gene->sol_num <= 0) {
					game_del_army(g, a);
					send_nf_army_where(a, WHERE_ALL);
					army_free(a);
					a = NULL;
				} 
			}
		}
		else if (gene->place == GENE_PLACE_WUBAO) {
			
		} 
		else if (gene->place == GENE_PLACE_CITY) {

			if (gene->hurt_num > 0) {
				num = MIN(gene->hurt_num, HURT_RECOVER);
				
				safe_add(gene->sol_num, num);
				safe_sub(gene->hurt_num, num);
			}
		} 
		else if (gene->place == GENE_PLACE_TRIP) {
			if (!game_find_cmd_trans(g, gene->place_id) && w) {
				gene_change_place(gene, GENE_PLACE_WUBAO, w->id);
			}
		}

		
		if(!user_is_npc(u)) {
			if (gene->uid > 0 && (gene->place == GENE_PLACE_WUBAO || gene->place == GENE_PLACE_CITY) \
					&& gene->faith <= 0 && gene->type == GENE_TYPE_NAME) {

				gene_away(gene);
				
				if ((city = game_get_random_city(g))) {
					gene_change_place(gene, GENE_PLACE_CITY, city->id);
				}

				send_nf_gene_where(gene, WHERE_ALL);
			}
		}

		if ((gene->place <= 0 && gene->place_id <= 0 && gene->uid <= 0 && gene->type == GENE_TYPE_NAME)) {
			if ((city = game_get_random_city(g))) {
				gene_change_place(gene, GENE_PLACE_CITY, city->id);
			}
			send_nf_gene_where(gene, WHERE_ALL);
		}

		if (gene->face_id <= 0) {
			gene->face_id = gene_gen_face();
		}

		if (gene->faith < 50 && game_time_is_year_end(now)) {
			send_gene_faith_decr_mail(gene);
		}

		send_nf_gene_where(gene, WHERE_ME);
		
		count++;
		if(next)
			g_up_st->id = next->id;
		
		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > GENE_UP_NUM && step) {
			return;
		}
	}
fin:
	
	g_up_st->type++;
	g_up_st->id = 0;

	if (game_time_is_day_end(now)) {
		cycle_flush_to_shm(g_cycle, SDB_GENE);
		cycle_flush_to_shm(g_cycle, SDB_ARMY);
	}
}


static void update_game_city(bool step)
{
	if (!(g_up_node && g_up_st->type == UP_CITY))
		return;
	
	Game *g = GAME;
	City *city, *cur, *next;
	int now = GAME_NOW;
	int count = 0;
	int num = 0;

		
	if (!game_time_is_year_end(now)) 
		goto fin;

	if(g_up_st->id > 0 && (cur = game_find_city(g, g_up_st->id))) {
		city = cur;
	}
	else {
		city = RB_MIN(GameCityMap, &g->cities);
	}
	
	for(; city; city = next) {
		next = RB_NEXT(GameCityMap, &g->cities, city);

		num = city->sol <= 1 ? 2 : city->sol;
		city_add_sol(city, ((1600 * city->level)/log(num)));

		num = city->defense <= 1 ? 2 : city->sol;
		city_add_defense(city, (100 * city->level) /log(num));

		city->state = CITY_NORMAL;

		send_nf_city_where(city, WHERE_ALL);

		count++;
		if(next)
			g_up_st->id = next->id;
		
		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > GENE_UP_NUM && step) {
			return;
		}
	}

fin:
	
	g_up_st->type++;
	g_up_st->id = 0;

	if (game_time_is_day_end(now))
		cycle_flush_to_shm(g_cycle, SDB_CITY);
}

static void update_game_cmd_trans(bool step)
{
	if (!(g_up_node && g_up_st->type == UP_CMD_TRANS))
		return;
	
	Game *g = GAME;
	CmdTrans *cmd, *cur, *next;
	int now = GAME_NOW;
	int count = 0;


	if(g_up_st->id > 0 && (cur = game_find_cmd_trans(g, g_up_st->id))) {
		cmd = cur;
	}
	else {
		cmd = RB_MIN(GameCmdTransferMap, &g->cmd_trans);
	}
	
	for(; cmd; cmd = next) {
		next = RB_NEXT(GameCmdTransferMap, &g->cmd_trans, cmd);

		if (cmd->end >= now)
			continue;
		do_execute_cmd_transfer(cmd, false);

		count++;
		if(next)
			g_up_st->id = next->id;
		
		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > CMD_TRANS_UP_NUM && step) {
			return;
		}
	}

	
	g_up_st->type++;
	g_up_st->id = 0;
}

static void update_game_order(bool step)
{
	if (!(g_up_node && g_up_st->type == UP_ORDER))
		return;
	
	Game *g = GAME;
	Order *o, *cur, *next;
	int now = GAME_NOW;
	int count = 0;

	if (!game_time_is_month_end(now)) 
		goto fin;

	if(g_up_st->id > 0 && (cur = game_find_order(g, g_up_st->id))) {
		o = cur;
	}
	else {
		o = RB_MIN(GameOrderMap, &g->orders);
	}
	
	for(; o; o = next) {
		next = RB_NEXT(GameOrderMap, &g->orders, o);

		if (o->ts + ORDER_LIFE < now) {
			remove_order(o->uid, ORDER_NORM, o->id);
			o = NULL;
		}

		count++;
		if(next)
			g_up_st->id = next->id;
		
		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > ORDER_UP_NUM && step) {
			return;
		}
	}

fin:
	cycle_flush_to_shm(g_cycle, SDB_ORDER);

	g_up_st->type++;
	g_up_st->id = 0;
}

static void update_game_sell_order(bool step)
{
	if (!(g_up_node && g_up_st->type == UP_SELL_ORDER))
		return;
	
	Game *g = GAME;
	SellOrder *o, *cur, *next;
	int now = GAME_NOW;
	int count = 0;

	if (!game_time_is_month_end(now)) 
		goto fin;

	if(g_up_st->id > 0 && (cur = game_find_sell_order(g, g_up_st->id))) {
		o = cur;
	}
	else {
		o = RB_MIN(GameSellOrderMap, &g->sell_orders);
	}
	
	for(; o; o = next) {
		next = RB_NEXT(GameSellOrderMap, &g->sell_orders, o);

		if (o->ts + SELL_ORDER_LIFE < now) {
			remove_order(o->uid, ORDER_SPEC, o->id);
			o = NULL;
		}

		count++;
		if(next)
			g_up_st->id = next->id;
		
		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > SELL_ORDER_UP_NUM && step) {
			return;
		}
	}

fin:
	cycle_flush_to_shm(g_cycle, SDB_SELL_ORDER);
	g_up_st->type++;
	g_up_st->id = 0;
}

static void update_game_room(bool step)
{
	Game *g = GAME;
	Room *o, *cur, *next;
	int now = GAME_NOW;
	int count = 0;


	if(g_up_st->id > 0 && (cur = game_find_room(g, g_up_st->id))) {
		o = cur;
	}
	else {
		o = RB_MIN(GameRoomMap, &g->rooms);
	}
	
	for(; o; o = next) {
		next = RB_NEXT(GameRoomMap, &g->rooms, o);

		DEBUG(LOG_FMT"ts %d, now %d\n", LOG_PRE, o->ts, now);
        if (o->ts <= now) {
            room_run(o);
            send_nf_end_room_where(o, WHERE_ALL);
            game_del_room(g, o);
            
            o = NULL;
        }

		count++;
		if(next)
			g_up_st->id = next->id;
		
		DEBUG(LOG_FMT"time %d, type %d, id %d, count %d\n", LOG_PRE, now, g_up_st->type, g_up_st->id, count);
		if (count > ROOM_UP_NUM && step) {
			return;
		}
	}

	cycle_flush_to_shm(g_cycle, SDB_ROOM);
	g_up_st->type++;
	g_up_st->id = 0;
}


static void update_game_online()
{
	if (!(g_up_node && g_up_st->type == UP_ONLINE))
		return;
	
	static int last_time = 0;
	static int last_online = 0;
	FILE *f = NULL;
	Conf *cf = g_cycle->conf;	
	char path[MAX_BUFFER];
	time_t t;
	struct tm tp, tp1;
	
	
	t = time(NULL);
	if (!localtime_r(&t, &tp)) {
		return;
	}

	if (!localtime_r(&last_time, &tp1)) {
		return;
	}

	if (tp.tm_hour == tp1.tm_hour) {
		if (g_cycle->game_conn_num > last_online) {
			last_online = g_cycle->game_conn_num;
			last_time = t;
		}
	} 
	else if (abs(tp.tm_hour - tp1.tm_hour) > 0) {
		if (last_time > 0) {
			snprintf(path, MAX_BUFFER - 1, "%s/online.txt", cf->core.work_dir);
			if (!(f = fopen(path, "a"))) {
				ERROR(LOG_FMT"fopen %s: %s\n", LOG_PRE, path, error_string());
				return;
			}
			fprintf(f, "%s %d\n", format_time(last_time, "%Y/%m/%d/%H"), last_online);
			fflush(f);
			fclose(f);
		}
			
		last_online = g_cycle->game_conn_num;
		last_time = t;
	}
	
	g_up_st->type++;
	g_up_st->id = 0;
}

static void update_game_other()
{
	if (!(g_up_node && g_up_st->type == UP_OTHER))
		return;
	
	Game *g = GAME;
	int now = GAME_NOW;
	

	if (game_time_is_month_end(now)) 
		cycle_flush_to_shm(g_cycle, SDB_GUANKA);

	check_deffer_http(NULL);

	now = ++g->time;	
	cycle_flush_to_shm(g_cycle, SDB_TIME);
	
	send_nf_time_where(now, WHERE_ALL);
	
	g_up_st->type++;
	g_up_st->id = 0;
}


