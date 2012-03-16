#include "hf.h"



City *city_new()
{
	City *c = (City *) cache_pool_alloc(POOL_CITY);
	if (!c)  {
		return NULL;
	}

	c->id = 0;
	c->sph_id = 0;
	c->defense = 0;
	c->level = 0;
	c->x = 0;
	c->y = 0;
	c->is_alloted = 0;
	c->state = 0;
	c->jun_code = 0;
	c->zhou_code = 0;
	c->sol = CITY_SOL;
	dstring_clear(&c->name);
	dstring_clear(&c->jun_name);
	dstring_clear(&c->zhou_name);
	dstring_clear(&c->desc);

	c->gene_num = 0;
	RB_INIT(&c->genes);

	c->idle_wubao_num = 0;
	c->wubao_num = 0;
	RB_INIT(&c->wubaos);

	return c;
}

void city_free(City *city)
{
	if (!city)
		return;
	cache_pool_free(POOL_CITY, city);
}


bool city_change_sphere(City *city, Sph *sph)
{
	if (!(city && sph)) 
		return false;

	Game *g = GAME;
	int old_sph_id = city->sph_id;
	Sph *old_sph = NULL;
	User *old_u = NULL;
	Key *k, *kt;
	Gene *gene = NULL;


	if (sph->id == city->sph_id)
		return false;
	
	city->sph_id = sph->id;

	if ((old_sph = game_find_sph(g, old_sph_id))) {
		sph_del_city(old_sph, city->id);
		old_u = game_find_user(g, old_sph->uid);
	}

	sph_add_city(sph, city->id);

	city->sol = city->level * CITY_SOL;
	city->defense = city->level * CITY_DEFENSE;
	
	/* check generals */
	for(k = RB_MIN(KeyMap, &city->genes); k; k = kt) {
		kt = RB_NEXT(KeyMap, &city->genes, k);

		if(!(gene = game_find_gene(g, k->id))) {
			continue;
		}

		if(old_sph && gene->uid == old_sph->uid) {
			if (old_sph->is_npc == 1) {
				if (old_sph->city_num <= 0) {
					gene->uid = 0;
					gene->faith = 0;
				}
				else {
					City *new_city = sph_get_city(old_sph);

					if (new_city) {
						gene_change_place(gene, GENE_PLACE_CITY, new_city->id);
					} 
				}
			} 
			else {
				gene_change_place(gene, GENE_PLACE_WUBAO, old_u->wid);
			}

			send_nf_gene_where(gene, WHERE_ALL);
		}

	}

	if (old_sph && old_sph->is_npc == 1 && old_sph->city_num <= 0) {
		game_del_sph(g, old_sph);
		sph_free(old_sph);
		old_sph = NULL;
	}

	return true;
}


bool city_set_state(City *city, byte state)
{
	if (!city) 
		return false;

	city->state = state;

	send_nf_city_where(city, WHERE_ALL);

	return true;
}


bool city_add_general(City *city, Gene *gene)
{
	if (!(city && gene)) 
		return false;

	Key *k = NULL;

	if (city_find_general(city, gene->id))
		return false;

	k = key_new(gene->id);
	if (!k) 
		return false;
	if (RB_INSERT(KeyMap, &city->genes, k)) {
		key_free(k);
		return false;
	}
	city->gene_num++;
	//DEBUG(LOG_FMT"city %d general %d\n", LOG_PRE, city->id, gene_id);
	return true;
}

bool city_del_general(City *city, Gene *gene)
{
	if (!(city && gene))  
		return false;

	Key k ;
	Key *r = NULL;

	k.id = gene->id;
	if (!(r = RB_FIND(KeyMap, &city->genes, &k))) {
		return false;
	}
	if ((r = RB_REMOVE(KeyMap, &city->genes, r)) == NULL) {
		return false;
	}
	key_free(r);
	city->gene_num--;

	return true;
}

Gene * city_find_general(City *city, int gene_id)
{
	if(!city) 
		return NULL;

	Game *g = GAME;
	Key k;
	Key *r;
	Gene *gene = NULL;

	k.id = gene_id;
	if ((r = RB_FIND(KeyMap, &city->genes, &k)) == NULL) 
		return NULL;
	if (!(gene = game_find_gene(g, r->id))) 
		return NULL;
	return gene;
}

Gene * city_find_general_by_min_sol(City *city)
{
	if (!city)
		return 0;

	Game *g = GAME;
	Key *k = NULL;
	Gene *gene = NULL;
	Gene *min = NULL;
	Sph *sph = NULL;


	RB_FOREACH(k, KeyMap, &city->genes) {
		if (!(gene = game_find_gene(g, k->id)))
			continue;

		if (gene->uid <= 0 || gene->sol_num <= 0) 
			continue;

		if (!(sph = game_find_sph_by_uid(g, gene->uid))) 
			continue;

		if (sph->id != city->sph_id)
			continue;

		if (min == NULL) {
			min = gene;
		}
		else if(gene->sol_num < min->sol_num){
			min = gene;
		}
	}

	if(min && min->sol_num <= 0) 
		return NULL;
	
	return min;
}


bool city_add_wubao(City *city, Wubao *w)
{
	if (!(city && w))
		return false;

	Key *k = NULL;

	if (city_find_wubao(city, w->id))
		return false;

	k = key_new(w->id);
	if (!k) 
		return false;
	if (RB_INSERT(KeyMap, &city->wubaos, k)) {
		key_free(k);
		return false;
	}
	city->wubao_num++;
	if (w->uid <= 0) 
		city->idle_wubao_num++;
	return true;
}

bool city_del_wubao(City *city, Wubao *w)
{
	if (!( w && city)) 
		return false;

	Key k ;
	Key *r = NULL;

	k.id = w->id;
	if (!(r = RB_FIND(KeyMap, &city->wubaos, &k))) {
		return false;
	}
	if ((r = RB_REMOVE(KeyMap, &city->wubaos, r)) == NULL) {
		return false;
	}
	key_free(r);
	return true;
}

Wubao * city_find_wubao(City *city, int id) 
{
	if(!city) 
		return NULL;

	Game *g = GAME;
	Key k;
	Key *r;
	Wubao *w = NULL;

	k.id = id;
	if ((r = RB_FIND(KeyMap, &city->wubaos, &k)) == NULL) 
		return NULL;
	if (!(w = game_find_wubao(g, r->id))) 
		return NULL;
	return w;
}

Wubao * city_get_idle_wubao(City *city)
{
	if (!city) 
		return NULL;

	Game *g = GAME;
	Wubao *w = NULL;
	Key *k = NULL;

	RB_FOREACH(k, KeyMap, &city->wubaos) {
		if (!(w = game_find_wubao(g, k->id)))
			continue;
		if(w->uid <= 0)
			return w;
	}

	return NULL;
}


int city_is_war(City *city)
{
	if (!city) 
		return 0;
	if (city->state == CITY_FIGHT)
		return 1;
	return 0;
}


int city_sol_num(City *city)
{
	if (!city)
		return 0;

	Game *g = GAME;
	Key *k = NULL;
	Gene *gene = NULL;
	Sph *sph = NULL;
	int count = 0;


	RB_FOREACH(k, KeyMap, &city->genes) {
		if (!(gene = game_find_gene(g, k->id)))
			continue;

		if (gene->uid <= 0) 
			continue;
		
		if (!(sph = game_find_sph_by_uid(g, gene->uid))) 
			continue;

		if (sph->id != city->sph_id)
			continue;

		count += gene->sol_num;
	}
	
	count += city->sol;
	
	return count;
}

bool city_get_idle_xy(City *city, int *x, int *y)
{
	if (!city)
		return false;

	Game *g = GAME;
	MapRegion *r = NULL;
	int i = 0;
	int j = 0;

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

void city_add_defense(City *city, float num)
{
	if (!city)
		return;

	city->defense += num;

	city->defense = MIN(city->defense, city->level * CITY_DEFENSE);
}

void city_add_sol(City *city, int num)
{
	if (!city)
		return;

	city->sol += num;

	city->sol = MIN(city->sol, city->level * CITY_SOL);
}

