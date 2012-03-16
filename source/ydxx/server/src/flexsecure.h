#ifndef _FLEXSECURE_H
#define _FLEXSECURE_H

#include "ev.h"

struct FlexConn;

typedef void (*FlexCb) (struct FlexConn *, void *);
typedef void (*FlexErrCb) (struct FlexConn *, short, void *);


struct FlexConn {
	int fd;
	dstring inbuf;
	dstring outbuf;
	int read_timeout;
	int type;
	Ev *ev;
	FlexCb readcb;
	FlexCb writecb;
	FlexErrCb errorcb;
	void *arg;

	TAILQ_ENTRY(FlexConn) link;
};
typedef struct FlexConn FlexConn;

extern FlexConn *flex_conn_new(int fd, int read_timeout, int type, FlexCb readcb, \
							   FlexCb writecb, FlexErrCb errorcb,  void *arg);
extern void flex_conn_free(FlexConn *conn);

extern void fle_conn_write(FlexConn *conn, const char *src, int len);

extern void flex_conn_accept(FlexConn *conn, void *arg);

extern void read_flex_conn(FlexConn *conn, void *arg);
extern void error_flex_conn(FlexConn *conn, short what, void *arg);

#endif
