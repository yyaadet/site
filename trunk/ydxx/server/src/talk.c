#include "hf.h"

#define DENY_WAR_FMT "亲爱的玩家，凌晨%d点至上午%d点是休战时间，"\
		"在此期间不能攻打任何城池。请大家合理安排游戏时间，保证足够的睡眠。"

static TAILQ_HEAD(HistoryTalkQueue, Talk) g_history_talks = TAILQ_HEAD_INITIALIZER(g_history_talks);
static int g_history_talk_num = 0;
static dstring msg = DSTRING_INITIAL;

Talk *talk_new(int send_uid, int recv_uid, const char *src, int len)
{
	Talk *t = (Talk *) cache_pool_alloc(POOL_TALK);
	if (!t)
		return NULL;
	t->send_uid = send_uid;
	t->recv_uid = recv_uid;
	dstring_clear(&t->msg);
	dstring_append(&t->msg, src, len);
	return t;
}

Talk *talk_new1(int send_uid, int recv_uid, const char *src)
{
	Talk *t = (Talk *) cache_pool_alloc(POOL_TALK);
	if (!t)
		return NULL;
	t->send_uid = send_uid;
	t->recv_uid = recv_uid;
	dstring_clear(&t->msg);
	dstring_set(&t->msg, src);
	return t;
}

void talk_free(Talk *talk)
{
	if (!talk)
		return;
	cache_pool_free(POOL_TALK, talk);
}


bool history_talk_push(Talk *t)
{
	Talk *old = NULL;

	if (!t) 
		return false;
	while(g_history_talk_num > HISTORY_TALK_NUM) {
		old = history_talk_pop();
		talk_free(old);
	}
	TAILQ_INSERT_TAIL(&g_history_talks, t, link);
	g_history_talk_num ++;
	return true;
}

Talk *history_talk_pop()
{
	Talk *t = NULL;

	t = TAILQ_FIRST(&g_history_talks);
	if (!t) 
		return NULL;
	TAILQ_REMOVE(&g_history_talks, t, link);
	g_history_talk_num--;
	return t;
}

void history_talk_send_out(GameConn *c)
{
	if (!c)
		return;

	Talk *t = NULL;
	
	TAILQ_FOREACH_REVERSE(t, &g_history_talks, HistoryTalkQueue, link) {
		send_nf_talk(t, c);
	}
}


/*
 * some import game tips 
 */

void send_new_user_talk_msg(User *u)
{
	if (!u) 
		return ;

	Talk *t = NULL;

	dstring_printf(&msg, "新人 %s 前来报到，大家一起热烈欢迎他！！",  u->name.buf);
	if (!(t = talk_new(TALK_SYS, TALK_ALL, msg.buf, msg.offset))) {
		return;
	} 

	send_nf_talk_where(t, WHERE_ALL);
	if (!history_talk_push(t)) {
		talk_free(t);
		return;
	}
}

void send_got_city_talk_msg(Sph *sph, City *city, int succ)
{
	if (!(sph && city)) 
		return ;

	Talk *t = NULL;

	dstring_clear(&msg);

	if (succ) {
		dstring_append_printf(&msg, "%s 胜利攻取了 %s 城",  sph->name.buf,  city->name.buf);
    }
	else {
		dstring_append_printf(&msg, "%s 攻城无果，被 %s 城中的将士击退了",  sph->name.buf,  city->name.buf);
	}
	
	if (!(t = talk_new(TALK_SYS, TALK_ALL, msg.buf, msg.offset))) {
		return;
	} 
	
	send_nf_talk_where(t, WHERE_ALL);

	if (!history_talk_push(t)) {
		talk_free(t);
		return;
	}
}


void send_dipl_talk_msg(Dipl *d)
{
	if (!d) 
		return ;

	Talk *t = NULL;
	Game *g = GAME;
	Sph *sph1 = NULL;
	Sph *sph2 = NULL;
	int now = GAME_NOW;


	if (!(sph1 = game_find_sph(g, d->self_id)))
		return ;

	if (!(sph2 = game_find_sph(g, d->target_id)))
		return ;

	dstring_clear(&msg);

	if (d->type == DIPL_LEAGUE) {
		if (d->end > now) {
			dstring_append_printf(&msg, "%s 势力与 %s 势力缔结同盟关系，期限为 %d 年",  \
					sph1->name.buf, sph2->name.buf, game_time_year(d->end) - game_time_year(d->start));
		}
		else {
			dstring_append_printf(&msg, "%s 势力与 %s 势力同盟关系结束了",  \
					sph1->name.buf, sph2->name.buf);
		}
	}
	else if (d->type == DIPL_ENEMY) {
		if (d->end > now) {
			dstring_append_printf(&msg, "%s 势力向 %s 势力宣战，战争状态将持续到 %d 年",  \
					sph1->name.buf, sph2->name.buf, game_time_year(d->end) - game_time_year(d->start));
		}
		else {
			dstring_append_printf(&msg, "%s 势力与 %s 势力不再处于敌对状态了",  \
					sph1->name.buf, sph2->name.buf);
		}
	}
	
	if (!(t = talk_new(TALK_SYS, TALK_ALL, msg.buf, msg.offset))) {
		return;
	} 

	send_nf_talk_where(t, WHERE_ALL);

	if (!history_talk_push(t)) {
		talk_free(t);
		return;
	}
}

#if 0
void send_sphere_talk_msg(Sph *sph, User *u, User *other, bool state)
{
	if (!(sph && u)) 
		return ;

	Talk *t = NULL;


	dstring_clear(&msg);

	if (state == SPH_NEW) 
		dstring_append_printf(&msg, "%s 创立 %s 势力，天下从此开始诸侯割据的时代", u->name.buf, sph->name.buf);
	else if (state == SPH_DEL) {
		dstring_append_printf(&msg, "%s 解散了 %s 势力，东汉历史上又减少了一位叱咤风云的豪杰", u->name.buf, sph->name.buf);
	}
	else if (state == SPH_FIRE) {
		dstring_append_printf(&msg, "%s 将 %s 从 %s 势力流放", u->name.buf, other ? other->name.buf: "", sph->name.buf);
	}
	else if (state == SPH_SHAN) {
		dstring_append_printf(&msg, "%s 将 %s 势力的主公地位禅让给了 %s，以避贤者路", u->name.buf, sph->name.buf, other ? other->name.buf : "");
	}
	else if (state == SPH_RENAME) {
		dstring_append_printf(&msg, "%s 修改了其靟下势力 %s 简介", u->name.buf, sph->name.buf);
	}
	else if (state == SPH_JOIN) {
		dstring_append_printf(&msg, "%s 请求加入 %s 势力，等待 %s 的同意", other ? other->name.buf : "", sph->name.buf,  u->name.buf);
	}
	else if (state == SPH_ALLOW_JOIN) {
		dstring_append_printf(&msg, "%s 同意了 %s 的加入势力请求，从此 %s 势力又多了一份力量", u->name.buf, other ? other->name.buf : "", sph->name.buf);
	}
	else if (state == SPH_DENY_JOIN) {
		dstring_append_printf(&msg, "%s 拒绝了 %s 的加入势力请求", u->name.buf, other ? other->name.buf : "");
	}

	if (!(t = talk_new(TALK_SYS, TALK_ALL, msg.buf, msg.offset))) {
		return;
	}

	send_nf_talk_where(t, WHERE_ALL);

	if (!history_talk_push(t)) {
		talk_free(t);
		return;
	}
}
#endif

void send_deny_war_talk()
{
	Conf *conf = g_cycle->conf;
	Talk *t = NULL;

	dstring_clear(&msg);

	dstring_append_printf(&msg, DENY_WAR_FMT, conf->core.deny_war_begin, conf->core.deny_war_end);

	if (!(t = talk_new(TALK_SYS, TALK_ALL, msg.buf, msg.offset))) {
		return;
	}

	send_nf_talk_where(t, WHERE_ALL);

	if (!history_talk_push(t)) {
		talk_free(t);
		return;
	}
}


void send_sell_weap_talk(struct User *u, struct SellOrder *o)
{
	if (!(u && o))
		return;
	
	Talk *t = NULL;
    const char *name = NULL;

    if (o->weap_id < 100) {
        name = weap_name(o->weap_id);
    }
    else {
        name = res_name(o->weap_id - 100);
    }

	dstring_printf(&msg, "%s 刚在市场上挂了 %d 把 %d 级的 %s，标价 %d，有兴趣的朋友可以去看看", \
			u->name.buf, o->weap_num, o->weap_level, name, o->gold);

	if (!(t = talk_new(TALK_SYS, TALK_ALL, msg.buf, msg.offset))) {
		return;
	}

	send_nf_talk_where(t, WHERE_ALL);

	if (!history_talk_push(t)) {
		talk_free(t);
		return;
	}
}

void send_reset_gk_talk(int h, int m)
{
	Talk *t = NULL;

	dstring_printf(&msg, "战役关卡将于 %02d:%02d 刷新", h, m);

	if (!(t = talk_new(TALK_SYS, TALK_ALL, msg.buf, msg.offset))) {
		return;
	}

	send_nf_talk_where(t, WHERE_ALL);

	if (!history_talk_push(t)) {
		talk_free(t);
		return;
	}
}

void send_pass_gk_talk(Guanka *gk, User *u)
{
	Talk *t = NULL;

	dstring_printf(&msg, "【%s】被【%s】成功击杀 ！", safe_str(gk->name.buf), safe_str(u->name.buf));

	if (!(t = talk_new(TALK_SYS, TALK_ALL, msg.buf, msg.offset))) {
		return;
	}

	send_nf_talk_where(t, WHERE_ALL);

	if (!history_talk_push(t)) {
		talk_free(t);
		return;
	}
}
