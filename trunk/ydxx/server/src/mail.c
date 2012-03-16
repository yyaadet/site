#include "hf.h"

static dstring g_title = DSTRING_INITIAL;
static dstring g_cnt = DSTRING_INITIAL;


Mail *mail_new(int type, int sender_id, const char *sender_name, int recv_id, const char *recv_name, \
					  const char *title, const char *content, int send_time)
{
	Mail *m = (Mail *) cache_pool_alloc(POOL_MAIL);
	if (!m)
		return NULL;

	m->id = 0;
	m->type = type;
	m->send_id = sender_id;

	dstring_printf(&m->send_name, "%s", sender_name ? sender_name : "");

	m->recv_id = recv_id;
	
	dstring_printf(&m->recv_name, "%s", recv_name ? recv_name : "");

	dstring_printf(&m->title, "%s", title ? title : "");
	
	dstring_printf(&m->cont, "%s", content ? content : "");
	
	
	m->is_read = 0;
	m->send_time = send_time;

	return m;
}

Mail *mail_new1()
{
	return mail_new(0, 0, NULL, 0, NULL, NULL, NULL, 0);
}

void mail_free(Mail *mail)
{
	if (!mail)
		return ;
	cache_pool_free(POOL_MAIL, mail);
}

void send_mail_done(const char *buf, int len, void *arg, int code)
{
	Mail *m = (Mail *) arg;
	GameConn *c = NULL;

	if (!m)
		return;

	if (!(code == HTTP_OK && buf && atoi(buf) > 0)) 
		goto err;

	m->id = atoi(buf);
	if ((c = cycle_find_game_conn_by_uid(g_cycle, m->recv_id))) 
		send_nf_mail(m, c);

	mail_free(m);

	return;
err:
	mail_free(m);
}

void send_new_dignitie_mail(Wubao *w)
{
	if (!w) 
		return;

	Game *g = GAME;
	DignitieInfo *info = NULL;
	User *u = NULL;
	Mail *m = NULL;


	if (!(info = get_dignitie_info_by_id(w->dig_id))) 
		return;

	if (!(u = game_find_user(g, w->uid)))
		return;
	
	dstring_clear(&g_title);
	dstring_append_printf(&g_title, "授爵通知");

	dstring_clear(&g_cnt);
	dstring_append_printf(&g_cnt, "%s 久经沙场，屡建奇功，授爵 %s。",  u->name.buf, info->m_name);
	
	if (!(m = mail_new(MAIL_SYS, MAIL_SYS_ID, MAIL_SYS_NAME, u->id, u->name.buf, g_title.buf, g_cnt.buf, GAME_NOW))) {
		return;
	}

	webapi_mail(m, ACTION_ADD, send_mail_done, m);
}

void send_order_selled_mail(struct SellOrder *o, User *u)
{
	if (!(o && u)) 
		return;

	Mail *m = NULL;
	Game *g = GAME;
	User *seller = NULL;

	if (!(seller = game_find_user(g, o->uid)))
		return ;
	
	dstring_clear(&g_title);
	dstring_append_printf(&g_title, "您的\"%s\"已经被\"%s\"买走", weap_name(o->weap_id), u->name.buf);

	dstring_clear(&g_cnt);
	dstring_append_printf(&g_cnt, "%s 已经购买了您的 %d 个 %d 级的\"%s\"，它的标价为 %d 金币。",  u->name.buf, o->weap_num, o->weap_level, \
			weap_name(o->weap_id), o->gold);
	
	if (!(m = mail_new(MAIL_SYS, MAIL_SYS_ID, MAIL_SYS_NAME, seller->id, seller->name.buf, g_title.buf, g_cnt.buf, GAME_NOW))) {
		return;
	}

	webapi_mail(m, ACTION_ADD, send_mail_done, m);
}

void send_order_buyed_mail(struct SellOrder *o, User *u)
{
	if (!(o && u)) 
		return;

	Mail *m = NULL;
	Game *g = GAME;
	User *seller = NULL;

	if (!(seller = game_find_user(g, o->uid)))
		return ;
	
	dstring_clear(&g_title);
	dstring_append_printf(&g_title, "您已经购买了 %s 的\"%s\"", seller->name.buf, weap_name(o->weap_id));

	dstring_clear(&g_cnt);
	dstring_append_printf(&g_cnt, "您已经购买了 %s 的 %d 个 %d 级的\"%s\"，花费了 %d 金币。",  seller->name.buf, o->weap_num, o->weap_level, \
			weap_name(o->weap_id), o->gold);
	
	if (!(m = mail_new(MAIL_SYS, MAIL_SYS_ID, MAIL_SYS_NAME, u->id, u->name.buf, g_title.buf, g_cnt.buf, GAME_NOW))) {
		return;
	}

	webapi_mail(m, ACTION_ADD, send_mail_done, m);
}

void send_gene_faith_decr_mail(struct Gene *p)
{
	if (!p) 
		return;

	Mail *m = NULL;
	Game *g = GAME;
	User *u = NULL;
	
	if (!(u = game_find_user(g, p->uid)))
		return ;

	dstring_printf(&g_title, "【紧急通知】%s 忠诚度低于50", gene_get_full_name(p));

	dstring_printf(&g_cnt, "快送给他【千金】、【百金】，否则他将要走了。");
	
	if (!(m = mail_new(MAIL_SYS, MAIL_SYS_ID, MAIL_SYS_NAME, u->id, u->name.buf, g_title.buf, g_cnt.buf, GAME_NOW))) {
		return;
	}

	webapi_mail(m, ACTION_ADD, send_mail_done, m);
}

