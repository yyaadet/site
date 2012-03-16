#include "hf.h"

#define GET_STRING(g, n, def, t, ini, ret) do { \
	t = init_get_entry(ini, g, n); \
	if (t) \
		(ret) = strdup(t); \
	else \
		(ret) = strdup(def); \
	}while(0)

#define GET_INT(g, n, def, t, ini, ret) do { \
	t = init_get_entry(ini, g, n); \
	if (t) \
	(ret) = atoi(t); \
	else \
	(ret) = def; \
	}while(0)


Conf *conf_new(const char *path)
{
	if (!path)
		return NULL;

	char *tmp = NULL;
	const char *t = NULL;
	Ini *ini = NULL;
	Conf *c = (Conf *) xmalloc(sizeof(Conf));
	if(!c)
		return NULL;
	if (NULL == (ini = ini_new(path))) {
		conf_free(c);
		return NULL;
	}
	
	//core
	GET_STRING(CONF_CORE_SECTION, "work_dir", DEFAULT_CORE_WORK_DIR, t, ini, c->core.work_dir);
	GET_INT(CONF_CORE_SECTION, "log_level", DEFAULT_CORE_LOG_LEVEL, t, ini, c->core.log_level);
	GET_STRING(CONF_CORE_SECTION, "addr", DEFAULT_CORE_ADDR, t, ini, c->core.addr);
	GET_INT(CONF_CORE_SECTION, "port", DEFAULT_CORE_PORT, t, ini, c->core.port);
	
	GET_STRING(CONF_CORE_SECTION, "webapi_addr", "", t, ini, c->core.webapi_addr);
	GET_INT(CONF_CORE_SECTION, "webapi_port", 80, t, ini, c->core.webapi_port);
	GET_STRING(CONF_CORE_SECTION, "webapi_url", "", t, ini, tmp);
	
	GET_INT(CONF_CORE_SECTION, "deny_war_begin", 1, t, ini, c->core.deny_war_begin);
	GET_INT(CONF_CORE_SECTION, "deny_war_end", 6, t, ini, c->core.deny_war_end);
	
	//fprintf(stderr, "%c\n", tmp[strlen(tmp) - 1]);
	if (tmp[strlen(tmp) - 1] != '/') {
		c->core.webapi_url = xmalloc(strlen(tmp) + 2);
		snprintf(c->core.webapi_url, strlen(tmp) + 2, "%s/", tmp);
	}
	else {
		c->core.webapi_url = strdup_safe(tmp);
	}

	//fprintf(stderr, "%s\n", c->core.webapi_url);
	
	GET_STRING(CONF_CORE_SECTION, "map", "", t, ini, c->core.map);
	GET_STRING(CONF_CORE_SECTION, "lua", "", t, ini, c->core.lua);
	GET_STRING(CONF_CORE_SECTION, "stage_map", "", t, ini, c->core.stage_map);

	//http
	GET_INT(CONF_HTTP_SECTION, "connect_timeout", DEFAULT_HTTP_CONNECT_TIMEOUT, t, ini, c->http.connect_timeout);
	GET_INT(CONF_HTTP_SECTION, "read_timeout", DEFAULT_HTTP_READ_TIMEOUT, t, ini, c->http.read_timeout);
	GET_INT(CONF_HTTP_SECTION, "max_concurrent", DEFUALT_HTTP_MAX_CONCURRENT, t, ini, c->http.max_concurrent);

	//flex
	GET_STRING(CONF_FLEX_SECTION,"addr", DEFAULT_FLEX_ADDR, t, ini, c->flex.addr);
	GET_INT(CONF_FLEX_SECTION, "port", DEFAULT_FLEX_PORT, t, ini, c->flex.port);

	ini_free(ini);
	return c;
}

void conf_free(Conf *c)
{
	if (!c)
		return;
	free(c);
}

