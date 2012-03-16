#include "hf.h"


Cycle *g_cycle = NULL;


Cycle * cycle_new()
{
	Cycle *c = (Cycle *) xmalloc(sizeof(Cycle));
	if (!c) 
		return NULL;

	c->pid = getpid();
	
	c->conf = NULL;

	if (!(c->evbase = ev_base_new())) {
		cycle_free(c);
		return NULL;
	}
	
	c->game_conn_num = 0;
	TAILQ_INIT(&c->game_conns);
	
	c->http_conn_num = 0;
	TAILQ_INIT(&c->http_conns);
	
	c->deffer_http_url_num = 0;
	TAILQ_INIT(&c->deffer_http_urls);

	c->flex_conn_num = 0;
	TAILQ_INIT(&c->flex_conns);

	if (!(c->game = game_new())) {
		cycle_free(c);
		return NULL;
	}

	if (!(c->lua = lua_script_new())) {
		cycle_free(c);
		return NULL;
	}

	c->state = CYCLE_RUNNING;
	
	c->stop_time = 0;

	return c;
}

void cycle_free(Cycle *c)
{	
	if (!c) 
		return;
	
	ev_base_free(c->evbase);
	c->evbase = NULL;

	lua_script_free(c->lua);
	c->lua = NULL;

	cycle_free_all_http_conn(c);
	cycle_free_all_game_conn(c);
	cycle_free_all_flex_conn(c);
	
	conf_free(c->conf);

	game_free(c->game);
	
	free(c);
}


GameConn * cycle_find_game_conn(Cycle *cyc, int fd) 
{
	if (!cyc) 
		return NULL;
	GameConn *c, *tmp;

	TAILQ_FOREACH_SAFE(c, &cyc->game_conns,link, tmp) {
		if (c->fd == fd) {
			return c;
		}
	}
	return NULL;
}


GameConn *cycle_find_game_conn_by_uid(Cycle *cyc, int uid)
{
	if(!cyc)
		return NULL;

	User *u = NULL;
	Game *g = cyc->game;
	GameConn *conn = NULL;

	if ((u = game_find_user(g, uid)) == NULL) 
		return NULL;

	if ((conn = cycle_find_game_conn(cyc, u->client_fd)))
		return conn;
	return NULL;
}

bool cycle_del_game_conn(Cycle *cyc, GameConn *c)
{
	if (!(c&& cyc)) 
		return false;

	TAILQ_REMOVE(&cyc->game_conns, c, link);
	cyc->game_conn_num --;
	
	return true;
}

bool cycle_add_game_conn(Cycle* cyc, GameConn *conn)
{
	if (!(conn && cyc))
		return false;

	TAILQ_INSERT_TAIL(&cyc->game_conns, conn, link);
	cyc->game_conn_num++;

	return true;
}

void cycle_free_all_game_conn(Cycle *c)
{
	if(!c)
		return;
	GameConn *p, *tmp;

	TAILQ_FOREACH_SAFE(p, &c->game_conns, link, tmp) {
		TAILQ_REMOVE(&c->game_conns, p, link);
		game_conn_free(p);
	}
}
	
bool cycle_add_http_conn(Cycle *c, HttpConn *conn)
{
	if (!(c && conn))
		return false;
	TAILQ_INSERT_TAIL(&c->http_conns, conn, link);
	c->http_conn_num++;
	return true;
}

bool cycle_del_http_conn(Cycle *c, HttpConn *conn) 
{
	if (!(c && conn))
		return false;
	TAILQ_REMOVE(&c->http_conns, conn, link);
	c->http_conn_num--;
	return true;
}

bool cycle_add_deffer_http_url(Cycle *cyc, HttpUrl *url)
{
	if (!(url && cyc))
		return false;
	TAILQ_INSERT_TAIL(&cyc->deffer_http_urls, url, link);
	cyc->deffer_http_url_num++;
	return true;
}

bool cycle_del_deffer_http_url(Cycle *cyc, HttpUrl *url)
{
	if (!(url && cyc))
		return false;
	TAILQ_REMOVE(&cyc->deffer_http_urls, url, link);
	cyc->deffer_http_url_num--;
	return true;
}

void cycle_free_all_http_conn(Cycle *cyc)
{
	if(!cyc)
		return ;

	HttpConn *c, *tmp;
	HttpUrl *url, *u_tmp;

	//close all deffer http conn
	TAILQ_FOREACH_SAFE(url, &cyc->deffer_http_urls, link, u_tmp) {
		TAILQ_REMOVE(&cyc->deffer_http_urls, url, link);
		http_url_free(url);
	}
	cyc->deffer_http_url_num = 0;

	// close all http conn
	TAILQ_FOREACH_SAFE(c, &cyc->http_conns, link, tmp) {
		TAILQ_REMOVE(&cyc->http_conns, c, link);
		http_conn_free(c);
	}
	cyc->http_conn_num = 0;
}

bool cycle_add_flex_conn(Cycle *cyc, FlexConn *c)
{
	if (!(c && cyc))
		return false;
	TAILQ_INSERT_TAIL(&cyc->flex_conns, c, link);
	cyc->flex_conn_num++;
	return true;
}

bool cycle_del_flex_conn(Cycle *cyc, FlexConn *c)
{
	if (!(cyc && c)) 
		return false;
	TAILQ_REMOVE(&cyc->flex_conns, c, link);
	cyc->flex_conn_num--;
	return true;
}

void cycle_free_all_flex_conn(Cycle *cyc)
{
	if (!cyc) 
		return;
	FlexConn *c, *tmp;

	TAILQ_FOREACH_SAFE(c, &cyc->flex_conns, link, tmp) {
		TAILQ_REMOVE(&cyc->flex_conns, c, link);
		flex_conn_free(c);
	}
}


void cycle_stop(Cycle *c, int deffer_sec)
{
	if(!c) 
		return;
	
	c->state = CYCLE_STOPING;

	cycle_flush_to_shm(c, SDB_ALL);
	
	exit(g_exit_code);
}
	

bool cycle_load_shm(Cycle *c)
{
	if (!c)
		return false;

	const char *path = NULL;
	bool succ = true;
	int i = 0;

	path = cycle_build_shm_path(c);

	for(i = SDB_NONE; i < SDB_ALL - 1; i++) {
		if (!shmem_load(&c->sdb_shm[i], path, g_sdb_info[i + 1].sz, SHM_FULL_PERM, i + 1))
			succ = false;
	}

	return succ;
}

void cycle_flush_to_shm(Cycle *c, int type)
{
	if (!c)  {
		DEBUG(LOG_FMT"cycle is null, return.\n", LOG_PRE);
		return;
	}

	if (c->game->init_state != GAME_INIT_FIN) {
		WARN(LOG_FMT"game is not init done, return.\n", LOG_PRE);
		return;
	}

	int i = 0;
	
	
	if (type == SDB_ALL) {
		for(i = SDB_NONE; i < SDB_ALL - 1; i++) {
			create_sdb(i + 1, &c->sdb_shm[i], c->game);
		}
	}
	else if (type > SDB_NONE && type <SDB_ALL) {
		create_sdb(type, &c->sdb_shm[type - 1], c->game);
	}
}


void check_deffer_http(void *arg)
{
	Conf *conf = g_cycle->conf;

	DEBUG(LOG_FMT"deffer %d, running %d\n", \
						LOG_PRE,  \
						g_cycle->deffer_http_url_num, \
						g_cycle->http_conn_num);

	while(g_cycle->deffer_http_url_num > 0 &&  \
		    g_cycle->http_conn_num < conf->http.max_concurrent) {
		
		HttpUrl *url = TAILQ_FIRST(&g_cycle->deffer_http_urls);
	
		if (!url)
			return;
		http_request(url->host.buf, url->port, url->path.buf, url->body.buf, \
					url->body.offset, url->cb, url->arg);
		
		cycle_del_deffer_http_url(g_cycle, url);
		http_url_free(url);
	}
}


const char * cycle_build_shm_path(Cycle *c)
{
	if (!c)
		return NULL;

	const char *path = NULL;
	const char *work_dir = c->conf->core.work_dir;

	path = build_file_path(work_dir, "hfd.shm");
	if (!path) 
		return NULL;

	if(path_exist(path) == false)
		create_path(path);

	return path;
}




