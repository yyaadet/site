#ifndef _CONF_H_
#define  _CONF_H_
#include "common.h"


struct Conf {
	struct {
		const char *work_dir;
		short port;
		const char *addr;
		/* 1: debug; 2: warning; 3: error; */
		int log_level;
		char *webapi_url;
		char *webapi_addr;
		short webapi_port;
		const char *ip;
		const char *map; 
		const char *lua;
		const char *stage_map;
		int deny_war_begin;
		int deny_war_end;
	}core;

	struct {
		int connect_timeout;
		int read_timeout;
		int max_concurrent;
	}http;

	struct {
		char *addr;
		short port;
	}flex;
};
typedef struct Conf Conf;

extern Conf *conf_new(const char *path);

extern void conf_free(Conf *c);

#endif
