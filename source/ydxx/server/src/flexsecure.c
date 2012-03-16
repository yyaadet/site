#include "hf.h"


static void write_socket(int fd, short what, void *arg);
static void read_socket(int fd, short what, void *arg);

static const char *CROSS_DOMAIN_POLICY = "<?xml version=\"1.0\"?>"
	"<cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"*\"/>"
	"</cross-domain-policy>";


FlexConn *flex_conn_new(int fd, int read_timeout, int type, FlexCb readcb, \
							   FlexCb writecb, FlexErrCb errorcb,  void *arg)
{
	FlexConn *c = (FlexConn *)cache_pool_alloc(POOL_FLEX_CONN);
	if (!c)
		return NULL;

	c->fd = fd;
	c->readcb = readcb;
	c->writecb = writecb;
	c->errorcb = errorcb;
	c->read_timeout = read_timeout;
	c->ev = NULL;
	dstring_clear(&c->inbuf);
	dstring_clear(&c->outbuf);
	c->type = type;
	c->arg = arg;
	/* set initial value */
	c->ev = ev_new(g_cycle->evbase);
	if (!c)  {
		flex_conn_free(c);
		return NULL;
	}
	ev_update(c->ev, fd, EV_READ, read_socket, c, c->read_timeout);
	set_nonblocking(c->fd);
	set_nodelay(c->fd);
	set_linger_close(c->fd);
	return c;
}
void flex_conn_free(FlexConn *conn)
{
	if (!conn)
		return;
	DEBUG(LOG_FMT"free flex conn %d\n", LOG_PRE, conn->fd);
	close(conn->fd);
	ev_free(conn->ev);
	cache_pool_free(POOL_FLEX_CONN, conn);
}

void flex_conn_write(FlexConn *conn, const char *src, int len) 
{
	if (!(conn))
		return;
	dstring_append(&conn->outbuf, src, len);
	write_socket(conn->fd, EV_WRITE, conn);
}


static void read_socket(int fd, short flag, void *arg)
{
	FlexConn *conn = (FlexConn *)arg;
	char buf[MAX_BUFFER];
	int n;
	int error_type = 0;

	assert(conn);
	ev_update(conn->ev, conn->fd, EV_READ, read_socket, conn, DEF_EV_TIMEOUT);

	if (conn->type == CONN_LISTEN) {
		if (conn->readcb) {
			conn->readcb(conn, conn->arg);
		}
		return;
	}

	assert(conn->type == CONN_NORMAL);
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
	} else if (n == 0) {
		error_type = CONN_ERR_CLOSED;
		goto error;
	} else {
		dstring_append(&conn->inbuf, buf, n);
	}

	if (conn->readcb)
		conn->readcb(conn, conn->arg);

	return;
error:
	if (conn->errorcb)
		conn->errorcb(conn, error_type, conn->arg);
	cycle_del_flex_conn(g_cycle, conn);
	flex_conn_free(conn);
}


static void write_socket(int fd, short flag, void *arg)
{
	FlexConn *conn = (FlexConn *)arg;
	int n;
	short error_type = 0;

	assert(conn);
	if (conn->type == CONN_LISTEN) {
		return;
	}

	if (flag == EV_TIMEOUT) {
		error_type = CONN_ERR_WRITE_TIEMOUT;
		goto error;
	}

	assert(conn->type == CONN_NORMAL);
	n = write(fd, conn->outbuf.buf, conn->outbuf.offset);
	if (n == -1) {
		if (is_ignore_errno(errno) == false) {
			error_type = CONN_ERR_WRITE;
			goto error;
		} else {
			ev_update(conn->ev, conn->fd, EV_WRITE, write_socket, conn, DEF_EV_TIMEOUT);
			return;
		}
	}
	if (n > 0) {
		DEBUG(LOG_FMT"send out %d bytes\n", LOG_PRE, n);
		dstring_erase(&conn->outbuf, 0, n);
		if (conn->outbuf.offset > 0)
			ev_update(conn->ev, conn->fd, EV_WRITE, write_socket, conn, DEF_EV_TIMEOUT);
		else 
			ev_update(conn->ev, conn->fd, EV_READ, read_socket, conn, DEF_EV_TIMEOUT);
	}

	if (conn->writecb)
		conn->writecb(conn, conn->arg);

	return;
error:
	if (conn->errorcb)
		conn->errorcb(conn, error_type, conn->arg);
	cycle_del_flex_conn(g_cycle,conn);
	flex_conn_free(conn);
}

void flex_conn_accept(FlexConn *conn, void *arg)
{
	int fd;
	FlexConn *cli_conn;

	assert(conn);
	if ((fd = accept(conn->fd, NULL, 0)) == -1) {
		if (is_ignore_errno(errno) == false) { 
			WARN(LOG_FMT"%s\n", LOG_PRE, error_string());
		}
		return;
	}


	cli_conn = flex_conn_new(fd, 30, CONN_NORMAL, read_flex_conn, NULL, NULL, NULL);
	if (!cli_conn) {
		close(fd);
		return;
	}
	cycle_add_flex_conn(g_cycle, cli_conn);
	DEBUG(LOG_FMT"accept flex conn %d.\n", LOG_PRE, fd);
}

void read_flex_conn(FlexConn *conn, void *arg)
{
	const char *zero = "\0";

	if (!conn)
		return;

	if (* (conn->inbuf.buf + conn->inbuf.offset - 1) == '\0') {
		DEBUG(LOG_FMT"begin to send flex secure cross domain file\n", LOG_PRE);
		flex_conn_write(conn, CROSS_DOMAIN_POLICY, strlen(CROSS_DOMAIN_POLICY));
		flex_conn_write(conn, zero, 1);
	}	
}



