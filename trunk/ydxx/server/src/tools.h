#ifndef _TOOLS_H
#define  _TOOLS_H
#include "tree.h"
#include "dstring.h"




struct IDName {
	int m_id;
	const char *name;
	const char *alias;
};
typedef struct IDName IDName;

struct Key {
	int id;
	void *arg;
	RB_ENTRY(Key) tlink;
	TAILQ_ENTRY(Key) link;
};
typedef struct Key Key;

typedef int (*KEYCMP) (Key *, Key *);

extern Key * key_new(int id);
extern Key * key_new1(int id, void *arg);
extern void key_free(Key *k);

struct KeyList {
	TAILQ_HEAD(KeyTailq, Key) keys;
	KEYCMP cmp;
	int num;
};
typedef struct KeyList KeyList;

extern KeyList *key_list_new(KEYCMP cmp);
extern void key_list_init(KeyList *kl, KEYCMP cmp);
extern void key_list_free(KeyList *kl);

extern bool key_list_add(KeyList *kl, Key *k);
extern bool key_list_del(KeyList *kl, Key *k);
extern Key * key_list_get(KeyList *kl, int id);

extern int key_comp(Key *k1, Key *k2);
RB_HEAD(KeyMap, Key);
RB_PROTOTYPE(KeyMap, Key, tlink, key_comp);


struct Name {
	dstring c;
	void *arg;

	RB_ENTRY(Name) tl;
};
typedef struct Name Name;

extern Name *name_new(const char *n);
extern void name_free(Name *n);

extern int name_cmp(Name *n1, Name *n2);

RB_HEAD(NameMap, Name);
RB_PROTOTYPE(NameMap, Name, tl, name_comp);

struct TwoArg {
	void *m_arg1;
	void *m_arg2;
};
typedef struct TwoArg TwoArg;

extern TwoArg *two_arg_new(void *arg1, void *arg2);
extern void two_arg_free(TwoArg *targ);


struct Pos {
	int x;
	int y;
	TAILQ_ENTRY(Pos) link;
};
typedef struct Pos Pos;

extern Pos *pos_new(unsigned short x, unsigned short y);
extern void pos_free(Pos *p);

struct TimePos{
	Pos *from;
	Pos *to;
	double sec;
	TAILQ_ENTRY(TimePos) link;
};
typedef struct TimePos TimePos;

extern TimePos *time_pos_new(Pos *from, Pos *to, double sec);
extern void time_pos_free(TimePos *tp);

struct Range {
	int low;
	int high;
};
typedef struct Range Range;

struct Entry {
	dstring name;
	dstring value;
	TAILQ_ENTRY(Entry) link;
};
typedef struct Entry Entry;

extern Entry *entry_new(const char *name, const char *value);
extern void entry_free(Entry *entry);

#ifndef HAVE_STRNDUP
extern char *strndup(const char *src, int len);
#endif
extern char *strdup_safe(const char *src);
extern int strlen_safe(const char *src);
extern char *strip(const char *src, const char *chs);
extern const dstring * read_line(const char *src, int len);
extern int remove_blank(char *src, int len);
extern void create_daemon(const char *cmd, const char *dir);

extern bool dir_exist(const char *path);

extern bool create_dirs(const char *path);

extern bool path_exist(const char *path);

extern bool create_path(const char *path);

extern const char *format_time(time_t t, const char *fmt);

extern const char *format_time_r(time_t t, const char *fmt, char *ret, int len);

extern const char *readable_time(int t);

extern unsigned int read_pid(const char *path);

extern bool write_pid(const char *path, unsigned int p);

extern bool remove_file(const char *path);

extern bool write_file(const char *path, const char *buf, int len);

extern const char *build_file_path(const char *prefix, const char *name);

extern void child_monitor(const char *app_name, void *arg);

extern int spawn(void (*cb)(void *), void *arg);

extern const char * error_string(void);

extern bool is_ignore_errno(int err);

extern bool set_nonblocking(int fd);

extern bool set_reuse(int fd);

extern bool set_nodelay(int fd);

extern bool set_linger_close(int fd);

extern bool set_sock_buf(int fd, int len);

extern const char *get_host_ip(const char *host);

extern bool is_ipv4(const char *ip);

extern void do_signal(int sig, sig_t func, int flags);

extern const char * signal_string(int sig);

extern void print_trace(void);

extern int network_listen(const char *addr, short port);

extern const char *encode_uri(const char *src);
extern const char *decode_uri(const char *src);

extern int set_bit(int *i, int pos, int onoff);

extern const char * int_to_char(int i);

extern int get_next_timestamp(int hour, int minu);
#endif

