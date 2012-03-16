#ifndef _GAMECONN_H_
#define _GAMECONN_H_
#include "common.h"
#include "ev.h"
#include "user.h"
#include "mem.h"


#define GAME_CONN_IN_BUF_SIZE 1024
#define GAME_CONN_OUT_BUF_SIZE 4096


struct GameConn;
struct Req;

typedef void(*ConnCb)(struct GameConn *, void *);
typedef void(*ConnErrCb)(struct GameConn *, short, void *);

enum CONN_ERR_TYPE {
	CONN_ERR_NONE,
	CONN_ERR_READ,
	CONN_ERR_WRITE,
	CONN_ERR_CLOSED,
	CONN_ERR_READ_TIMEOUT,
	CONN_ERR_WRITE_TIEMOUT,
};

enum CONN_TYPE {
	CONN_NONE,
	CONN_LISTEN,
	CONN_NORMAL,
};


struct GameConn {
	int fd;

	int in_bytes;
	Mem * inbuf;
	
	int out_bytes;
	Mem * outbuf;
	
	TAILQ_HEAD(, Req) in_req;
	struct Req *handling_req;

	int read_timeout;
	int type;
    /* check is logined */
	int uid;
	
	char remote_ip[16];

	Ev *ev;

	ConnCb readcb;
	ConnCb writecb;
	ConnErrCb errorcb;
	void *arg;

	int connect_time;
	
	TAILQ_ENTRY(GameConn) link;
};
typedef struct GameConn GameConn;

extern GameConn *game_conn_new(int fd, int read_timeout, int type, ConnCb readcb, \
							   ConnCb writecb, ConnErrCb errorcb, void *arg);
extern void game_conn_free(GameConn *conn);
extern bool game_conn_parse_inbuf(GameConn *conn);
extern void game_conn_send_resp(GameConn *conn, struct Req *r, int code, const char *reason, int len);
extern void game_conn_send_resp1(GameConn *conn, int send_id, int msg_id, int code, const char *reason, int len);
extern void game_conn_send_req(GameConn *conn, struct Req *req);
extern void game_conn_set_uid(GameConn *conn, User *u);
extern struct Req *game_conn_get_ahead_req(GameConn *conn);


extern void game_conn_accept(GameConn *c, void  *arg);


extern void worker_read_conn(GameConn *conn, void *data);
extern void worker_write_conn(GameConn *conn, void *data);
extern void worker_error_conn(GameConn *conn, short flag, void *data);
extern void worker_process_request(struct Req *r);
extern void worker_process_request_finish(struct Req *r);

extern const char * conn_error_type_string(int type);

#endif

