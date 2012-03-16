#ifndef _HTTP_H
#define _HTTP_H
#include "common.h"
#include "defines.h"
#include "tools.h"
#include "queue.h"
#include "ev.h"
#include "mem.h"

typedef struct HeaderEntry HeaderEntry;
typedef struct HttpParam HttpParam;
typedef struct HttpRequest  HttpRequest;
typedef struct HttpResponse HttpResponse;
typedef struct HttpConn HttpConn;

enum HTTP_METHOD {
	HTTP_METHOD_NONE,
	HTTP_GET,
	HTTP_POST,
};

enum HTTP_STATE {
	HTTP_NONE = 0,
	HTTP_NOT_CONNECTED,
	HTTP_CONNECTING,
	HTTP_CONNECTED,
};

typedef void(*HTTP_REQ_CB)(HttpRequest *, void *);

struct HeaderEntry {
	dstring name;
	dstring value;
	TAILQ_ENTRY(HeaderEntry) link;
};

extern HeaderEntry *header_entry_new(const char *name, const char *value);
extern void header_entry_free(HeaderEntry *entry);

struct HttpHeader {
	TAILQ_HEAD(, HeaderEntry) entries;
};
typedef struct HttpHeader HttpHeader;

extern HttpHeader * http_header_new();
extern void http_header_free(HttpHeader *header);
extern void http_header_init(HttpHeader *header);
extern void http_header_clear(HttpHeader *header);
extern int http_header_add(HttpHeader *header, const char *name, const char *value);
extern const char *http_header_get_value(HttpHeader *header, const char *name);
extern HeaderEntry * http_header_get_entry(HttpHeader *header, const char *name);


struct HttpParam {
	TAILQ_HEAD(, HeaderEntry) entries;
};

extern HttpParam *http_param_new(const char *buf);
extern void http_param_free(HttpParam *params);
extern void http_param_init(HttpParam *params);
extern void http_param_clear(HttpParam *params);
extern int http_param_parse(HttpParam *p, const char *buf);

extern void http_param_add_int(HttpParam *params, const char *k, int v);
extern void http_param_add_uint(HttpParam *params, const char *k, uint v);

extern void http_param_add_double(HttpParam *params, const char *k, double v);
extern void http_param_add_string(HttpParam *params, const char *k, const char * v);
extern const char * http_param_get_value(HttpParam *params, const char *k);
extern const dstring * http_param_to_string(HttpParam *params);

struct HttpRequest {
	dstring uri;
	byte method;
	HTTP_REQ_CB cb;
	void *arg;
	HttpHeader header;
	dstring body;
	HttpResponse *resp;
};

extern HttpRequest * http_request_new(const char *uri, byte method, HTTP_REQ_CB, void *arg);
extern void http_request_free(HttpRequest *req);
extern void http_request_set_body(HttpRequest *req, const char *body, int len);
extern void http_request_add_header(HttpRequest *req, const char *name, const char *value);
extern const dstring *http_request_to_string(HttpRequest *req);

struct HttpResponse {
	int header_size;
	int body_size;
	byte chunked;
	byte header_parsed;
	byte body_parsed;
	short code;
	dstring body;
};

extern HttpResponse * http_response_new();
extern void http_response_free(HttpResponse *resp);

struct HttpConn {
	int fd;
	dstring remote_addr;
	dstring remote_ip;
	short remote_port;
	int connect_timeout;
	int read_timeout;
	Mem *inbuf;
	Mem *outbuf;
	HttpRequest *req;
	Ev *ev;
	byte retry;
	byte state;
	TAILQ_ENTRY(HttpConn) link;
};

extern HttpConn * http_conn_new(const char *addr, short port, int connect_timeout, int read_timeout);
extern void http_conn_free(HttpConn *conn);
extern int http_conn_open(HttpConn *conn);
extern int http_conn_request(HttpConn *conn);

struct HttpStatu
{
	HTTPCB cb;
	void *arg;
};
typedef struct HttpStatu HttpStatu;

extern HttpStatu *http_statu_new();
extern void http_statu_free(HttpStatu *p);

struct HttpUrl {
	dstring host;
	dstring path;
	dstring body;
	HTTPCB cb;
	void *arg;
	int port;
	TAILQ_ENTRY(HttpUrl) link;
};
typedef struct HttpUrl HttpUrl;

extern HttpUrl * http_url_new(const char *addr, short port, const char *uri, \
					const char *body, int len, HTTPCB endcb,  void *arg);
extern void http_url_free(HttpUrl *url);

extern void http_request(const char *addr, short port, const char *uri, \
				const char *body, int len, HTTPCB endcb,  void *arg);
#endif


