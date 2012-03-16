#ifndef _TALK_H_
#define _TALK_H_

#include "city.h"
#include "general.h"
#include "treasure.h"

#define HISTORY_TALK_NUM 128

struct User;
struct Wubao;
struct Dipl;
struct Guanka;
struct Sph;

struct Talk {
	int send_uid;
	int recv_uid;
	dstring msg;

	TAILQ_ENTRY(Talk) link;
};
typedef struct Talk Talk;

enum TALK_WHO {
	TALK_NONE,
	TALK_SYS = -1,
	TALK_ALL = -2,
	TALK_SPH = -3,
};

enum SPH_STATE {
	SPH_NEW,
	SPH_DEL,
	SPH_FIRE,
	SPH_SHAN,
	SPH_RENAME,
	SPH_JOIN,
	SPH_ALLOW_JOIN,
	SPH_DENY_JOIN,
};

extern Talk *talk_new(int send_uid, int recv_uid, const char *src, int len);
extern Talk *talk_new1(int send_uid, int recv_uid, const char *src);
extern void talk_free(Talk *talk);


extern bool history_talk_push(Talk *t);
extern Talk *history_talk_pop();


extern void history_talk_send_out(GameConn *c);

extern void send_new_user_talk_msg(struct User *u);

extern void send_got_city_talk_msg(struct Sph *sph, City *city, int succ);

extern void send_dipl_talk_msg(struct Dipl *d);

#if 0
extern void send_sphere_talk_msg(struct Sph *sph, struct User *u, struct User *other, bool state);
#endif

extern void send_deny_war_talk();

extern void send_sell_weap_talk(struct User *u, struct SellOrder *o);

extern void send_reset_gk_talk(int h, int m);

extern void send_pass_gk_talk(struct Guanka *gk, struct User *u);

#endif


