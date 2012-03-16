#include "hf.h"

typedef void * (*ReqBodyParser) (dstring *);
typedef void (*ReqBodyFreer) (void *);

struct ReqBodyHandleInfo {
	int type;
	const char *name;
	ReqBodyParser parser;
	ReqBodyFreer freer;
};
typedef struct ReqBodyHandleInfo ReqBodyHandleInfo;

static  ReqBodyHandleInfo  g_req_handlers[] = {
	{REQ_NONE, "REQ_NONE", NULL, NULL},
	/* c --> s */
	{REQ_LOGIN, "REQ_LOGIN", req_login_body_parse, req_login_body_free},
	{REQ_CREATE_ROLE, "REQ_CREATE_ROLE", req_create_role_body_parse, req_create_role_body_free}, 
	{REQ_LEVEL_UP, "REQ_LEVEL_UP", req_level_up_body_parse, req_level_up_body_free},
	{REQ_CANCEL_LEVEL_UP, "REQ_CANCEL_LEVEL_UP", req_cancel_level_up_body_parse, req_cancel_level_up_body_free}, 
	{REQ_SPEED, "REQ_SPEED", req_speed_body_parse, req_speed_body_free},
	{REQ_CHECK_LEVEL, "REQ_CHECK_LEVEL", NULL, NULL},
	{REQ_MADE, "REQ_MADE", req_made_body_parse, req_made_body_free},
	{REQ_COMBIN, "REQ_COMBIN", req_comb_body_parse, req_comb_body_free},
	{REQ_DESTROY, "REQ_DESTROY", req_destroy_body_parse, req_destroy_body_free},
	{REQ_CONFIG_SOL, "REQ_CONFIG_SOL", req_config_sol_body_parse, req_config_sol_body_free},
	{REQ_EXP, "REQ_EXP", req_exp_body_parse, req_exp_body_free},
	{REQ_RECOVER, "REQ_RECOVER", req_recover_body_parse, req_recover_body_free},
	{REQ_USE_GENE, "REQ_USE_GENE", req_use_gene_body_parse, req_use_gene_body_free},
	{REQ_TRAN_GENE, "REQ_TRAN_GENE", req_tran_gene_body_parse, req_tran_gene_body_free},
	{REQ_VISIT_GENE, "REQ_VISIT_GENE", req_visit_gene_body_parse, req_visit_gene_body_free},
	{REQ_GIVE, "REQ_GIVE", req_give_body_parse, req_give_body_free},
	{REQ_BUY, "REQ_BUY", req_buy_body_parse, req_buy_body_free},
	{REQ_FIRE, "REQ_FIRE", req_fire_body_parse, req_fire_body_free},
	{REQ_CREATE_SPH, "REQ_CREATE_SPH", req_create_sph_body_parse, req_create_sph_body_free},
	{REQ_SHAN_SPH, "REQ_SHAN_SPH", req_shan_sph_body_parse, req_shan_sph_body_free},
	{REQ_EDIT_SPH, "REQ_EDIT_SPH", req_edit_sph_body_parse, req_edit_sph_body_free},
	{REQ_REMOVE_SPH, "REQ_REMOVE_SPH", req_remove_sph_body_parse, req_remove_sph_body_free},
	{REQ_FIRE_MEM, "REQ_FIRE_MEM", req_fire_mem_body_parse, req_fire_mem_body_free},
	{REQ_APPLY_JOIN_SPH, "REQ_APPLY_JOIN_SPH", req_apply_join_sph_body_parse, req_apply_join_sph_body_free},
	{REQ_TELL_APPLY_JOIN_SPH, "REQ_TELL_APPLY_JOIN_SPH", req_tell_apply_join_sph_body_parse, req_tell_apply_join_sph_body_free},
	{REQ_AWAY_SPH, "REQ_AWAY_SPH", req_away_sph_body_parse, req_away_sph_body_free},
	{REQ_APPLY_OFF, "REQ_APPLY_OFF", req_apply_off_body_parse, req_apply_off_body_free},
	{REQ_APPLY_LEAGUE, "REQ_APPLY_LEAGUE", req_apply_league_body_parse, req_apply_league_body_free},
	{REQ_TELL_APPLY_LEAGUE, "REQ_TELL_APPLY_LEAGUE", req_tell_apply_league_body_parse, req_tell_apply_league_body_free},
	{REQ_READY_WAR, "REQ_READY_WAR", req_ready_war_body_parse, req_ready_war_body_free},
	{REQ_MOVE, "REQ_MOVE", req_move_body_parse, req_move_body_free},
	{REQ_CHANGE_ZHEN, "REQ_CHANGE_ZHEN", req_change_zhen_body_parse, req_change_zhen_body_free},
	{REQ_MAIL, "REQ_MAIL", req_mail_body_parse, req_mail_body_free},
	{REQ_TALK, "REQ_TALK", req_talk_body_parse, req_talk_body_free},
	{REQ_LEARN,	"REQ_LEARN", req_learn_body_parse, req_learn_body_free},
	{REQ_SYS_TRADE, "REQ_SYS_TRADE", req_sys_trade_body_parse, req_sys_trade_body_free},
	{REQ_ORDER, "REQ_ORDER", req_order_body_parse, req_order_body_free},
	{REQ_SELL_ORDER, "REQ_SELL_ORDER", req_sell_order_body_parse, req_sell_order_body_free},
	{REQ_BUY_WEAP, "REQ_BUY_WEAP", req_buy_weap_body_parse, req_buy_weap_body_free},
	{REQ_CANCEL_ORDER, "REQ_CANCEL_ORDER", req_cancel_order_body_parse, req_cancel_order_body_free},
	{REQ_ACCEPT_TASK, "REQ_ACCEPT_TASK", req_accept_task_body_parse, req_accept_task_body_free},
	{REQ_CANCEL_TASK, "REQ_CANCEL_TASK", NULL, NULL},
	{REQ_CHECK_TASK, "REQ_CHECK_TASK", NULL, NULL},
	{REQ_GET_PRIZE, "REQ_GET_PRIZE", NULL, NULL},
	{REQ_BOX, "REQ_BOX", req_box_body_parse, req_box_body_free},
	{REQ_WELFARE, "REQ_WELFARE", NULL, NULL},
	{REQ_PLUNDER, "REQ_PLUNDER", req_plunder_body_parse, req_plunder_body_free},
	{REQ_TRAIN, "REQ_TRAIN", req_train_body_parse, req_train_body_free},
	{REQ_MOVE_CITY, "REQ_MOVE_CITY", req_move_city_body_parse, req_move_city_body_free},
	{REQ_PK, "REQ_PK", req_pk_body_parse, req_pk_body_free},
	{REQ_ADD_MADE, "REQ_ADD_MADE", NULL, NULL},
	{REQ_ADD_SOL, "REQ_ADD_SOL", NULL, NULL},
	{REQ_SPEED_TRAIN, "REQ_SPEED_TRAIN", NULL, NULL},
	{REQ_SPEED_JUNLIN, "REQ_SPEED_JUNLIN", NULL, NULL},
	{REQ_BUY_JUNLIN, "REQ_BUY_JUNLIN", NULL, NULL},
	{REQ_APPLY_SPH_BOSS, "REQ_APPLY_SPH_BOSS", NULL, NULL},
	{REQ_UP_KUFANG, "REQ_UP_KUFANG", NULL, NULL},
	{REQ_SET_FRESH_STEP, "REQ_SET_FRESH_STEP", req_set_fresh_step_body_parse, req_set_fresh_step_body_free},
	{REQ_DECLARE_WAR, "REQ_DECLARE_WAR", req_declare_war_body_parse, req_declare_war_body_free},
	{REQ_APPLY_WAR, "REQ_APPLY_WAR", req_apply_war_body_parse, req_apply_war_body_free},
	{REQ_EXIT_WAR, "REQ_EXIT_WAR", req_exit_war_body_parse, req_exit_war_body_free},
	/* s --> c */
	{REQ_NF_CREATE_ROLE, "REQ_NF_CREATE_ROLE", NULL, NULL},
	{REQ_NF_TIME, "REQ_NF_TIME", NULL, NULL},
	{REQ_NF_WUBAO, "REQ_NF_WUBAO", NULL, NULL},
	{REQ_NF_GENE, "REQ_NF_GENE", NULL, NULL}, 
	{REQ_NF_CITY, "REQ_NF_CITY", NULL, NULL}, 
	{REQ_NF_SPH, "REQ_NF_SPH", NULL, NULL},
	{REQ_NF_ARMY, "REQ_NF_ARMY", NULL, NULL},
	{REQ_NF_USER, "REQ_NF_USER", NULL, NULL},  
	{REQ_NF_DIPL, "REQ_NF_DIPL", NULL, NULL},
	{REQ_NF_TREA, "REQ_NF_TREA", NULL, NULL},
	{REQ_NF_WAR, "REQ_NF_WAR", NULL, NULL},
	{REQ_NF_MAIL, "REQ_NF_MAIL", NULL, NULL},
	{REQ_NF_TALK, "REQ_NF_TALK", NULL, NULL},
	{REQ_NF_CMD_TRANS, "REQ_NF_CMD_TRANS", NULL, NULL},
	{REQ_NF_ORDER, "REQ_NF_ORDER", NULL, NULL},
	{REQ_NF_SELL_ORDER, "REQ_NF_SELL_ORDER", NULL, NULL},
	{REQ_NF_FIGHT, "REQ_NF_BOX", NULL, NULL},
	{REQ_NF_WELFARE, "REQ_NF_WELFARE", NULL, NULL},
	{REQ_NF_GUANKA, "REQ_NF_GUANKA", NULL, NULL},
	/* c -->s, special*/
	{REQ_POOL, "REQ_POOL", NULL, NULL},
	{REQ_DONATE_TREA, "REQ_DONATE_TREA", req_donate_trea_body_parse, req_donate_trea_body_free},
};

static int g_msg_id = 0;
static dstring g_dst = DSTRING_INITIAL;


Req *req_new(int type, int send_id, int msg_id, const char *body, int len, GameConn *conn)
{
	Req *r = (Req *)cache_pool_alloc(POOL_REQ);
	if (!r) {
		return NULL;
	}
	r->type = type;
	r->sid = send_id;
	r->mid = msg_id;
	dstring_clear(&r->body);
	dstring_append(&r->body, body, len);
	dstring_set_big_endian(&r->body);
	r->resp_code = 0;
	r->conn = conn;
	r->bs = NULL;
	r->cb = NULL;
	r->arg = NULL;
	r->total = 16 + r->body.offset;
	return r;
}

//not need to parse
Req *req_new1(int type, int send_id, int msg_id, void *bs, GameConn *conn)
{
	Req *r = (Req *)cache_pool_alloc(POOL_REQ);
	if (!r) {
		return NULL;
	}
	r->type = type;
	r->sid = send_id;
	r->mid = msg_id;
	dstring_clear(&r->body);
	dstring_set_big_endian(&r->body);
	r->resp_code = 0;
	r->conn = conn;
	r->bs = bs;
	r->cb = NULL;
	r->arg = NULL;
	r->total = 16;
	return r;
}

void req_free(Req *req)
{
	if (!req)
		return;

	int arr_len = 0;
	int i = 0;
	ReqBodyHandleInfo *rh = NULL;

	dstring_clear(&req->body);

	arr_len =  ARRAY_LEN(g_req_handlers, ReqBodyHandleInfo);
	for ( i = 0 ; i < arr_len; i ++ ) {
		if (req->type == g_req_handlers[i].type) {
			rh = &g_req_handlers[i];
			break;
		}
	}
	if (rh && rh->freer) {
		rh->freer(req->bs);
	}
	cache_pool_free(POOL_REQ, req);
}

bool req_parse(Req *r, const char *buf, int len)
{
	int offset = 0;
	int body_len = 0;
	int i = 0;
	int arr_len = 0;
	ReqBodyHandleInfo *rh = NULL;
	bool ret = true;

	if (!(r && buf)) {
		return false;
	}
	//get total length
	memcpy(&r->total, buf, 4);
	r->total = ntohl(r->total);
	offset += 4;
	if (len != r->total) {
		WARN(LOG_FMT"request msg header total length not equal with factual msg length\n", LOG_PRE);
		return false;
	}
	//get msg type
	memcpy(&r->type, buf + offset, 4);
	r->type = ntohl(r->type);
	offset += 4;
	//get send id
	memcpy(&r->sid, buf + offset, 4);
	r->sid = ntohl(r->sid);
	offset += 4;
	//get msg id
	memcpy(&r->mid, buf+offset, 4);
	r->mid = ntohl(r->mid);
	offset += 4;
	//get body
	body_len = r->total - 16; 
	if (body_len > 0) {
		dstring_append(&r->body, buf + 16, body_len);
	}

	arr_len =  ARRAY_LEN(g_req_handlers, ReqBodyHandleInfo);
	for ( i = 0 ; i < arr_len; i ++ ) {
		if (r->type == g_req_handlers[i].type) {
			rh = &g_req_handlers[i];
			break;
		}
	}

	if (rh && rh->parser) {
		if (!(r->bs = rh->parser(&r->body))) {
			ret = false;
		}
	}

	DEBUG(LOG_FMT"total %d, type %s(%d), send id %d, msg id %d, bs %p, %s\n",  \
		LOG_PRE,
		r->total, 
		rh ? rh->name : "", 
		r->type,
		r->sid, 
		r->mid, 
		r->bs,
		ret ? "succ" : "failed");
	return ret;
}


void req_send_resp(Req *r, int code , const char *reason)
{
	if(!r)
		return ;
	int len = reason ? strlen(reason): 0;
	GameConn *conn = r->conn;
	
	r->resp_code = code;
	if (conn) {
		game_conn_send_resp(conn, r, code, reason, len);
		conn->handling_req = NULL;
	}
}

void req_send_resp1(Req *r, int code , const char *reason, int len)
{
	if(!r)
		return ;
	GameConn *conn = r->conn;

	r->resp_code = code;
	if (conn) {
		game_conn_send_resp(conn, r, code, reason, len);
		conn->handling_req = NULL;
	}
}

void req_set_cb(Req *req, ReqCb cb, void *arg)
{
	if(!req)
		return;
	req->cb = cb;
	req->arg = arg;
}

void req_to_string(Req *req, Mem *dst)
{
	if (!(dst && req))
		return;

	req->total = 16 + req->body.offset;

	mem_set_big(dst);

	mem_write_int(dst, &req->total);
	mem_write_int(dst, &req->type);
	mem_write_int(dst, &req->sid);
	mem_write_int(dst, &req->mid);
	
	if(req->body.offset > 0) {
		mem_append_buf(dst, req->body.buf, req->body.offset);
	}
}

ReqLoginBody * req_login_body_new()
{
	ReqLoginBody *b = (ReqLoginBody *) cache_pool_alloc(POOL_REQ_LOGIN_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(ReqLoginBody));
	return b;
}

void req_login_body_free(void * b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_LOGIN_BODY, b);
}

void * req_login_body_parse(dstring * src)
{
	if (!src)
		return NULL;

	ReqLoginBody *b = req_login_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->ver))
		goto err;

	return b;
err:
	req_login_body_free(b);
	return NULL;
}

ReqCreateRoleBody * req_create_role_body_new()
{
	ReqCreateRoleBody *b = (ReqCreateRoleBody *) cache_pool_alloc(POOL_REQ_CREATE_ROLE_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(ReqCreateRoleBody));
	return b;
}

void req_create_role_body_free(void * b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_CREATE_ROLE_BODY, b);
}

void * req_create_role_body_parse(dstring * src)
{
	if (!src)
		return NULL;

	char *t = NULL;
	ReqCreateRoleBody *b = req_create_role_body_new();

	if (!b) 
		return NULL;

	if(!dstring_read_string(src, &t))
		goto err;

	dstring_set(&b->name, t);

	if (!dstring_read_int(src, &b->city_id))
		goto err;

	return b;
err:
	req_create_role_body_free(b);
	return NULL;
}


ReqLevelUpBody * req_level_up_body_new()
{
	ReqLevelUpBody *b = (ReqLevelUpBody *) cache_pool_alloc(POOL_REQ_LEVEL_UP_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_level_up_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_LEVEL_UP_BODY, b);
}

void * req_level_up_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqLevelUpBody *b = req_level_up_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_byte(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->id))
		goto err;

	return b;
err:
	req_level_up_body_free(b);
	return NULL;
}

/* cancel level up */
ReqCancelLevelUpBody * req_cancel_level_up_body_new()
{
	ReqCancelLevelUpBody *b = (ReqCancelLevelUpBody *) cache_pool_alloc(POOL_REQ_CANCEL_LEVEL_UP_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_cancel_level_up_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_CANCEL_LEVEL_UP_BODY, b);
}

void * req_cancel_level_up_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqCancelLevelUpBody *b = req_cancel_level_up_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_byte(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->id))
		goto err;

	return b;
err:
	req_cancel_level_up_body_free(b);
	return NULL;
}

/* speed */
ReqSpeedBody * req_speed_body_new()
{
	ReqSpeedBody *b = (ReqSpeedBody *) cache_pool_alloc(POOL_REQ_SPEED_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_speed_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_SPEED_BODY, b);
}

void * req_speed_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqSpeedBody *b = req_speed_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_byte(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->id))
		goto err;

	return b;
err:
	req_speed_body_free(b);
	return NULL;
}


/* made */
ReqMadeBody * req_made_body_new()
{
	ReqMadeBody *b = (ReqMadeBody *) cache_pool_alloc(POOL_REQ_MADE_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_made_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_MADE_BODY, b);
}

void * req_made_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqMadeBody *b = req_made_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_byte(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->num))
		goto err;

	return b;
err:
	req_made_body_free(b);
	return NULL;
}

/* combin */
ReqCombBody * req_comb_body_new()
{
	ReqCombBody *b = (ReqCombBody *) cache_pool_alloc(POOL_REQ_COMBIN_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_comb_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_COMBIN_BODY, b);
}

void * req_comb_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqCombBody *b = req_comb_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_byte(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->level))
		goto err;
	if (!dstring_read_int(src, &b->num))
		goto err;

	return b;
err:
	req_comb_body_free(b);
	return NULL;
}

/* destroy */

ReqDestroyBody * req_destroy_body_new()
{
	ReqDestroyBody *b = (ReqDestroyBody *) cache_pool_alloc(POOL_REQ_DESTROY_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_destroy_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_DESTROY_BODY, b);
}

void * req_destroy_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqDestroyBody *b = req_destroy_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_byte(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->level))
		goto err;

	return b;
err:
	req_destroy_body_free(b);
	return NULL;
}



/* config sol */
ReqConfigSolBody * req_config_sol_body_new()
{
	ReqConfigSolBody *b = (ReqConfigSolBody *) cache_pool_alloc(POOL_REQ_CONFIG_SOL_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_config_sol_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_CONFIG_SOL_BODY, b);
}

void * req_config_sol_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	int i = 0;
	ReqConfigSolBody *b = req_config_sol_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	if (!dstring_read_int(src, &b->num))
		goto err;
	if (!dstring_read_int(src, &b->zhen))
		goto err;
	
	for(i = 0; i < GENE_WEAP_NUM; i++) {
		if (!dstring_read_int(src, &b->weap[i].id))
			goto err;
		if (!dstring_read_int(src, &b->weap[i].level))
			goto err;
	}

	return b;
err:
	req_config_sol_body_free(b);
	return NULL;
}


ReqExpBody * req_exp_body_new()
{
	ReqExpBody *b = (ReqExpBody *) cache_pool_alloc(POOL_REQ_EXP_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_exp_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_EXP_BODY, b);
}

void * req_exp_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqExpBody *b = req_exp_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	if (!dstring_read_byte(src, &b->type))
		goto err;	
	if (!dstring_read_int(src, &b->day))
		goto err;
	if (!dstring_read_uint(src, &b->zhen))
		goto err;

	return b;
err:
	req_exp_body_free(b);
	return NULL;
}

/* recover */
ReqRecoverBody * req_recover_body_new()
{
	ReqRecoverBody *b = (ReqRecoverBody *) cache_pool_alloc(POOL_REQ_RECOVER_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_recover_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_RECOVER_BODY, b);
}

void * req_recover_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqRecoverBody *b = req_recover_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	
	return b;
err:
	req_recover_body_free(b);
	return NULL;
}


/* use gene */
ReqUseGeneBody * req_use_gene_body_new()
{
	ReqUseGeneBody *b = (ReqUseGeneBody *) cache_pool_alloc(POOL_REQ_USE_GENE_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_use_gene_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_USE_GENE_BODY, b);
}

void * req_use_gene_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqUseGeneBody *b = req_use_gene_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	
	return b;
err:
	req_use_gene_body_free(b);
	return NULL;
}

ReqTranGeneBody * req_tran_gene_body_new()
{
	ReqTranGeneBody *b = (ReqTranGeneBody *) cache_pool_alloc(POOL_REQ_TRAN_GENE_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_tran_gene_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_TRAN_GENE_BODY, b);
}

void * req_tran_gene_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqTranGeneBody *b = req_tran_gene_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	if (!dstring_read_byte(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->to_id))
		goto err;
	if (!dstring_read_int(src, &b->is_speed))
		goto err;
	
	return b;
err:
	req_tran_gene_body_free(b);
	return NULL;
}


ReqVisitGeneBody * req_visit_gene_body_new()
{
	ReqVisitGeneBody *b = (ReqVisitGeneBody *) cache_pool_alloc(POOL_REQ_VISIT_GENE_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_visit_gene_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_VISIT_GENE_BODY, b);
}

void * req_visit_gene_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqVisitGeneBody *b = req_visit_gene_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	
	return b;
err:
	req_visit_gene_body_free(b);
	return NULL;
}

/* give */
ReqGiveBody * req_give_body_new()
{
	ReqGiveBody *b = (ReqGiveBody *) cache_pool_alloc(POOL_REQ_GIVE_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;

}

void req_give_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_GIVE_BODY, b);
}

void * req_give_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqGiveBody *b = req_give_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	if (!dstring_read_int(src, &b->tid))
		goto err;
	
	return b;
err:
	req_give_body_free(b);
	return NULL;
}

/* buy */
ReqBuyBody * req_buy_body_new()
{
	ReqBuyBody *b = (ReqBuyBody *) cache_pool_alloc(POOL_REQ_BUY_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;

}

void req_buy_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_BUY_BODY, b);
}

void * req_buy_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqBuyBody *b = req_buy_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->trea_id))
		goto err;
	
	return b;
err:
	req_buy_body_free(b);
	return NULL;
}


ReqFireBody * req_fire_body_new()
{
	ReqFireBody *b = (ReqFireBody *) cache_pool_alloc(POOL_REQ_FIRE_BODY);

	if (!b) 
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_fire_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_FIRE_BODY, b);
}

void * req_fire_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqFireBody *b = req_fire_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	
	return b;
err:
	req_fire_body_free(b);
	return NULL;
}

/* create sph */
ReqCreateSphBody * req_create_sph_body_new()
{
	ReqCreateSphBody * b = cache_pool_alloc(POOL_REQ_CREATE_SPH_BODY);
	if(!b)
		return NULL;
	dstring_clear(&b->name);
	dstring_clear(&b->desc);

	return b;
}

void req_create_sph_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_CREATE_SPH_BODY, b);
}

void * req_create_sph_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqCreateSphBody *b = req_create_sph_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_string1(src, &b->name))
		goto err;

	if (!dstring_read_string1(src, &b->desc))
		goto err;
	
	return b;
err:
	req_create_sph_body_free(b);
	return NULL;
}

/* shan sph */
ReqShanSphBody * req_shan_sph_body_new()
{
	ReqShanSphBody *b = (ReqShanSphBody *) cache_pool_alloc(POOL_REQ_SHAN_SPH_BODY);
	if (!b)
		return NULL;
	b->sph_id = 0;
	b->recv_uid = 0;
	return b;
}

void req_shan_sph_body_free(void *b)
{
	if (!b)
		return ;
	cache_pool_free(POOL_REQ_SHAN_SPH_BODY, b);
}

void * req_shan_sph_body_parse(dstring *src)
{
	if (!src)
		return NULL;
	
	ReqShanSphBody *b = req_shan_sph_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	
	if (!dstring_read_int(src, &b->recv_uid))
		goto err;
	
	return b;
err:
	req_shan_sph_body_free(b);
	return NULL;
}


/* edit sph */
ReqEditSphBody *req_edit_sph_body_new()
{
	ReqEditSphBody *b = (ReqEditSphBody *)cache_pool_alloc(POOL_REQ_EDIT_SPH_BODY);
	if (!b)
		return NULL;
	b->sph_id = 0;
	dstring_clear(&b->desc);
	return b;
}

void req_edit_sph_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_EDIT_SPH_BODY, b);
}

void *req_edit_sph_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	char *t = NULL;
	ReqEditSphBody *b = req_edit_sph_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	
	if (!dstring_read_string(src, &t))
		goto err;
	dstring_set(&b->desc, t);
	
	return b;
err:
	req_edit_sph_body_free(b);
	return NULL;
}


/* remove sph */
ReqRemoveSphBody * req_remove_sph_body_new()
{
	ReqRemoveSphBody * b = cache_pool_alloc(POOL_REQ_REMOVE_SPH_BODY);

	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_remove_sph_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_REMOVE_SPH_BODY, b);
}

void * req_remove_sph_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqRemoveSphBody *b = req_remove_sph_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	return b;
err:
	req_remove_sph_body_free(b);
	return NULL;
}

/* fire mem */
ReqFireMemBody * req_fire_mem_body_new()
{
	ReqFireMemBody * b = cache_pool_alloc(POOL_REQ_FIRE_MEM_BODY);

	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_fire_mem_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_FIRE_MEM_BODY, b);
}

void * req_fire_mem_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqFireMemBody *b = req_fire_mem_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	
	if (!dstring_read_int(src, &b->uid))
		goto err;
	
	return b;
err:
	req_fire_mem_body_free(b);
	return NULL;
}

/* apply join sph */
ReqApplyJoinSphBody * req_apply_join_sph_body_new()
{
	ReqApplyJoinSphBody * b = cache_pool_alloc(POOL_REQ_APPLY_JOIN_SPH_BODY);

	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_apply_join_sph_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_APPLY_JOIN_SPH_BODY, b);
}

void * req_apply_join_sph_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqApplyJoinSphBody *b = req_apply_join_sph_body_new();

	if (!b) 
		return NULL;

	
	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	
	return b;
err:
	req_apply_join_sph_body_free(b);
	return NULL;
}

/* tell apply join sph */

ReqTellApplyJoinSphBody * req_tell_apply_join_sph_body_new()
{
	ReqTellApplyJoinSphBody * b = (ReqTellApplyJoinSphBody *) cache_pool_alloc(POOL_REQ_TELL_APPLY_JOIN_SPH_BODY);

	if(!b)
		return NULL; 
	memset(b, 0, sizeof(*b));
	return b;
}

void req_tell_apply_join_sph_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_TELL_APPLY_JOIN_SPH_BODY, b);
}

void * req_tell_apply_join_sph_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqTellApplyJoinSphBody *b = req_tell_apply_join_sph_body_new();

	if (!b) 
		return NULL;


	if (!dstring_read_int(src, &b->uid))
		goto err;
	
	if (!dstring_read_byte(src, &b->is_agree))
		goto err;
	
	
	return b;
err:
	req_tell_apply_join_sph_body_free(b);
	return NULL;
}

/* away from sph */

ReqAwaySphBody *req_away_sph_body_new()
{
	ReqAwaySphBody *b = cache_pool_alloc(POOL_REQ_AWAY_SPH_BODY);

	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_away_sph_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_AWAY_SPH_BODY, b);
}

void * req_away_sph_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqAwaySphBody *b = req_away_sph_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	
	
	return b;
err:
	req_away_sph_body_free(b);
	return NULL;
}

/* apply 0ff */

ReqApplyOffBody * req_apply_off_body_new()
{
	ReqApplyOffBody * b = (ReqApplyOffBody * )cache_pool_alloc(POOL_REQ_APPLY_OFF_BODY);

	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_apply_off_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_APPLY_OFF_BODY, b);
}

void * req_apply_off_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqApplyOffBody *b = req_apply_off_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	
	if (!dstring_read_int(src, &b->off_id))
		goto err;
	
	return b;
err:
	req_apply_off_body_free(b);
	return NULL;
}


/* apply league */
ReqApplyLeagueBody * req_apply_league_body_new()
{
	ReqApplyLeagueBody * b = cache_pool_alloc(POOL_REQ_APPLY_LEAGUE_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_apply_league_body_free(void *b)
{
	if(!b)
		return;
	cache_pool_free(POOL_REQ_APPLY_LEAGUE_BODY, b);
}

void * req_apply_league_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqApplyLeagueBody *b = req_apply_league_body_new();

	if (!b) 
		return NULL;


	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	
	if (!dstring_read_int(src, &b->target_sph_id))
		goto err;
	
	if (!dstring_read_int(src, &b->year))
		goto err;
	
	return b;
err:
	req_apply_league_body_free(b);
	return NULL;
}


/* tell apply league */
ReqTellApplyLeagueBody * req_tell_apply_league_body_new()
{
	ReqTellApplyLeagueBody * b = (ReqTellApplyLeagueBody *) cache_pool_alloc(POOL_REQ_TELL_APPLY_LEAGUE_BODY);
	if (!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_tell_apply_league_body_free(void *b)
{
	if (!b)
		return ;
	cache_pool_free(POOL_REQ_TELL_APPLY_LEAGUE_BODY, b);
}

void * req_tell_apply_league_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqTellApplyLeagueBody *b = req_tell_apply_league_body_new();

	if (!b) 
		return NULL;


	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	
	if (!dstring_read_int(src, &b->year))
		goto err;
	
	if (!dstring_read_byte(src, &b->is_agree))
		goto err;
	
	return b;
err:
	req_tell_apply_league_body_free(b);
	return NULL;
}


/* ready war */
ReqReadyWarBody * req_ready_war_body_new()
{
	ReqReadyWarBody * b = (ReqReadyWarBody *) cache_pool_alloc(POOL_REQ_READY_WAR_BODY);
	if (!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_ready_war_body_free(void *b)
{
	if (!b)
		return ;
	cache_pool_free(POOL_REQ_READY_WAR_BODY, b);
}

void * req_ready_war_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqReadyWarBody *b = req_ready_war_body_new();

	if (!b) 
		return NULL;


	if (!dstring_read_int(src, &b->sph_id))
		goto err;
	
	if (!dstring_read_int(src, &b->target_sph_id))
		goto err;
	
	return b;
err:
	req_ready_war_body_free(b);
	return NULL;
}

/* change zhen */
ReqChangeZhenBody * req_change_zhen_body_new()
{
	ReqChangeZhenBody * b = (ReqChangeZhenBody *) cache_pool_alloc(POOL_REQ_CHANGE_ZHEN_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_change_zhen_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_CHANGE_ZHEN_BODY, b);
}

void * req_change_zhen_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqChangeZhenBody *b = req_change_zhen_body_new();

	if (!b) 
		return NULL;


	if (!dstring_read_int(src, &b->aid))
		goto err;
	
	if (!dstring_read_int(src, &b->zhen))
		goto err;
	
	return b;
err:
	req_change_zhen_body_free(b);
	return NULL;
}

/* move */

ReqMoveBody * req_move_body_new()
{
	ReqMoveBody * b = (ReqMoveBody *) cache_pool_alloc(POOL_REQ_MOVE_BODY);
	if(!b)
		return NULL;
	b->aid = 0;
	b->target = 0;
	TAILQ_INIT(&b->pos);
	return b;
}

void req_move_body_free(void *b)
{
	if (!b)
		return;

	Pos *p, *t;
	ReqMoveBody *b1 = (ReqMoveBody *) b;

	TAILQ_FOREACH_SAFE(p, &b1->pos, link, t) {
		TAILQ_REMOVE(&b1->pos, p, link);
		pos_free(p);
	}
	
	cache_pool_free(POOL_REQ_MOVE_BODY, b);
}

void * req_move_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	short count = 0;
	Pos *p = NULL;
	int i = 0;
	ReqMoveBody *b = req_move_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->aid))
		goto err;
	
	if (!dstring_read_byte(src, &b->target))
		goto err;
	
	if (!dstring_read_int(src, &b->city_id))
		goto err;
	
	if (!dstring_read_short(src, &count))
		goto err;
	for(i = 0; i < count; i++) {
		short x, y;

		if (!dstring_read_short(src, &x))
			goto err;
		if (!dstring_read_short(src, &y))
			goto err;

		if (!(p = pos_new(x, y))) {
			goto err;
		}

		TAILQ_INSERT_TAIL(&b->pos, p, link);
	}
	
	return b;
err:
	req_move_body_free(b);
	return NULL;
}


/* mail */
ReqMailBody * req_mail_body_new()
{
	ReqMailBody * b = (ReqMailBody *)cache_pool_alloc(POOL_REQ_MAIL_BODY);
	if (!b)
		return NULL;

	b->uid = 0;	
	b->type = 0;
	dstring_clear(&b->title);
	dstring_clear(&b->content);

	return b;
}

void req_mail_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_MAIL_BODY, b);
}

void * req_mail_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	char *t = NULL;
	ReqMailBody *b = req_mail_body_new();

	if (!b) 
		return NULL;


	if (!dstring_read_int(src, &b->uid))
		goto err;
	
	if (!dstring_read_int(src, &b->type))
		goto err;
	
	if (!dstring_read_string(src, &t))
		goto err;
	dstring_set(&b->title, t);
	
	if (!dstring_read_string(src, &t))
		goto err;
	dstring_set(&b->content, t);
	
	return b;
err:
	req_mail_body_free(b);
	return NULL;
}

/* talk */

ReqTalkBody * req_talk_body_new()
{
	ReqTalkBody * b = (ReqTalkBody *)cache_pool_alloc(POOL_REQ_TALK_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_talk_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_TALK_BODY, b);
}

void * req_talk_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	char *t = NULL;
	ReqTalkBody *b = req_talk_body_new();

	if (!b) 
		return NULL;


	if (!dstring_read_int(src, &b->uid))
		goto err;
	
	if (!dstring_read_int(src, &b->target_uid))
		goto err;
	
	if (!dstring_read_string(src, &t))
		goto err;
	dstring_set(&b->msg, t);
	
	return b;
err:
	req_talk_body_free(b);
	return NULL;
}


ReqLearnBody * req_learn_body_new()
{
	ReqLearnBody * b = (ReqLearnBody *)cache_pool_alloc(POOL_REQ_LEARN_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_learn_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_LEARN_BODY, b);
}

void * req_learn_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqLearnBody *b = req_learn_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	
	if (!dstring_read_byte(src, &b->type))
		goto err;
	
	if (!dstring_read_byte(src, &b->id))
		goto err;
	
	return b;
err:
	req_learn_body_free(b);
	return NULL;
}


ReqSysTradeBody * req_sys_trade_body_new()
{
	ReqSysTradeBody * b = (ReqSysTradeBody *)cache_pool_alloc(POOL_REQ_SYS_TRADE_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_sys_trade_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_SYS_TRADE_BODY, b);
}

void *req_sys_trade_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqSysTradeBody *b = req_sys_trade_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->res))
		goto err;
	if (!dstring_read_int(src, &b->num))
		goto err;
	
	return b;
err:
	req_sys_trade_body_free(b);
	return NULL;
}

ReqOrderBody * req_order_body_new()
{
	ReqOrderBody * b = (ReqOrderBody *)cache_pool_alloc(POOL_REQ_ORDER_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_order_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_ORDER_BODY, b);
}

void *req_order_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqOrderBody *b = req_order_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->res))
		goto err;
	if (!dstring_read_int(src, &b->num))
		goto err;
	if (!dstring_read_int(src, &b->unit_money))
		goto err;
	
	return b;
err:
	req_order_body_free(b);
	return NULL;
}

ReqCancelOrderBody * req_cancel_order_body_new()
{
	ReqCancelOrderBody * b = (ReqCancelOrderBody *)cache_pool_alloc(POOL_REQ_CANCEL_ORDER_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_cancel_order_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_CANCEL_ORDER_BODY, b);
}

void *req_cancel_order_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqCancelOrderBody *b = req_cancel_order_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->type))
		goto err;
	if (!dstring_read_int(src, &b->oid))
		goto err;
	
	return b;
err:
	req_cancel_order_body_free(b);
	return NULL;
}

ReqSellOrderBody * req_sell_order_body_new()
{
	ReqSellOrderBody * b = (ReqSellOrderBody *)cache_pool_alloc(POOL_REQ_SELL_ORDER_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_sell_order_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_SELL_ORDER_BODY, b);
}

void *req_sell_order_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqSellOrderBody *b = req_sell_order_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->weap_id))
		goto err;
	if (!dstring_read_int(src, &b->weap_level))
		goto err;
	if (!dstring_read_int(src, &b->num))
		goto err;
	if (!dstring_read_int(src, &b->gold))
		goto err;
	
	return b;
err:
	req_sell_order_body_free(b);
	return NULL;
}


ReqBuyWeapBody * req_buy_weap_body_new()
{
	ReqBuyWeapBody * b = (ReqBuyWeapBody *)cache_pool_alloc(POOL_REQ_BUY_WEAP_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_buy_weap_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_BUY_WEAP_BODY, b);
}

void *req_buy_weap_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqBuyWeapBody *b = req_buy_weap_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->oid))
		goto err;
	
	return b;
err:
	req_buy_weap_body_free(b);
	return NULL;
}

/* accept task */
ReqAcceptTaskBody * req_accept_task_body_new()
{
	ReqAcceptTaskBody * b = (ReqAcceptTaskBody *)cache_pool_alloc(POOL_REQ_ACCEPT_TASK_BODY);
	if(!b)
		return NULL;
	b->id = 0;
	return b;
}

void req_accept_task_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_ACCEPT_TASK_BODY, b);
}

void *req_accept_task_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqAcceptTaskBody *b = req_accept_task_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->id))
		goto err;
	
	return b;
err:
	req_accept_task_body_free(b);
	return NULL;
}

/* box */
ReqBoxBody * req_box_body_new()
{
	ReqBoxBody * b = (ReqBoxBody *)cache_pool_alloc(POOL_REQ_BOX_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(ReqBoxBody));
	return b;
}

void req_box_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_BOX_BODY, b);
}

void *req_box_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	int i = 0;
	ReqBoxBody *b = req_box_body_new();

	if (!b) 
		return NULL;
	
	if (!dstring_read_int(src, &b->level))
		goto err;
	
	if (!dstring_read_int(src, &b->gene_num))
		goto err;

	if (b->gene_num > MAX_BOX_GENE)
		goto err;

	for( i = 0; i < b->gene_num; i++) { 
		if (!dstring_read_int(src, &b->gene_id[i]))
			goto err;
	}

	
	return b;
err:
	req_box_body_free(b);
	return NULL;
}

ReqPlunderBody * req_plunder_body_new()
{
	ReqPlunderBody * b = (ReqPlunderBody *)cache_pool_alloc(POOL_REQ_PLUNDER_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_plunder_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_PLUNDER_BODY, b);
}

void *req_plunder_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	int i = 0;
	ReqPlunderBody *b = req_plunder_body_new();

	if (!b) 
		return NULL;
	
	if (!dstring_read_int(src, &b->to_uid))
		goto err;

	for (i = 0; i < RES_MAX - 1; i ++) {
		if (!dstring_read_int(src, &b->res[i]))
			goto err;
	}
	
	return b;
err:
	req_plunder_body_free(b);
	return NULL;
}


ReqTrainBody * req_train_body_new()
{
	ReqTrainBody * b = (ReqTrainBody *)cache_pool_alloc(POOL_REQ_TRAIN_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_train_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_TRAIN_BODY, b);
}

void *req_train_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqTrainBody *b = req_train_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->gene_id))
		goto err;
	
	if (!dstring_read_int(src, &b->is_double))
		goto err;
	
	return b;
err:
	req_train_body_free(b);
	return NULL;
}


ReqMoveCityBody * req_move_city_body_new()
{
	ReqMoveCityBody * b = (ReqMoveCityBody *)cache_pool_alloc(POOL_REQ_MOVE_CITY_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_move_city_body_free(void *b)
{
	if (!b)
		return;
	cache_pool_free(POOL_REQ_MOVE_CITY_BODY, b);
}

void *req_move_city_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqMoveCityBody *b = req_move_city_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->city_id))
		goto err;
	
	return b;
err:
	req_move_city_body_free(b);
	return NULL;
}

ReqSetFreshStepBody * req_set_fresh_step_body_new()
{
	ReqSetFreshStepBody * b = (ReqSetFreshStepBody *)cache_pool_alloc(POOL_REQ_SET_FRESH_STEP_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_set_fresh_step_body_free(void *b)
{
	cache_pool_free(POOL_REQ_SET_FRESH_STEP_BODY, b);
}

void *req_set_fresh_step_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqSetFreshStepBody *b = req_set_fresh_step_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->step))
		goto err;
	
	return b;
err:
	req_set_fresh_step_body_free(b);
	return NULL;
}

ReqPkBody * req_pk_body_new()
{
	ReqPkBody * b = (ReqPkBody *)cache_pool_alloc(POOL_REQ_PK_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_pk_body_free(void *b)
{
	cache_pool_free(POOL_REQ_PK_BODY, b);
}

void *req_pk_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqPkBody *b = req_pk_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->uid))
		goto err;
	
	return b;
err:
	req_pk_body_free(b);
	return NULL;
}


ReqDonateTreaBody * req_donate_trea_body_new()
{
	ReqDonateTreaBody * b = (ReqDonateTreaBody *)cache_pool_alloc(POOL_REQ_DONATE_TREA_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_donate_trea_body_free(void *b)
{
	cache_pool_free(POOL_REQ_DONATE_TREA_BODY, b);
}

void *req_donate_trea_body_parse(dstring *src)
{
	if (!src)
		return NULL;

	ReqDonateTreaBody *b = req_donate_trea_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->uid))
		goto err;
	
	if (!dstring_read_int(src, &b->trea_id))
		goto err;
	
	return b;
err:
	req_donate_trea_body_free(b);
	return NULL;
}


ReqDeclareWarBody * req_declare_war_body_new()
{
    ReqDeclareWarBody * b = (ReqDeclareWarBody *)cache_pool_alloc(POOL_REQ_DECLARE_WAR_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_declare_war_body_free(void *b)
{
	cache_pool_free(POOL_REQ_DECLARE_WAR_BODY, b);
}

void *req_declare_war_body_parse(dstring *src)
{
    
	if (!src)
		return NULL;

	ReqDeclareWarBody *b = req_declare_war_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->city_id))
		goto err;
	
	return b;
err:
	req_declare_war_body_free(b);
	return NULL;
}

ReqApplyWarBody * req_apply_war_body_new()
{
    ReqApplyWarBody * b = (ReqApplyWarBody *)cache_pool_alloc(POOL_REQ_APPLY_WAR_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_apply_war_body_free(void *b)
{
	cache_pool_free(POOL_REQ_APPLY_WAR_BODY, b);
}

void *req_apply_war_body_parse(dstring *src)
{
    
	if (!src)
		return NULL;

	ReqApplyWarBody *b = req_apply_war_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->room_id))
		goto err;
	
	return b;
err:
	req_apply_war_body_free(b);
	return NULL;
}

ReqExitWarBody * req_exit_war_body_new()
{
    ReqExitWarBody * b = (ReqExitWarBody *)cache_pool_alloc(POOL_REQ_EXIT_WAR_BODY);
	if(!b)
		return NULL;
	memset(b, 0, sizeof(*b));
	return b;
}

void req_exit_war_body_free(void *b)
{
	cache_pool_free(POOL_REQ_EXIT_WAR_BODY, b);
}

void *req_exit_war_body_parse(dstring *src)
{
    
	if (!src)
		return NULL;

	ReqExitWarBody *b = req_exit_war_body_new();

	if (!b) 
		return NULL;

	if (!dstring_read_int(src, &b->room_id))
		goto err;
	
	return b;
err:
	req_exit_war_body_free(b);
	return NULL;
}
/* s --> c */
void send_nf_offline(GameConn * c)
{
	if(!c)
		return ;
	
	Req * r = NULL;

	if (!(r = req_new(REQ_NF_OFFLINE, SYS_SEND_ID, g_msg_id, NULL, 0, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

/* nf create role */
dstring * req_nf_create_role_body_new(byte is_goto_create)
{
	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_byte(&dst, is_goto_create);
	
	return &dst;
}

void send_nf_create_role(byte is_goto_create, GameConn * c)
{
	if(!c)
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_create_role_body_new(is_goto_create)))
		return;
	
	if (!(r = req_new(REQ_NF_CREATE_ROLE, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

/* nf time */

dstring * req_nf_time_body_new(int t)
{
	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, t);
	
	return &dst;
}

void send_nf_time(int t, GameConn *c)
{
	if(!c)
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_time_body_new(t)))
		return;
	
	if (!(r = req_new(REQ_NF_TIME, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_time_where(int t, int where)
{
	GameConn *c = NULL;
	
	if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_time(t, c);
		}
	}
	else {
		return;
	}
}

/* nf wubao */
dstring * req_nf_wubao_body_new(Wubao *w)
{
	if (!w)
		return NULL;

	int i = 0;
	int j = 0;
	Key *k = NULL;
	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, w->id);
	dstring_write_int(&dst, w->uid);
	dstring_write_int(&dst, w->sph_id);
	dstring_write_int(&dst, w->city_id);
	dstring_write_int(&dst, w->dig_id);
	dstring_write_int(&dst, w->off_id);
	dstring_write_int(&dst, w->people);
	dstring_write_int(&dst, w->family);
	dstring_write_int(&dst, w->prestige);
	dstring_write_int(&dst, w->sol);
	/* res */
	for(i = 0; i < RES_MAX - 1; i++) {
		dstring_write_int(&dst, w->res[i]);
	}
	dstring_write_int(&dst, w->got_sol);
	dstring_write_int(&dst, w->used_made);
	dstring_write_int(&dst, w->cure_sol);
	/* weapon */
	dstring_write_int(&dst, (WEAP_MAX - 1) * (WEAP_LEVEL_MAX));
	for(i = 0; i < (WEAP_MAX - 1); i++) {
		for(j = 0; j < WEAP_LEVEL_MAX; j++) {
			dstring_write_int(&dst, w->weap[i].id);
			dstring_write_int(&dst, j);
			dstring_write_int(&dst, w->weap[i].num[j]);
		}
	}
	/* building */
	dstring_write_int(&dst, BUILDING_MAX - 1);
	for(i = 0; i < BUILDING_MAX - 1; i++) {
		dstring_write_int(&dst, w->build[i].id);
		dstring_write_int(&dst, w->build[i].level);
		dstring_write_int(&dst, w->build[i].up_end_time);
	}
	/* tech */
	dstring_write_int(&dst, TECH_MAX - 1);
	for(i = 0; i < TECH_MAX - 1; i++) {
		dstring_write_int(&dst, w->tech[i].id);
		dstring_write_int(&dst, w->tech[i].level);
		dstring_write_int(&dst, w->tech[i].up_end_time);
	}
	/* fri */
	dstring_write_int(&dst, w->fri_num);
	DEBUG(LOG_FMT"id %d, fri num %d\n", LOG_PRE, w->id, w->fri_num);
	RB_FOREACH(k, KeyMap, &w->fris) {
		dstring_write_int(&dst, k->id);
		dstring_write_int(&dst, (int)k->arg);
	}
	
	return &dst;
}

void send_nf_wubao(Wubao *w, GameConn *c)
{
	if(!(w && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_wubao_body_new(w)))
		return;
	
	if (!(r = req_new(REQ_NF_WUBAO, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_wubao_where(Wubao *w, int where)
{
	if (!w) 
		return;

	GameConn *c = NULL;

	if(where == WHERE_ME) {
		if ((c = cycle_find_game_conn_by_uid(g_cycle, w->uid))) 
			send_nf_wubao(w, c);
	}
	else if (where == WHERE_SPH) {
	}
	else if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_wubao(w, c);
		}
	}
}

/* nf gene */
dstring * req_nf_gene_body_new(Gene *gene)
{
	if (!gene)
		return NULL;

	int i = 0;
	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, gene->id);
	dstring_write_int(&dst, gene->uid);
	dstring_write_byte(&dst, gene->type);
	dstring_write_string1(&dst, gene->first_name.buf, gene->first_name.offset);
	dstring_write_string1(&dst, gene->last_name.buf, gene->last_name.offset);
	dstring_write_string1(&dst, gene->zi.buf, gene->zi.offset);
	dstring_write_byte(&dst, gene->sex);
	dstring_write_int(&dst, gene->born_year);
	dstring_write_int(&dst, gene->init_year);
	dstring_write_byte(&dst, gene->place);
	dstring_write_int(&dst, gene->place_id);
	dstring_write_int(&dst, gene->kongfu);
	dstring_write_int(&dst, gene->intel);
	dstring_write_int(&dst, gene->polity);
	dstring_write_int(&dst, gene->speed);
	dstring_write_int(&dst, gene->faith);
	dstring_write_int(&dst, gene->face_id);
	dstring_write_byte(&dst, gene->is_dead);
	dstring_write_int(&dst, gene->fri);
	dstring_write_uint(&dst, gene->skill);
	dstring_write_uint(&dst, gene->zhen);
	dstring_write_int(&dst, gene->used_zhen);
	dstring_write_int(&dst, gene->sol_num);
	dstring_write_int(&dst, gene->level);
	dstring_write_int(&dst, gene->sol_spirit);
	dstring_write_int(&dst, gene->hurt_num);
	dstring_write_int(&dst, gene->level_percent);
	for(i = 0; i < GENE_WEAP_NUM; i++) {
		dstring_write_int(&dst, gene->weap[i].id);
		dstring_write_int(&dst, gene->weap[i].level);
	}
	
	return &dst;
}

void send_nf_gene(Gene *gene, GameConn *c)
{
	if(!(gene && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_gene_body_new(gene)))
		return;
	
	if (!(r = req_new(REQ_NF_GENE, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_gene_where(Gene *gene, int where)
{
	if (!gene)
		return;

	GameConn *c = NULL;

	if(where == WHERE_ME) {
		if ((c = cycle_find_game_conn_by_uid(g_cycle, gene->uid))) 
			send_nf_gene(gene, c);
	}
	else if (where == WHERE_SPH) {
	}
	else if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_gene(gene, c);
		}
	}
}

/* nf city */
dstring * req_nf_city_body_new(City *city)
{
	if (!city)
		return NULL;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, city->id);
	dstring_write_int(&dst, city->sph_id);
	dstring_write_byte(&dst, city->state);
	dstring_write_string1(&dst, city->name.buf, city->name.offset);
	dstring_write_byte(&dst, city->level);
	dstring_write_string1(&dst, city->jun_name.buf, city->jun_name.offset);
	dstring_write_string1(&dst, city->zhou_name.buf, city->zhou_name.offset);
	dstring_write_string1(&dst, city->desc.buf, city->desc.offset);
	dstring_write_int(&dst, city->x);
	dstring_write_int(&dst, city->y);
	dstring_write_byte(&dst, city->is_alloted);
	dstring_write_int(&dst, city->zhou_code);
	dstring_write_int(&dst, city->jun_code);
	dstring_write_int(&dst, city->idle_wubao_num);
	dstring_write_int(&dst, city->sol);
	dstring_write_int(&dst, city->defense);
	dstring_write_int(&dst, city->wubao_num);
	
	return &dst;
}

void send_nf_city(City *city, GameConn *c)
{
	if(!(city && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_city_body_new(city)))
		return;
	
	if (!(r = req_new(REQ_NF_CITY, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_city_where(City *city, int where)
{
	if (!city)
		return;
	
	GameConn *c = NULL;


	if (where == WHERE_SPH) {
	}
	else if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_city(city, c);
		}
	}
}

/* nf sph */
dstring * req_nf_sph_body_new(Sph *sph)
{
	if (!sph)
		return NULL;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, sph->id);
	dstring_write_int(&dst, sph->uid);
	dstring_write_string1(&dst, sph->name.buf, sph->name.offset);
	dstring_write_int(&dst, sph->level);
	dstring_write_int(&dst, sph->prestige);
	dstring_write_string1(&dst, sph->desc.buf, sph->desc.offset);

	return &dst;
}

void send_nf_sph(Sph *sph, GameConn *c)
{
	if(!(sph && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_sph_body_new(sph)))
		return;
	
	if (!(r = req_new(REQ_NF_SPH, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_sph_where(Sph *sph, int where)
{
	if (!sph)
		return;
	
	GameConn *c = NULL;

	if (where == WHERE_SPH) {
	}
	else if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_sph(sph, c);
		}
	}
}

/* nf army */

dstring * req_nf_army_body_new(Army *army)
{
	if (!army)
		return NULL;

	TimePos *p = NULL;
	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, army->id);
	dstring_write_int(&dst, army->gene_id);
	dstring_write_byte(&dst, army->state);
	dstring_write_int(&dst, army->x);
	dstring_write_int(&dst, army->y);
	dstring_write_int(&dst, army->money);
	dstring_write_int(&dst, army->food);
	dstring_write_int(&dst, army->original);
	dstring_write_byte(&dst, army->type);


	dstring_write_int(&dst, army->move_tp_num);
	TAILQ_FOREACH(p, &army->move_tp, link) {
		dstring_write_short(&dst, p->from->x);
		dstring_write_short(&dst, p->from->y);
		dstring_write_short(&dst, p->to->x);
		dstring_write_short(&dst, p->to->y);
		dstring_write_int(&dst, p->sec * 1000);
	}

	return &dst;
}

void send_nf_army(Army *a, GameConn *c)
{
	if(!(a && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_army_body_new(a)))
		return;
	
	if (!(r = req_new(REQ_NF_ARMY, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_army_where(Army *a, int where)
{
	if (!a)
		return;
	
	GameConn *c = NULL;

	if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_army(a, c);
		}
	}
}

/* nf user */
dstring * req_nf_user_body_new(User *u)
{
	if (!u)
		return NULL;

	static dstring dst = DSTRING_INITIAL;
	Game *g = GAME;
	Wubao *w = NULL;
	Sph *sph = NULL;
	Key *k = NULL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	w = game_find_wubao(g, u->wid);

	sph = game_find_sph_by_uid(g, u->id);


	dstring_write_int(&dst, u->id);
	dstring_write_int(&dst, sph ? sph->id : 0);
	dstring_write_string1(&dst, u->name.buf, u->name.offset);
	dstring_write_int(&dst, (w ? w->prestige : 0));
	dstring_write_int(&dst, (w ? w->gx : 0));
	dstring_write_int(&dst, (w ? w->build[BUILDING_YISHITANG - 1].level : 0));
	dstring_write_int(&dst, (w ? w->dig_id : 0));
	dstring_write_int(&dst, (w ? w->off_id : 0));
	dstring_write_int(&dst, w ? w->last_login_time : 0);
	dstring_write_byte(&dst, u->isonline);
	dstring_write_int(&dst, u->vip_total_hour);
	dstring_write_int(&dst, u->vip_used_hour);
	dstring_write_int(&dst, u->wid);
	dstring_write_int(&dst, w ? w->city_id : 0);
	dstring_write_int(&dst, w ? w->task_id : 0);
	dstring_write_int(&dst, w ? w->task_is_fin : 0);
	dstring_write_int(&dst, w ? w->war_sleep_end_time : 0);
	dstring_write_int(&dst, w ? w->jl : 0);
	dstring_write_int(&dst, w ? w->train_sleep_end_time : 0);
	dstring_write_int(&dst, w ? w->use_gx_trea_num : 0);
	dstring_write_int(&dst, w ? w->been_plunder_num : 0);
	dstring_write_int(&dst, w ? w->rank : 0);
	dstring_write_int(&dst, w ? w->box_level : 0);
	dstring_write_int(&dst, u->is_locked);
	dstring_write_int(&dst, w ? w->fresh_step : 0);

	if (w) {
		dstring_write_int(&dst, w->task_fin_num);
		RB_FOREACH(k, KeyMap, &w->task_fins) {
			dstring_write_int(&dst, k->id);
		}	
	}
	else 
		dstring_write_int(&dst, 0);
	


	return &dst;
}

void send_nf_user(User *u, GameConn *c)
{
	if(!(u && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_user_body_new(u)))
		return;
	
	if (!(r = req_new(REQ_NF_USER, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_user_where(User *u, int where)
{
	if (!u)
		return;
	
	GameConn *c = NULL;

	if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_user(u, c);
		}
	}
}

/* nf dipl */
dstring * req_nf_dipl_body_new(Dipl *dipl)
{
	if (!dipl)
		return NULL;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, dipl->id);
	dstring_write_int(&dst, dipl->type);
	dstring_write_int(&dst, dipl->self_id);
	dstring_write_int(&dst, dipl->target_id);
	dstring_write_int(&dst, dipl->start);
	dstring_write_int(&dst, dipl->end);
	
	return &dst;
}

void send_nf_dipl(Dipl *dipl, GameConn *c)
{
	if(!(dipl && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_dipl_body_new(dipl)))
		return;
	
	if (!(r = req_new(REQ_NF_DIPL, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_dipl_where(Dipl *dipl, int where)
{
	if (!dipl)
		return;
	
	GameConn *c = NULL;

	if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_dipl(dipl, c);
		}
	}
}

/* nf trea */
dstring *req_nf_trea_body_new(Trea *t)
{
	if (!t)
		return NULL;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, t->id);
	dstring_write_int(&dst, t->trea_id);
	dstring_write_int(&dst, t->gene_id);
	dstring_write_byte(&dst, t->is_used);
	dstring_write_int(&dst, t->uid);
	dstring_write_int(&dst, t->use_time);
	
	return &dst;
}

void send_nf_trea(Trea *t, GameConn *c)
{
	if(!(t && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_trea_body_new(t)))
		return;
	
	if (!(r = req_new(REQ_NF_TREA, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_trea_where(Trea *t, int where)
{
	if (!t)
		return ;
	
	GameConn *c = NULL;

	if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_trea(t, c);
		}
	}
	else if (where == WHERE_ME) {
		if ((c = cycle_find_game_conn_by_uid(g_cycle, t->uid)))
			send_nf_trea(t, c);
	}
}

dstring *req_nf_war_body_new(byte type, int id1, int dead1, int hurt1, int exp1, int id2, int dead2, int hurt2, int exp2, float def)
{
	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);
	
	dstring_write_byte(&dst, type);
	dstring_write_int(&dst, id1);
	dstring_write_int(&dst, dead1);
	dstring_write_int(&dst, hurt1);
	dstring_write_int(&dst, exp1);
	dstring_write_int(&dst, id2);
	dstring_write_int(&dst, dead2);
	dstring_write_int(&dst, hurt2);
	dstring_write_int(&dst, exp2);
	dstring_write_int(&dst, def);
	
	return &dst;
}

void send_nf_war(int type, int id1, int dead1, int hurt1, int exp1, int id2, int dead2, int hurt2, int exp2, float def, GameConn *c)
{
	if(!(c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_war_body_new(type, id1, dead1, hurt1, exp1, id2, dead2, hurt2, exp2, def)))
		return;
	
	if (!(r = req_new(REQ_NF_WAR, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_war_where(int type, int id1, int dead1, int hurt1, int exp1, int id2, int dead2, int hurt2, int exp2, float def, int where)
{
	GameConn *c = NULL;

	if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_war(type, id1, dead1, hurt1, exp1, id2, dead2, hurt2, exp2, def, c);
		}
	}
}

dstring *req_nf_mail_body_new(Mail *m)
{
	if (!m)
		return NULL;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, m->id);
	dstring_write_int(&dst, m->send_id);
	dstring_write_string1(&dst, m->send_name.buf, m->send_name.offset);
	dstring_write_int(&dst, m->recv_id);
	dstring_write_string1(&dst, m->recv_name.buf, m->recv_name.offset);
	dstring_write_string1(&dst, m->title.buf, m->title.offset);
	dstring_write_string1(&dst, m->cont.buf, m->cont.offset);
	dstring_write_byte(&dst, m->is_read);
	dstring_write_int(&dst, m->type);
	dstring_write_int(&dst, m->send_time);
	return &dst;
}

void send_nf_mail(Mail *m, GameConn *c)
{
	if(!(m && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_mail_body_new(m)))
		return;
	
	if (!(r = req_new(REQ_NF_MAIL, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_mail_where(Mail *m, int where)
{
}

/* talk */
dstring *req_nf_talk_body_new(Talk *t)
{
	if (!t)
		return NULL;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, t->send_uid);
	dstring_write_int(&dst, t->recv_uid);
	dstring_write_string1(&dst, t->msg.buf, t->msg.offset);

	return &dst;
}

void send_nf_talk(Talk *t, GameConn *c)
{
	if(!(t && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_talk_body_new(t)))
		return;
	
	if (!(r = req_new(REQ_NF_TALK, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_talk_where(Talk *t, int where)
{
	if (!t)
		return;

	GameConn *c = NULL;
	Game *g = GAME;
	Sph *sph = NULL;
	Wubao *w = NULL;

	if (where == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_talk(t, c);
		}
	}
	else if (where == WHERE_SPH) {
		if ((sph = game_find_sph_by_uid(g, t->send_uid))) {
			TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
				if ((w = game_find_wubao_by_uid(g, c->uid))) {
					if (w->sph_id == sph->id)
						send_nf_talk(t, c);
				}
			}
		}
	}
}


dstring * req_nf_cmd_trans_body_new(CmdTrans *cmd)
{
	if (!cmd)
		return NULL;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);
	
	dstring_write_int(&dst, cmd->id);
	dstring_write_int(&dst, cmd->from_id);
	dstring_write_int(&dst, cmd->to_id);
	dstring_write_int(&dst, cmd->type);
	dstring_write_int(&dst, cmd->sph_id);
	dstring_write_int(&dst, cmd->good_type);
	dstring_write_int(&dst, cmd->good_id);
	dstring_write_int(&dst, cmd->good_num);
	dstring_write_int(&dst, cmd->end);
	return &dst;
}

void send_nf_cmd_trans(CmdTrans *cmd, GameConn *c)
{
	if(!(cmd && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_cmd_trans_body_new(cmd)))
		return;
	
	if (!(r = req_new(REQ_NF_CMD_TRANS, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_cmd_trans_where(CmdTrans *cmd, int wh)
{
	Game *g = GAME;
	Gene *gene = NULL;
	GameConn *c = NULL;

	if (cmd->good_type != GOOD_GENE) {
		return;
	}

	if (!(gene = game_find_gene(g, cmd->good_id)))
		return;

	if ((c = cycle_find_game_conn_by_uid(g_cycle, gene->uid)))
		send_nf_cmd_trans(cmd, c);
}


/* nf order */
dstring * req_nf_order_body_new(Order *o)
{
	if (!o)
		return NULL;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);
	
	dstring_write_int(&dst, o->id);
	dstring_write_int(&dst, o->uid);
	dstring_write_int(&dst, o->type);
	dstring_write_int(&dst, o->res);
	dstring_write_int(&dst, o->num);
	dstring_write_int(&dst, o->deal_num);
	dstring_write_int(&dst, o->unit_money);
	dstring_write_int(&dst, o->ts);
	dstring_write_int(&dst, o->is_del);
	return &dst;
}

void send_nf_order(Order *o, GameConn *c)
{
	if(!(o && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_order_body_new(o)))
		return;
	
	if (!(r = req_new(REQ_NF_ORDER, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_order_where(Order *o, int wh)
{
	if (!o)
		return;

	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_order(o, c);
		}
	}
}

/* nf sell order */
dstring * req_nf_sell_order_body_new(SellOrder *o)
{
	if (!o)
		return NULL;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);
	
	dstring_write_int(&dst, o->id);
	dstring_write_int(&dst, o->uid);
	dstring_write_int(&dst, o->weap_id);
	dstring_write_int(&dst, o->weap_level);
	dstring_write_int(&dst, o->weap_num);
	dstring_write_int(&dst, o->gold);
	dstring_write_int(&dst, o->ts);
	dstring_write_int(&dst, o->is_del);
	return &dst;
}

void send_nf_sell_order(SellOrder *o, GameConn *c)
{
	if(!(o && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_sell_order_body_new(o)))
		return;
	
	if (!(r = req_new(REQ_NF_SELL_ORDER, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_sell_order_where(SellOrder *o, int wh)
{
	if (!o)
		return;

	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_sell_order(o, c);
		}
	}
}

dstring * req_nf_fight_body_new(War *war)
{
	if (!war)
		return NULL;

	static dstring dst = DSTRING_INITIAL;
	WarRound *r = NULL;
	WarGene *gene = NULL;
	int i = 0;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	dstring_write_int(&dst, war->room_id);
	dstring_write_int(&dst, war->guan_id);
	
	dstring_write_string1(&dst, dstring_buf(&war->name), dstring_offset(&war->name));
	dstring_write_int(&dst, war->gene_num);
	dstring_write_int(&dst, war->uid);
	TAILQ_FOREACH(gene, &war->genes, link) {
		dstring_write_int(&dst, gene->id);
		dstring_write_string(&dst, safe_str(gene->name.buf));
		dstring_write_int(&dst, gene->old_sol);
		for( i = 0; i < GENE_WEAP_NUM; i++) {
			dstring_write_int(&dst, gene->weap[i].id);
			dstring_write_int(&dst, gene->weap[i].level);
		}
		dstring_write_int(&dst, gene->zhen);
		dstring_write_int(&dst, gene->old_spirit);
		dstring_write_int(&dst, gene->old_train);
	}
	
	dstring_write_string1(&dst, dstring_buf(&war->target_name), dstring_offset(&war->target_name));
	dstring_write_int(&dst, war->target_gene_num);
	dstring_write_int(&dst, war->target_uid);
	TAILQ_FOREACH(gene, &war->target_genes, link) {
		dstring_write_int(&dst, gene->id);
		dstring_write_string(&dst, safe_str(gene->name.buf));
		dstring_write_int(&dst, gene->old_sol);
		for( i = 0; i < GENE_WEAP_NUM; i++) {
			dstring_write_int(&dst, gene->weap[i].id);
			dstring_write_int(&dst, gene->weap[i].level);
		}
		dstring_write_int(&dst, gene->zhen);
		dstring_write_int(&dst, gene->old_spirit);
		dstring_write_int(&dst, gene->old_train);
	}
	
	dstring_write_int(&dst, war->round_num);
	TAILQ_FOREACH(r, &war->rounds, link) {
		dstring_write_int(&dst, r->id);
		dstring_write_int(&dst, r->dead);
		dstring_write_int(&dst, r->skill);
		dstring_write_int(&dst, r->spirit);

		dstring_write_int(&dst, r->id1);
		dstring_write_int(&dst, r->dead1);
		dstring_write_int(&dst, r->skill1);
		dstring_write_int(&dst, r->spirit1);
	}

	dstring_write_int(&dst, war->is_win);
	dstring_write_int(&dst, war->dead);
	dstring_write_int(&dst, war->dead1);
	dstring_write_int(&dst, war->gx);
	dstring_write_int(&dst, war->weap_id);
	dstring_write_int(&dst, war->weap_level);
	dstring_write_int(&dst, war->weap_num);

	return &dst;
}

void send_nf_fight(War *war, GameConn *c)
{
	if(!(war && c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_fight_body_new(war)))
		return;
	
	if (!(r = req_new(REQ_NF_FIGHT, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_fight_where(War *war, int wh)
{
	if (!war)
		return;

	GameConn *c = NULL;


	TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
		send_nf_fight(war, c);
	}
}


/* nf welfare */
dstring * req_nf_welfare_body_new(int res[RES_MAX - 1], int gold)
{
	int i = 0;
	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);
	
	for(i = 0; i < RES_MAX - 1; i++) {
		dstring_write_int(&dst, res[i]);
	}
	dstring_write_int(&dst, gold);

	return &dst;
}

void send_nf_welfare(int res[RES_MAX - 1], int gold, GameConn *c)
{
	if(!(c))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_welfare_body_new(res, gold)))
		return;
	
	if (!(r = req_new(REQ_NF_WELFARE, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_welfare_where(int res[RES_MAX - 1], int gold, int wh)
{
	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_welfare(res, gold, c);
		}
	}
}

dstring * req_nf_zhanyi_body_new(Zhanyi *p)
{
	if (!p)
		return NULL;


	dstring_clear(&g_dst);
	dstring_set_big_endian(&g_dst);
	
	dstring_write_int(&g_dst, p->id);
	dstring_write_string1(&g_dst, p->pic_u1.buf, p->pic_u1.offset);
	dstring_write_string1(&g_dst, p->title.buf, p->title.offset);
	dstring_write_string1(&g_dst, p->info.buf, p->info.offset);
	dstring_write_int(&g_dst, p->site);

	return &g_dst;
}

void send_nf_zhanyi(Zhanyi *p, GameConn *c)
{
	if(!(c && p))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_zhanyi_body_new(p)))
		return;
	
	if (!(r = req_new(REQ_NF_ZHANYI, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_zhanyi_where(Zhanyi *p, int wh)
{
	if (!p)
		return;

	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_zhanyi(p, c);
		}
	}
}


dstring * req_nf_guanka_body_new(Guanka *p)
{
	if (!p)
		return NULL;


	dstring_clear(&g_dst);
	dstring_set_big_endian(&g_dst);
		
	dstring_write_int(&g_dst, p->id);
	dstring_write_int(&g_dst, p->zy_id);
	dstring_write_string1(&g_dst, p->name.buf, p->name.offset);
	dstring_write_int(&g_dst, p->x);
	dstring_write_int(&g_dst, p->y);
	dstring_write_int(&g_dst, p->gx);
	dstring_write_int(&g_dst, p->weap_id);
	dstring_write_int(&g_dst, p->weap_level);
	dstring_write_int(&g_dst, p->weap_num);
	dstring_write_int(&g_dst, p->total);
	dstring_write_int(&g_dst, p->percent);
	dstring_write_int(&g_dst, p->cd);
	dstring_write_int(&g_dst, p->used);

	return &g_dst;
}

void send_nf_guanka(Guanka *p, GameConn *c)
{
	if(!(c && p))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_guanka_body_new(p)))
		return;
	
	if (!(r = req_new(REQ_NF_GUANKA, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_guanka_where(Guanka *p, int wh)
{
	if (!p)
		return;

	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_guanka(p, c);
		}
	}
}

dstring * req_nf_box_body_new(Box *p)
{
	if (!p)
		return NULL;

    int i = 0;

	dstring_clear(&g_dst);
	dstring_set_big_endian(&g_dst);
		
	dstring_write_int(&g_dst, p->id);
	dstring_write_int(&g_dst, p->level);
	dstring_write_string1(&g_dst, p->name.buf, p->name.offset);
	dstring_write_int(&g_dst, p->face_id);
	dstring_write_int(&g_dst, p->skill);
	dstring_write_int(&g_dst, p->zhen);
	dstring_write_int(&g_dst, p->kongfu);
	dstring_write_int(&g_dst, p->intel);
	dstring_write_int(&g_dst, p->polity);
    for ( i = 0; i < GENE_WEAP_NUM; i++) {
	    dstring_write_int(&g_dst, p->weap[i].id);
	    dstring_write_int(&g_dst, p->weap[i].level);
    }

	dstring_write_int(&g_dst, p->sol);
	dstring_write_int(&g_dst, p->train);
	dstring_write_int(&g_dst, p->spirit);

	return &g_dst;
}

void send_nf_box(Box *p, GameConn *c)
{
	if(!(c && p))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_box_body_new(p)))
		return;
	
	if (!(r = req_new(REQ_NF_BOX, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_box_where(Box *p, int wh)
{
	if (!p)
		return;

	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_box(p, c);
		}
	}
}

dstring * req_nf_room_body_new(Room *p)
{
	if (!p)
		return NULL;

    Game *g = GAME;
    int j = 0;
    int num = 0;
    Wubao *w = NULL;
    User *u = NULL;

	dstring_clear(&g_dst);
	dstring_set_big_endian(&g_dst);
		
	dstring_write_int(&g_dst, p->id);
	dstring_write_int(&g_dst, p->attack_sph_id);
	dstring_write_int(&g_dst, p->defense_sph_id);
	dstring_write_int(&g_dst, p->city_id);
	dstring_write_int(&g_dst, p->ts);


    num = 0;
    for (j = 0; j < ROOM_USER_NUM; j++) {
        if (p->attack_uid[j] > 0 && \
                (u = game_find_user(g, p->attack_uid[j])) &&
                (w = game_find_wubao_by_uid(g, p->attack_uid[j]))) {
            num++;
        }
    }
   
    dstring_write_int(&g_dst, num);
    for (j = 0; j < ROOM_USER_NUM; j++) {
        if (p->attack_uid[j] > 0 && \
                (u = game_find_user(g, p->attack_uid[j])) &&
                (w = game_find_wubao_by_uid(g, p->attack_uid[j]))) {
            dstring_write_int(&g_dst, u->id);
            dstring_write_string1(&g_dst, u->name.buf, u->name.offset);
	        dstring_write_int(&g_dst, w->build[BUILDING_YISHITANG - 1].level);
        }
    }
    
    num = 0;
    for (j = 0; j < ROOM_USER_NUM; j++) {
        if (p->defense_uid[j] != 0) {
            num++;
        }
    }
   
    dstring_write_int(&g_dst, num);
    for (j = 0; j < ROOM_USER_NUM; j++) {
        int tmp = p->defense_uid[j];

        if (tmp != 0) {
            u = game_find_user(g, tmp);
            w = game_find_wubao_by_uid(g, tmp);
            
            dstring_write_int(&g_dst, tmp);

            if (tmp < 0) 
                dstring_write_string(&g_dst, "守城武将");
            else 
                dstring_write_string(&g_dst, u ? u->name.buf : "无名氏");

	        dstring_write_int(&g_dst,  w ? w->build[BUILDING_YISHITANG - 1].level : 0);
        }
    }


	return &g_dst;
}

void send_nf_room(Room *p, GameConn *c)
{
	if(!(c && p))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_room_body_new(p)))
		return;
	
	if (!(r = req_new(REQ_NF_ROOM, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_room_where(Room *p, int wh)
{
	if (!p)
		return;

	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_room(p, c);
		}
	}
}


dstring * req_nf_goto_room_body_new(Room *p, int uid)
{
	if (!p)
		return NULL;

    Game *g = GAME;
    Wubao *w = NULL;
    User *u = NULL;

	dstring_clear(&g_dst);
	dstring_set_big_endian(&g_dst);
		
	dstring_write_int(&g_dst, p->id);
	dstring_write_int(&g_dst, uid);
    
    if ((u = game_find_user(g, uid)) && 
            (w = game_find_wubao_by_uid(g, uid))) {
        dstring_write_int(&g_dst, w->sph_id);
        dstring_write_string1(&g_dst, u->name.buf, u->name.offset);
        dstring_write_int(&g_dst, w->build[BUILDING_YISHITANG - 1].level);
    } 
    else {
        dstring_write_int(&g_dst, 0);
        dstring_write_int(&g_dst, 0);
        dstring_write_int(&g_dst, 0);
    }


	return &g_dst;
}

void send_nf_goto_room(Room *p, int uid, GameConn *c)
{
	if(!(c && p))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_goto_room_body_new(p, uid)))
		return;
	
	if (!(r = req_new(REQ_NF_GOTO_ROOM, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_goto_room_where(Room *p, int uid, int wh)
{
	if (!p)
		return;

	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_goto_room(p, uid, c);
		}
	}
}

dstring * req_nf_exit_room_body_new(Room *p, int uid)
{
	if (!p)
		return NULL;

    Game *g = GAME;
    Wubao *w = NULL;
    User *u = NULL;

	dstring_clear(&g_dst);
	dstring_set_big_endian(&g_dst);
		
	dstring_write_int(&g_dst, p->id);
	dstring_write_int(&g_dst, uid);
    
    if ((u = game_find_user(g, uid)) && 
            (w = game_find_wubao_by_uid(g, uid))) {
        dstring_write_string1(&g_dst, u->name.buf, u->name.offset);
        dstring_write_int(&g_dst, w->build[BUILDING_YISHITANG - 1].level);
    } 
    else {
        dstring_write_int(&g_dst, 0);
        dstring_write_int(&g_dst, 0);
    }


	return &g_dst;
}

void send_nf_exit_room(Room *p, int uid, GameConn *c)
{
	if(!(c && p))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_exit_room_body_new(p, uid)))
		return;
	
	if (!(r = req_new(REQ_NF_EXIT_ROOM, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_exit_room_where(Room *p, int uid, int wh)
{
	if (!p)
		return;

	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_exit_room(p, uid, c);
		}
	}
}


dstring * req_nf_end_room_body_new(Room *p)
{
	if (!p)
		return NULL;

	dstring_clear(&g_dst);
	dstring_set_big_endian(&g_dst);
		
	dstring_write_int(&g_dst, p->id);
	dstring_write_int(&g_dst, p->is_win);

	return &g_dst;
}

void send_nf_end_room(Room *p, GameConn *c)
{
	if(!(c && p))
		return ;
	
	Req * r = NULL;
	dstring *body = NULL;

	if (!(body = req_nf_end_room_body_new(p)))
		return;
	
	if (!(r = req_new(REQ_NF_END_ROOM, SYS_SEND_ID, g_msg_id, body->buf, body->offset, c)))
		return;

	game_conn_send_req(c, r);

	req_free(r);
}

void send_nf_end_room_where(Room *p, int wh)
{
	if (!p)
		return;

	GameConn *c = NULL;

	if (wh == WHERE_ALL) {
		TAILQ_FOREACH(c, &g_cycle->game_conns, link) {
			send_nf_end_room(p, c);
		}
	}
}


