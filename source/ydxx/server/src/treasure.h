#ifndef _TREASURE_H_
#define _TREASURE_H_


enum TREA_TYPE {
	TREA_NONE = 0,
	TREA_KONG,
	TREA_INTE,
	TREA_POLI,
	TREA_SPEE,
	TREA_FRIE,
	TREA_VIP,
	TREA_FAIT,
	TREA_FLUSH,
	TREA_REC,
	TREA_GX,
	TREA_MAX,
};

struct TreaInfo {
	int id;
	int type;
	int level;
	char* name;
	int num;
	
	RB_ENTRY(TreaInfo) tlink;
	TAILQ_ENTRY(TreaInfo) link;
};
typedef struct TreaInfo TreaInfo;

struct Trea{
	int id;
	int trea_id;
	int gene_id;
	int uid;
	int use_time;
	byte is_used;
	
	RB_ENTRY(Trea) tlink;
};
typedef struct Trea Trea;

extern Trea *trea_new(int trea_id, int gene_id, int uid);

extern void trea_free(Trea *t);

extern const char *trea_get_name(Trea *t);

extern int trea_get_type(Trea *t);

extern int trea_get_num(Trea *t);

extern bool trea_set_used(Trea *t);

extern bool trea_set_unused(Trea *t);

extern void trea_recycle(Trea *t);

extern void donate_trea(int uid, int trea_id);

#endif

