#ifndef _MAIL_H_
#define _MAIL_H_

struct Wubao;
struct SellOrder;
struct User;
struct Plunder;
struct Gene;

enum MAIL_TYPE{
	MAIL_NORMAL = 0,
	MAIL_APPLY_JOIN_SPH,
	MAIL_APPLY_LEAGUE,
	MAIL_SYS,
};

struct Mail {
	int id;
	int type;
	int send_id;
	int recv_id;
	dstring send_name;
	dstring recv_name;
	dstring title;
	dstring cont;
	byte is_read;
	int send_time;
};
typedef struct Mail Mail;

extern Mail *mail_new(int type, int sender_id, const char *sender_name, int recv_id, const char *recv_name, \
					  const char *title, const char *content, int send_time);
extern Mail *mail_new1();

extern void mail_free(Mail *mail);

extern void send_mail_done(const char *buf, int len, void *arg, int code);

extern void send_new_dignitie_mail(struct Wubao *w);

extern void send_order_selled_mail(struct SellOrder *o, struct User *u);

extern void send_order_buyed_mail(struct SellOrder *o, struct User *u);

extern void send_gene_faith_decr_mail(struct Gene *p);

#endif


