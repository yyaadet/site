#ifndef _PLAYER_H_
#define _PLAYER_H_

struct Plunder;

struct User {
	int id;
	dstring name;
	dstring last_login_ip;
	int isonline;
    int is_locked;
	uint vip_total_hour;
	uint vip_used_hour;
	uint online_second;
	
	/*
	 * map to game connection
	 */
	int client_fd;
	/* map to wubao */
	int wid;

	RB_ENTRY(User) tlink;
};
typedef struct User User;

extern User *user_new();

extern void user_free(User *u);

extern bool user_is_vip(User *u);

extern bool user_is_npc(User *u);

extern int  user_get_vip_left_hour(User *u);

extern void user_retry_commit(const char *buf, int len, void *arg, int code);

extern void user_offline(User *u);

#endif

