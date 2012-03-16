#include "hf.h"

static void donate_trea_done(const char *buf, int len, void *arg, int code);


Trea *trea_new(int treasure_id, int gene_id, int uid)
{
	Trea *t = (Trea *) cache_pool_alloc(POOL_TREA);
	if (!t) 
		return NULL;
	t->id = 0;
	t->trea_id = treasure_id;
	t->gene_id = gene_id;
	t->uid = uid;
	t->is_used = 0;
	t->use_time = 0;
	return t;
}

void trea_free(Trea *t)
{
	if (!t)
		return;
	cache_pool_free(POOL_TREA, t);
}

void trea_recycle(Trea *t) 
{
	Game *g = GAME;
	Gene *gene = NULL;

	if (!t) 
		return ;

	DEBUG(LOG_FMT"trea %d, old general %d\n", LOG_PRE, 
				t->id, t->gene_id);
	//check old
	if ((gene = game_find_gene(g, t->gene_id))) {
		gene_del_trea(gene, t);
	}

	trea_set_unused(t);
}

int trea_get_type(Trea *gt)
{
	TreaInfo *t = NULL;
	Game *g = GAME;

	if (!gt)
		return 0;
	if (!(t = game_find_trea_info(g, gt->trea_id)))
		return 0;
	return t->type;
}


int trea_get_num(Trea *gt)
{
	TreaInfo *t = NULL;
	Game *g = GAME;

	if (!gt)
		return 0;
	if (!(t = game_find_trea_info(g, gt->trea_id)))
		return 0;
	return t->num;
}

const char *trea_get_name(Trea *gt)
{
	TreaInfo *t = NULL;
	Game *g = GAME;

	if (!gt) 
		return NULL;
	if (!(t = game_find_trea_info(g, gt->trea_id)))
		return 0;
	return t->name;
}

bool trea_set_used(Trea *t)
{
	if (!t)
		return false;
	t->is_used = 1;
	t->use_time = GAME_NOW;
	return true;
}

bool trea_set_unused(Trea *t)
{
	if (!t)
		return false;
	t->gene_id = 0;
	t->is_used = 0;
	t->use_time = 0;
	return true;
}


void donate_trea(int uid, int trea_id)
{
	Trea *t = NULL;

	if (!(t = trea_new(trea_id, 0, uid))) {
		return;
	}

	webapi_donate_trea(t, donate_trea_done, t);
}

static void donate_trea_done(const char *buf, int len, void *arg, int code)
{
	if (!arg)
		return ;

	Game *g = GAME;
	Trea *t = (Trea *) arg;


	if (!(buf && code == HTTP_OK && atoi(buf) > 0)) {
		goto err;
	}

	t->id = atoi(buf);
	if (!game_add_trea(g, t)) {
		goto err;
	}

	send_nf_trea_where(t, WHERE_ME);
	return;

err:
	trea_free(t);
}


