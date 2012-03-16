#include "hf.h"


User * user_new()
{
	User *u = (User *) cache_pool_alloc(POOL_USER);
	if (!u) 
		return NULL;
	
	u->id = 0;
	dstring_clear(&u->last_login_ip);
	dstring_clear(&u->name);
	u->vip_total_hour = 0;
	u->vip_used_hour = 0;
	u->online_second = 0;
	u->isonline = 0;

	u->client_fd = -1;
	u->wid = 0;

	return u;
}

void user_free(User *u)
{
	if (!u)
		return;

	cache_pool_free(POOL_USER, u);
}


bool user_is_vip(User *u)
{
	if (!u)
		return false;
	
	int left = user_get_vip_left_hour(u);

	return (left > 0);
}

bool user_is_npc(User *u)
{
	if (!u)
		return true;
	return (u->wid <= 0);
}

int user_get_vip_left_hour(User *u)
{
	int left_hour = 0;
	
	if (!u)
		return 0;
	
	left_hour = u->vip_total_hour - u->vip_used_hour;
	if (left_hour <= 0) {
		return 0;
	}
	return left_hour;
}
	

void user_retry_commit(const char *buf, int len, void *arg, int code)
{
	User *u = (User *)arg;

	if (!u)
		return;

	if (code == HTTP_OK)
		return;

	webapi_user(GAME, 0, u, ACTION_EDIT, user_retry_commit, u);
}

void user_offline(User *u)
{
	if (!u)
		return;

	Game *g = GAME;
	Wubao *w = NULL;
	time_t now = time(NULL);

	u->client_fd = -1;
	u->isonline = 0;
	if ((w = game_find_wubao(g, u->wid))) {
		u->online_second += (now - w->last_login_time);
	}
}



