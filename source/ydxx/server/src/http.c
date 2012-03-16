#include "hf.h"

static void parse_response(HttpResponse *resp, HttpConn *conn);
static void parse_resp_header(HttpResponse *resp, const dstring *src);

static bool do_connect_remote(HttpConn *conn);
static bool connect_remote(HttpConn *conn);
static void connect_remote_finish(int fd, short what, void *arg);
static void dispatch_request(HttpConn *conn);
static void dispatch_request_finish(HttpConn *conn);
static size_t headersEnd(const char *mime, size_t l);
//static void resolve_ipv4_cb(int result, char type, int count, int ttl, void *addresses, void *arg);

static void http_write(int fd, short what, void *arg);
static void http_error(int fd, short what, void *arg);
static void http_read(int fd, short what, void *arg);

static void http_request_result(HttpRequest *req, void *arg);
static  void do_http_request(const char *addr, short port,  const char *uri, const char *body, int len, HTTPCB endcb,  void *arg);


HttpStatu *http_statu_new()
{
	HttpStatu *p = (HttpStatu *)cache_pool_alloc(POOL_HTTP_STATU);
	if (!p)
		return NULL;
	p->arg = NULL;
	p->cb = NULL;
	return p;
}

void http_statu_free(HttpStatu *p)
{
	if (!p)
		return;
	cache_pool_free(POOL_HTTP_STATU, p);
}


HeaderEntry *header_entry_new(const char *name, const char *value)
{
	HeaderEntry * entry = (HeaderEntry *) cache_pool_alloc(POOL_HEADER_ENTRY);

	if (!entry) 
		return NULL;

	dstring_clear(&entry->name);
	dstring_clear(&entry->value);
	if (name)
		dstring_set(&entry->name, name);
	if (value)
		dstring_set(&entry->value, value);
	
	return entry;
}


void header_entry_free(HeaderEntry *entry)
{
	if (!entry) 
		return;
	cache_pool_free(POOL_HEADER_ENTRY, entry);
}


HttpHeader * http_header_new()
{
	HttpHeader *header = NULL;

	header = (HttpHeader *)xmalloc(sizeof(HttpHeader));
	if (!header)
		return NULL;
	http_header_init(header);
	return header;
}

void http_header_free(HttpHeader *header)
{
	if (!header)
		return;
	http_header_clear(header);
	free(header);
}

void http_header_init(HttpHeader *header)
{
	if (!header)
		return;
	TAILQ_INIT(&header->entries);
}

void http_header_clear(HttpHeader *header)
{
	HeaderEntry *node = NULL;
	HeaderEntry *tmp = NULL;

	if (!header)
		return;
	TAILQ_FOREACH_SAFE(node, &header->entries, link, tmp) {
		TAILQ_REMOVE(&header->entries, node, link);
		header_entry_free(node);
	}
}

int http_header_add(HttpHeader *header, const char *name, const char *value)
{
	HeaderEntry *entry = NULL;

	if (!(name && value))
		return 0;
	entry = header_entry_new(name, value);
	if (!entry)
		return 0;
	TAILQ_INSERT_HEAD(&header->entries, entry, link);
	return 0;
}

const char *http_header_get_value(HttpHeader *header, const char *name)
{
	HeaderEntry *entry = http_header_get_entry(header, name);
	if (!entry)
		return NULL;
	return entry->value.buf;
}

HeaderEntry * http_header_get_entry(HttpHeader *header, const char *name)
{
	HeaderEntry *entry = NULL;
	HeaderEntry *tmp = NULL;

	if (!header) 
		return NULL;
	if (!(name))
		return NULL;
	TAILQ_FOREACH_SAFE(entry, &header->entries, link, tmp) {
		if (!strcasecmp(name, entry->name.buf)) {
			return entry;
		}
	}
	return NULL;
}

HttpParam *http_param_new(const char *buf)
{
	HttpParam *p = NULL;

	p = (HttpParam *)xmalloc(sizeof(HttpParam));
	if (!p)
		return NULL;
	http_param_init(p);
	if (buf) {
		http_param_parse(p, buf);
	}
	return p;
}

void http_param_free(HttpParam *params)
{
	if (!params)
		return ;
	http_param_clear(params);
	safe_free(params);
}

void http_param_init(HttpParam *params)
{
	if (!params)
		return;
	TAILQ_INIT(&params->entries);
}

void http_param_clear(HttpParam *params)
{
	HeaderEntry *entry = NULL;
	HeaderEntry *tmp = NULL;

	if (!params)
		return;
	TAILQ_FOREACH_SAFE(entry, &params->entries, link, tmp) {
		TAILQ_REMOVE(&params->entries, entry, link);
		header_entry_free(entry);
	}
}

int http_param_parse(HttpParam *p, const char *buf)
{
	char *token, *token1, *last, *last1;
	static char t[MAX_BUFFER];

	token = token1 = last = last1 = NULL;
	if (!(buf && p))
		return 0;
	snprintf(t, MAX_BUFFER - 1, "%s", buf);
	for (token = strtok_r(t, "&", &last); token; token = strtok_r(NULL, "&", &last)) {
		char *name, *value;
		const char *new_value;

		if ((name = strtok_r(token, "=", &last1)) == NULL) 
			continue;
		if ((value = strtok_r(NULL, "=", &last1)) == NULL) 
			continue;
		if (NULL == (new_value = decode_uri(value)))
			continue;
		DEBUG(LOG_FMT"param name %s, value %s\n", LOG_PRE, name, new_value);
		http_param_add_string(p, name, new_value);
	}
	return true;
}

void http_param_add_int(HttpParam *params, const char *k, int v)
{
	static  dstring t;

	if (!(k && params))
		return;
	dstring_clear(&t);
	dstring_append_printf(&t, "%d", v);
	http_param_add_string(params, k, t.buf);
}

void http_param_add_uint(HttpParam *params, const char *k, uint v)
{
	static  dstring t;

	if (!(k && params))
		return;
	dstring_clear(&t);
	dstring_append_printf(&t, "%u", v);
	http_param_add_string(params, k, t.buf);
}

void http_param_add_double(HttpParam *params, const char *k, double v)
{
	static  dstring t;

	if (!(k && params))
		return;
	dstring_clear(&t);
	dstring_append_printf(&t, "%.4f", v);
	http_param_add_string(params, k, t.buf);
}

void http_param_add_string(HttpParam *params, const char *k, const char * v)
{
	static  dstring t;
	HeaderEntry *entry = NULL;

	if (!(k && params && v))
		return;
	dstring_clear(&t);
	dstring_append_printf(&t, "%s", v);
	if (!(entry = header_entry_new(k, v))) {
		return;
	}
	TAILQ_INSERT_HEAD(&params->entries, entry, link);
}

const char *http_param_get_value(HttpParam *params, const char *k)
{
	HeaderEntry *entry = NULL;
	HeaderEntry *tmp = NULL;

	if (!(params && k))
		return NULL;
	TAILQ_FOREACH_SAFE(entry, &params->entries, link, tmp) {
		if(!strcasecmp(k, entry->name.buf)) {
			return  entry->value.buf;
		}
	}
	return NULL;
}

const dstring *http_param_to_string(HttpParam *params)
{
	static dstring t = DSTRING_INITIAL;
	const char *new_value = NULL;
	HeaderEntry *entry = NULL;
	HeaderEntry *tmp = NULL;

	dstring_clear(&t);

	if (!(params))
		return NULL;
	TAILQ_FOREACH_SAFE(entry, &params->entries, link, tmp) {
		new_value = encode_uri(entry->value.buf);
		if (!new_value) 
			continue;
		dstring_append_printf(&t, "%s=%s&", entry->name.buf, new_value);
	}
	
	return &t;
}

HttpRequest * http_request_new(const char *uri, byte method, HTTP_REQ_CB cb, void *arg)
{
	HttpRequest *req = NULL;

	req = (HttpRequest *)cache_pool_alloc(POOL_HTTP_REQ);
	if (!req)
		return NULL;
	dstring_clear(&req->uri);
	if (uri) {
		dstring_set(&req->uri, uri);
	}
	dstring_clear(&req->body);
	req->method = method;
	req->cb = cb;
	req->arg = arg;
	req->resp = http_response_new();
	if (!req->resp) {
		http_request_free(req);
		return NULL;
	}
	http_header_init(&req->header);
	//http_header_add(&req->headers,"User-Agent", "Star Software Http Client");
	//http_header_add(&req->headers,"Connection", "close");
	return req;
}

void http_request_free(HttpRequest *req)
{
	if (!req)
		return ;
	http_response_free(req->resp);
	http_header_clear(&req->header);
	dstring_clear(&req->body);
	cache_pool_free(POOL_HTTP_REQ, req);
}

void http_request_set_body(HttpRequest *req, const char *body, int len)
{
	static char tmp[32];

	if (!(body && req))
		return;
	dstring_append(&req->body, body, len);
	req->method = HTTP_POST;
	snprintf(tmp, 32 - 1, "%d", len);
	http_header_add(&req->header, "Content-Type", "application/x-www-form-urlencoded");
	http_header_add(&req->header, "Content-Length", tmp);
}

const dstring *http_request_to_string(HttpRequest *req)
{
	static dstring res = DSTRING_INITIAL;
	HeaderEntry *entry = NULL;
	HeaderEntry *tmp = NULL;

	if (!req) {
		return NULL;
	}
	dstring_clear(&res);
	if (req->method == HTTP_GET) 
		dstring_append_printf(&res, "GET");
	else if(req->method == HTTP_POST) 
		dstring_append_printf(&res, "POST");
	else {
		return NULL;
	}
	dstring_append_printf(&res, " ");
	if (req->uri.offset > 0)  {
		dstring_append(&res, req->uri.buf, req->uri.offset);
	}
	else {
		return NULL;
	}
	dstring_append_printf(&res, " HTTP/1.1\r\n");
	//append headers
	TAILQ_FOREACH_SAFE(entry, &(req->header.entries), link, tmp) {
		dstring_append_printf(&res, "%s: %s\r\n", entry->name.buf, entry->value.buf);
	}

	dstring_append_printf(&res, "\r\n");
	//append body
	if (req->body.offset > 0) 
		dstring_append(&res, req->body.buf, req->body.offset);

	return &res;
}

HttpResponse * http_response_new()
{
	HttpResponse *resp = (HttpResponse *)cache_pool_alloc(POOL_HTTP_RESP);

	if (!resp)
		return NULL;
	resp->code = 0;
	resp->chunked = 0;
	resp->header_parsed = 0;
	resp->body_parsed = 0;
	resp->body_size = -1;
	resp->header_size = 0;
	dstring_clear(&resp->body);
	return resp;
}

void http_response_free(HttpResponse *resp)
{
	if (!resp) {
		return;
	}
	cache_pool_free(POOL_HTTP_RESP, resp);
}


HttpConn * http_conn_new(const char *addr, short port, int connect_timeout, int read_timeout)
{
	HttpConn *conn = NULL;

	if (!(conn = (HttpConn *)cache_pool_alloc(POOL_HTTP_CONN))) {
		return NULL;
	}
	dstring_clear(&conn->remote_addr);
	if (addr) {
		dstring_set(&conn->remote_addr, addr);
	}
	dstring_clear(&conn->remote_ip);
	conn->remote_port = port;
	conn->ev = ev_new(g_cycle->evbase);
	if(!conn->ev) {
		http_conn_free(conn);
		return NULL;
	}
	conn->state = HTTP_NOT_CONNECTED;
	conn->fd = -1;
	if (!(conn->inbuf = mem_new())) {
		http_conn_free(conn);
		return NULL;
	}
	if (!(conn->outbuf = mem_new())) {
		http_conn_free(conn);
		return NULL;
	}
	conn->req = NULL;
	conn->connect_timeout = connect_timeout;
	conn->read_timeout = read_timeout;
	conn->retry = 0;
	return conn;
}

void http_conn_free(HttpConn *conn)
{
	if (!conn)
		return;
	safe_close(conn->fd);
	ev_free(conn->ev);
	http_request_free(conn->req);
	conn->req = NULL;
	mem_free(conn->inbuf);
	mem_free(conn->outbuf);
	cache_pool_free(POOL_HTTP_CONN, conn);
}
int http_conn_open(HttpConn *conn)
{
	if (!conn)
		return 0;
	if (conn->fd > 0)
		return 0;
	if ((conn->fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
		return 0;
	}
	set_nonblocking(conn->fd);
	set_nodelay(conn->fd);
	set_linger_close(conn->fd);
	return 1;
}

int http_conn_request(HttpConn *conn)
{
	if (!(conn))
		return 0;
	if (!conn->req) {
		dispatch_request_finish(conn);
		return 0;
	}
	if (conn->state != HTTP_NOT_CONNECTED) {
		dispatch_request_finish(conn);
		return 0;
	}
	DEBUG(LOG_FMT"http://%s:%d%s, body {%s}\n",  LOG_PRE, \
		dstring_buf(&conn->remote_addr), 
		conn->remote_port, \
		dstring_buf(&conn->req->uri), \
		dstring_buf(&conn->req->body));
	connect_remote(conn);
	return 1;
}

HttpUrl * http_url_new(const char *addr, short port, const char *path, \
							  const char *body, int len, HTTPCB endcb,  void *arg)
{
	HttpUrl *url = (HttpUrl *) cache_pool_alloc(POOL_HTTP_URL);
	if (!url) 
		return NULL;
	dstring_clear(&url->host);
	if (addr) {
		dstring_set(&url->host, addr);
	}
	url->port = port;
	dstring_clear(&url->path);
	if (path) {
		dstring_set(&url->path, path);
	}
	dstring_clear(&url->body);
	if (body && len > 0) {
		dstring_append(&url->body, body, len);
	}
	url->cb = endcb;
	url->arg = arg;
	return url;
}

void http_url_free(HttpUrl *url)
{
	if (!url) 
		return;
	cache_pool_free(POOL_HTTP_URL, url);
}

static void dispatch_request(HttpConn *conn)
{
	HttpRequest *req = NULL;
	const dstring *out = NULL;
	
	if(!conn) {
		return;
	}
	if (conn->req == NULL) {
		dispatch_request_finish(conn);
		return;
	}
	req = conn->req;
	out = http_request_to_string(req);
	if (out == NULL) {
		dispatch_request_finish(conn);
		return;
	}
	mem_append_buf(conn->outbuf, out->buf, out->offset);

	ev_update(conn->ev, conn->fd, EV_WRITE, http_write, conn, DEF_EV_TIMEOUT);
}

static void dispatch_request_finish(HttpConn *conn) 
{
	HttpRequest *req = NULL;
	HttpResponse *resp;

	if (!conn)
		return;
	req = conn->req;
	if (req) {
		resp = req->resp;
		if (resp) {
			DEBUG(LOG_FMT"response from {http://%s:%d%s, %s} code %d\n",  \
							LOG_PRE, 
							dstring_buf(&conn->remote_addr), 
							conn->remote_port, 
							dstring_buf(&req->uri),
							dstring_buf(&req->body), 
							resp->code);
		
			if (resp->code == HTTP_OK) {
				DEBUG(LOG_FMT"\n-----\n%s\n------\n",  LOG_PRE, resp->body.buf);
			}
		}
		if (req->cb) 
			req->cb(req, req->arg);
	}
	cycle_del_http_conn(g_cycle, conn);
	http_conn_free(conn);
	
	check_deffer_http(NULL);
}

static bool connect_remote(HttpConn *conn)
{
	const char *ip = NULL;

	if (!(conn)) {
		return false;
	}
	if (conn->remote_addr.offset <= 0) {
		dispatch_request_finish(conn);
		return false;
	}
	if (is_ipv4(conn->remote_addr.buf) == false)  {
		ip = get_host_ip(conn->remote_addr.buf);
		dstring_set(&conn->remote_ip, ip);
	}
	do_connect_remote(conn);
	return true;
}

static bool do_connect_remote(HttpConn *conn)
{
	struct sockaddr_in remote_addr;
	socklen_t socklen = sizeof(remote_addr);
	char *ip = NULL;

	if(!conn)
		return false;
	if (conn->state != HTTP_NOT_CONNECTED) {
		dispatch_request_finish(conn);
		return false;
	}

	remote_addr.sin_port = htons(conn->remote_port);
	remote_addr.sin_family = AF_INET;
	if (is_ipv4(conn->remote_addr.buf)) 
		ip = conn->remote_addr.buf;
	else if (conn->remote_ip.offset > 0)
		ip = conn->remote_ip.buf;
	else {
		WARN(LOG_FMT"ip is null\n", LOG_PRE);
		dispatch_request_finish(conn);
		return false;
	}

	if(inet_pton(AF_INET, ip, &remote_addr.sin_addr) != 1) {
		WARN(LOG_FMT"inet_pton %s error: %s\n", LOG_PRE, \
			ip, error_string());
		dispatch_request_finish(conn);
		return false;
	}
	if (conn->fd < 0) {
		WARN(LOG_FMT"fd %d is invalid.\n", LOG_PRE, conn->fd);
		dispatch_request_finish(conn);
		return false;
	}

	if (connect(conn->fd, (struct sockaddr *) &remote_addr, socklen) == -1 ) {
		if (is_ignore_errno(errno) == false) {
			ERROR(LOG_FMT"connect %s:%d error: %s\n", \
				LOG_PRE, ip, conn->remote_port, error_string());
			dispatch_request_finish(conn);
			return false;
		} else {
			ev_update(conn->ev, conn->fd, EV_WRITE, connect_remote_finish, conn, \
				conn->connect_timeout);
			conn->state = HTTP_CONNECTING;
			return true;
		}
	}

	connect_remote_finish(conn->fd, EV_WRITE, conn);
	return true;
}

static void connect_remote_finish(int fd, short what, void * arg)
{
	HttpConn *conn = NULL;
	int error;	
	socklen_t errsz = sizeof(error);	
	
	if (!(conn = (HttpConn *)arg))
		return;
	if (fd != conn->fd) {
		WARN(LOG_FMT"fd %d not equal conn %d\n", LOG_PRE, fd, conn->fd);
		return;
	}
	if (what == EV_TIMEOUT) {
		WARN(LOG_FMT"http connection timeout for \"%s:%d\" on %d, retry %d\n",  \
			LOG_PRE, conn->remote_addr.buf, conn->remote_port, conn->fd, \
			conn->retry);
		conn->retry++;
		if (conn->retry >= HTTP_MAX_RETRY) {
			dispatch_request_finish(conn);
			return;
		}
		else {
			ev_update(conn->ev, conn->fd, EV_WRITE, connect_remote_finish, conn, \
					conn->connect_timeout);
			return;
		}
	}	
	/* Check if the connection completed */	
	if (getsockopt(conn->fd, SOL_SOCKET, SO_ERROR, (void*)&error, &errsz) == -1) {		
		ERROR(LOG_FMT"getsockopt for \"%s:%d\" on %d\n",
			LOG_PRE, conn->remote_addr.buf, conn->remote_port, conn->fd);		
		dispatch_request_finish(conn);
		return ;
	}	
	if (error) {		
		ERROR(LOG_FMT"connect failed for \"%s:%d\" on %d: %s\n", \
			LOG_PRE, conn->remote_addr, conn->remote_port, conn->fd, error_string());
		dispatch_request_finish(conn);
		return;
	}
	DEBUG(LOG_FMT"connected %s:%d.\n", LOG_PRE, conn->remote_addr.buf, conn->remote_port);

	conn->state = HTTP_CONNECTED;
	dispatch_request(conn);
}


void parse_resp_header(HttpResponse *resp, const dstring *src) 
{
	dstring *line = NULL;
	int offset = 0;
	char *token = NULL;
	HttpHeader headers;
	char *t = NULL;
	static dstring k = DSTRING_INITIAL;
	static dstring v = DSTRING_INITIAL;


	if (!(src))
		return;
	if (!(resp && resp->header_parsed == 0)) 
		return;
	http_header_init(&headers);
	//parse header
	if ((resp->header_size = headersEnd(src->buf, src->offset)) == 0) {
		DEBUG(LOG_FMT"header not receive complete.\n", LOG_PRE);
		return;
	}
	//get response line
	line = (dstring *)read_line(src->buf, src->offset);
	if (!line) 
		return;
	offset += line->offset;
	dstring_strip(line, "\r\n\t ");

	token = strtok((char *)line->buf, " ");
	if (token == NULL) {
		WARN(LOG_FMT"response is error\n", LOG_PRE);
		return ;
	}
	token = strtok(NULL, " ");
	if (token == NULL) {
		WARN(LOG_FMT"response is error\n", LOG_PRE);
		return;
	}
	resp->code = atoi(token);
	//header parse
	while ((line = (dstring *)read_line(src->buf + offset, src->offset - offset)) > 0 && (uint)offset <= src->offset)  {
		dstring_clear(&k);
		dstring_clear(&v);
		offset += line->offset;
		if (( t = strchr(line->buf, ':')) == NULL) {
			break;
		}
		dstring_append(&k, line->buf, t - line->buf);
		dstring_strip(&k, " ");
		
		dstring_append(&v, t+ 1, strlen(t + 1));
		dstring_strip(&v, "\r\n\t ");

		http_header_add(&headers, k.buf, v.buf);
		DEBUG(LOG_FMT"add header {%s}={%s}\n", LOG_PRE, k.buf, v.buf);
	}
	resp->header_parsed = true;
	//get body size
	if ((t = (char *)http_header_get_value(&headers, "content-length"))) {
		resp->body_size = atoi(t);
	}
	//is chunk
	if ((t = (char *)http_header_get_value(&headers, "transfer-encoding"))) {
		resp->chunked = true;
	}

	http_header_clear(&headers);

	DEBUG(LOG_FMT"parse http resp header %d bytes, body %d bytes, chunked %s, code %d\n", 
						LOG_PRE, resp->header_size, 
						resp->body_size, 
						resp->chunked ? "true": "false",
						resp->code);
}


static void parse_response(HttpResponse *resp, HttpConn *conn) 
{
	const dstring *line = NULL;
	int offset = 0;
	char *body_pos;
	long chunk = 0;
	int left = 0;
	const dstring *src = NULL;

	if (!(resp&& conn))
		return;
	if (!(src = mem_get_buf(conn->inbuf, 0, conn->inbuf->off)))
		return;

	parse_resp_header(resp, src);
	if (resp->header_parsed == false) {
		return;
	}
	body_pos = (char *) (src->buf + resp->header_size);
	//begin to parse body
	if (resp->chunked) {
		while((line = read_line(body_pos + offset, src->offset - resp->header_size - offset)) && \
						(int)src->offset >= resp->header_size + offset) {
			chunk = left = 0;
			offset += line->offset;
			left = src->offset - offset - resp->header_size;
			chunk = strtol(line->buf, NULL, 16); 
			DEBUG(LOG_FMT"chunk %d, left %d\n", LOG_PRE, chunk, left);
			if(chunk == 0) {
				resp->body_parsed = true;
				break;
			}
			else if (chunk > left) {
				return;
			}
			dstring_append(&resp->body, body_pos + offset, chunk);
			offset += chunk + 2;
		}
		return;
	}

	//received all body
	if (resp->body_size > 0 && src->offset - resp->header_size == (uint)resp->body_size) {
		dstring_clear(&resp->body);
		dstring_append(&resp->body, body_pos, resp->body_size);
		resp->body_parsed = true;
	} else if (resp->body_size == 0) {
		dstring_clear(&resp->body);
		resp->body_parsed = true;
	}
}





static size_t headersEnd(const char *mime, size_t l)
{
	size_t e = 0;
	int state = 1;
	while (e < l && state < 3) {
		switch (state) {
			case 0:
				if ('\n' == mime[e])
					state = 1;
				break;
			case 1:
				if ('\r' == mime[e])
					state = 2;
				else if ('\n' == mime[e])
					state = 3;
				else
					state = 0;
				break;
			case 2:
				if ('\n' == mime[e])
					state = 3;
				else
					state = 0;
				break;
			default:
				break;
		}
		e++;
	}
	if (3 == state)
		return e;
	return 0;
}


static void http_write(int fd, short what, void * arg)
{
	HttpConn *conn =NULL;
	HttpRequest *req = NULL;
	int n = 0;
	int len = 0;
	const dstring *s = NULL;

	if (!(conn = (HttpConn *)arg))
		return;
	if (fd != conn->fd) {
		WARN(LOG_FMT"fd %d not equal conn %d\n", LOG_PRE, fd, conn->fd);
		return;
	}

	req = conn->req;
	if (!req) 
		return;
	
	len = MIN(conn->outbuf->off, SOCK_MAX_BUFFER);

	if (!(s = mem_get_buf(conn->outbuf, 0, len)))
		return;
	
	if(-1 == (n = write(conn->fd, s->buf, s->offset))) {
		if (is_ignore_errno(errno) == false) {
			ERROR(LOG_FMT"%s\n", LOG_PRE, error_string());
			http_error(fd, what, conn);
			return;
		} 
		else {
			ev_update(conn->ev, conn->fd, EV_WRITE, http_write, conn, DEF_EV_TIMEOUT);
		}
		return;
	} 
	else if (n > 0) {	
		mem_erase(conn->outbuf, 0, n);
	}

	flow_incr_byte(FLOW_HTTP_OUT, n);

	if (conn->outbuf->off == 0) {
		ev_update(conn->ev, conn->fd, EV_READ , http_read, conn, conn->read_timeout);
	} 
	else  {
		ev_update(conn->ev, conn->fd, EV_WRITE, http_write, conn, DEF_EV_TIMEOUT);
	}
}


static void http_read(int fd, short what, void * arg)
{
	HttpConn *conn =NULL;
	HttpRequest *req = NULL;
	int n = 0;
	static char buf[SOCK_MAX_BUFFER];


	if (!(conn = (HttpConn *)arg))
		return;
	if (fd != conn->fd) {
		WARN(LOG_FMT"fd %d not equal conn %d\n", LOG_PRE, fd, conn->fd);
		return;
	}
	req = conn->req;
	if (!req)
		return;
	
	if (what == EV_TIMEOUT) {
		WARN(LOG_FMT"http connection read %d timeout, return\n", LOG_PRE, fd);
		http_error(fd, what, conn);
		return;
	}
	
	n = read(fd, buf, SOCK_MAX_BUFFER);
	if (n == -1) {
		if (is_ignore_errno(errno) == false) {
			ERROR(LOG_FMT"%s\n", LOG_PRE, error_string());
			http_error(fd, what,conn);
			return;
		} else
			ev_update(conn->ev, conn->fd, EV_READ, http_read, conn, DEF_EV_TIMEOUT);
		return;
	} 
	else if (n == 0) {
		DEBUG(LOG_FMT"remote close %d\n", LOG_PRE, fd); 
		parse_response(req->resp, conn);
		http_error(fd, what, conn);
		return;
	}
	
	flow_incr_byte(FLOW_HTTP_IN, n);

	mem_append_buf(conn->inbuf, buf, n);
	parse_response(req->resp, conn);

	if (req->resp->header_parsed && req->resp->body_parsed)  {
		dispatch_request_finish(conn);
		return;
	}

	ev_update(conn->ev, conn->fd, EV_READ, http_read, conn, DEF_EV_TIMEOUT);
}

static void http_error(int fd, short what, void *arg)
{
	HttpConn *conn = NULL;
	HttpRequest *req = NULL;

	if (!(conn = (HttpConn *)arg))
		return;
	if (fd != conn->fd) {
		WARN(LOG_FMT"fd %d not equal conn %d\n", LOG_PRE, fd, conn->fd);
		return;
	}
	req = conn->req;
	ERROR(LOG_FMT"some error happend when request url http://%s:%d%s, body {%s}\n",  \
			LOG_PRE, conn->remote_addr.buf, conn->remote_port, req->uri.buf, req->body.buf);
		
	if (req->cb) 
		req->cb(req, req->arg);

	cycle_del_http_conn(g_cycle, conn);
	http_conn_free(conn);
	check_deffer_http(NULL);
}


void http_request(const char *addr, short port,  const char *path, const char *body, int len, HTTPCB endcb,  void *arg)
{
	Conf *conf = g_cycle->conf;
	HttpUrl  *url = NULL;

	if (!(addr && port > 0 && path)) {
		goto done;
	}

	if (g_cycle->http_conn_num > conf->http.max_concurrent) {
		DEBUG(LOG_FMT"http(%d) has reached max concurrent %d, deffer %d\n",  \
						LOG_PRE,  \
						g_cycle->http_conn_num, \
						conf->http.max_concurrent, \
						g_cycle->deffer_http_url_num);

		url = http_url_new(addr, port, path, body, len, endcb, arg);
		if (!url) {
			goto done;
		}

		cycle_add_deffer_http_url(g_cycle, url);
		return;
	}

	do_http_request(addr, port, path, body, len, endcb, arg);

	return;
done:
	if (endcb) {
		endcb(NULL, 0, arg, HTTP_ERR);
	}
}

static  void do_http_request(const char *addr, short port,  const char *uri, const char *body, int len, HTTPCB endcb,  void *arg)
{
	HttpRequest *req = NULL;
	HttpStatu *statu = NULL;
	int method = HTTP_GET;
	HttpConn *conn = NULL;
	Conf *conf = g_cycle->conf;


	if (!(addr && port > 0 && uri)) {
		goto fin;
	}
	conn = http_conn_new(addr, port, conf->http.connect_timeout, conf->http.read_timeout);
	if (!conn) {
		goto fin;
	}

	statu = http_statu_new();
	if (!statu) {
		WARN(LOG_FMT"failed to new http statu.\n", LOG_PRE);
		goto fin;
	}
	statu->arg = arg;
	statu->cb = endcb;
	req = http_request_new(uri, method, http_request_result, statu);
	if (!req) {
		WARN(LOG_FMT"failed to new http request.\n", LOG_PRE);
		goto fin;
	}
	if (body && len > 0) {
		http_request_set_body(req, body, len);
	}
	http_header_add(&req->header, "Host", addr);
	conn->req = req;

	if (http_conn_open(conn) == 0) {
		goto fin;
	}
	cycle_add_http_conn(g_cycle, conn);
	http_conn_request(conn);
	return;
fin:
	if(endcb)
		endcb(NULL, 0, arg, HTTP_ERR);
	http_statu_free(statu);
	if (conn) {
		http_conn_free(conn);
	}
}

static void http_request_result(HttpRequest *req,  void *arg)
{
	HttpStatu *statu = (HttpStatu *) arg;
	HttpResponse *resp = NULL;
	int code = HTTP_ERR;
	const char *buf = NULL;
	int len = 0;

	if (!(req && statu))
		return;
	resp = req->resp;
	if (!resp) {
		code = HTTP_ERR;
		goto finish;
	}
	code = resp->code;
	if (resp->body.offset > 0) {
		buf = resp->body.buf;
		len = resp->body.offset;
	}

finish:
	if(statu && statu->cb)
		statu->cb(buf, len, statu->arg, code);
	http_statu_free(statu);
}



