#include "hf.h"


static void read_socket(int fd, short flag, void *arg);

static void write_socket(int fd, short flag, void *arg);

static void process_req_login(Req *r);
static void process_req_login_done(const char *buf, int len, void *arg, int code);
static void process_req_login_ok(Req *r, User *u);
static void process_req_login_goto_create_role(Req *r, User *u);

static void process_req_create_role(Req *r);

static void process_req_level_up(Req *r);

static void process_req_cancel_level_up(Req *r);

static void process_req_speed(Req *r);
static void process_req_speed_done(const char *buf, int len , void *arg, int code);

static void process_req_check_level(Req *r);

static void process_req_made(Req *r);

static void process_req_combin(Req *r);

static void process_req_destroy(Req *r);

static void process_req_config_sol(Req *r);

static void process_req_exp(Req *r);

static void process_req_recover(Req *r);

static void process_req_use_gene(Req *r);

static void process_req_trans_gene(Req *r);
static void process_req_trans_gene_done(const char *buf, int len, void *arg, int code);

static void process_req_visit_gene(Req *r);

static void process_req_give(Req *r);
static void process_req_give_done(const char *buf, int len, void *arg, int code);

static void process_req_buy(Req *r);
static void process_req_buy_done(const char *buf, int len, void *arg, int code);

static void process_req_fire(Req *r);

static void process_req_create_sph(Req *r);

static void process_req_shan_sph(Req *r);

static void process_req_edit_sph(Req *r);

static void process_req_remove_sph(Req *r);

static void process_req_fire_mem(Req *r);

static void process_req_apply_join_sph(Req *r);

static void process_req_tell_apply_join_sph(Req *r);

static void process_req_away_sph(Req *r);

static void process_req_apply_off(Req *r);

static void process_req_apply_league(Req *r);

static void process_req_tell_apply_league(Req *r);
static void process_req_tell_apply_league_done(const char *buf, int len, void *arg, int code) ;

static void process_req_ready_war(Req *r);
static void process_req_ready_war_done(const char *buf, int len, void *arg, int code) ;

static void process_req_move(Req *r);

static void process_req_change_zhen(Req *r);

static void process_req_mail(Req *r);

static void process_req_talk(Req *r);

static void process_req_learn(Req *r);

static void process_req_sys_trade(Req *r);

static void process_req_order(Req *r);
static void process_req_order_done(const char *buf, int len, void *arg, int code);

static void process_req_sell_order(Req *r);
static void process_req_sell_order_done(const char *buf, int len, void *arg, int code) ;

static void process_req_buy_weap(Req *r);
static void process_req_buy_weap_done(const char *buf, int len, void *arg, int code) ;

static void process_req_cancel_order(Req *r);

static void process_req_accept_task(Req *r);

static void process_req_cancel_task(Req *r);

static void process_req_check_task(Req *r);

static void process_req_get_prize(Req *r);
static void process_req_get_prize_done(const char *buf, int len, void *arg, int code);

static void process_req_box(Req *r);
static void process_req_box_done(const char *buf, int len, void *arg, int code);

static void process_req_welfare(Req *r);

static void process_req_plunder(Req *r);

static void process_req_train(Req *r);
static void process_req_train_done(const char *buf, int len, void *arg, int code);

static void process_req_move_city(Req *r);
static void process_req_move_city_done(const char *buf, int len, void *arg, int code);

static void process_req_pk(Req *r);
static void process_req_pk_done(const char *buf, int len, void *arg, int code);

static void process_req_add_made(Req *r);
static void process_req_add_made_done(const char *buf, int len, void *arg, int code);

static void process_req_add_sol(Req *r);
static void process_req_add_sol_done(const char *buf, int len, void *arg, int code);

static void process_req_speed_train(Req *r);
static void process_req_speed_train_done(const char *buf, int len, void *arg, int code);

static void process_req_speed_junlin(Req *r);
static void process_req_speed_junlin_done(const char *buf, int len, void *arg, int code);

static void process_req_buy_junlin(Req *r);
static void process_req_buy_junlin_done(const char *buf, int len, void *arg, int code);

static void process_req_apply_sph_boss(Req *r);

static void process_req_up_kufang(Req *r);
static void process_req_up_kufang_done(const char *buf, int len, void *arg, int code);

static void process_req_set_fresh_step(Req *r);

static void process_req_pool(Req *r);

static void process_req_donate_trea(Req *r);
static void process_req_donate_trea_done(const char *buf, int len, void *arg, int code);

static void process_req_declare_war(Req *r);

static void process_req_apply_war(Req *r);

static void process_req_exit_war(Req *r);

typedef void (*ReqProcCb)(Req *);

struct ReqProcInfo {
	int type;
	ReqProcCb proc;
};
typedef struct ReqProcInfo ReqProcInfo;

static ReqProcInfo g_req_procs[] = {
	{REQ_LOGIN, process_req_login},
	{REQ_CREATE_ROLE, process_req_create_role},
	{REQ_LEVEL_UP, process_req_level_up},
	{REQ_CANCEL_LEVEL_UP, process_req_cancel_level_up},
	{REQ_SPEED, process_req_speed},
	{REQ_CHECK_LEVEL, process_req_check_level},
	{REQ_MADE, process_req_made},
	{REQ_COMBIN, process_req_combin},
	{REQ_DESTROY, process_req_destroy},
	{REQ_CONFIG_SOL, process_req_config_sol},
	{REQ_EXP, process_req_exp},
	{REQ_RECOVER, process_req_recover},
	{REQ_FLUSH_GENE, NULL},
	{REQ_USE_GENE, process_req_use_gene},
	{REQ_TRAN_GENE, process_req_trans_gene},
	{REQ_VISIT_GENE, process_req_visit_gene},
	{REQ_GIVE, process_req_give},
	{REQ_BUY, process_req_buy},
	{REQ_FIRE, process_req_fire},
	{REQ_CREATE_SPH, process_req_create_sph},
	{REQ_SHAN_SPH, process_req_shan_sph},
	{REQ_EDIT_SPH, process_req_edit_sph},
	{REQ_REMOVE_SPH, process_req_remove_sph},
	{REQ_FIRE_MEM, process_req_fire_mem},
	{REQ_APPLY_JOIN_SPH, process_req_apply_join_sph},
	{REQ_TELL_APPLY_JOIN_SPH, process_req_tell_apply_join_sph},
	{REQ_AWAY_SPH, process_req_away_sph},
	{REQ_APPLY_OFF, process_req_apply_off},
	{REQ_APPLY_LEAGUE, process_req_apply_league},
	{REQ_TELL_APPLY_LEAGUE, process_req_tell_apply_league},
	{REQ_READY_WAR, process_req_ready_war},
	{REQ_MOVE, process_req_move},
	{REQ_CHANGE_ZHEN, process_req_change_zhen},
	{REQ_MAIL, process_req_mail},
	{REQ_TALK, process_req_talk},
	{REQ_LEARN,	process_req_learn},
	{REQ_SYS_TRADE, process_req_sys_trade},
	{REQ_ORDER, process_req_order},
	{REQ_SELL_ORDER, process_req_sell_order},
	{REQ_BUY_WEAP, process_req_buy_weap},
	{REQ_CANCEL_ORDER, process_req_cancel_order},
	{REQ_ACCEPT_TASK, process_req_accept_task},
	{REQ_CANCEL_TASK, process_req_cancel_task},
	{REQ_CHECK_TASK, process_req_check_task},
	{REQ_GET_PRIZE, process_req_get_prize},
	{REQ_BOX, process_req_box},
	{REQ_WELFARE, process_req_welfare},
	{REQ_PLUNDER, process_req_plunder},
	{REQ_TRAIN, process_req_train},
	{REQ_MOVE_CITY, process_req_move_city},
	{REQ_PK, process_req_pk},
	{REQ_ADD_MADE, process_req_add_made},
	{REQ_ADD_SOL, process_req_add_sol},
	{REQ_SPEED_TRAIN, process_req_speed_train},
	{REQ_SPEED_JUNLIN, process_req_speed_junlin},
	{REQ_BUY_JUNLIN, process_req_buy_junlin},
	{REQ_APPLY_SPH_BOSS, process_req_apply_sph_boss},
	{REQ_UP_KUFANG, process_req_up_kufang},
	{REQ_SET_FRESH_STEP, process_req_set_fresh_step},
	{REQ_DECLARE_WAR, process_req_declare_war},
	{REQ_APPLY_WAR, process_req_apply_war},
	{REQ_EXIT_WAR, process_req_exit_war},
	/* special req */
	{REQ_POOL, process_req_pool},
	{REQ_DONATE_TREA, process_req_donate_trea},
};



GameConn *game_conn_new(int fd, int read_timeout, int type, ConnCb readcb, \
							   ConnCb writecb, ConnErrCb errorcb, void *arg)
{
	struct sockaddr_in addr;
	socklen_t addr_len = sizeof(addr);
	GameConn * c = (GameConn *) cache_pool_alloc(POOL_GAME_CONN);

	if (!c) {
		return NULL;
	}
	c->fd = fd;
	c->readcb = readcb;
	c->writecb = writecb;
	c->errorcb = errorcb;
	c->read_timeout = read_timeout;
	c->in_bytes = c->out_bytes = 0;

	if (!(c->inbuf = mem_new())) {
		game_conn_free(c);
		return NULL;
	}
	if (!(c->outbuf = mem_new())) {
		game_conn_free(c);
		return NULL;
	}
	
	c->type = type;
	c->uid = 0;
	c->arg = arg;
	TAILQ_INIT(&c->in_req);
	c->handling_req = NULL;
	if(!(c->ev =  ev_new(g_cycle->evbase))) {
		game_conn_free(c);
		return NULL;
	}

	ev_update(c->ev, c->fd, EV_READ, read_socket, c, c->read_timeout);

	c->connect_time = time(NULL);
	c->remote_ip[0] = '\0';

	set_nonblocking(c->fd);
	set_nodelay(c->fd);
	set_linger_close(c->fd);
	set_sock_buf(c->fd, SOCK_MAX_BUFFER);

	if (-1 != getpeername(fd, (struct sockaddr *) &addr, &addr_len)) {
		inet_ntop(AF_INET, (struct sockaddr *) &addr.sin_addr, c->remote_ip, 16);
	}

	DEBUG(LOG_FMT"conn %d, remote %s, inbuf size %d, outbuf size %d\n",  LOG_PRE,  \
					c->fd, c->remote_ip, c->inbuf->off, c->outbuf->off);
	return c;
}

void game_conn_free(GameConn *conn)
{
	if (!conn) 
		return ;
	Req *r, *t;

	DEBUG(LOG_FMT"free remote %s, fd %d.\n", LOG_PRE, conn->remote_ip, conn->fd);
	
	ev_free(conn->ev);
	
	safe_close(conn->fd);

	mem_free(conn->inbuf);

	mem_free(conn->outbuf);

	TAILQ_FOREACH_SAFE(r, &conn->in_req, link, t) {
		TAILQ_REMOVE(&conn->in_req, r, link);
		req_free(r);
	}
	if (conn->handling_req) {
		conn->handling_req->conn = NULL;
	}
	cache_pool_free(POOL_GAME_CONN, conn);
}

bool game_conn_parse_inbuf(GameConn *conn)
{
	int offset = 0;
	int total = 0;
	int len = 0;
	Req *r = NULL;
	const dstring *t = NULL;
	int reason = 0;



	len = conn->inbuf->off;
	for ( ; len > offset ; ) {
		if (!(t = mem_get_buf(conn->inbuf, 0, 4))) {
			break;
		}

		total = 0;

		dstring_set_big_endian((dstring *)t);
	
		dstring_read_int((dstring *)t, &total);

		if (total < 0) {
			WARN(LOG_FMT"request header msg total %d < 0, close\n", LOG_PRE, total);
			return false;
		}
		else if (total >= MAX_MSG_LEN) {
			WARN(LOG_FMT"request header msg total %d > max msg len %d, close\n", \
				LOG_PRE, total, MAX_MSG_LEN);
			return false;
		}

		DEBUG(LOG_FMT"total %d, left %d, handled %d\n", LOG_PRE, total, len - offset, offset);

		/* get all req data */
		if (!(t = mem_get_buf(conn->inbuf, 0, total))) {
			break;
		}

		if(!(r = req_new(0, 0, 0, NULL, 0, conn))) {
			break;
		}

		if (req_parse(r, t->buf, t->offset) == false) {
			reason = REASON_DEF;
			set_reason("消息包格式出错，请升级客户端到最新版本");
			req_send_resp(r, RESP_ERR, get_reason(reason));
			worker_process_request_finish(r);

			r = NULL;
		}

        if (r && conn->uid != r->sid && r->sid != -1) {
            if (!(r->type == REQ_LOGIN || r->type == REQ_CREATE_ROLE)) {
                reason = REASON_DEF;
                set_reason("不要搞破坏，我知道你在哪里");
                req_send_resp(r, RESP_ERR, get_reason(reason));
                worker_process_request_finish(r);

                r = NULL;
            }
        }

        if (r)
            TAILQ_INSERT_TAIL(&conn->in_req, r, link);
		
		offset += total;
	}

	if (offset > 0) {
		mem_erase(conn->inbuf, 0, offset);
	}

	return true;
}

void  game_conn_send_resp(GameConn *conn, Req *r, int code, const char *reason, int len)
{
	if (!(conn && r))
		return;
	
	game_conn_send_resp1(conn, r->sid, r->mid, code, reason, len);
}

void  game_conn_send_resp1(GameConn *conn, int send_id, int msg_id, int code, const char *reason, int len)
{
	if (!(conn))
		return;

	int total = 0;

	mem_set_big(conn->outbuf);

	total = 16 + len;
	mem_write_int(conn->outbuf, &total);
	mem_write_int(conn->outbuf, &code);
	mem_write_int(conn->outbuf, &send_id);
	mem_write_int(conn->outbuf, &msg_id);
	mem_append_buf(conn->outbuf, reason, len);

	write_socket(conn->fd, EV_WRITE, conn);
	
	DEBUG(LOG_FMT"conn %d: total %d, code %d, send id %d, msg id %d\n", \
					LOG_PRE, conn->fd, total, code, send_id, msg_id);
	
}

void game_conn_send_req(GameConn *conn, Req *r)
{
	if (!(conn && r))
		return;

	req_to_string(r, conn->outbuf);
	
	write_socket(conn->fd, EV_WRITE, conn);
}

void game_conn_set_uid(GameConn *conn, User *u)
{
	if (!(u && conn)) 
		return;

	
	conn->uid = u->id;
	
	u->isonline = 1;
	u->client_fd = conn->fd;
}

Req *game_conn_get_ahead_req(GameConn *conn)
{
	if (!conn) 
		return false;

	Req *r = NULL ;

	if ((r = TAILQ_FIRST(&conn->in_req)) == NULL)
		return NULL;

	if (conn->handling_req != NULL) {
		DEBUG(LOG_FMT"conn %d is handling request %p\n", LOG_PRE, conn->fd, conn->handling_req);
		return NULL;
	}
	TAILQ_REMOVE(&conn->in_req, r, link);
	conn->handling_req = r;
	return r;
}

void game_conn_accept(GameConn *c, void  *arg)
{
	int fd = -1;
	GameConn *cl = NULL; 

	if (!c) 
		return ;

	if ((fd = accept(c->fd, NULL, 0)) == -1) {
		WARN(LOG_FMT"listen fd %d failed to accept: %s\n", LOG_PRE, c->fd, error_string());
		return;
	}

	if (!(cl = game_conn_new(fd, GAME_CONN_TIMEOUT, CONN_NORMAL, worker_read_conn, NULL, worker_error_conn, NULL))) {
		WARN(LOG_FMT"failed to alloc new game conn for %d.\n", LOG_PRE, fd);
		close(fd);
		return;
	}
	cycle_add_game_conn(g_cycle, cl);

	DEBUG(LOG_FMT"listen %d accept client %d '%s'.\n", LOG_PRE, c->fd, fd, cl->remote_ip);
}


static void read_socket(int fd, short flag, void *arg)
{
	GameConn *conn = (GameConn *) arg;
	static char buf[MAX_BUFFER];
	int n = 0;
	int error_type = 0;
	int reason = 0;

	if (!conn) 
		return;
	
	ev_update(conn->ev, conn->fd, EV_READ, read_socket, conn, DEF_EV_TIMEOUT);
	
	if (conn->type == CONN_LISTEN) {
		if (conn->readcb) {
			conn->readcb(conn, conn->arg);
		}
		return;
	}
	
	if (flag == EV_TIMEOUT) {
		error_type = CONN_ERR_READ_TIMEOUT;
		goto error;
	}

	n = read(fd, buf, MAX_BUFFER);
	if (n == -1) {
		if (is_ignore_errno(errno) == false) {
			error_type = CONN_ERR_READ;
			goto error;
		}
	} 
	else if (n == 0) {
		error_type = CONN_ERR_CLOSED;
		goto error;
	} 
	else {
		flow_incr_byte(FLOW_GAME_IN, n);

		mem_append_buf(conn->inbuf, buf, n);
		conn->in_bytes += n;
	}

	if (false == game_conn_parse_inbuf(conn)) {
		WARN(LOG_FMT"game conn %d error happen, close.\n", LOG_PRE, conn->fd);
		error_type = CONN_ERR_READ;
		reason = REASON_REQ_FMT_ERR;
		goto error;
	}

	DEBUG(LOG_FMT"read %d byte in conn %d\n", LOG_PRE, n, conn->fd);
	
	if (conn->readcb)
		conn->readcb(conn, conn->arg);
	return;
error:
	cycle_del_game_conn(g_cycle, conn);
	if (conn->errorcb)
		conn->errorcb(conn, error_type, conn->arg);
	game_conn_free(conn);
}

static void write_socket(int fd, short flag, void *arg)
{
	GameConn *conn = (GameConn *)arg;
	int n = 0;
	short error_type = 0;
	int len = 0;
	const dstring *s = NULL;

	if (!conn) 
		return ;

	if (conn->type == CONN_LISTEN) {
		return;
	}
	
	ev_update(conn->ev, conn->fd, EV_WRITE, write_socket, conn, DEF_EV_TIMEOUT);
	
	if (flag == EV_TIMEOUT) {
		error_type = CONN_ERR_WRITE_TIEMOUT;
		goto error;
	}

	len = MIN(conn->outbuf->off, SOCK_MAX_BUFFER);

	if (!(s = mem_get_buf(conn->outbuf, 0, len)))
		return;
	
	n = write(conn->fd, s->buf, s->offset);
	if (n < 0) {
		if (is_ignore_errno(errno) == false) {
			error_type = CONN_ERR_WRITE;
			goto error;
		}
	}

	if (n > 0) { 
		conn->out_bytes += n;
		mem_erase(conn->outbuf, 0, n);
		
		if (conn->outbuf->off == 0) 
			ev_update(conn->ev, conn->fd, EV_READ, read_socket, conn, DEF_EV_TIMEOUT);
	}

	DEBUG(LOG_FMT"conn %d write %d, left %d\n",  \
					LOG_PRE, conn->fd, n, conn->outbuf->off);

	if (conn->writecb)
		conn->writecb(conn, conn->arg);

	return;
error:
	cycle_del_game_conn(g_cycle, conn);
	if (conn->errorcb)
		conn->errorcb(conn, error_type, conn->arg);
	game_conn_free(conn);
}


void worker_read_conn(GameConn *conn, void *data)
{
	Req *r = NULL;
	
	if (!conn) 
		return;
	if (NULL == (r = game_conn_get_ahead_req(conn)))
		return ;
	worker_process_request(r);
}


void worker_write_conn(GameConn *conn, void *data)
{
}

void worker_error_conn(GameConn *conn, short flag, void *data)
{
	Game *g = GAME;
	User *u = NULL;
	
	if (!conn) 
		return;

	DEBUG(LOG_FMT"conn %d, '%s' error: %s\n", LOG_PRE, conn->fd, conn->remote_ip, conn_error_type_string(flag));
	
	if ((u = game_find_user(g, conn->uid))) {
		
		user_offline(u);
		
		send_nf_user_where(u, WHERE_ALL);

		webapi_user(g, 0, u, ACTION_EDIT, NULL, NULL);
	}
}

void worker_process_request(Req *r)
{
	ReqProcInfo *rh = NULL;
	int len  = 0;
	int i = 0;


	if (!r)
		return;
	len = ARRAY_LEN(g_req_procs, ReqProcInfo);
	for( i = 0; i < len; i ++) {
		if (r->type == g_req_procs[i].type) {
			rh = &g_req_procs[i];
			break;
		}
	}
	if (rh == NULL) {
		req_send_resp(r, RESP_ERR, NULL);
		worker_process_request_finish(r);
		return;
	}
	if (rh->proc) {
		rh->proc(r);
		return;
	}
	else {
		req_send_resp(r, RESP_ERR, NULL);
		worker_process_request_finish(r);
		return;
	}
}

void worker_process_request_finish(Req *r)
{
	GameConn *conn = NULL;
	Req *next_r = NULL;
	int code = RESP_ERR;

	if (!r)
		return;
	conn  = r->conn;
	if (r->cb) {
		code = r->resp_code;
		r->cb(code, r->arg);
	}
	req_free(r);
	r = NULL;
	if (!conn) {
		return;
	}
	if (NULL == (next_r = game_conn_get_ahead_req(conn)))
		return;
	worker_process_request(next_r);	
}


static void process_req_login(Req *r)
{
	if (!r)
		return;

	Game *g = GAME;
	User *u = NULL;

	if (!(u = game_find_user(g, r->sid))) {
		webapi_user(g, r->sid, NULL, ACTION_GET, process_req_login_done, r);
		return;
	}

	process_req_login_done(NULL, 0, r, HTTP_OK);
}

static void process_req_login_done(const char *buf, int len, void *arg, int code) 
{
	Req * r = (Req *) arg;
	int reason = 0;
	Game *g = GAME;
	User *u = NULL;
	ReqLoginBody *b = r->bs;

	if (!(code == HTTP_OK)) {
		reason = REASON_WEB_ERR;
		goto err;
	}

	if (b->ver < REQ_CLIENT_VER) {
		reason = REASON_DEF;
		set_reason("请刷新页面，将客户端版本升级到%d或者以上版本", REQ_CLIENT_VER);
		goto err;
	}

	parse_all_user(buf, len, NULL, code);

	if(!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	
	if (u->client_fd > 0) {
		GameConn *old_c = NULL;
		if ((old_c = cycle_find_game_conn(g_cycle, u->client_fd))) {
			send_nf_offline(old_c);
		} 
		else {
			reason = REASON_HAVE_LOGINED;
			goto err;
		}
	}
	

	if (u->wid <= 0) {
		/* go to create role */
		process_req_login_goto_create_role(r, u);
	}
	else {
		game_conn_set_uid(r->conn, u);
		process_req_login_ok(r, u);
	}

	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_login_ok(Req *r, User *u)
{
	if (!(u && r && r->conn))
		return;

	Game *g = GAME;
	Wubao *w = NULL;	
	City *c = NULL;	
	Gene *gene = NULL;	
	Sph *sph = NULL;	
	Trea *t = NULL;	
	Dipl *dipl = NULL;	
	User *other = NULL;	
	Army *a = NULL;	
	CmdTrans *cmd = NULL;	
	Order *o = NULL;	
	SellOrder *so = NULL;
	Zhanyi *zy = NULL;
	Guanka *gk = NULL;
	Box *bx = NULL;
    Room *room = NULL;
	Key *k = NULL;


	if (!(w = game_find_wubao(g, u->wid))) 
		return;

	w->last_login_time = time(NULL);

	send_nf_time(g->time, r->conn);
	
	send_nf_user_where(u, WHERE_ALL);
	
	send_nf_wubao(w, r->conn);

	/* sph */
	RB_FOREACH(sph, GameSphMap, &g->sphs) {
		send_nf_sph(sph, r->conn);
	}
	/* user */
	RB_FOREACH(other, GameUserMap, &g->users) {
		send_nf_user(other, r->conn);
	}
	/* city  */
	RB_FOREACH(c, GameCityMap, &g->cities) {
		send_nf_city(c, r->conn);
	}
	
	/* gene */
	RB_FOREACH(gene, GameGeneMap, &g->genes) {
		if(gene->type == GENE_TYPE_NAME || gene->uid == u->id || \
				(gene->place == GENE_PLACE_ARMY && gene->place_id > 0) || \
				(gene->place == GENE_PLACE_WUBAO && gene->place_id == w->id))
			send_nf_gene(gene, r->conn);
	}
	/* trea */
	RB_FOREACH(k, KeyMap, &w->treas) {
		if ((t = game_find_trea(g, k->id)))
			send_nf_trea(t, r->conn);
	}

	/* dipl */
	RB_FOREACH(dipl, GameDiplMap, &g->dipls) {
		send_nf_dipl(dipl, r->conn);
	}
	/* army */
	RB_FOREACH(a, GameArmyMap, &g->armies) {
		if (a->state == ARMY_DEAD || a->state <= 0)
			continue;
		send_nf_army(a, r->conn);
	}
	/* cmd trans */
	RB_FOREACH(cmd, GameCmdTransferMap, &g->cmd_trans) {
		send_nf_cmd_trans(cmd, r->conn);
	}
	/* order */
	RB_FOREACH(o, GameOrderMap, &g->orders) {
		send_nf_order(o, r->conn);
	}
	/* sell order */
	RB_FOREACH(so, GameSellOrderMap, &g->sell_orders) {
		send_nf_sell_order(so, r->conn);
	}
	
    /* zhanyi */
	RB_FOREACH(zy, GameZhanyiMap, &g->zhanyis) {
		send_nf_zhanyi(zy, r->conn);
	}
	
	/* gk */
	RB_FOREACH(gk, GameGuankaMap, &g->guankas) {
		send_nf_guanka(gk, r->conn);
	}
    
    /* box */
	RB_FOREACH(bx, GameBoxMap, &g->boxes) {
		send_nf_box(bx, r->conn);
	}

    /* room */
    RB_FOREACH(room, GameRoomMap, &g->rooms) {
        send_nf_room(room, r->conn);
    }


	history_talk_send_out(r->conn);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
}


static void process_req_login_goto_create_role(Req *r, User *u)
{
	if (!(u && r))
		return;

	Game *g = GAME;
	City *c = NULL;


	RB_FOREACH(c, GameCityMap, &g->cities) {
		send_nf_city(c, r->conn);
	}
	send_nf_create_role(1, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
}


static void process_req_create_role(Req *r)
{
	if (!r)
		return;

	Game *g = GAME;
	User *u = NULL;
	int reason = 0;
	ReqCreateRoleBody *b = NULL;
	City *city = NULL;
	Wubao *w = NULL;
	User *t = NULL;
	Gene *gene = NULL;
	

	b = (ReqCreateRoleBody *) r->bs;

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if(!(city = game_find_city(g, b->city_id))) {
		reason = REASON_NOT_FOUND_CITY;
		goto error;
	}

	if (!(w = city_get_idle_wubao(city))) {
		reason = REASON_NOT_FOUND_IDLE_WUBAO;
		goto error;
	}

	RB_FOREACH(t, GameUserMap, &g->users) {
		if (!dstring_cmp(&b->name, &t->name)) {
			reason = REASON_MULT_NAME;
			goto error;
		}
	}


	city->idle_wubao_num--;
	send_nf_city_where(city, WHERE_ALL);
	
	u->wid = w->id;

	w->uid = u->id;

	game_alloc_rank(g, w);
	
	dstring_set(&u->name, b->name.buf);

	if((gene = game_gen_new_gene(g, w))) {
		dstring_clear(&gene->last_name);
		dstring_set(&gene->first_name, b->name.buf);
		
		lua_update_gene_for_fresh(gene);
		
		gene->faith = 100;
		gene->uid = w->uid;

		gene_change_place(gene, GENE_PLACE_WUBAO, w->id);
	}


	send_nf_user_where(u, WHERE_ALL);
	
	webapi_user(g, 0, u, ACTION_EDIT, user_retry_commit, u);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}


static void process_req_level_up(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int now = GAME_NOW;
	int reason = 0;
	ReqLevelUpBody *b = NULL;
	Wubao *w = NULL;
	int is_allow = 0;
	int h = 0;
	int res[RES_MAX - 1] = {0};
	int i = 0;
	int queue = 0;
	int num = 0;


	DEBUG(LOG_FMT"game now %d\n", LOG_PRE, GAME_NOW);

	b = (ReqLevelUpBody *) r->bs;
	if(!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	if (b->type == LEVEL_UP_BUILD) {
		if(b->id <= BUILDING_NONE || b->id >= BUILDING_MAX) {
			reason = REASON_LEVEL_UP_BUIL_ERR;
			goto err;
		}

		if (!lua_get_building_queue(w, &queue)) {
			reason = REASON_AI_ERR;
			goto err;
		}

		if ((num = wubao_level_up_build(w)) >= queue) {
			reason = REASON_DEF;
			set_reason("当前已经有%d个建筑在升级中，你的建筑队列上限是%d.", num, queue);
			goto err;
		}


		if(w->build[b->id - 1].up_end_time > 0)  {
			if(w->build[b->id - 1].up_end_time < now) {
				reason = REASON_UPING;
				goto err;
			}
			else {
				w->build[b->id - 1].up_end_time = 0;
				w->build[b->id - 1].level++;
			}
		}
	}
	else if (b->type == LEVEL_UP_TECH) {
		if(b->id <= TECH_NONE || b->id >= TECH_MAX) {
			reason = REASON_LEVEL_UP_TECH_ERR;
			goto err;
		}
		
		if (!lua_get_tech_queue(w, &queue)) {
			reason = REASON_AI_ERR;
			goto err;
		}

		if ((num = wubao_level_up_tech(w)) >= queue) {
			reason = REASON_DEF;
			set_reason("当前已经有%d个科技在升级中，你的科技队列上限是%d.", num, queue);
			goto err;
		}
		if(w->tech[b->id - 1].up_end_time > 0) {
			if (w->tech[b->id - 1].up_end_time < now) {
				reason = REASON_UPING;
				goto err;
			}
			else {
				w->tech[b->id - 1].up_end_time = 0;
				w->tech[b->id - 1].level++;
			}
		}
	}
	else {
		reason = REASON_LEVEL_UP_TYPE_ERR;
		goto err;
	}
	
	
	if (!lua_level_up(w, b->type, b->id, &is_allow, res, &h)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (is_allow == 0) {
		reason = REASON_UNREACHED;
		goto err;
	}

	for(i = 0; i < RES_MAX - 1; i++) {
		safe_sub(w->res[i], res[i]); 
	}

	if (b->type == LEVEL_UP_BUILD) {
		w->build[b->id - 1].up_end_time = GAME_NOW + h;
	}
	else if (b->type == LEVEL_UP_TECH) {
		w->tech[b->id - 1].up_end_time = GAME_NOW + h;
	}

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_cancel_level_up(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqCancelLevelUpBody *b = NULL;
	Wubao *w = NULL;

	b = (ReqCancelLevelUpBody *) r->bs;
	if(!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	if (b->type == LEVEL_UP_BUILD) {
		if(b->id <= BUILDING_NONE || b->id >= BUILDING_MAX) {
			goto err;
		}
		w->build[b->id - 1].up_end_time = 0;
	}
	else if(b->type == LEVEL_UP_TECH) {
		if(b->id <= TECH_NONE || b->id >= TECH_MAX) 
			goto err;
		w->tech[b->id - 1].up_end_time = 0;
	}
	else 
		goto err;

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_speed(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqSpeedBody *b = NULL;
	Wubao *w = NULL;
	int h = 0;
	int gold = 0;
	TwoArg *targ = NULL;
	bool changed = false;

	b = (ReqSpeedBody *) r->bs;
	if(!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	if (b->type == SPEED_BUILD) {
		if(b->id <= BUILDING_NONE || b->id >= BUILDING_MAX) {
			goto err;
		}
		h = w->build[b->id - 1].up_end_time - GAME_NOW;
	}
	else if(b->type == SPEED_TECH) {
		if(b->id <= TECH_NONE || b->id >= TECH_MAX) 
			goto err;
		h = w->tech[b->id - 1].up_end_time - GAME_NOW;
	}
	else {
		goto err;
	}

	if((changed = wubao_check_level(w, GAME_NOW)))
		send_nf_wubao(w, r->conn);

	if (h <= 0) {	
		WARN(LOG_FMT"up end time %d, now %d, type %d, id %d\n", LOG_PRE, w->tech[b->id - 1].up_end_time, GAME_NOW, \
				b->type, b->id);
		reason = REASON_SPEED_HOUR_ERR;
		goto err;
	}

	if (!lua_get_speed_gold(h, &gold)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (!(targ = two_arg_new(w, r))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	webapi_sub_gold(r->sid, gold, process_req_speed_done, targ);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_speed_done(const char *buf, int len , void *arg, int code)
{
	if (!arg)
		return;
	
	int reason = 0;
	Req *r = NULL;
	ReqSpeedBody *b = NULL;
	Wubao *w = NULL;
	TwoArg *targ = (TwoArg *) arg;


	
	w = (Wubao *) targ->m_arg1;
	r = (Req *) targ->m_arg2;	
	b = (ReqSpeedBody *) r->bs;

	if (!(buf && code == HTTP_OK && atoi(buf) > 0)) {
		reason = REASON_MONEY_SHORTAGE;
		goto err;
	}
	
	if (b->type == SPEED_BUILD) {
		if(b->id <= BUILDING_NONE || b->id >= BUILDING_MAX) {
			goto err;
		}
		w->build[b->id - 1].up_end_time = 0;
		w->build[b->id - 1].level++;
	}
	else if(b->type == SPEED_TECH) {
		if(b->id <= TECH_NONE || b->id >= TECH_MAX) 
			goto err;
		w->tech[b->id - 1].up_end_time = 0;
		w->tech[b->id - 1].level++;
	}
	else 
		goto err;

	send_nf_wubao(w, r->conn);

	two_arg_free(targ);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	two_arg_free(targ);
	
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
	return;
}

static void process_req_check_level(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int now = GAME_NOW;
	int reason = 0;
	Wubao *w = NULL;


	if(!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
			
	if (wubao_check_level(w, now))
		send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_made(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqMadeBody *b = NULL;
	Wubao *w = NULL;
	int is_allow = 0;
	int res[RES_MAX - 1] = {0};
	int made = 0;
	int i = 0;


	b = (ReqMadeBody *)r->bs;
	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
    
    if (b->num <= 0) {
        goto err;
    }

	if (!lua_made(w, b->type, b->num, &is_allow, res, &made)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (is_allow == 0) {
		reason = REASON_UNREACHED;
		goto err;
	}

	for(i = 0; i < RES_MAX - 1; i++) {
		safe_sub(w->res[i], res[i]);
	}

	safe_add(w->used_made, made);
	
	safe_add(w->weap[b->type - 1].num[0], b->num);

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_combin(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqCombBody *b = NULL;
	Wubao *w = NULL;
	int is_allow = 0;
	int level = 0;
	int num = 0;


	b = (ReqCombBody *)r->bs;
	if(b->type <= WEAP_NONE || b->type >= WEAP_MAX) {
		goto err;
	}
	
    if (b->level < WEAP_LEVEL0 || b->level >= WEAP_LEVEL_MAX) {
		goto err;
    }

    if (b->num <= 0) {
        goto err;
    }
	
	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

    if (w->weap[b->type - 1].num[b->level] <= 0) {
        goto err;
    }
	
    if (!lua_comb(w, b->type, b->level, b->num, &is_allow, &level, &num)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (is_allow == 0 || level < WEAP_LEVEL0 || level >= WEAP_LEVEL_MAX) {
		reason = REASON_UNREACHED;
		goto err;
	}

	safe_sub(w->weap[b->type - 1].num[b->level], b->num);

	safe_add(w->weap[b->type - 1].num[level], num);

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_destroy(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqDestroyBody *b = NULL;
	Wubao *w = NULL;
	int money = 0;


	b = (ReqDestroyBody *)r->bs;
	if(b->type <= WEAP_NONE || b->type >= WEAP_MAX) {
		reason = REASON_WEAP_TYPE_ERR;
		goto err;
	}
	if (b->level < WEAP_LEVEL0 || b->level >= WEAP_LEVEL_MAX) {
		reason = REASON_WEAP_LEVEL_ERR;
		goto err;
	}
	
	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	if (!lua_destroy(b->type, b->level, w->weap[b->type - 1].num[b->level], &money)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	w->res[RES_MONEY - 1] += money;

	w->weap[b->type - 1].num[b->level] = 0;

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_config_sol(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqConfigSolBody *b = NULL;
	Wubao *w = NULL;
	int is_allow = 0;
	int i = 0;
	Gene *gene = NULL;
	int sol_per_weap = 0;
	int num[GENE_WEAP_NUM] = {0};


	b = (ReqConfigSolBody *)r->bs;

	for(i = 0; i < GENE_WEAP_NUM; i++) {
		if(b->weap[i].id < WEAP_NONE || b->weap[i].id >= WEAP_MAX) {
			reason = REASON_WEAP_TYPE_ERR;
			goto err;
		}
		if (b->weap[i].level < WEAP_LEVEL0 || b->weap[i].level >= WEAP_LEVEL_MAX) {
			reason = REASON_WEAP_LEVEL_ERR;
			goto err;
		}
	}
	
	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if(!(gene = game_find_gene(g, b->gene_id))){
		reason = REASON_NOT_FOUND_GENE;
		goto err;
	}

    if (b->num < 0) {
        goto err;
    }

	if (b->num > gene->fol) {
		reason = REASON_EXCEED_GENE_FOLLOW;
		goto err;
	}
	
	if (!lua_config_sol(b, &is_allow, num)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (is_allow == 0) {
		reason = REASON_UNREACHED;
		goto err;
	}
	//check sol	
	if (b->num > gene->sol_num + w->sol + gene->hurt_num) {
		reason = REASON_SOL_SHORTAGE;
		goto err;
	}
	//check weapon
	for(i = 0; i < GENE_WEAP_NUM; i++) {
		if( b->weap[i].id <= 0 || b->weap[i].level <= 0)
			continue;
		if(w->weap[b->weap[i].id - 1].num[b->weap[i].level] + gene->sol_num + gene->hurt_num < num[i]) {
			reason = REASON_WEAPON_SHORTAGE;
			goto err;
		}
	}

	for (i = 0; i < GENE_WEAP_NUM; i++) {
		if (gene->weap[i].id > 0 && gene->weap[i].level >= WEAP_LEVEL0) {
			if (!lua_get_sol_per_weapon(gene->weap[i].id, &sol_per_weap))
				continue;

			sol_per_weap = sol_per_weap <= 0 ? 1 : sol_per_weap;

			w->weap[gene->weap[i].id - 1].num[gene->weap[i].level] += floor((gene->sol_num + gene->hurt_num) / sol_per_weap);
		}

		if(b->weap[i].id > 0 && b->weap[i].level >= WEAP_LEVEL0) {
			
			if (!lua_get_sol_per_weapon(b->weap[i].id, &sol_per_weap))
				continue;
			
			sol_per_weap = sol_per_weap <= 0 ? 1 : sol_per_weap;
			
			w->weap[b->weap[i].id - 1].num[b->weap[i].level] -= floor(b->num / sol_per_weap);
		}

		if (b->num > 0) {
			gene->weap[i].id = b->weap[i].id;
			gene->weap[i].level = b->weap[i].level;
		}
		else {
			gene->weap[i].id = 0;
			gene->weap[i].level = 0;
		}
	}
	
	
	if (b->num > gene->sol_num + gene->hurt_num) {
		gene->sol_spirit = (gene->sol_spirit * (gene->sol_num + gene->hurt_num) + \
				DEF_SOL_SPIRIT * (b->num - gene->sol_num - gene->hurt_num)) / b->num;
	}
	gene->sol_spirit = gene->sol_spirit <= 0 ? DEF_SOL_SPIRIT : gene->sol_spirit;

	if (b->num >= gene->hurt_num) {
		w->sol += gene->sol_num;
		gene->sol_num = b->num - gene->hurt_num;
		w->sol -= gene->sol_num;
	}
	else {
		w->sol += gene->sol_num;
		gene->sol_num = 0;
		gene->hurt_num = b->num;
	}

	gene->used_zhen = b->zhen;

	send_nf_gene(gene, r->conn);
	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_exp(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqExpBody *b = NULL;
	Wubao *w = NULL;
	int is_allow = 0;
	int need_money = 0;
	int need_food = 0;
	Gene *gene = NULL;
	Army *a = NULL;
	int x = 0;
	int y = 0;
	City *city = NULL;


	b = (ReqExpBody *)r->bs;

	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if(!(gene = game_find_gene(g, b->gene_id))){
		reason = REASON_NOT_FOUND_GENE;
		goto err;
	}

	if (gene->uid != w->uid) {
		reason = REASON_AUTH_ERR;
		goto err;
	}

	if (!(gene->place == GENE_PLACE_WUBAO || gene->place == GENE_PLACE_CITY)) {
		goto err;
	}

	if (b->type <= 0 || b->day <= 0) {
		reason = REASON_EXP_TYPE_ERR;
		goto err;
	}
	
	if (!lua_exp(w->res[RES_MONEY - 1], w->res[RES_FOOD - 1], b->type, b->day, gene->sol_num + gene->hurt_num, \
			&is_allow, &need_money, &need_food)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (is_allow == 0) {
		reason = REASON_UNREACHED;
		goto err;
	}

	if(gene->place == GENE_PLACE_WUBAO && !wubao_get_idle_xy(w, &x, &y)) {
        wubao_get_xy(w, &x, &y);
	}
	else if (gene->place == GENE_PLACE_CITY &&  (city = game_find_city(g, gene->place_id))) {
		x = city->x;
		y = city->y;
	}

	if (!(a = army_new1(b->gene_id, x, y, need_money, need_food, b->type, gene->sol_num))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}
	a->id = (g->max_army_id + 1);
	if (!game_add_army(g, a)) {
		goto err;
	}

	a->from_place = gene->place;
	a->from_place_id = gene->place_id;
	

	safe_sub(w->res[RES_MONEY - 1], need_money);

	safe_sub(w->res[RES_FOOD - 1], need_food);

	gene->used_zhen = b->zhen;

	gene_change_place(gene, GENE_PLACE_ARMY, a->id);
	
	send_nf_gene_where(gene, WHERE_ALL);

	send_nf_wubao(w, r->conn);
	
	send_nf_army_where(a, WHERE_ALL);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	if (a) {
		game_del_army(g, a);
		army_free(a);
	}
	
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);

}

static void process_req_recover(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqRecoverBody *b = NULL;
	Wubao *w = NULL;
	Gene *gene = NULL;
	int num = 0;


	b = (ReqRecoverBody *)r->bs;

	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if(!(gene = game_find_gene(g, b->gene_id))){
		reason = REASON_NOT_FOUND_GENE;
		goto err;
	}

    if (gene->place == GENE_PLACE_ARMY) {
		reason = REASON_DEF;
        set_reason("作战期间不能治疗武将");
		goto err;
    }
	
	if (!lua_recover(w, gene->hurt_num, &num)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (num <= 0) {
		reason = REASON_UNREACHED;
		goto err;
	}

	safe_sub(gene->hurt_num, num);
	
	safe_add(gene->sol_num, num);

	send_nf_gene_where(gene, WHERE_ALL);
	
	safe_add(w->cure_sol, num);

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);

}

static void process_req_use_gene(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqUseGeneBody *b = NULL;
	Wubao *w = NULL;
	Gene *gene = NULL;
	int succ = 0;
	int num = 0;

	b = (ReqUseGeneBody *)r->bs;

	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if(!(gene = game_find_gene(g, b->gene_id))){
		reason = REASON_NOT_FOUND_GENE;
		goto err;
	}
	if (gene->uid > 0) {
		reason = REASON_GENE_HAS_USED_BY_OTHER;
		goto err;
	}

	num = wubao_get_mine_gene_num(w);

	if (num >= w->max_gene) {
		reason = REASON_GENE_HAS_REACHE_MAX;
		goto err;
	}

	if (!lua_use_gene(w, gene->type, wubao_get_fri(w, gene->id), gene->fri, &succ)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (!succ) {
		reason = REASON_UNREACHED;
		goto err;
	}

	gene->faith = 100;
	gene->uid = w->uid;

	gene_change_place(gene, GENE_PLACE_WUBAO, w->id);

	send_nf_gene_where(gene, WHERE_ALL);

	wubao_set_fri(w, gene->id, 0);

	send_nf_wubao_where(w, WHERE_ME);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}


static void process_req_trans_gene(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqTranGeneBody *b = NULL;
	Wubao *w = NULL;
	Gene *gene = NULL;
	City *c, *c1;
	int now = GAME_NOW;
	double h = 0;
	int speed = 15;
    int dist = 0;
	CmdTrans *cmd = NULL;
    int x = 0;
    int y = 0;


	b = (ReqTranGeneBody *)r->bs;
	if(!(gene = game_find_gene(g, b->gene_id))){
		reason = REASON_NOT_FOUND_GENE;
		goto err;
	}
	if (gene->uid != r->sid) {
		reason = REASON_DEF;
		set_reason("该武将并不属于你，你无权输送");
		goto err;
	}
	if (gene->place == GENE_PLACE_TRIP) {
		reason = REASON_DEF;
		set_reason("您的武将已经在赶往目的地的路途中");
		goto err;
	}

	if (!lua_get_army_speed(gene, EXPEDITION_GENE, &speed)) {
		reason = REASON_AI_ERR;
		goto err;
	}
	
	if(!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	if(b->type == TRANS_WU_TO_CI) {
		if (!(c = game_find_city(g, b->to_id))) {
			reason = REASON_NOT_FOUND_CITY;
			goto err;
		}

		if (gene->place != GENE_PLACE_WUBAO) {
			reason = REASON_DEF;
			set_reason("您的武将并不在坞堡中");
			goto err;
		}

        wubao_get_xy(w, &x, &y);

        dist = computer_distance(x, y, c->x, c->y);
	}
	else if (b->type == TRANS_CI_TO_CI) {
		if (gene->place != GENE_PLACE_CITY) {
			reason = REASON_DEF;
			set_reason("您的武将并不在该城中");
			goto err;
		}

		if (!(c = game_find_city(g, gene->place_id))) {
			reason = REASON_NOT_FOUND_CITY;
			goto err;
		}
		if (!(c1 = game_find_city(g, b->to_id))) {
			reason = REASON_NOT_FOUND_CITY;
			goto err;
		}
		
		
		dist = computer_distance(c1->x, c1->y, c->x, c->y);
	}
	else if (b->type == TRANS_CI_TO_WU) {
		if (gene->place != GENE_PLACE_CITY) {
			reason = REASON_DEF;
			set_reason("您的武将并不在该城中");
			goto err;
		}

		if (!(c = game_find_city(g, gene->place_id))) {
			reason = REASON_NOT_FOUND_CITY;
			goto err;
		}
		if (w->id != b->to_id) {
			reason = REASON_NOT_FOUND_WUBAO;
			goto err;
		}

        wubao_get_xy(w, &x, &y);

		dist = computer_distance(x, y, c->x, c->y);
	}
	else {
		goto err;
	}

    h = (double)dist/(double)speed;

    DEBUG(LOG_FMT"distance %d, speed %d, hour %d\n", LOG_PRE, dist, speed, h);

	if (b->is_speed) 
		h /= 2;	

	if (!(cmd = cmd_trans_new(gene->place_id, b->to_id, b->type, w->sph_id, GOOD_GENE, \
					b->gene_id, 1, now + h))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	cmd->id = g->max_cmd_trans_id + 1;

	if (!game_add_cmd_trans(g, cmd)) {
		goto err;
	}

	if (b->is_speed) {
		TwoArg *targ = NULL;
		int gold = 0;

		if (!lua_get_speed_gold(ceil(h), &gold)) {
			reason = REASON_AI_ERR;
			goto err;
		}

		if (!(targ = two_arg_new(cmd, r))) {
			reason = REASON_MEM_SHORTAGE;
			goto err;
		}


		webapi_sub_gold(r->sid, gold, process_req_trans_gene_done, targ);
		return;
	}

	gene_change_place(gene, GENE_PLACE_TRIP, cmd->id);

	send_nf_gene_where(gene, WHERE_ALL);

	send_nf_cmd_trans(cmd, r->conn);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	cmd_trans_free(cmd);
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_trans_gene_done(const char *buf, int len, void *arg, int code)
{
	if (!arg)
		return;
	
	Game *g = GAME;
	int reason = 0;
	Req *r = NULL;
	ReqTranGeneBody *b = NULL;
	Gene *gene = NULL;
	CmdTrans *cmd = NULL;
	TwoArg *targ = (TwoArg *) arg;


	cmd = targ->m_arg1;
	r = targ->m_arg2;
	b = (ReqTranGeneBody *)r->bs;
	
	if (!(buf && code == HTTP_OK && atoi(buf) > 0)) {
		reason = REASON_MONEY_SHORTAGE;
		goto err;
	}


	if(!(gene = game_find_gene(g, b->gene_id))){
		reason = REASON_NOT_FOUND_GENE;
		goto err;
	}

	gene_change_place(gene, GENE_PLACE_TRIP, cmd->id);

	send_nf_gene_where(gene, WHERE_ALL);

	send_nf_cmd_trans(cmd, r->conn);

	two_arg_free(targ);

	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	
	game_del_cmd_trans(g, cmd);

	cmd_trans_free(cmd);

	two_arg_free(targ);

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_visit_gene(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqVisitGeneBody *b = NULL;
	Wubao *w = NULL;
	Gene *gene = NULL;
	int succ = 0;
	int now = GAME_NOW;
	City *city = NULL;
	int num = 0;
    int hour = 0;
    int fri = 0;


	b = (ReqVisitGeneBody *)r->bs;
	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if(!(gene = game_find_gene(g, b->gene_id))){
		reason = REASON_NOT_FOUND_GENE;
		goto err;
	}
	if (gene->uid > 0) {
		reason = REASON_GENE_HAS_USED_BY_OTHER;
		goto err;
	}
	if (gene->place != GENE_PLACE_CITY) {
		reason = REASON_DEF;
		set_reason("您的武将并不在城中，不能拜访");
		goto err;
	}

	if (!(city = game_find_city(g, gene->place_id))) {
		reason = REASON_NOT_FOUND_CITY;
		goto err;
	}

    if (!lua_get_visit_gene_fri(gene, &fri, &hour)) {
        reason = REASON_AI_ERR;
        goto err;
    }


	if (now - w->last_visit_time < hour) {
		reason = REASON_DEF;
		set_reason("请等待 %d 时辰后再拜访", ((w->last_visit_time + hour) - now));
		goto err;
	}

	if (w->sph_id <= 0 || w->sph_id != city->sph_id) {
		reason = REASON_DEF;
		set_reason("必须先攻打下城池，才能拜访武将");
		goto err;
	}

	num = wubao_get_mine_gene_num(w);

	if (num >= w->max_gene) {
		DEBUG(LOG_FMT"mine gene %d, max %d\n", LOG_PRE, num, w->max_gene);
		reason = REASON_GENE_HAS_REACHE_MAX;
		goto err;
	}


	wubao_change_fri(w, gene->id, fri);

	w->last_visit_time = now;

	if (!lua_use_gene(w, gene->type, wubao_get_fri(w, gene->id), gene->fri, &succ)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (succ) {
		gene->uid = w->uid;
		gene->faith = 100;
		gene_change_place(gene, GENE_PLACE_WUBAO, w->id);
		send_nf_gene_where(gene, WHERE_ALL);

		wubao_set_fri(w, gene->id, 0);
	}
		
	send_nf_wubao(w, r->conn);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_give(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqGiveBody *b = NULL;
	Wubao *w = NULL;
	Gene *gene = NULL;
	Trea *t = NULL;
	TwoArg *targ = NULL;
	int type = 0;
	

	b = (ReqGiveBody *)r->bs;

	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if (!(t = wubao_find_trea(w, b->tid))) {
		reason = REASON_NOT_FOUND_TREA;
		goto err;
	}

	type = trea_get_type(t);
	
	if (b->type == REQ_GIVE_YES) {
		if(t->is_used) {
			reason = REASON_TREA_USED;
			goto err;
		}
		if(!(gene = game_find_gene(g, b->gene_id))){
			reason = REASON_NOT_FOUND_GENE;
			goto err;
		}
		if (gene_find_trea_by_type(gene, type)) {
			reason = REASON_GENE_HAS_SAME_TYPE_TREA;
			goto err;
		}

		trea_set_used(t);
		t->gene_id = gene->id;
	} 
	else if (b->type == REQ_GIVE_NO) {
		trea_set_unused(t);
	}
	else if (b->type == REQ_GIVE_USE) {
		trea_set_used(t);
	}
	else {
		goto err;
	}

	if (!(targ = two_arg_new(t, r))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	webapi_treasure(g, t, ACTION_EDIT, process_req_give_done, targ);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_give_done(const char *buf, int len, void *arg, int code)
{
	if (!arg)
		return;
	
	Game *g = GAME;
	Req *r = NULL;
	int reason = 0;
	ReqGiveBody *b = NULL;
	Wubao *w = NULL;
	Gene *gene = NULL;
	Trea *t = NULL;
	int type = 0;
	int num = 0;
	int mine = 0;
	User *u = NULL;
	TwoArg *targ = (TwoArg *) arg;
	HttpParam p;
	HeaderEntry *e;
	int id = 0;
	const char *ret_reason = NULL;
	

	http_param_init(&p);
	
	t = (Trea *)targ->m_arg1;
	r = (Req *)targ->m_arg2;
	b = (ReqGiveBody *)r->bs;

	if (!(code == HTTP_OK && buf)){
		reason = REASON_WEB_ERR;
		goto err;
	}

	if (!http_param_parse(&p, buf)) {
		goto err;
	}
	
	TAILQ_FOREACH(e, &p.entries, link) {
		if(!strcasecmp(e->name.buf, "id")) 
			id = atoi(e->value.buf);
		else if(!strcasecmp(e->name.buf, "reason")) 
			ret_reason = e->value.buf;
	}

	if (id == 0) {
		reason = REASON_DEF;
		set_reason(ret_reason);
		goto err;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	
	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
		
	type = trea_get_type(t);
	num = trea_get_num(t);
	if (b->type == REQ_GIVE_YES) {
		if(!(gene = game_find_gene(g, b->gene_id))){
			reason = REASON_NOT_FOUND_GENE;
			goto err;
		}

		if (type == TREA_FRIE) {
			if(gene->uid == 0 && gene->uid != r->sid) {
				int succ = 0;

				wubao_change_fri(w, gene->id, num);

				mine = wubao_get_mine_gene_num(w);

				if (mine < w->max_gene) {
					if (!lua_use_gene(w, gene->type, wubao_get_fri(w, gene->id), gene->fri, &succ)) {
						reason = REASON_AI_ERR;
						goto err;
					}

					if (succ) {
						gene->uid = w->uid;
						gene->faith = 100;
						gene_change_place(gene, GENE_PLACE_WUBAO, w->id);
						send_nf_gene_where(gene, WHERE_ALL);
						wubao_set_fri(w, gene->id, 0);
					}
				}
				
				send_nf_wubao(w, r->conn);
			}
			

			game_del_trea(g, t);
			trea_free(t);
			t = NULL;
		} 
		else if (type == TREA_FAIT) {
			gene_change_faith(gene, num);
			
			send_nf_gene_where(gene, WHERE_ALL);

			game_del_trea(g, t);
			trea_free(t);
			t = NULL;
		} 
		else {
			gene_add_trea(gene, t);
		}
	}
	else if (b->type == REQ_GIVE_NO) {
		if(!(gene = game_find_gene(g, b->gene_id))){
			reason = REASON_NOT_FOUND_GENE;
			goto err;
		}
		gene_del_trea(gene, t);
	}
	else if (b->type == REQ_GIVE_USE) {
		if (type == TREA_VIP) {
			if((u = game_find_user(g, r->sid))) {
				u->vip_total_hour += num;
				send_nf_user_where(u, WHERE_ALL);
				webapi_user(g, 0, u, ACTION_EDIT, user_retry_commit, u);
			}
		}
		else if (type == TREA_FLUSH) {
			Gene *new_gene = NULL;

			if ((new_gene = wubao_get_wild_gene(w))) {
				game_update_gene_for_wubao(g, new_gene, w);
			}
			else {
				new_gene = game_gen_new_gene(g, w);
			}

			send_nf_gene(new_gene, r->conn);
		}
		else if (type == TREA_REC) {
			Key *k;

			RB_FOREACH(k, KeyMap, &w->genes) {
				if (!(gene = game_find_gene(g, k->id))) {
					continue;
				}
				if (gene->uid == w->uid) {
					safe_add(gene->sol_num, gene->hurt_num);
					gene->hurt_num = 0;

					send_nf_gene_where(gene, WHERE_ALL);
				}
			}
		}
		else if (type == TREA_GX) {
			if (w->use_gx_trea_num >= MAX_USE_GX_TREA_NUM) {
				reason = REASON_DEF;
				set_reason("本宝物一年最多可使用 %d 次", MAX_USE_GX_TREA_NUM);
				goto err;
			}

			safe_add(w->gx, num);
			send_nf_user_where(u, WHERE_ALL);

			w->use_gx_trea_num++;
		}
		else {
			goto err;
		}
			
		game_del_trea(g, t);
		trea_free(t);
		t = NULL;
	}
	else {
		goto err;
	}

	two_arg_free(targ);

	http_param_clear(&p);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	two_arg_free(targ);
	http_param_clear(&p);
	trea_set_unused(t);
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_buy(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqBuyBody *b = NULL;
	Wubao *w = NULL;
	Trea *t = NULL;
	TwoArg *targ = NULL;
	

	b = (ReqBuyBody *)r->bs;

	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if (!(t = trea_new(b->trea_id, 0, w->uid))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	if (!(targ = two_arg_new(t, r))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	webapi_treasure(g, t, ACTION_ADD, process_req_buy_done, targ);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_buy_done(const char *buf, int len, void *arg, int code)
{
	if (!arg)
		return;
	
	Game *g = GAME;
	Req *r = NULL;
	int reason = 0;
	ReqBuyBody *b = NULL;
	Trea *t = NULL;
	TwoArg *targ = (TwoArg *) arg;
	static HttpParam p;
	HeaderEntry *e;
	const char *err_reason = NULL;
	

	t = (Trea *)targ->m_arg1;
	r = (Req *)targ->m_arg2;
	b = (ReqBuyBody *)r->bs;

	http_param_init(&p);
	
	if (!(code == HTTP_OK && buf)){
		reason = REASON_WEB_ERR;
		goto err;
	}
	
	if (!http_param_parse(&p, buf)) {
		goto err;
	}
	
	TAILQ_FOREACH(e, &p.entries, link) {
		if(!strcasecmp(e->name.buf, "id")) 
			t->id = atoi(e->value.buf);
		else if(!strcasecmp(e->name.buf, "reason")) 
			err_reason = e->value.buf;
	}

	if (t->id <= 0) {
		reason = REASON_DEF;
		set_reason(err_reason);
		goto err;
	}

	if (!game_add_trea(g, t)) {
		goto err;
	}

	send_nf_trea(t, r->conn);

	http_param_clear(&p);

	two_arg_free(targ);
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	http_param_clear(&p);
	two_arg_free(targ);
	trea_free(t);
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_fire(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqFireBody *b = NULL;
	Wubao *w = NULL;
	Gene *gene = NULL;
	City * city = NULL;
	

	b = (ReqFireBody *)r->bs;

	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if (!(gene = game_find_gene(g, b->gene_id))) {
		reason = REASON_NOT_FOUND_GENE;
		goto err;
	}

	if (!(city = game_get_random_city(g))) {
		reason = REASON_NOT_FOUND_CITY;
		goto err;
	}
	
	gene_away(gene);
	
	if (gene->type != GENE_TYPE_NAME) {
		gene_change_place(gene, 0, 0);
		game_del_gene(g, gene);
		send_nf_gene_where(gene, WHERE_ALL);
		gene_free(gene);
		gene = NULL;
	}
	else {
		gene_change_place(gene, GENE_PLACE_CITY, city->id);
		send_nf_gene_where(gene, WHERE_ALL);
	}

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}


static void process_req_create_sph(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqCreateSphBody *b = NULL;
	Wubao *w = NULL;
	int is_agree = 0;
	Sph *sph = NULL;
	User *u = NULL;
	

	b = (ReqCreateSphBody *)r->bs;
	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if (!lua_create_sph(w, &is_agree)) {
		reason = REASON_AI_ERR;
		goto err;
	}
	if (is_agree == 0) {
		reason = REASON_UNREACHED;
		goto err;
	}

	/* check name */
	if (b->name.offset <= 0) {
		goto err;
	}
	if (game_find_sph_by_name(g, b->name.buf)) {	
		reason = REASON_MULT_NAME;
		goto err;
	}

	if (!(sph = sph_new())) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}
	
	sph->id = g->max_sph_id + 1;
	sph->uid = r->sid;
	dstring_set(&sph->name, b->name.buf);
	dstring_set(&sph->desc, b->desc.buf);

	if (!game_add_sph(g, sph)) {
		sph_free(sph);
		goto err;
	}

	sph_add_wubao(sph, w);

	send_nf_sph_where(sph, WHERE_ALL);

	w->sph_id = sph->id;

	send_nf_wubao(w, r->conn);

	//send_sphere_talk_msg(sph, u, NULL, SPH_NEW);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_shan_sph(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqShanSphBody *b = NULL;
	Wubao *w = NULL;
	Wubao *recv_w = NULL;
	Sph *sph = NULL;
	User *recv_u = NULL;
	User *u = NULL;
	

	b = (ReqShanSphBody *)r->bs;
	if (!(sph = game_find_sph(g, b->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}
	if (!(recv_u = game_find_user(g, b->recv_uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	if (!(recv_w = game_find_wubao(g, recv_u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	if (recv_w->sph_id != sph->id) {
		reason = REASON_DEF;
		set_reason("对方不在本势力中");
		goto err;
	}
	
	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	if (u->id != sph->uid) {
		goto err;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	w->off_id = 0;

	send_nf_wubao(w, r->conn);

	sph->uid = recv_u->id;
	
	send_nf_sph_where(sph, WHERE_ALL);

	//send_sphere_talk_msg(sph, u, recv_u, SPH_SHAN);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_edit_sph(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqEditSphBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	

	b = (ReqEditSphBody *)r->bs;
	if (!(sph = game_find_sph(g, b->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}
	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	if (u->id != sph->uid) {
		goto err;
	}

	if(b->desc.offset <= 0) {
		goto err;
	}

	dstring_set(&sph->desc, b->desc.buf);
	
	send_nf_sph_where(sph, WHERE_ALL);
	
	//send_sphere_talk_msg(sph, u, NULL, SPH_RENAME);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_remove_sph(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqRemoveSphBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	Wubao *w = NULL;
	City *city = NULL;
	Dipl *d = NULL;
	Key *k = NULL;
	

	b = (ReqRemoveSphBody *)r->bs;
	if (!(sph = game_find_sph(g, b->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}
	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	if (u->id != sph->uid) {
		goto err;
	}

	RB_FOREACH(k, KeyMap, &sph->wubao) {
		if (!(w = game_find_wubao(g, k->id)))
			continue;
		w->off_id = 0;
		w->sph_id = 0;
		send_nf_wubao_where(w, WHERE_ME);
	}
	
	RB_FOREACH(k, KeyMap, &sph->city) {
		if (!(city = game_find_city(g, k->id)))
			continue;
		city->sph_id = 0;
		send_nf_city_where(city, WHERE_ALL);
	}

	//dipl 
	RB_FOREACH(k, KeyMap, &sph->dipl) {
		if (!(d = game_find_dipl(g, k->id))) 
			continue;
		game_del_dipl(g, d);
	}

	//send_sphere_talk_msg(sph, u, NULL, SPH_DEL);

	game_del_sph(g, sph);
	sph_free(sph);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_fire_mem(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqFireMemBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	Wubao *w = NULL;
	User *m = NULL;
	

	b = (ReqFireMemBody *)r->bs;
	if (!(sph = game_find_sph(g, b->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}
	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	if (u->id != sph->uid) {
		goto err;
	}
	if (!(m = game_find_user(g, b->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	if (!(w = sph_find_wubao(sph, m->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	sph_del_wubao(sph, w);

	w->off_id = 0;
	w->sph_id = 0;

	send_nf_wubao_where(w, WHERE_ME);

	//send_sphere_talk_msg(sph, u, m, SPH_FIRE);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_apply_join_sph(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqApplyJoinSphBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	User *target = NULL;
	Wubao *w = NULL;
	int is_agree = 0;
	Mail *m = NULL;
	

	b = (ReqApplyJoinSphBody *)r->bs;

	if (!(sph = game_find_sph(g, b->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}
	
	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	if (!lua_join_sph(sph, w, &is_agree)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (is_agree == 0) {
		reason = REASON_UNREACHED;
		goto err;
	}

	/* send mail */
	if (!(target = game_find_user(g, sph->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	if (!(u = game_find_user(g, w->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	if (!(m = mail_new(MAIL_APPLY_JOIN_SPH, u->id, u->name.buf, target->id, target->name.buf, NULL, NULL, GAME_NOW))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	webapi_mail(m, ACTION_ADD, send_mail_done, m);
	
	//send_sphere_talk_msg(sph, target, u, SPH_JOIN);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_tell_apply_join_sph(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqTellApplyJoinSphBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	Wubao *w = NULL;
	User *target = NULL;
	Wubao *target_w = NULL;
	Mail *m = NULL;
	

	b = (ReqTellApplyJoinSphBody *)r->bs;

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if (!(sph = game_find_sph(g, w->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}
	
	if (!(target = game_find_user(g, b->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	if (b->is_agree == 0) {
		/* send mail */

		if (!(m = mail_new(MAIL_NORMAL, u->id, u->name.buf, target->id, target->name.buf, MAIL_REJECT_JOIN_SPH_TITLE, NULL, GAME_NOW))) {
			reason = REASON_MEM_SHORTAGE;
			goto err;
		}

		webapi_mail(m, ACTION_ADD, send_mail_done, m);
	
		//send_sphere_talk_msg(sph, u, target, SPH_DENY_JOIN);
	} 
	else {
		if(!(target_w = game_find_wubao(g, target->wid))) {
			reason = REASON_NOT_FOUND_WUBAO;
			goto err;
		}
		if (target_w->sph_id > 0) {
			reason = REASON_USER_HAS_SPH;
			goto err;
		}
		target_w->sph_id = sph->id;
		sph_add_wubao(sph, target_w);


		send_nf_wubao_where(target_w, WHERE_ME);

		send_nf_sph_where(sph, WHERE_ALL);
		
		//send_sphere_talk_msg(sph, u, target, SPH_ALLOW_JOIN);
	}

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_away_sph(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqAwaySphBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	Wubao *w = NULL;
	User *target = NULL;
	Mail *m = NULL;
	

	b = (ReqAwaySphBody *)r->bs;

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if (!(sph = game_find_sph(g, b->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}

	if (u->id == sph->uid) {
		goto err;
	}
	
	if (!(target = game_find_user(g, sph->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}


	w->sph_id = 0;
	w->off_id = 0;
	send_nf_wubao(w, r->conn);

	send_nf_user_where(u, WHERE_ALL);

	sph_del_wubao(sph, w);

	send_nf_sph_where(sph, WHERE_ALL);

	/* send mail */
	if ((m = mail_new(MAIL_NORMAL, u->id, u->name.buf, target->id, target->name.buf, MAIL_AWAY_FROM_SPH_TITLE, NULL, GAME_NOW))) {
		webapi_mail(m, ACTION_ADD, send_mail_done, m);
	}


	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_apply_off(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqApplyOffBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	Wubao *w = NULL;
	int is_agree = 0;
	Key *k = NULL;
	Wubao *other = NULL;
	User *other_u = NULL;
	

	b = (ReqApplyOffBody *)r->bs;

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if (!(sph = game_find_sph(g, b->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}

	if (!lua_apply_official(w, b->off_id, &is_agree)) {
		reason = REASON_AI_ERR;
		goto err;
	}

	if (is_agree == 0) {
		reason = REASON_UNREACHED;
		goto err;
	}

	RB_FOREACH(k, KeyMap, &sph->wubao) {
		if (!(other = game_find_wubao(g, k->id))) {
			continue;
		}
		if (!(other_u = game_find_user(g, other->uid))) 
			continue;

		if (other->off_id == b->off_id) {
			if (w->prestige > other->prestige) {
				other->off_id = 0;
				send_nf_wubao_where(other, WHERE_ME);
				send_nf_user_where(other_u, WHERE_ALL);
			} 
			else {
				goto err;
			}
		}
	}
				
	w->off_id = b->off_id;
	send_nf_wubao_where(w, WHERE_ME);
	send_nf_user_where(u, WHERE_ALL);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_apply_league(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqApplyLeagueBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	User *target = NULL;
	Sph *target_sph = NULL;
	Mail *m = NULL;
	char buf[16];
	

	b = (ReqApplyLeagueBody *)r->bs;

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	if (!(sph = game_find_sph(g, b->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}

	if (u->id != sph->uid) {
		goto err;
	}

	if (!(target_sph = game_find_sph(g, b->target_sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}
	
	if (!(target = game_find_user(g, target_sph->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	if (sph_relation(sph, target_sph) != DIPL_NONE) {
		reason = REASON_DIPL_EXIST;
		goto err;
	}


	/* send mail */
	snprintf(buf, 15, "%d", b->year);

	if (!(m = mail_new(MAIL_APPLY_LEAGUE, u->id, u->name.buf, target->id, target->name.buf, buf, NULL, GAME_NOW))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}
	
	webapi_mail(m, ACTION_ADD, send_mail_done, m);


	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_tell_apply_league(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqTellApplyLeagueBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	Wubao *w = NULL;
	User *target = NULL;
	Sph *target_sph = NULL;
	Wubao *target_w = NULL;
	Mail *m = NULL;
	Dipl *dipl = NULL;
	int start = 0;
	int end = 0;
	TwoArg *targ = NULL;
	

	b = (ReqTellApplyLeagueBody *)r->bs;

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if (!(sph = game_find_sph(g, w->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}

	if (u->id != sph->uid) {
		goto err;
	}

	if (!(target_sph = game_find_sph(g, b->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}
	if (!(target = game_find_user(g, target_sph->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	if (!(target_w = game_find_wubao(g, target->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	if (target->id != target_sph->uid) {
		goto err;
	}
	
	if (b->is_agree == 0) {
		/* send mail */

		if ((m = mail_new(MAIL_NORMAL, u->id, u->name.buf, target->id, target->name.buf, MAIL_REJECT_LEAGUE_TITLE, NULL, GAME_NOW))) {
			webapi_mail(m, ACTION_ADD, send_mail_done, m);
		}
	}
	else {
	
		if ((dipl = sph_find_dipl(sph, target_sph->id))) {
			reason = REASON_DIPL_EXIST;
			goto err;
		}

		start = GAME_NOW;
		end = start + YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR * b->year;
		if(!(dipl = dipl_new(DIPL_LEAGUE, sph->id, target_sph->id, start, end))) {
			reason = REASON_MEM_SHORTAGE;
			goto err;
		}

		if (!(targ = two_arg_new(dipl, r))) {
			reason = REASON_MEM_SHORTAGE;
			goto err;
		}

		webapi_diplomacy(g, dipl, ACTION_ADD, process_req_tell_apply_league_done, targ);
		return;
	}


	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}


static void process_req_tell_apply_league_done(const char *buf, int len, void *arg, int code) 
{
	if (!arg)
		return;
	
	TwoArg *targ = (TwoArg *) arg;
	Req *r = NULL;
	Game *g = GAME;
	int reason = 0;
	ReqTellApplyLeagueBody *b = NULL;
	Dipl *dipl = NULL;
	

	dipl = (Dipl *) targ->m_arg1;
	r = (Req *) targ->m_arg2;
	b = (ReqTellApplyLeagueBody *)r->bs;

	if (!(code == HTTP_OK && buf && atoi(buf) > 0)) {
		reason = REASON_WEB_ERR;
		goto err;
	}

	dipl->id = atoi(buf);
	
	if (!game_add_dipl(g, dipl)) {
		dipl_free(dipl);
		goto err;
	}

	send_nf_dipl_where(dipl, WHERE_ALL);
		
	send_dipl_talk_msg(dipl);
	
	two_arg_free(targ);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	two_arg_free(targ);
	
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_ready_war(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqReadyWarBody *b = NULL;
	Sph *sph = NULL;
	User *u = NULL;
	Wubao *w = NULL;
	User *target = NULL;
	Sph *target_sph = NULL;
	Dipl *dipl = NULL;
	int start = 0;
	int end = 0;
	TwoArg *targ = NULL;
	

	b = (ReqReadyWarBody *)r->bs;

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}
	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}
	if (!(sph = game_find_sph(g, w->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}

	if (u->id != sph->uid) {
		goto err;
	}

	if (!(target_sph = game_find_sph(g, b->target_sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto err;
	}
	if (!(target = game_find_user(g, target_sph->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto err;
	}

	/*
	 * remember to uncomment.
	 *
	 */
	if (target_sph->prestige > sph->prestige && user_is_npc(target)) {
		reason = REASON_DEF;
		set_reason("您的威望只有%d, 低于对手的威望.", sph->prestige);
		goto err;
	}
		
	if ((dipl = sph_find_dipl(sph, target_sph->id))) {
		reason = REASON_DIPL_EXIST;
		goto err;
	}


	start = GAME_NOW;
	end = start + YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR * 1;
	if(!(dipl = dipl_new(DIPL_ENEMY, sph->id, target_sph->id, start, end))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	if (!(targ = two_arg_new(dipl, r))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	webapi_diplomacy(g, dipl, ACTION_ADD, process_req_ready_war_done, targ);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}


static void process_req_ready_war_done(const char *buf, int len, void *arg, int code) 
{
	if (!arg)
		return;
	
	TwoArg *targ = (TwoArg *) arg;
	Req *r = NULL;
	Game *g = GAME;
	int reason = 0;
	Dipl *dipl = NULL;
	ReqReadyWarBody *b = NULL;
	

	dipl = (Dipl *) targ->m_arg1;
	r = (Req *) targ->m_arg2;
	b = (ReqReadyWarBody *)r->bs;

	if (!(code == HTTP_OK && buf && atoi(buf) > 0)) {
		reason = REASON_WEB_ERR;
		goto err;
	}

	dipl->id = atoi(buf);
	
	if (!game_add_dipl(g, dipl)) {
		dipl_free(dipl);
		goto err;
	}


	send_nf_dipl_where(dipl, WHERE_ALL);
		
	send_dipl_talk_msg(dipl);
	
	two_arg_free(targ);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	two_arg_free(targ);
	
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_move(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	Army * army = NULL;
	ReqMoveBody *bs;
	int reason = 0;
	int speed = 0;
	Pos * to = NULL;
	Pos *from = NULL;
	float sec = 0.0 ;
	TimePos *timepos = NULL;


	bs = (ReqMoveBody *)r->bs;
	
	if (NULL == (army = game_find_army(g, bs->aid))) {
		reason = REASON_NOT_FOUND_ARMY;
		goto error;
	}

    if ((from = TAILQ_FIRST(&bs->pos))) {
        if (!(from->x == army->x && from->y == army->y)) {
            goto error;
        }
    }
	
	army_end_move(army);

	army->move_target = bs->target;
	
	army->move_target_id = bs->city_id;

	army->war_target_type = 0;

	army->war_target_id = 0;
	
	speed = army_get_speed(army);

	TAILQ_FOREACH(from, &bs->pos, link) {
		to = TAILQ_NEXT(from, link);
		if (!to) {
			break;
		}
		if (is_neighbour(from, to) == false) {
			goto error;
		}
		sec = computer_move_second(from->x, from->y, to->x, to->y, speed);
		timepos =time_pos_new(from, to, sec);
		if(!timepos) {
			goto error;
		}
		TAILQ_INSERT_TAIL(&army->move_tp, timepos, link);
		army->move_tp_num++;
	}
	
	army_continue_to_move(army);
	
	send_nf_army_where(army, WHERE_ALL);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

#define MAX_CHANGE_ZHEN_HOUR 12

static void process_req_change_zhen(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqChangeZhenBody *b;
	int reason = 0;
	Army *a = NULL;
	Gene *gene = NULL;


	b = (ReqChangeZhenBody *)r->bs;
	if (!(a = game_find_army(g, b->aid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}
	if (!(gene = game_find_gene(g, a->gene_id))) {
		reason = REASON_NOT_FOUND_GENE;
		goto error;
	}

	if(a->last_change_zhen_time > 0 && (g->time - a->last_change_zhen_time) < MAX_CHANGE_ZHEN_HOUR) {
		reason = REASON_CHANGE_ZHEN_TIME_ERR;
		goto error;
	}

	if (!gene_has_zhen(gene, b->zhen)) {
		reason = REASON_GENE_NOT_HAVE_ZHEN;
		goto error;
	}

	gene->used_zhen = b->zhen;
	a->last_change_zhen_time = g->time;

	send_nf_gene_where(gene, WHERE_ALL);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_mail(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqMailBody *b;
	int reason = 0;
	User *target = NULL;
	User *u = NULL;
	Mail *m = NULL;


	b = (ReqMailBody *)r->bs;
	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}
	if (!(target = game_find_user(g, b->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}
	
	if (!(m = mail_new(MAIL_NORMAL, u->id, u->name.buf, target->id, target->name.buf, b->title.buf, b->content.buf, GAME_NOW))) {
		reason = REASON_MEM_SHORTAGE;
		goto error;
	}

	webapi_mail(m, ACTION_ADD, send_mail_done, m);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

#define TALK_YISHITANG_LEVEL 20

static void process_req_talk(Req *r)
{
	if (!r)
		return;

	ReqTalkBody *body = (ReqTalkBody *) r->bs;
	Game *g = GAME;
	int reason = 0;
	GameConn *c = NULL;
	Talk *t = NULL;
	User *target = NULL;
	Wubao *w = NULL;

    if (!(w = game_find_wubao_by_uid(g, r->sid))) {
        reason = REASON_NOT_FOUND_WUBAO;
        goto error;
    }


	if (body->msg.offset > MAX_TALK_MSG_LEN) {
		reason = REASON_TALK_MSG_TOO_LONG;
		goto error;
	}
	if (!(t = talk_new(body->uid, body->target_uid, body->msg.buf, body->msg.offset))) {
		reason = REASON_MEM_SHORTAGE;
		goto error;
	}

	if (body->target_uid == TALK_ALL) {
        if (w->build[BUILDING_YISHITANG - 1].level < TALK_YISHITANG_LEVEL) {
            reason = REASON_DEF;
            set_reason("议事堂等级低于 %d，不能发言", TALK_YISHITANG_LEVEL);
            goto error;
        }
		
        send_nf_talk_where(t, WHERE_ALL);

	}
	else if(body->target_uid == TALK_SPH) {
		send_nf_talk_where(t, WHERE_SPH);
	}
	else  {
		if (!(target = game_find_user(g, body->target_uid))) {
			reason = REASON_NOT_FOUND_USER;
			goto error;
		}
		if ((c = cycle_find_game_conn(g_cycle, target->client_fd))) {
			send_nf_talk(t, c);
		}
	}


	if (!history_talk_push(t)) {
		talk_free(t);
		t = NULL;
	}
	
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_learn(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqLearnBody *body = (ReqLearnBody *) r->bs;
	int reason = 0;
	Gene *gene = NULL;
	int is_allow = 0;
	int need_kill = 0;
	Wubao *w = NULL;
	User *u = NULL;


	if (!(gene = game_find_gene(g, body->gene_id))) {
		reason = REASON_NOT_FOUND_GENE;
		goto error;
	}  
	
	if (!(u = game_find_user(g, gene->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	/* 
	 * check learn type 
	 */
	if (!lua_get_learn(gene, w, body->type, body->id, &is_allow, &need_kill)) {
		reason = REASON_AI_ERR;
		goto error;
	}

	if (is_allow == 0) {
		reason = REASON_UNREACHED;
		goto error;
	}

	safe_sub(w->gx, need_kill);

	send_nf_user_where(u, WHERE_ALL);

	if (body->type == LEARN_SKILL) {
		if  (body->id > SKILL_NONE && body->id < SKILL_MAX) {
			set_bit((int *)&gene->skill, body->id - 1, 1);
		}
	}  
	else if (body->type == LEARN_ZHEN) {
		if  (body->id > ZHEN_NONE && body->id < ZHEN_MAX) {
			set_bit((int *)&gene->zhen, body->id - 1, 1);
		}
	} 
	else {
		goto error;
	}

	send_nf_gene(gene, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}


static void process_req_sys_trade(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqSysTradeBody *b = (ReqSysTradeBody *) r->bs;
	int reason = 0;
	int succ = 0;
	int money = 0;
	Wubao *w = NULL;


	if (b->res <= RES_NONE || b->res >= RES_MAX) {
		reason = REASON_RES_TYPE_ERR;
		goto error;
	}

    if (b->num <= 0) {
        goto error;
    }
	
	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!lua_sys_trade(w, b->type, b->res, b->num, &succ, &money)) {
		reason = REASON_AI_ERR;
		goto error;
	}

	if (!succ) {
		reason = REASON_UNREACHED;
		goto error;
	}

	safe_add(w->res[RES_MONEY - 1], money);

	if (b->type == TRADE_BUY) {
		safe_add(w->res[b->res - 1], b->num);
	} 
	else {
		safe_sub(w->res[b->res - 1],  b->num);
	}

	send_nf_wubao(w, r->conn);


	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}


static void process_req_order(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqOrderBody *b = (ReqOrderBody *) r->bs;
	int reason = 0;
	Wubao *w = NULL;
    int gold = 0;
    int is_allow = 0;


	if (b->res <= RES_NONE || b->res >= RES_MAX) {
		reason = REASON_RES_TYPE_ERR;
		goto error;
	}
	if (!(b->type == TRADE_BUY || b->type == TRADE_SELL)) {
		reason = REASON_TRADE_TYPE_ERR;
		goto error;
	}
	
	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (w->order_num > PERSON_MAX_ORDER) {
		set_reason("您的挂单总数已经超过限额了");
		reason = REASON_DEF;
		goto error;
	}
    
    if (b->num <= 0 || b->unit_money <= 0 || b->num > 100000 || b->unit_money > 100000) {
		set_reason("非法数目");
		reason = REASON_DEF;
        goto error;
    }


    if (!lua_trade_res(w, &is_allow, &gold)) {
        reason = REASON_AI_ERR;
        goto error;
    }

    if (!is_allow) {
        reason = REASON_UNREACHED;
        goto error;
    }

    webapi_sub_gold(r->sid, gold, process_req_order_done, r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_order_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Game *g = GAME;
    Req *r = (Req *)arg;
	ReqOrderBody *b = (ReqOrderBody *) r->bs;
	int reason = 0;
	Wubao *w = NULL;
	Wubao *target_w = NULL;
	Order *o = NULL;
	Key *k, *t;
	KeyList *kl = NULL;
	Order *mo = NULL;
	int num = 0;
	int money = 0;
	int unit_money = 0;


    if (!(code == HTTP_OK && buf && atoi(buf) > 0)) {
        reason = REASON_MONEY_SHORTAGE;
        goto error;
    } 
	
    if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!(mo = order_new1(r->sid, b->type, b->res, b->num, b->unit_money, GAME_NOW))) {
		reason = REASON_MEM_SHORTAGE;
		goto error;
	}
	mo->id = g->max_order_id + 1;
	if (!game_add_order(g, mo)) {
		goto error;
	}

	if (b->type == TRADE_BUY) {
		if (w->res[RES_MONEY - 1] < b->num * b->unit_money) {
			reason = REASON_DEF;
			set_reason("钱币不足");
			goto error;
		}
		w->res[RES_MONEY - 1] -= mo->money;
		kl = &g->res_sell_orders[b->res - 1];
		TAILQ_FOREACH_REVERSE_SAFE(k, &kl->keys, KeyTailq, link, t) {
			if (!(o = game_find_order(g, k->id))) 
				continue;
			if (!(target_w = game_find_wubao_by_uid(g, o->uid)))
				continue;

			if (o->uid == mo->uid)
				continue;

			if (o->unit_money > mo->unit_money) 
				break;

			num = MIN(o->num - o->deal_num, mo->num - mo->deal_num);
			unit_money = o->unit_money;
			money = num * o->unit_money;

			o->deal_num += num;
			o->last_unit_money = unit_money;
			send_nf_order_where(o, WHERE_ALL);
			target_w->res[RES_MONEY - 1] += money;
			send_nf_wubao_where(target_w, WHERE_ME);
			if (o->deal_num >= o->num) {
				game_del_order(g, o);
				send_nf_order_where(o, WHERE_ALL);
				order_free(o);
				o = NULL;
			}

			mo->deal_num += num;
			mo->money -= money;
			mo->last_unit_money = unit_money;
			w->res[mo->res - 1] += num;
			if (mo->deal_num >= mo->num) {
				w->res[RES_MONEY - 1] += mo->money;
				break;
			}
		}
	}
	else if (b->type == TRADE_SELL) {
		if (w->res[b->res - 1] < b->num) {
			reason = REASON_RES_SHORTAGE;
			goto error;
		}
		w->res[b->res - 1] -= b->num;

		kl = &g->res_buy_orders[b->res - 1];
		TAILQ_FOREACH_SAFE(k, &kl->keys, link, t) {
			if (!(o = game_find_order(g, k->id))) 
				continue;
			if (!(target_w = game_find_wubao_by_uid(g, o->uid)))
				continue;
			if (o->uid == mo->uid)
				continue;

			if (o->unit_money < mo->unit_money) 
				break;

			num = MIN(o->num - o->deal_num, mo->num - mo->deal_num);
			unit_money = o->unit_money;
			money = num * o->unit_money;

			o->last_unit_money = unit_money;
			o->deal_num += num;
			o->money -= money;
			send_nf_order_where(o, WHERE_ALL);
			target_w->res[o->res - 1] += num;
			send_nf_wubao_where(target_w, WHERE_ME);
			if (o->deal_num >= o->num) {
				game_del_order(g, o);
				send_nf_order_where(o, WHERE_ALL);
				order_free(o);
				o = NULL;
			}

			mo->last_unit_money = unit_money;
			mo->deal_num += num;
			w->res[RES_MONEY - 1] += money;
			if (mo->deal_num >= mo->num) {
				break;
			}
		}
	}

	if (mo->deal_num >= mo->num) { 
		game_del_order(g, mo);
		order_free(mo);
		mo = NULL;
	}
	else {
		send_nf_order_where(mo, WHERE_ALL);
	}
	
	send_nf_wubao(w, r->conn);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	if (mo) {
		game_del_order(g, mo);
		order_free(mo);
	}
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_sell_order(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqSellOrderBody *b = (ReqSellOrderBody *) r->bs;
	int reason = 0;
	SellOrder *o = NULL;
	Wubao *w = NULL;
	TwoArg *targ = NULL;
    int res_id = 0;
    int is_allow = 0;


	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
    
    if (!lua_trade_weap(w, &is_allow)) {
        reason = REASON_AI_ERR;
        goto error;
    }

    if (!is_allow) {
        reason = REASON_UNREACHED;
        goto error;
    }

    if (b->gold < MIN_SELL_GOLD) {
        reason = REASON_DEF;
        set_reason("价格不得低于 %d 金币", MIN_SELL_GOLD);
        goto error;
    }

    if (b->num <= 0) {
        goto error;
    }

    if (b->weap_id < 100) {
        if (b->weap_id <= WEAP_NONE || b->weap_id >= WEAP_MAX) {
            reason = REASON_WEAP_TYPE_ERR;
            goto error;
        }
        if (b->weap_level < WEAP_LEVEL0 || b->weap_level >= WEAP_LEVEL_MAX) {
            reason = REASON_WEAP_LEVEL_ERR;
            goto error;
        }


        if (w->weap[b->weap_id - 1].num[b->weap_level] < b->num) {
            reason = REASON_UNREACHED;
            goto error;
        }
    }
    else {
        res_id = b->weap_id - 100;
        if (!(res_id > RES_NONE && res_id < RES_MAX)) {
            goto error;
        }
        if (w->res[res_id - 1] < b->num) {
            reason = REASON_UNREACHED;
            goto error;
        }
    }

	if (!(o = sell_order_new1(r->sid, b->weap_id, b->weap_level, b->num, b->gold, GAME_NOW))) {
		reason = REASON_MEM_SHORTAGE;
		goto error;
	}
	o->id = g->max_sell_order_id + 1;
	if (!game_add_sell_order(g, o)) {
		goto error;
	}

	if (!(targ = two_arg_new(o, r))) {
		reason = REASON_MEM_SHORTAGE;
		goto error;
	}

	webapi_sell_weapon(r->sid, process_req_sell_order_done, targ);
	return;
error: 
	if (o) {
		game_del_sell_order(g, o);
		sell_order_free(o);
	}
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_sell_order_done(const char *buf, int len, void *arg, int code) 
{
	if (!arg) 
		return;

	Game *g = GAME;
	Req *r = NULL;
	ReqSellOrderBody *b = NULL;
	int reason = 0;
	SellOrder *o = NULL;
	User *u = NULL;
	Wubao *w = NULL;
	HttpParam p;
	HeaderEntry *e;
	int is_succ = 0;
	const char *err_reason = NULL;
	TwoArg *targ = arg;
    int res_id = 0;

	
	http_param_init(&p);

	o = targ->m_arg1;
	r = targ->m_arg2;
	b = r->bs;

	if (!(code == HTTP_OK && buf)) {
		reason = REASON_WEB_ERR;
		goto error;
	}

	if (!http_param_parse(&p, buf)) {
		goto error;
	}

	TAILQ_FOREACH(e, &p.entries, link) {
		if(!strcasecmp(e->name.buf, "is_succ")) 
			is_succ = atoi(e->value.buf);
		else if(!strcasecmp(e->name.buf, "reason")) 
			err_reason = e->value.buf;
	}

	if (is_succ == 0) {
		reason = REASON_DEF;
		set_reason(err_reason);
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	send_nf_sell_order_where(o, WHERE_ALL);

    if (o->weap_id < 100) {
	    w->weap[b->weap_id - 1].num[b->weap_level] -= b->num;
    }
    else {
        res_id = o->weap_id - 100;
        w->res[res_id - 1] -= b->num;
    }

	send_nf_wubao(w, r->conn);

	send_sell_weap_talk(u, o);

	http_param_clear(&p);
	two_arg_free(targ);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r); 
	return;
error: 
	if (o) {
		game_del_sell_order(g, o);
		sell_order_free(o);
	}
	http_param_clear(&p);
	two_arg_free(targ);

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_buy_weap(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqBuyWeapBody *b = (ReqBuyWeapBody *) r->bs;
	int reason = 0;
	SellOrder *o = NULL;
	Wubao *w = NULL;
	int max_grid = 0;


	if (!(o = game_find_sell_order(g, b->oid))) {
		reason = REASON_NOT_FOUND_ORDER;
		goto error;
	}
	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
    if (o->weap_id < 100) {
        /* check weap id num  ? */
        if (!lua_get_grid(w, &max_grid)) {
            reason = REASON_AI_ERR;
            goto error;
        }
        if (wubao_weap_id_num(w) >= max_grid) {
            reason = REASON_DEF;
            set_reason("库房已满");
            goto error;
        }
    }

	webapi_buy_weap(o->uid, r->sid, o->gold, process_req_buy_weap_done, r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_buy_weap_done(const char *buf, int len, void *arg, int code) 
{
	if (!arg) 
		return;

	Game *g = GAME;
	Req *r = (Req *)arg;
	ReqBuyWeapBody *b = (ReqBuyWeapBody *) r->bs;
	int reason = 0;
	SellOrder *o = NULL;
	User *u = NULL;
	Wubao *w = NULL;
	HttpParam p;
	HeaderEntry *e;
	int is_succ = 0;
	const char *err_reason = NULL;
    int res_id = 0;

	
	http_param_init(&p);

	if (!(code == HTTP_OK && buf)) {
		reason = REASON_WEB_ERR;
		goto error;
	}

	if (!http_param_parse(&p, buf)) {
		goto error;
	}

	TAILQ_FOREACH(e, &p.entries, link) {
		if(!strcasecmp(e->name.buf, "is_succ")) 
			is_succ = atoi(e->value.buf);
		else if(!strcasecmp(e->name.buf, "reason")) 
			err_reason = e->value.buf;
	}

	if (is_succ == 0) {
		reason = REASON_DEF;
		set_reason(err_reason);
		goto error;
	}
	

	if (!(o = game_find_sell_order(g, b->oid))) {
		reason = REASON_NOT_FOUND_ORDER;
		goto error;
	}
	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (o->uid == r->sid) {
		reason = REASON_UNREACHED;
		goto error;
	}

    if (o->weap_id < 100) 
	    w->weap[o->weap_id - 1].num[o->weap_level] += o->weap_num;
    else {
        res_id = o->weap_id - 100;
        w->res[res_id - 1] += o->weap_num;
    }

	send_nf_wubao(w, r->conn);

	/* send mail */
	send_order_selled_mail(o, u);
	
	send_order_buyed_mail(o, u);

	game_del_sell_order(g, o);

	send_nf_sell_order_where(o, WHERE_ALL);
	
	sell_order_free(o);

	http_param_clear(&p);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r); 
	return;
error: 
	http_param_clear(&p);
	
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_cancel_order(Req *r)
{
	if (!r) 
		return;

	ReqCancelOrderBody *b = (ReqCancelOrderBody *) r->bs;
	int reason = 0;


	if (!remove_order(r->sid, b->type, b->oid)) {
		goto error;
	}
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}


static void process_req_accept_task(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqAcceptTaskBody *b = (ReqAcceptTaskBody *) r->bs;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	Task *t = NULL;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!(t = game_find_task(g, b->id))) {
		reason = REASON_NOT_FOUND_TASK;
		goto error;
	}

	if (w->task_id > 0) {
		reason = REASON_DEF;
		set_reason("您当前的任务还未完成");
		goto error;
	}

	if (wubao_find_task_fin(w, b->id)) {
		reason = REASON_DEF;
		set_reason("该任务您已经完成，不能重复接受");
		goto error;
	}

	if (t->before_id > 0 && !wubao_find_task_fin(w, t->before_id)) {
		reason = REASON_DEF;
		set_reason("前提任务未完成");
		goto error;
	}

	w->task_id = b->id;

	if (task_is_fin(w)) {
		w->task_is_fin = 1;
	}

	send_nf_user_where(u, WHERE_ALL);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_cancel_task(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}


	w->task_id = 0;
	w->task_is_fin = 0;

	send_nf_user_where(u, WHERE_ALL);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_check_task(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!task_is_fin(w)) {
		goto error;
	}

	w->task_is_fin = 1;

	send_nf_user_where(u, WHERE_ALL);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_get_prize(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	Task *t = NULL;
	Trea *tr = NULL;
	TwoArg *targ = NULL;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}
	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
	if (!(t = game_find_task(g, w->task_id))) {
		reason = REASON_NOT_FOUND_TASK;
		goto error;
	}

	if (!task_is_fin(w)) {
		reason = REASON_DEF;
		set_reason("您的任务未完成");
		goto error;
	}

	if (t->gold > 0) {
		if (!(targ = two_arg_new(NULL, r))) {
			reason = REASON_MEM_SHORTAGE;
			goto error;
		}

		webapi_add_gold(r->sid, t->gold, process_req_get_prize_done, targ);
		return;
	} 
	else if (t->trea[0] > 0) {
		if (!(tr = trea_new(t->trea[0], 0, r->sid))) {
			reason = REASON_MEM_SHORTAGE;
			goto error;
		}
		if (!(targ = two_arg_new(tr, r))) {
			reason = REASON_MEM_SHORTAGE;
			goto error;
		}

		webapi_donate_trea(tr, process_req_get_prize_done, targ);
		return;
	}

	task_fin(w);

	send_nf_user_where(u, WHERE_ALL);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	two_arg_free(targ);

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_get_prize_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Game *g = GAME;
	Req *r = NULL;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	Trea *tr = NULL;
	TwoArg *targ = arg;


	tr = targ->m_arg1;
	r = targ->m_arg2;

	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_WEB_ERR;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (tr) {
		tr->id = atoi(buf);
		if (!game_add_trea(g, tr)) {
			goto error;
		}
		send_nf_trea(tr, r->conn);
	}
	
	task_fin(w);

	send_nf_user_where(u, WHERE_ALL);
	
	two_arg_free(targ);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	two_arg_free(targ);
	
	if (tr) {
		trea_free(tr);
	}

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_box(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqBoxBody *b = r->bs;
	int reason = 0;
	Wubao *w = NULL;
	Gene *gene = NULL;
	int i = 0;
	Guanka *gk = NULL;

	
	if (!(gk = game_find_guanka(g, b->level))) {
		reason = REASON_NOT_FOUND_GUANKA;
		goto error;
	}

	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
	if (w->war_sleep_end_time > GAME_NOW) {
		reason = REASON_DEF;
		set_reason("您还需要等待 %d 时辰，才能开始下一场", w->war_sleep_end_time - GAME_NOW);
		goto error;
	}

	if (w->jl <= 0) {
		reason = REASON_JL_SHORTAGE;
		goto error;
	}

	if (w->box_level >= gk->id && gk->used >= gk->total && gk->total != -1) {
		reason = REASON_DEF;
		set_reason("该关卡已经被人打了 %d 次，已关闭.", gk->used);
		goto error;
	}

	if (b->level - w->box_level > 1) {
		reason = REASON_DEF;
		set_reason("请先打败前面的BOSS，您当前还在第 %d 关，不能挑战第 %d 关", w->box_level, b->level);
		goto error;
	}
	

	for (i = 0; i < b->gene_num; i++) {
		if (!(gene = game_find_gene(g, b->gene_id[i]))) {
			reason = REASON_NOT_FOUND_GENE;
			goto error;
		}

		if (!(gene->place == GENE_PLACE_CITY || gene->place == GENE_PLACE_WUBAO)) {
			reason = REASON_DEF;
			set_reason("%s%s 不在城里或是坞堡中", gene->first_name.buf, gene->last_name.buf);
			goto error;
		}

		if (gene->sol_num <= 0) {
			reason = REASON_DEF;
			set_reason("%s%s 没有健卒了", gene->first_name.buf, gene->last_name.buf);
			goto error;
		}
	}
	


	process_req_box_done("1", 1, r, HTTP_OK);
	
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_box_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Req *r = arg;
	Game *g = GAME;
	ReqBoxBody *b = r->bs;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	Box *box = NULL;
	Gene *gene = NULL;
	War *war = NULL;
	WarGene *war_gene = NULL;
	int i = 0;
	int j = 0;
	int id = 1;
	int sleep_hour = 0;
	Guanka *gk = NULL;
	int is_yes = 0;


	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_MONEY_SHORTAGE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!(gk = game_find_guanka(g, b->level))) {
		reason = REASON_NOT_FOUND_GUANKA;
		goto error;
	}

	sleep_hour = gk->cd;

	if (!(war = war_new())) {
		reason = REASON_MEM_SHORTAGE;
		goto error;
	}

	war->guan_id = b->level;

	dstring_append(&war->name, dstring_buf(&u->name), dstring_offset(&u->name));
	
	dstring_printf(&war->target_name, "npc");
	
	for (i = 0; i < b->gene_num; i++) {
		if (!(gene = game_find_gene(g, b->gene_id[i]))) {
			reason = REASON_NOT_FOUND_GENE;
			goto error;
		}

		if (!(war_gene = war_gene_new())) {
			reason = REASON_MEM_SHORTAGE;
			goto error;
		}

		dstring_set(&war_gene->name, gene_get_full_name(gene)); 
		war_gene->id = id++;
		war_gene->gene_id = gene->id;
		war_gene->kongfu = gene_get_kongfu(gene);
		war_gene->intel = gene_get_intel(gene);
		war_gene->polity = gene_get_polity(gene);
        war_gene->speed = gene_get_speed(gene);
		war_gene->zhen = gene->used_zhen;
		war_gene->skill = gene->skill;
		war_gene->old_train = gene->level;
		war_gene->train = gene->level;
		war_gene->old_spirit = gene->sol_spirit;
		war_gene->spirit = gene->sol_spirit;
		war_gene->sol = gene->sol_num;
		war_gene->old_sol = gene->sol_num;
		war_gene->hurt = gene->hurt_num;
		war_gene->uid = gene->uid;
		for(j = 0; j < GENE_WEAP_NUM; j++) {
			war_gene->weap[j].id = gene->weap[j].id;
			war_gene->weap[j].level = gene->weap[j].level;
		}

		TAILQ_INSERT_TAIL(&war->genes, war_gene, link);
		war->gene_num++;
	}
		
	RB_FOREACH(box, GameBoxMap, &g->boxes) {

		if (box->level != b->level)
			continue;

		if (!(war_gene = war_gene_new())) {
			reason = REASON_MEM_SHORTAGE;
			goto error;
		}

		dstring_set(&war_gene->name, dstring_buf(&box->name));
		war_gene->id = id++;
		war_gene->gene_id = 0;
		war_gene->kongfu = box->kongfu;
		war_gene->intel = box->intel;
		war_gene->polity = box->polity;
        war_gene->speed = gene_get_speed(gene);
		war_gene->zhen = box->zhen;
		war_gene->skill = box->skill;
		war_gene->old_train = box->train;
		war_gene->train = box->train;
		war_gene->old_spirit = box->spirit;
		war_gene->spirit = box->spirit;
		war_gene->old_sol = box->sol;
		war_gene->sol = box->sol;
		war_gene->hurt = 0;
		war_gene->uid = 0;
		for(j = 0; j < GENE_WEAP_NUM; j++) {
			war_gene->weap[j].id = box->weap[j].id;
			war_gene->weap[j].level = box->weap[j].level;
		}


		TAILQ_INSERT_TAIL(&war->target_genes, war_gene, link);
		war->target_gene_num++;
	}


	/* fight */
	do_war(war);
	
	if (gk->total > 0 && gk->id <= w->box_level) {
		gk->used++;
		send_nf_guanka_where(gk, WHERE_ALL);
	}

	if (war->is_win) {
		war->gx = gk->gx;

        if (gk->weap_id > 0 && w->box_level < b->level) {
            send_pass_gk_talk(gk, u);
        }

		if (lua_lost_weap(w, gk->percent, &is_yes) && is_yes) {
			/* prize */
			if(gk->weap_id > WEAP_NONE && gk->weap_id < WEAP_MAX) {
				if (gk->weap_level >= WEAP_LEVEL0 && gk->weap_level < WEAP_LEVEL_MAX) {
					safe_add(w->weap[gk->weap_id - 1].num[gk->weap_level], gk->weap_num);
					war->weap_id = gk->weap_id;
					war->weap_level = gk->weap_level;
					war->weap_num = gk->weap_num;
				}
			}
		}
		w->box_level = MAX(b->level, w->box_level);
		w->gx += gk->gx;
	}
		
	w->war_sleep_end_time = GAME_NOW + sleep_hour;

	safe_sub(w->jl, 1);


	TAILQ_FOREACH(war_gene, &war->genes, link) {
		if ((gene = game_find_gene(g, war_gene->gene_id))) {
			gene->sol_num = war_gene->sol;
			gene->hurt_num = war_gene->hurt;
			gene->sol_spirit = war_gene->spirit;
			if (gene->sol_spirit < DEF_SOL_SPIRIT) {
				gene->sol_spirit = DEF_SOL_SPIRIT;
			}
			else if (gene->sol_spirit > MAX_SOL_SPIRIT) {
				gene->sol_spirit = MAX_SOL_SPIRIT;
			}

			send_nf_gene_where(gene, WHERE_ALL);
		}
	}
	
	send_nf_fight(war, r->conn);

	send_nf_wubao(w, r->conn);

	send_nf_user_where(u, WHERE_ALL);

	war_free(war);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	war_free(war);

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_welfare(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	Wubao *w = NULL;
	int reason = 0;
	int res [RES_MAX - 1] = {0};
	int i = 0;
	int is_allow = 0;
	int gold = 0;


	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (w->sph_id <= 0) {
		reason = REASON_DEF;
		set_reason("您必须加入势力，才有资格领取福利");
		goto error;
	}

	if (!lua_get_welfare(w, &is_allow, res, &gold)) {
		reason = REASON_AI_ERR;
		goto error;
	}

	for (i = 0; i < RES_MAX - 1; i ++) {
		w->res[i] += res[i];
	}

	if (is_allow == 0) {
		reason = REASON_DEF;
		set_reason("每年只可以领取一次");
		goto error;
	}

	w->last_welfare_time = GAME_NOW;

	if (gold > 0) 
		webapi_add_gold(r->sid, gold, NULL, NULL);
	
	send_nf_welfare(res, gold, r->conn);

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_plunder(Req *r)
{
	if (!r) 
		return;
	
	Game *g = GAME;
	User *u = NULL;
	Wubao *w = NULL;
	User *u1 = NULL;
	Wubao *w1 = NULL;
	Gene *gene = NULL;
	War *war = NULL;
	WarGene *war_gene = NULL;
	int i = 0;
	int j = 0;
	Key *k;
	int res[RES_MAX - 1] = {0}; 
	Mail *m = NULL;
	static dstring title = DSTRING_INITIAL;
	static dstring cnt = DSTRING_INITIAL;
	int id = 1;
	int cd = 0;
	ReqPlunderBody *b = r->bs;
	int left_sol = 0;
	int reason = 0;


	if (!(u = game_find_user(g, r->sid))) {
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		goto error;
	}
	
	if (!(u1 = game_find_user(g, b->to_uid))) {
		goto error;
	}

	if (!(w1 = game_find_wubao(g, u1->wid))) {
		goto error;
	}
	
	if (w->sph_id == w1->sph_id && w->sph_id > 0) {
		reason = REASON_DEF;
		set_reason("不能掠夺同势力的兄弟");
		goto error;
	}

	if (w->war_sleep_end_time > GAME_NOW) {
		reason = REASON_DEF;
		set_reason("还有 %d 时辰才开始掠夺", w->war_sleep_end_time - GAME_NOW);
		goto error;
	}
	
	if (w->jl <= 0) {
		reason = REASON_JL_SHORTAGE;
		goto error;
	}


	if (!(war = war_new())) {
		goto error;
	}
		
	
    dstring_append(&war->name, dstring_buf(&u->name), dstring_offset(&u->name));
	
	dstring_append(&war->target_name, dstring_buf(&u1->name), dstring_offset(&u1->name));
	
	RB_FOREACH(k, KeyMap, &w->genes) {
		if (!(gene = game_find_gene(g, k->id))) {
			reason = REASON_NOT_FOUND_GENE;
			goto error;
		}

		if (gene->uid != u->id || gene->sol_num <= 0) 
			continue;

		if (!(war_gene = war_gene_new())) {
			reason = REASON_MEM_SHORTAGE;
			goto error;
		}
    
        dstring_set(&war_gene->name, gene_get_full_name(gene)); 
		war_gene->id = id++;
		war_gene->gene_id = gene->id;
		war_gene->kongfu = gene_get_kongfu(gene);
		war_gene->intel = gene_get_intel(gene);
		war_gene->polity = gene_get_polity(gene);
        war_gene->speed = gene_get_speed(gene);
		war_gene->zhen = gene->used_zhen;
		war_gene->skill = gene->skill;
		war_gene->old_train = gene->level;
		war_gene->train = gene->level;
		war_gene->old_spirit = gene->sol_spirit;
		war_gene->spirit = gene->sol_spirit;
		war_gene->sol = gene->sol_num;
		war_gene->old_sol = gene->sol_num;
		war_gene->hurt = gene->hurt_num;
		war_gene->uid = gene->uid;
		for(j = 0; j < GENE_WEAP_NUM; j++) {
			war_gene->weap[j].id = gene->weap[j].id;
			war_gene->weap[j].level = gene->weap[j].level;
		}

		TAILQ_INSERT_TAIL(&war->genes, war_gene, link);
		war->gene_num++;
	}
	
	RB_FOREACH(k, KeyMap, &w1->genes) {
		if (!(gene = game_find_gene(g, k->id))) {
			reason = REASON_NOT_FOUND_GENE;
			goto error;
		}

		if (gene->uid != u1->id || gene->sol_num <= 0) 
			continue;

		if (!(war_gene = war_gene_new())) {
			reason = REASON_MEM_SHORTAGE;
			goto error;
		}

        dstring_set(&war_gene->name, gene_get_full_name(gene)); 
		war_gene->id = id++;
		war_gene->gene_id = gene->id;
		war_gene->kongfu = gene_get_kongfu(gene);
		war_gene->intel = gene_get_intel(gene);
		war_gene->polity = gene_get_polity(gene);
        war_gene->speed = gene_get_speed(gene);
		war_gene->zhen = gene->used_zhen;
		war_gene->skill = gene->skill;
		war_gene->old_train = gene->level;
		war_gene->train = gene->level;
		war_gene->old_spirit = gene->sol_spirit;
		war_gene->spirit = gene->sol_spirit;
		war_gene->sol = gene->sol_num;
		war_gene->old_sol = gene->sol_num;
		war_gene->hurt = gene->hurt_num;
		war_gene->uid = gene->uid;
		for(j = 0; j < GENE_WEAP_NUM; j++) {
			war_gene->weap[j].id = gene->weap[j].id;
			war_gene->weap[j].level = gene->weap[j].level;
		}

		TAILQ_INSERT_TAIL(&war->target_genes, war_gene, link);
		war->target_gene_num++;
	}


	/* fight */
	do_war(war);
	
	TAILQ_FOREACH(war_gene, &war->genes, link) {
		if ((gene = game_find_gene(g, war_gene->gene_id))) {
			gene->sol_num = war_gene->sol;
			gene->hurt_num = war_gene->hurt;
			gene->sol_spirit = war_gene->spirit;
			if (gene->sol_spirit < DEF_SOL_SPIRIT) {
				gene->sol_spirit = DEF_SOL_SPIRIT;
			}
			else if (gene->sol_spirit > MAX_SOL_SPIRIT) {
				gene->sol_spirit = MAX_SOL_SPIRIT;
			}

			send_nf_gene_where(gene, WHERE_ALL);

			left_sol += gene->sol_num;
		}
	}
	
	TAILQ_FOREACH(war_gene, &war->target_genes, link) {
		if ((gene = game_find_gene(g, war_gene->gene_id))) {
			gene->sol_num = war_gene->sol;
			gene->hurt_num = war_gene->hurt;
			gene->sol_spirit = war_gene->spirit;

			send_nf_gene_where(gene, WHERE_ALL);
		}
	}
		
	if (!lua_get_plunder(w1, b->res, left_sol, res, &cd))
		goto error;

	if (war->is_win) {
		for(i = 0; i < RES_MAX - 1; i++) {
			safe_add(w->res[i], res[i]);
			safe_sub(w1->res[i], res[i]);
		}
	}
	
	send_nf_wubao_where(w, WHERE_ME);

	send_nf_wubao_where(w1, WHERE_ME);
		
	/* send mail */
	dstring_printf(&title, "掠夺【%s】归来", dstring_buf(&u1->name));

	dstring_printf(&cnt, "<FONT FACE='新宋体' SIZE='12' COLOR='#FFFFFF'>【掠夺资源】</FONT>\n");
	if(war->is_win) {
		for(i = 0; i < RES_MAX - 1; i++) {
			if (res[i] <= 0) 
				continue;

			dstring_append_printf(&cnt, "\t<FONT FACE='新宋体' SIZE='12' COLOR='#C8D8A9'>%s</FONT>"
					"：<FONT FACE='新宋体' SIZE='15' COLOR='#00FF00'>%d</FONT>\n", res_name(i+1), res[i]);
		}
	}
	else {
		dstring_append_printf(&cnt, "\t掠夺失败\n\n");
	}

	dstring_append_printf(&cnt, "\t%s 死亡 %d, %s 死亡 %d\n", dstring_buf(&u->name), war->dead, \
			dstring_buf(&u1->name), war->dead1);



	/* notify from */
	if ((m = mail_new(MAIL_SYS, MAIL_SYS_ID, MAIL_SYS_NAME, u->id, \
					dstring_buf(&u->name), title.buf, cnt.buf, GAME_NOW))) {
		webapi_mail(m, ACTION_ADD, send_mail_done, m);
		m = NULL;
	}

	/* notify to */
	dstring_printf(&title, "【%s】对您的坞堡展开了掠夺", dstring_buf(&u->name));

	if ((m = mail_new(MAIL_SYS, MAIL_SYS_ID, MAIL_SYS_NAME, u1->id, dstring_buf(&u1->name), title.buf, cnt.buf, GAME_NOW))) {
		webapi_mail(m, ACTION_ADD, send_mail_done, m);
		m = NULL;
	}


	w1->been_plunder_num++;

	w->war_sleep_end_time = GAME_NOW + cd;

	safe_sub(w->jl, 1);

	send_nf_user_where(u1, WHERE_ALL);
	
	send_nf_user_where(u, WHERE_ALL);

	send_nf_fight(war, r->conn);

	war_free(war);
	
	req_send_resp(r, RESP_OK, NULL); 
	worker_process_request_finish(r); 
	return;
error: 
	war_free(war);
	
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_train(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	Gene *gene = NULL;
	Wubao *w = NULL;
	ReqTrainBody *b = r->bs;
	int reason = 0;
	int gold = 0;
	int cd = 0;


	if (!(gene = game_find_gene(g, b->gene_id))) {
		reason = REASON_NOT_FOUND_GENE;
		goto error;
	}

	if (!(w = game_find_wubao_by_uid(g, gene->uid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (w->train_sleep_end_time > GAME_NOW) {
		reason = REASON_DEF;
		set_reason("还需要 %d 时辰才能训练", w->train_sleep_end_time - GAME_NOW);
		goto error;
	}

	if (gene->uid != r->sid) {
		reason = REASON_DEF;
		set_reason("该武将不属于您");
		goto error;
	}

	if (gene->place == GENE_PLACE_ARMY) {
		reason = REASON_DEF;
		set_reason("武将在军团中");
		goto error;
	}
	
	if (!lua_get_train_info(w, gene, b->is_double, NULL, NULL, &gold, &cd)) {
		reason = REASON_AI_ERR;
		goto error;
	}

	if (gold > 0) {
		webapi_sub_gold(r->sid, gold, process_req_train_done, r);
	}
	else {
		process_req_train_done("1", 1, r, HTTP_OK);
	}

	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_train_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Game *g = GAME;
	Gene *gene = NULL;
	Wubao *w = NULL;
	User *u = NULL;
	Req *r = arg;
	ReqTrainBody *b = r->bs;
	int reason = 0;
	int gold = 0;
	int cd = 0;


	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_DEF;
		set_reason("金币不足");
		goto error;
	}

	if (!(gene = game_find_gene(g, b->gene_id))) {
		reason = REASON_NOT_FOUND_GENE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
	
	if (!lua_get_train_info(w, gene, b->is_double, &gene->level_percent, &gene->level, &gold, &cd)) {
		reason = REASON_AI_ERR;
		goto error;
	}

	w->train_sleep_end_time = GAME_NOW + cd;

	send_nf_gene_where(gene, WHERE_ALL);	

	send_nf_user_where(u, WHERE_ALL);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_move_city(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	Wubao *w = NULL;
	Wubao *idle_w = NULL;
	City *city = NULL;
	ReqMoveCityBody *b = r->bs;
	int gold = 0;
	int reason = 0;


	if (!(city = game_find_city(g, b->city_id))) {
		reason = REASON_NOT_FOUND_CITY;
		goto error;
	}

	if (!(w = game_find_wubao_by_uid(g, r->sid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!(idle_w = city_get_idle_wubao(city))) {
		reason = REASON_NOT_FOUND_IDLE_WUBAO;
		goto error;
	}

	if (!lua_move_city(&gold)) {
		reason = REASON_AI_ERR;
		goto error;
	}

	webapi_sub_gold(r->sid, gold, process_req_move_city_done, r);

	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_move_city_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Game *g = GAME;
	Req *r = arg;
	ReqMoveCityBody *b = r->bs;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	Wubao *idle_w = NULL;
	City *city = NULL;
	City *old_city = NULL;


	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_MONEY_SHORTAGE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!(old_city = game_find_city(g, w->city_id))) {
		reason = REASON_NOT_FOUND_CITY;
		goto error;
	}
	
	if (!(city = game_find_city(g, b->city_id))) {
		reason = REASON_NOT_FOUND_CITY;
		goto error;
	}
	
	if (!(idle_w = city_get_idle_wubao(city))) {
		reason = REASON_NOT_FOUND_IDLE_WUBAO;
		goto error;
	}

	old_city->idle_wubao_num ++;
	send_nf_city_where(old_city, WHERE_ALL);

	city->idle_wubao_num--;
	send_nf_city_where(city, WHERE_ALL);
	
	w->city_id = city->id;
	send_nf_wubao_where(w, WHERE_ME);

	send_nf_user_where(u, WHERE_ALL);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r); 
}

static void process_req_pk(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	ReqPkBody *b = r->bs;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	User *u1 = NULL;
	Wubao *w1 = NULL;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
	
	if (!(u1 = game_find_user(g, b->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w1 = game_find_wubao(g, u1->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
	
	if (w->rank <= 0) {
		if (MAX_RANK - w1->rank > PK_PRE) {
			reason = REASON_DEF;
			set_reason("请先打败最后的 %d 名玩家，谢谢", PK_PRE);
			goto error;
		}
	}
	else if (w->rank - w1->rank > PK_PRE) {
		reason = REASON_DEF;
		set_reason("您们之间的差距不要超过 %d 哦，谢谢", PK_PRE);
		goto error;
	}
	else if (w->rank < w1->rank) {
		reason = REASON_DEF;
		set_reason("不能挑战比你排名低的玩家");
		goto error;
	}

	if (w->war_sleep_end_time > GAME_NOW) {
		reason = REASON_DEF;
		set_reason("还需要等待 %d 时辰，才能挑战", w->war_sleep_end_time - GAME_NOW);
		goto error;
	}
	if (w->jl <= 0) {
		reason = REASON_JL_SHORTAGE;
		goto error;
	}

	process_req_pk_done("1", 1, r, HTTP_OK);
	return;
error: 

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_pk_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Req *r = arg;
	Game *g = GAME;
	ReqPkBody *b = r->bs;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	User *u1 = NULL;
	Wubao *w1 = NULL;
	Gene *gene = NULL;
	War *war = NULL;
	WarGene *war_gene = NULL;
	int j = 0;
	Key *k;
	int id = 1;
	int cd = 0;

	
	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_MONEY_SHORTAGE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
	
	if (!(u1 = game_find_user(g, b->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w1 = game_find_wubao(g, u1->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}


	if (!(war = war_new())) {
		reason = REASON_MEM_SHORTAGE;
		goto error;
	}

	dstring_append(&war->name, dstring_buf(&u->name), dstring_offset(&u->name));
	
	dstring_append(&war->target_name, dstring_buf(&u1->name), dstring_offset(&u1->name));
	
	RB_FOREACH(k, KeyMap, &w->genes) {
		if (!(gene = game_find_gene(g, k->id))) {
			reason = REASON_NOT_FOUND_GENE;
			goto error;
		}

		if (gene->uid != u->id || gene->sol_num <= 0) 
			continue;

		if (!(war_gene = war_gene_new())) {
			reason = REASON_MEM_SHORTAGE;
			goto error;
		}

        dstring_set(&war_gene->name, gene_get_full_name(gene));
		war_gene->id = id++;
		war_gene->gene_id = gene->id;
		war_gene->kongfu = gene_get_kongfu(gene);
		war_gene->intel = gene_get_intel(gene);
		war_gene->polity = gene_get_polity(gene);
        war_gene->speed = gene_get_speed(gene);
		war_gene->zhen = gene->used_zhen;
		war_gene->skill = gene->skill;
		war_gene->old_train = gene->level;
		war_gene->train = gene->level;
		war_gene->old_spirit = gene->sol_spirit;
		war_gene->spirit = gene->sol_spirit;
		war_gene->sol = gene->sol_num;
		war_gene->old_sol = gene->sol_num;
		war_gene->hurt = gene->hurt_num;
		war_gene->uid = gene->uid;
		for(j = 0; j < GENE_WEAP_NUM; j++) {
			war_gene->weap[j].id = gene->weap[j].id;
			war_gene->weap[j].level = gene->weap[j].level;
		}

		TAILQ_INSERT_TAIL(&war->genes, war_gene, link);
		war->gene_num++;
	}
	
	RB_FOREACH(k, KeyMap, &w1->genes) {
		if (!(gene = game_find_gene(g, k->id))) {
			reason = REASON_NOT_FOUND_GENE;
			goto error;
		}

		if (gene->uid != u1->id || gene->sol_num <= 0) 
			continue;

		if (!(war_gene = war_gene_new())) {
			reason = REASON_MEM_SHORTAGE;
			goto error;
		}

        dstring_set(&war_gene->name, gene_get_full_name(gene));
		war_gene->id = id++;
		war_gene->gene_id = gene->id;
		war_gene->kongfu = gene_get_kongfu(gene);
		war_gene->intel = gene_get_intel(gene);
		war_gene->polity = gene_get_polity(gene);
        war_gene->speed = gene_get_speed(gene);
		war_gene->zhen = gene->used_zhen;
		war_gene->skill = gene->skill;
		war_gene->old_train = gene->level;
		war_gene->train = gene->level;
		war_gene->old_spirit = gene->sol_spirit;
		war_gene->spirit = gene->sol_spirit;
		war_gene->sol = gene->sol_num;
		war_gene->old_sol = gene->sol_num;
		war_gene->hurt = gene->hurt_num;
		war_gene->uid = gene->uid;
		for(j = 0; j < GENE_WEAP_NUM; j++) {
			war_gene->weap[j].id = gene->weap[j].id;
			war_gene->weap[j].level = gene->weap[j].level;
		}

		TAILQ_INSERT_TAIL(&war->target_genes, war_gene, link);
		war->target_gene_num++;
	}
		

	/* fight */
	do_war(war);

	send_nf_fight(war, r->conn);

	if (war->is_win) {
		game_trans_rank(g, w, w1);
	}

	lua_get_pk_info(&cd);

	w->war_sleep_end_time = GAME_NOW + cd;

	safe_sub(w->jl, 1);

	send_nf_user_where(u, WHERE_ALL);
	
	send_nf_user_where(u1, WHERE_ALL);

	war_free(war);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	war_free(war);

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}


static void process_req_add_made(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	int num = 0;
	int gold = 0;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!lua_add_made(&num, &gold)) {
		reason = REASON_AI_ERR;
		goto error;
	}	

	webapi_sub_gold(r->sid, gold, process_req_add_made_done, r);
	return;
error: 

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_add_made_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Req *r = arg;
	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	int num = 0;
	int gold = 0;

	
	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_MONEY_SHORTAGE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!lua_add_made(&num, &gold)) {
		reason = REASON_AI_ERR;
		goto error;
	}

	safe_sub(w->used_made, num);	

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_add_sol(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	int num = 0;
	int gold = 0;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!lua_add_sol(&num, &gold)) {
		reason = REASON_AI_ERR;
		goto error;
	}	

	webapi_sub_gold(r->sid, gold, process_req_add_sol_done, r);
	return;
error: 

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_add_sol_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Req *r = arg;
	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	int num = 0;
	int gold = 0;

	
	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_MONEY_SHORTAGE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!lua_add_sol(&num, &gold)) {
		reason = REASON_AI_ERR;
		goto error;
	}

	safe_add(w->sol, num);	

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_speed_train(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	int gold = 0;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!lua_get_speed_gold(w->train_sleep_end_time - GAME_NOW, &gold)) {
		reason = REASON_AI_ERR;
		goto error;
	}	

	webapi_sub_gold(r->sid, gold, process_req_speed_train_done, r);
	return;
error: 

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_speed_train_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Req *r = arg;
	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;

	
	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_MONEY_SHORTAGE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	w->train_sleep_end_time = 0;

	send_nf_user(u, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_speed_junlin(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	int gold = 0;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!lua_get_war_speed_gold(w->war_sleep_end_time - GAME_NOW, &gold)) {
		reason = REASON_AI_ERR;
		goto error;
	}	

	webapi_sub_gold(r->sid, gold, process_req_speed_junlin_done, r);
	return;
error: 

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_speed_junlin_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Req *r = arg;
	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;

	
	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_MONEY_SHORTAGE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	w->war_sleep_end_time = 0;

	send_nf_user(u, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_buy_junlin(Req *r)
{
	if (!r) 
		return;

	int reason = 0;
	int gold = 0;
	int num = 0;


	if (!lua_get_jl_info(&gold, &num)) {
		reason = REASON_AI_ERR;
		goto error;
	}	

	webapi_sub_gold(r->sid, gold, process_req_buy_junlin_done, r);
	return;
error: 

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_buy_junlin_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Req *r = arg;
	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	int gold = 0;
	int num = 0;



	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_MONEY_SHORTAGE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
	
	if (!lua_get_jl_info(&gold, &num)) {
		reason = REASON_AI_ERR;
		goto error;
	}	

	w->jl += num;

	send_nf_user(u, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_apply_sph_boss(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;
	User *old_u = NULL;
	Wubao *old_w = NULL;
	Sph *sph = NULL;
	int is_allow = 0;



	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	if (!(sph = game_find_sph(g, w->sph_id))) {
		reason = REASON_NOT_FOUND_SPHERE;
		goto error;
	}
	
	if (!(old_u = game_find_user(g, sph->uid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(old_w = game_find_wubao(g, old_u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	
	if (!lua_become_boss(old_w, w, &is_allow)) {
		reason = REASON_AI_ERR;
		goto error;
	}	

	if (!is_allow) {
		reason = REASON_UNREACHED;
		goto error;
	}

	sph->uid = w->uid;

	send_nf_sph_where(sph, WHERE_ALL);

	old_w->sph_id = 0;

	send_nf_wubao_where(old_w, WHERE_ME);

	send_nf_user_where(u, WHERE_ALL);
	
	send_nf_user_where(old_u, WHERE_ALL);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_up_kufang(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	int reason = 0;
	int gold = 0;
	int is_allow = 0;
	User *u = NULL;
	Wubao *w = NULL;



	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}


	if (!lua_level_up_kufang(w, &gold, &is_allow)) {
		reason = REASON_AI_ERR;
		goto error;
	}	

	if (is_allow == 0) {
		reason = REASON_UNREACHED;
		goto error;
	}

	webapi_sub_gold(r->sid, gold, process_req_up_kufang_done, r);
	return;
error: 

	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_up_kufang_done(const char *buf, int len, void *arg, int code)
{
	if (!arg) 
		return;

	Req *r = arg;
	Game *g = GAME;
	int reason = 0;
	User *u = NULL;
	Wubao *w = NULL;


	if (!(buf && atoi(buf) > 0 && code == HTTP_OK)) {
		reason = REASON_MONEY_SHORTAGE;
		goto error;
	}

	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}
	
	w->build[BUILDING_KUFANG - 1].level++;

	send_nf_wubao(w, r->conn);
	
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_set_fresh_step(Req *r)
{
	if (!r) 
		return;

	Game *g = GAME;
	User *u = NULL;
	Wubao *w = NULL;
	int reason = 0;
	ReqSetFreshStepBody *b = r->bs;


	if (!(u = game_find_user(g, r->sid))) {
		reason = REASON_NOT_FOUND_USER;
		goto error;
	}

	if (!(w = game_find_wubao(g, u->wid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto error;
	}

	w->fresh_step = b->step;

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error: 
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}


static void process_req_pool(Req *r)
{
	if (!r)
		return;

	static dstring dst = DSTRING_INITIAL;

	dstring_clear(&dst);
	dstring_set_big_endian(&dst);

	cache_pool_dump(&dst);
		
	req_send_resp1(r, RESP_OK, dst.buf, dst.offset);
	worker_process_request_finish(r);
}


static void process_req_donate_trea(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqDonateTreaBody *b = r->bs;
	Wubao *w = NULL;
	Trea *t = NULL;
	TwoArg *targ = NULL;
	

	if (r->sid != -1)
		goto err;

	if (!(w = game_find_wubao_by_uid(g, b->uid))) {
		reason = REASON_NOT_FOUND_WUBAO;
		goto err;
	}

	if (!(t = trea_new(b->trea_id, 0, w->uid))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	if (!(targ = two_arg_new(t, r))) {
		reason = REASON_MEM_SHORTAGE;
		goto err;
	}

	webapi_donate_trea(t, process_req_donate_trea_done, targ);
	return;
err:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_donate_trea_done(const char *buf, int len, void *arg, int code)
{
	if (!arg)
		return;
	
	Game *g = GAME;
	Req *r = NULL;
	int reason = 0;
	ReqDonateTreaBody *b = NULL;
	Trea *t = NULL;
	TwoArg *targ = (TwoArg *) arg;
	

	t = (Trea *)targ->m_arg1;
	r = (Req *)targ->m_arg2;
	b = (ReqDonateTreaBody *)r->bs;
	
	if (!(code == HTTP_OK && buf && atoi(buf) > 0)){
		reason = REASON_WEB_ERR;
		goto err;
	}

	t->id = atoi(buf);

	if (!game_add_trea(g, t)) {
		goto err;
	}

	send_nf_trea_where(t, WHERE_ME);

	two_arg_free(targ);
	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
err:
	two_arg_free(targ);
	trea_free(t);
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}


static void process_req_declare_war(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqDeclareWarBody *b = r->bs;
    Sph *sph, *target_sph;
    City *city = NULL;
    Room *room = NULL;
    int attack_room_num = 0;
    int defense_room_num = 0;
	int now = 0;
	struct tm now_tm;


	now = time(NULL);
	if (!localtime_r(&now, &now_tm)) {
		goto error;
	}

    if (!(now_tm.tm_hour >= 9 && now_tm.tm_hour < 12)) {
        reason = REASON_DEF;
        set_reason("宣战时间为9点~12点");
        goto error;
    }

    if (!(city = game_find_city(g, b->city_id))) {
        reason = REASON_NOT_FOUND_CITY;
        goto error;
    }
    if (!(sph = game_find_sph_by_uid(g, r->sid))) {
        reason = REASON_NOT_FOUND_SPHERE;
        goto error;
    }

    if (sph->uid != r->sid) {
        reason = REASON_DEF;
        set_reason("您不是盟主");
        goto error;
    }

    if (game_find_room_by_city_id(g, city->id)) {
        reason = REASON_DEF;
        set_reason("已经有人对该城宣战");
        goto error;
    }
    
    if (game_find_room_by_attack_sph_id(g, sph->id)) {
        reason = REASON_DEF;
        set_reason("不能重复宣战");
        goto error;
    }

    target_sph = game_find_sph(g, city->sph_id);

    game_find_room_num_by_uid(g, r->sid, &attack_room_num, &defense_room_num);
    
    if (attack_room_num > DECLARE_WAR_NUM) {
        reason = REASON_DEF;
        set_reason("宣战数超过 %d", DECLARE_WAR_NUM);
        goto error;
    }

    if (target_sph && game_find_room_num_by_defense_sph_id(g, target_sph->id) >= target_sph->level) {
        reason = REASON_DEF;
        set_reason("对方被宣战次数过多");
        goto error;
    }

    if (target_sph && sph->prestige < target_sph->prestige && target_sph->is_npc) {
        reason = REASON_DEF;
        set_reason("攻打NPC城池，需要威望高于对方");
        goto error;
    }
    
    if (target_sph && sph->id == target_sph->id) {
        reason = REASON_DEF;
        set_reason("同一势力不能攻打");
        goto error;
    }
	
    if (!(room = room_new())) {
        reason = REASON_MEM_SHORTAGE;
        goto error;
    }

    room->id = g->max_room_id + 1;
    room->attack_sph_id = sph->id;
    if (!target_sph) {
        room->defense_sph_id = 0;
        room->is_npc = 1;
    }
    else if (target_sph->is_npc) {
        room->defense_sph_id = target_sph->id;
        room->is_npc = 1;
    }
    else {
        room->defense_sph_id = target_sph->id;
        room->is_npc = 0;
    }
    room->city_id = b->city_id;

    if (!game_add_room(g, room)) {
        goto error;
    }

    if (room->defense_sph_id == 0 || (target_sph && target_sph->is_npc)) {
        room_alloc_defense_uid(room);
    }

    send_nf_room_where(room, WHERE_ALL);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error:
    room_free(room);
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_apply_war(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqApplyWarBody *b = r->bs;
    Sph *sph;
    Room *room = NULL;
    int attack_room_num = 0;
    int defense_room_num = 0;
    int i = 0;


    if (!(room = game_find_room(g, b->room_id))) {
        reason = REASON_NOT_FOUND_ROOM;
        goto error;
    }

    if (room->ts - GAME_NOW > 60) {
        reason = REASON_DEF;
        set_reason("现在还不能进入战场");
        goto error;
    }

    if (!(sph = game_find_sph_by_uid(g, r->sid))) {
        reason = REASON_NOT_FOUND_SPHERE;
        goto error;
    }

    game_find_room_num_by_uid(g, r->sid, &attack_room_num, &defense_room_num);
    
    if (attack_room_num > DECLARE_WAR_NUM) {
        reason = REASON_DEF;
        set_reason("参加的攻战数超过 %d", DECLARE_WAR_NUM);
        goto error;
    }
    
    if (defense_room_num > DEFENSE_WAR_NUM) {
        reason = REASON_DEF;
        set_reason("参加的防守战数超过 %d", DEFENSE_WAR_NUM);
        goto error;
    }

    if (room_has_uid(room, r->sid)) {
        reason = REASON_DEF;
        set_reason("不要重复报名");
        goto error;
    }

    for (i = 0; i < ROOM_USER_NUM; i++) {
        if (sph->id == room->attack_sph_id) {
            if (room->attack_uid[i] <= 0) {
                room->attack_uid[i] = r->sid;
                break;
            }
        }
        else if (sph->id == room->defense_sph_id) {
            if (room->defense_uid[i] <= 0) {
                room->defense_uid[i] = r->sid;
                break;
            }
        }
        else {
            break;
        }
    }

    send_nf_goto_room_where(room, r->sid, WHERE_ALL);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

static void process_req_exit_war(Req *r)
{
	if (!r)
		return;
	
	Game *g = GAME;
	int reason = 0;
	ReqApplyWarBody *b = r->bs;
    Sph *sph;
    Room *room = NULL;
    int i = 0;


    if (!(room = game_find_room(g, b->room_id))) {
        reason = REASON_NOT_FOUND_ROOM;
        goto error;
    }

    if (!(sph = game_find_sph_by_uid(g, r->sid))) {
        reason = REASON_NOT_FOUND_SPHERE;
        goto error;
    }

    if (!room_has_uid(room, r->sid)) {
        reason = REASON_DEF;
        set_reason("已经退出战场");
        goto error;
    }

    for (i = 0; i < ROOM_USER_NUM; i++) {
        if (sph->id == room->attack_sph_id) {
            if (room->attack_uid[i] == r->sid) {
                room->attack_uid[i] = 0;
                break;
            }
        }
        else if (sph->id == room->defense_sph_id) {
            if (room->defense_uid[i] == r->sid) {
                room->defense_uid[i] = 0;
                break;
            }
        }
        else {
            break;
        }
    }

    send_nf_exit_room_where(room, r->sid, WHERE_ALL);

	req_send_resp(r, RESP_OK, NULL);
	worker_process_request_finish(r);
	return;
error:
	req_send_resp(r, RESP_ERR, get_reason(reason));
	worker_process_request_finish(r);
}

const char *conn_error_type_string(int type)
{
	switch(type) {
		case CONN_ERR_READ:
			return "READ ERROR";
		case CONN_ERR_WRITE:
			return "WRITE ERROR";
		case CONN_ERR_CLOSED:
			return "REMOTE CLOSED";
		case CONN_ERR_READ_TIMEOUT:
			return "READ TIMEOUT";
		case CONN_ERR_WRITE_TIEMOUT:
			return "WRITE TIMEOUT";
		default:
			return "UNKNOWN";
	}
}


