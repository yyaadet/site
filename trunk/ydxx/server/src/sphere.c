#include "hf.h"


Sph *sph_new(void)
{
	Sph * s = (Sph *) cache_pool_alloc(POOL_SPHERE);
	if (!s)
		return NULL;

	s->id = 0;
	s->uid  = 0;
	dstring_clear(&s->name);
	dstring_clear(&s->desc);
	s->level = 0;
	s->prestige = 0;
	s->max_member = 0;
	s->is_npc = 0;

	RB_INIT(&s->dipl);
	s->dipl_num = 0;

	RB_INIT(&s->city);
	s->city_num = 0;

	RB_INIT(&s->wubao);
	s->wubao_num = 0;

	return s;
}

void sph_free(Sph *sph) 
{
	Key *k, *t;

	if (!sph)
		return;
	for (k = RB_MIN(KeyMap, &sph->dipl); k != NULL; k = t) {
		t = RB_NEXT(KeyMap, &sph->dipl, k);
		RB_REMOVE(KeyMap, &sph->dipl, k);
		key_free(k);
	}
	
	for (k = RB_MIN(KeyMap, &sph->city); k != NULL; k = t) {
		t = RB_NEXT(KeyMap, &sph->city, k);
		RB_REMOVE(KeyMap, &sph->city, k);
		key_free(k);
	}
	
	for (k = RB_MIN(KeyMap, &sph->wubao); k != NULL; k = t) {
		t = RB_NEXT(KeyMap, &sph->wubao, k);
		RB_REMOVE(KeyMap, &sph->wubao, k);
		key_free(k);
	}

	cache_pool_free(POOL_SPHERE, sph);
}



bool sph_add_dipl(Sph *sph, int sph_id, int dipl_id)
{
	if (!sph)
		return false;
	if (sph_find_dipl(sph, sph_id))
		return false;

	Key *k = key_new(sph_id);
	if (!k) 
		return false;
	k->arg = (void *) dipl_id;

	if (NULL == RB_INSERT(KeyMap, &sph->dipl, k)) {
		sph->dipl_num++;
		return true;
	}
	key_free(k);
	return false;
}

bool sph_del_dipl(Sph *sph, int sph_id)
{
	Key k;
	Key *r = NULL;

	if (!sph) 
		return false;
	k.id = sph_id;
	if ((r = RB_FIND(KeyMap, &sph->dipl, &k)) == NULL) {
		return false;
	}
	RB_REMOVE(KeyMap, &sph->dipl, r);
	sph->dipl_num--;
	key_free(r);
	return true;
}

Dipl * sph_find_dipl(Sph *sph, int sph_id)
{
	Game *g = GAME;
	Key k;
	Key *r = NULL;

	if (!sph) 
		return NULL;
	k.id = sph_id;
	r = RB_FIND(KeyMap, &sph->dipl, &k);
	if (!r) 
		return NULL;
	return (game_find_dipl(g, (int)r->arg));
}

bool sph_add_city(Sph *sph, int city_id)
{
	if (!sph)
		return false;
	if (sph_find_city(sph, city_id))
		return false;
	
	Key *k = key_new(city_id);
	if (!k) 
		return false;
	if (RB_INSERT(KeyMap, &sph->city, k)) {
		key_free(k);
		return false;
	}
	
	sph->city_num++;
	return true;
}

bool sph_del_city(Sph *sph, int city_id)
{
	Key k ;
	Key *r = NULL;

	if (!sph) 
		return false;
	
	k.id = city_id;
	if ((r = RB_FIND(KeyMap, &sph->city, &k)) == NULL) {
		return false;
	}
	if(!RB_REMOVE(KeyMap, &sph->city, r))
		return false;

	key_free(r);
	
	sph->city_num--;
	return true;
}

City *sph_find_city(Sph *sph, int city_id)
{
	Game *g = GAME;
	Key k;
	Key *r = NULL;

	if (!sph) 
		return NULL;
	k.id = city_id;
	r = RB_FIND(KeyMap, &sph->city, &k);
	if (!r) 
		return NULL;
	return (game_find_city(g, r->id));
}

City *sph_get_city(Sph *sph)
{
	if (!sph)
		return NULL;

	Game *g = GAME;
	Key *n = RB_MIN(KeyMap, &sph->city);

	if (!n)
		return NULL;

	return game_find_city(g, n->id);
}

int sph_relation(Sph * sph1, Sph * sph2)
{
	Dipl *dipl = NULL;
	Dipl *dipl1 = NULL;
	int rela = 0;
	int life = 0;
	int rela1 = 0;
	int life1 = 0;


	if (sph1->id == sph2->id)
		return DIPL_LEAGUE;

	dipl = sph_find_dipl(sph1, sph2->id);
	rela = dipl ? dipl->type : 0;
	life = dipl ? GAME_NOW - dipl->start : 0;

	dipl1 = sph_find_dipl(sph2, sph1->id);
	rela1 = dipl1 ? dipl1->type : 0;
	life1 = dipl1 ? GAME_NOW - dipl1->start : 0;

	if ((rela == DIPL_ENEMY && life >= MAX_DIPL_ENEMY_LIFE) || \
			(rela1 == DIPL_ENEMY && life1 >= MAX_DIPL_ENEMY_LIFE)) 
		return DIPL_ENEMY;
	else if (rela == DIPL_LEAGUE || rela1 == DIPL_LEAGUE)
		return DIPL_LEAGUE;


	return DIPL_NONE;
}


bool sph_add_wubao(Sph *sph, Wubao *w)
{
	if (!(sph && w))
		return false;

	if (sph_find_wubao(sph, w->id))
		return false;

	Key *k ;

	if (!(k = key_new(w->id))) {
		return false;
	}
	if (RB_INSERT(KeyMap, &sph->wubao, k)) {
		key_free(k);
		return false;
	}

	sph->wubao_num++;
	return true;
}

bool sph_del_wubao(Sph *sph, Wubao *w)
{
	if (!(sph && w))
		return false;

	Key *r = NULL;
	Key k;

	k.id = w->id;
	
	if(!(r = RB_FIND(KeyMap, &sph->wubao, &k)))
		return false;
	
	if (!RB_REMOVE(KeyMap, &sph->wubao, r))
		return false;
	
	sph->wubao_num--;

	key_free(r);	
	
	return true;
}

Wubao * sph_find_wubao(Sph *sph, int id)
{
	if (!(sph))
		return false;

	Game *g = GAME;
	Key *r = NULL;
	Key k;

	k.id = id;
	
	if(!(r = RB_FIND(KeyMap, &sph->wubao, &k)))
		return false;
	
	return game_find_wubao(g, r->id);
}


int sph_add_prestige(Sph *sph, int num)
{
	if (!sph)
		return 0;

	sph->left_prestige += num;
	
	sph->prestige += (sph->left_prestige / SPH_PRES_OF_KILL);

	sph->left_prestige = sph->left_prestige % SPH_PRES_OF_KILL;

	return sph->prestige;
}
