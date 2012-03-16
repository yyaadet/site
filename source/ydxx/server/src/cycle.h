#ifndef _CYCLE_H_
#define  _CYCLE_H_
#include "common.h"
#include "logging.h"
#include "conf.h"
#include "conn.h"
#include "http.h"
#include "game.h"
#include "flexsecure.h"
#include "ev.h"
#include "luaapi.h"
#include "shm.h"
#include "sdb.h"




enum CYCLE_STATE {
	CYCLE_RUNNING,
	CYCLE_STOPING, 
};


struct Cycle {	
	int pid;

	Conf *conf;

	EvBase *evbase;

	Game *game;
	
	int game_conn_num;
	TAILQ_HEAD(, GameConn) game_conns;

	int flex_conn_num;
	TAILQ_HEAD(, FlexConn) flex_conns;

	int http_conn_num;
	TAILQ_HEAD(, HttpConn) http_conns;

	int deffer_http_url_num;
	TAILQ_HEAD(, HttpUrl) deffer_http_urls;
	
	LuaScript *lua;

	byte state;

	int stop_time;

	Shmem sdb_shm[SDB_ALL - 1];
};
typedef struct Cycle Cycle;

extern Cycle *cycle_new();
extern void cycle_free(Cycle *c);

extern void cycle_stop(Cycle *c, int deffer_sec);

extern bool cycle_load_shm(Cycle *c);
extern void cycle_flush_to_shm(Cycle *c, int type);

extern GameConn * cycle_find_game_conn(Cycle *c, int fd);
extern GameConn * cycle_find_game_conn_by_uid(Cycle *c, int uid);
extern bool cycle_del_game_conn(Cycle * c, GameConn *conn);
extern bool cycle_add_game_conn(Cycle *c, GameConn *conn);
extern void cycle_free_all_game_conn(Cycle *c);

extern bool cycle_add_deffer_http_url(Cycle *c, HttpUrl * url);
extern bool cycle_del_deffer_http_url(Cycle *c, HttpUrl * url);

extern bool cycle_add_http_conn(Cycle *c, HttpConn *conn);
extern bool cycle_del_http_conn(Cycle *c, HttpConn *conn);
extern void cycle_free_all_http_conn(Cycle *c);

extern bool cycle_add_flex_conn(Cycle *c, FlexConn *conn);
extern bool cycle_del_flex_conn(Cycle *c, FlexConn *conn);
extern void cycle_free_all_flex_conn(Cycle *c);

extern const char * cycle_build_shm_path(Cycle *c);

extern void check_deffer_http(void *arg);

/*
 * constant
 */

extern Cycle *g_cycle;

#endif

