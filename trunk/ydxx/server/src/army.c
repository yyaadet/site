#include "hf.h"


static void fight_with_city(Army *army, Gene *gene, City *city);
static void fight_with_army(Army *army, Gene *gene1, Army *enemy, Gene *gene2);


Army *army_new()
{
	Army *a = (Army *) cache_pool_alloc(POOL_ARMY);
	if (!a) 
		return NULL;

	a->id = 0;
	a->x = 0;
	a->y = 0;
	a->money = 0;
	a->food = 0;
	a->original = 0;
	a->gene_id = 0;
	a->state = ARMY_NORMAL;
	a->war_target_type = WAR_TARGET_NONE;
	a->war_target_id = 0;
	a->type = EXPEDITION_NORMAL;
	a->move_target = 0;
	a->move_target_id = 0;
	a->last_change_zhen_time = 0;
	a->from_place = 0;
	a->from_place_id = 0;

	a->move_tp_num = 0;
	TAILQ_INIT(&a->move_tp);

	a->ev = ev_new(g_cycle->evbase);
	if (!a->ev) {
		army_free(a);
		return NULL;
	}
	return a;
}

Army * army_new1(int gene_id, int x, int y, int money, int food, int type, int orig)
{
	Army *a = army_new();

	if (!a) 
		return NULL;

	a->id = 0;
	a->x = x;
	a->y = y;
	a->money = money;
	a->food = food;
	a->gene_id = gene_id;
	a->type = type;
	a->original = orig;
	
	return a;
}


void army_free(Army *army)
{
	TimePos *p, *t;
	Game *g = GAME;
	City *city = NULL;

	if (!army)
		return;

	if (army->war_target_type == WAR_TARGET_CITY && army->war_target_id > 0) {
		if ((city = game_find_city(g, army->war_target_id))) {
			city_set_state(city, CITY_NORMAL);
		}
	} 

	TAILQ_FOREACH_SAFE(p, &army->move_tp, link, t) {
		TAILQ_REMOVE(&army->move_tp, p, link);
		time_pos_free(p);
	}
	ev_free(army->ev);
	cache_pool_free(POOL_ARMY, army);
}


bool army_get_war_target(Army *army, Gene *gene)
{
	City *city = NULL;
	Army *enemy = NULL;
	Game *g = GAME;

	if (!(gene && army))
		return false;

	if (army->war_target_type != WAR_TARGET_NONE && army->war_target_id > 0) {
		if (army->war_target_type == WAR_TARGET_CITY) {
			if ((city = game_find_city(g, army->war_target_id))) {
				if (is_fightable(army, gene, city)) {
					return true;
				} 
			}
		} 
		else if (army->war_target_type == WAR_TARGET_ARMY) {
			if ((enemy = game_find_army(g, army->war_target_id))) {
				if (is_fightable1(army, gene, enemy)) {
					return true;
				}
			}
		}
	}

	//old war target is invalid
	city = NULL;
	enemy = NULL;
	if (army->move_target == MOVE_TO_WAR) {
		if ((city = game_find_city(g, army->move_target_id))) {
			if(is_fightable(army, gene, city)) {
				army->war_target_type = WAR_TARGET_CITY;
				army->war_target_id = city->id;
				return true;
			}
			else {
				return false;
			}
		}

		if((city = find_fightable_city(army, gene))) {
			army->war_target_type = WAR_TARGET_CITY;
			army->war_target_id = city->id;
			return true;
		}
	}

	if ((enemy = find_fightable_army(army, gene))) {
		army->war_target_type = WAR_TARGET_ARMY;
		army->war_target_id = enemy->id;
		return true;
	}


	DEBUG(LOG_FMT"can't find any war target for army %d (%d, %d)\n", LOG_PRE, \
			army->id, army->x, army->y);

	return false;
}


bool army_set_state(Army *army, byte state) 
{
	if (!army) 
		return false;


	Game *g = GAME;
	City *city = NULL;


	army->state = state;
	send_nf_army_where(army, WHERE_ALL);

	if (army->state == ARMY_NORMAL) {
		if (army->war_target_type == WAR_TARGET_CITY && army->war_target_id > 0) {
			if ((city = game_find_city(g, army->war_target_id))) {
				city_set_state(city, CITY_NORMAL);
			}
		} 
	}

	return true;
}


int army_get_speed(Army *a)
{
	int speed = 10;
	Game *g = GAME;
	Gene *gene = NULL;


	if (!(gene = game_find_gene(g, a->gene_id))) {
		return speed;
	}
	if (!lua_get_army_speed(gene, a->type, &speed))
		return speed;

	return speed;
}

bool army_move(Army *a)
{
	TimePos *timepos = NULL;

	if (!a) 
		return false;
	if (TAILQ_FIRST(&a->move_tp) == NULL) 
		return false;

	timepos = TAILQ_FIRST(&a->move_tp);
	
	TAILQ_REMOVE(&a->move_tp, timepos, link);
	a->move_tp_num--;

	a->x = timepos->to->x;
	a->y = timepos->to->y;
	time_pos_free(timepos);
	
	DEBUG(LOG_FMT"army %d move to (%d, %d), state %d, target %d, war %d %d\n", LOG_PRE, \
			a->id, a->x, a->y, a->state, a->move_target, a->war_target_type, a->war_target_id);
	return true;
}

void army_continue_to_move(Army *a)
{
	TimePos *timepos;

	if (!a) 
		return;
	if (TAILQ_FIRST(&a->move_tp) == NULL) 
		return ;
	timepos = TAILQ_FIRST(&a->move_tp);

	ev_update(a->ev, -1, 0, update_army_position, a, timepos->sec);
}

void army_end_move(Army *a)
{
	TimePos *p, *t;

	if (!a) 
		return;
	
	TAILQ_FOREACH_SAFE(p, &a->move_tp, link, t) {
		TAILQ_REMOVE(&a->move_tp, p, link);
		time_pos_free(p);
		a->move_tp_num--;
	}

	ev_update(a->ev, -1, 0, NULL, NULL, DEF_EV_TIMEOUT);
}


int army_is_war(Army *a)
{
	if (!a) 
		return 0;
	if (a->state == ARMY_FIGHT)
		return 1;
	return 0;
}


bool is_neighbour(Pos *p1, Pos *p2)
{
	if (!(p1 && p2))
		return false;
	if (abs(p1->x - p2->x) > 1)
		return false;
	if (abs(p1->y - p2->y) > 1)
		return false;
	return true;
}

void update_army_position(int fd, short flag, void *arg)
{
	Game *g = GAME;
	Army *army = (Army *)arg;
	City *enemy_city = NULL;
	Army *enemy_army = NULL;
	float need_sec = 0;
	float need_hour = 0;
	City *city = NULL;
	Gene *gene = NULL;
	Gene *enemy_gene = NULL;
	Wubao *w = NULL;
	Sph *sph = NULL;

	
	if (!army)
		return;

	if (!lua_get_war_time(&need_hour))
		return;

	need_sec = GAME_HOUR_PER_SEC * need_hour;
	
	if (!(gene = game_find_gene(g, army->gene_id))) {
		return;
	}

	w = game_find_wubao_by_uid(g, gene->uid);

	if (army_move(army)) {
		if (army->move_target == MOVE_TO_CITY || army->move_target == MOVE_TO_WUBAO) {
			if((city = game_find_city_by_pos(g, army->x, army->y))) {
				if (army->move_target == MOVE_TO_CITY) {
					Sph *sph1, *sph2;

					if ((sph1 = game_find_sph(g, city->sph_id)) && (sph2 = game_find_sph(g, w->sph_id)) && \
							sph_relation(sph1, sph2) == DIPL_LEAGUE) {

						gene_change_place(gene, GENE_PLACE_CITY, city->id);

						game_del_army(g, army);

						send_nf_gene_where(gene, WHERE_ALL);

						send_nf_army_where(army, WHERE_ALL);

						army_free(army);
						return;
					}
				} 
				else if (army->move_target == MOVE_TO_WUBAO) {
					if (w && w->city_id == city->id) {

						gene_change_place(gene, GENE_PLACE_WUBAO, w->id);
						
						send_nf_gene_where(gene, WHERE_ALL);
						
						game_del_army(g, army);
						
						send_nf_army_where(army, WHERE_ALL);
					
						army_free(army);
						return;
					}
				}
			}
		}
	}

	if (!(army_get_war_target(army, gene))) {
		army_set_state(army, ARMY_NORMAL);
		army_continue_to_move(army);
		return;
	}


	if (army->war_target_type == WAR_TARGET_CITY) {
		if (!(enemy_city = game_find_city(g, army->war_target_id))) {
			army_set_state(army, ARMY_NORMAL);
			return;
		}
	}
	else if (army->war_target_type == WAR_TARGET_ARMY) {
		if (!(enemy_army = game_find_army(g, army->war_target_id))) {
			army_set_state(army, ARMY_NORMAL);
			return;
		}
	} 
	else {
		army_set_state(army, ARMY_NORMAL);
		return;
	}
	
	//war
	army_set_state(army, ARMY_FIGHT);
	army_end_move(army);

	if (enemy_army) {
		DEBUG(LOG_FMT"army %d figth with enemy army %d\n", LOG_PRE, army->id, enemy_army->id);

		if (!(enemy_gene = game_find_gene(g, enemy_army->gene_id))) {
			return;
		}

		army_set_state(enemy_army, ARMY_FIGHT);
		army_end_move(enemy_army);
		
		fight_with_army(army, gene, enemy_army, enemy_gene);

		if (enemy_gene->sol_num <= 0) {
			game_del_army(g, enemy_army);
			send_nf_army_where(enemy_army, WHERE_ALL);
			army_free(enemy_army);
			enemy_army = NULL;
		}
	}
	else if (enemy_city) {
		DEBUG(LOG_FMT"army %d fight with enemy city %d\n", LOG_PRE,  army->id, enemy_city->id);

		city_set_state(enemy_city, CITY_FIGHT);

		fight_with_city(army, gene, enemy_city);

		if (city_sol_num(enemy_city) <= 0) {
			city_set_state(enemy_city, CITY_NORMAL);

			if ((sph = game_find_sph_by_uid(g, gene->uid)) && enemy_city->sph_id != sph->id) {
                sph->prestige += 2000;
				city_change_sphere(enemy_city, sph);
				send_nf_city_where(enemy_city, WHERE_ALL);
			}

			//send_got_city_talk_msg(gene, enemy_city, 1);
		} 
		else if (gene->sol_num <= 0) {
			city_set_state(enemy_city, CITY_NORMAL);
			//send_got_city_talk_msg(gene, enemy_city, 0);
		}
	}

	//check me is over ?
	if (army && gene->sol_num <= 0) {

		game_del_army(g, army);

		send_nf_army_where(army, WHERE_ALL);

		army_free(army);
		return;
	}

	if (army && army->state != ARMY_NORMAL) {
		ev_update(army->ev, -1, 0, update_army_position, army, need_sec);
	}
}


City * find_fightable_city(Army *army, Gene *gene)
{
	Game *g = GAME;
	City *city = NULL;

	if (!(army && gene))
		return NULL;

	RB_FOREACH(city, GameCityMap, &g->cities) {
		if (is_fightable(army, gene, city)){
			DEBUG(LOG_FMT"army %d (%d, %d) fightable city %d (%d, %d)\n", LOG_PRE, \
					army->id, army->x, army->y, city->id, city->x, city->y);
			return city;
		}
	}
	return NULL;
}


Army *find_fightable_army(Army *army, Gene *gene)
{
	Game *g = GAME;
	Army *other = NULL;

	if (!(army && gene))
		return NULL;

	RB_FOREACH(other, GameArmyMap, &g->armies) {
		if (is_fightable1(army, gene, other)){
			DEBUG(LOG_FMT"army %d (%d, %d) fightable army %d (%d, %d)\n", LOG_PRE, \
					army->id, army->x, army->y, other->id, other->x, other->y);
			return other;
		}
	}
	return NULL;
}


bool is_fightable(Army *army, Gene *gene, City *city)
{
	int distance = 0;
	Sph *sph = NULL;
	Sph *sph1 = NULL;
	Game *g = GAME;

	if (!(army && gene && city))
		return false;

	if (is_deny_war(NULL))
		return false;

	sph = game_find_sph(g, city->sph_id);

	if(!(sph1 = game_find_sph_by_uid(g, gene->uid))) {
		DEBUG(LOG_FMT"army %d don't have any sphere, return false.\n", LOG_PRE, army->id);
		return false;
	}

	if (sph && sph1 && sph_relation(sph, sph1) != DIPL_ENEMY) {
		DEBUG(LOG_FMT"army %d of sphere %d isn't enemy with city %d of sphere %d\n", LOG_PRE, \
				army->id, sph1->id, city->id, sph->id);
		return false;
	}

	if (!lua_get_sol_prop(gene->weap, gene->used_zhen, NULL,  &distance))
		return false;

	if (!pos_in_city_region(army->x, army->y, city, distance)) {
		DEBUG(LOG_FMT"army %d isn't in war region of city %d\n", LOG_PRE, \
				army->id, city->id);
		return false;
	}

	return true;
}

bool is_deny_war(int *h)
{
	time_t t;
	struct tm *tp;
	Conf *conf = g_cycle->conf;
	
	t = time(NULL);
	if ((tp = localtime(&t))) {
		if (h) 
			(*h) = tp->tm_hour;

		if (tp->tm_hour >= conf->core.deny_war_begin && tp->tm_hour < conf->core.deny_war_end) {
			return true;
		}
	}

	return false;
}

bool is_fightable1(Army *army, Gene *gene, Army *enemy)
{
	int dis = 0;
	Sph *sph = NULL;
	Sph *sph1 = NULL;
	Gene *gene1 = NULL;
	Game *g = GAME;

	if (!(army && gene && enemy))
		return false;
	if (army->id == enemy->id)
		return false;

	sph = game_find_sph_by_uid(g, gene->uid);

	if ((gene1 = game_find_gene(g, enemy->gene_id))) {
		sph1 = game_find_sph_by_uid(g, gene1->uid);
	}

	if (sph && sph1 && sph->id == sph1->id)
		return false;

	if (sph && sph1 && sph_relation(sph, sph1) == DIPL_LEAGUE)
		return false;

	if (!lua_get_sol_prop(gene->weap, gene->used_zhen, NULL, &dis))
		return false;

	if (computer_distance(army->x, army->y, enemy->x, enemy->y) <= dis + ARMY_GRID) 
		return true;

	return false;
}


static void fight_with_city(Army *army, Gene *gene, City *city)
{
	int city_sol = 0;
	int dead1 = 0;
	int dead2 = 0;
	int hurt1 = 0;
	int hurt2 = 0;
	int exp1 = 0;
	int exp2 = 0;
	float spirit1 = 0;
	float spirit2 = 0;
	float train1 = 0;
	float train2 = 0;
	Gene *gene2 = NULL;
	Wubao *w1 = NULL;
	Wubao *w2 = NULL;
	float def = 0;


	if (!(army && gene && city))
		return;

	city_sol = city_sol_num(city);

	if (gene->sol_num <= 0 || city_sol <= 0) {
		DEBUG(LOG_FMT"gene sol %d, city sol %d, return.\n", LOG_PRE, \
				gene->sol_num, city_sol);
		return;
	}
	
	gene2 = city_find_general_by_min_sol(city);

	if (!lua_get_war_city(army, gene, city, gene2, \
				&dead1, &hurt1, &exp1, &spirit1, &train1, \
				&dead2, &hurt2, &exp2, &spirit2, &train2, &def)) {
		return;
	}

	safe_sub(gene->sol_num, dead1);
	safe_add(gene->hurt_num, hurt1);
	gene_change_sol_spirit(gene, spirit1);
    if (gene->sol_spirit > 200)
        gene->sol_spirit = 200;
	send_nf_gene_where(gene, WHERE_ALL);

	
	if(gene2 && gene2->sol_num > 0) {
		safe_sub(gene2->sol_num, dead2);
		safe_add(gene2->hurt_num, hurt2);
		gene_change_sol_spirit(gene2, spirit2);
		send_nf_gene_where(gene2, WHERE_ALL);
	}
	else {
		safe_sub(city->sol, dead2);
	}

	safe_sub(city->defense, def);

	send_nf_city_where(city, WHERE_ALL);

	if (gene && gene->sol_num <= 0) {
		send_nf_wubao_where(w1, WHERE_ME);
	}
	else if (gene2 && gene2->sol_num <= 0) {
		send_nf_wubao_where(w2, WHERE_ME);
	}

	send_nf_war_where(WAR_CITY, army->id, dead1, hurt1, exp1, city->id, dead2, hurt2, exp2, def, WHERE_ALL);	
}

static void fight_with_army(Army *army, Gene *gene1, Army *enemy, Gene *gene2)
{
	int dead1 = 0;
	int dead2 = 0;
	int hurt1 = 0;
	int hurt2 = 0;
	int exp1 = 0;
	int exp2 = 0;
	float spirit1 = 0;
	float spirit2 = 0;
	float train1 = 0;
	float train2 = 0;
	MapRegion *reg = NULL;
	int r1 = REGION_PINGYAN;
	int r2 = REGION_PINGYAN;
	

	if (!(army && enemy && gene1 && gene2))
		return;

	if (gene1->sol_num <= 0 || gene2->sol_num <= 0)
		return;

	if ((reg = get_global_region(army->x, army->y)))
		r1 = reg->m_reg;
	if ((reg = get_global_region(enemy->x, enemy->y)))
		r2 = reg->m_reg;
	

	if (!lua_get_war_army(r1, gene1, r2, gene2,\
				&dead1, &hurt1, &exp1, &spirit1, &train1,\
				&dead2, &hurt2, &exp2, &spirit2, &train2)) {
		return;
	}


	safe_sub(gene1->sol_num, dead1);
	safe_add(gene1->hurt_num, hurt1);
	gene_change_sol_spirit(gene1, spirit1);
    if (gene1->sol_spirit > 200)
        gene1->sol_spirit = 200;
	send_nf_gene_where(gene1, WHERE_ALL);

	safe_sub(gene2->sol_num, dead2);
	safe_add(gene2->hurt_num, hurt2);
	gene_change_sol_spirit(gene2, spirit2);
	send_nf_gene_where(gene2, WHERE_ALL);


	send_nf_war_where(WAR_WILD, army->id, dead1, hurt1, exp1, enemy->id, dead2, hurt2, exp2, 0, WHERE_ALL);	
}



bool pos_in_city_region(int px, int py, City *city, int dist) 
{
	if (!(px >= 0 && py >= 0 && city))
		return false;

	float radius = 0;
	bool ret = false;


	
	radius = dist + city->level * CITY_GRID;

	if (sqrt(pow(abs(px - city->x), 2) + pow(abs(py - city->y), 2)) <= radius) 
		ret = true;
	
	DEBUG(LOG_FMT"(%d, %d) is in region %d of city %d(%d, %d)\n", LOG_PRE, \
				px, py, dist, city->id, city->x, city->y);

	return ret;
}


