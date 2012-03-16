#ifndef _SDB_H_
#define _SDB_H_

#include "game.h"


enum SDB_TYPE {
	SDB_NONE, 
	SDB_TIME,
	SDB_SPH, 
	SDB_CITY, 
	SDB_WUBAO,
	SDB_GENE, 
	SDB_ARMY,
	SDB_CMD_TRANS,
	SDB_ORDER,
	SDB_SELL_ORDER,
	SDB_GUANKA,
	SDB_ROOM,
	SDB_ALL,
};

enum SDB_TIME_VER {
	SDB_TIME_V1,
	SDB_TIME_VN,
};

enum SDB_SPH_VER {
	SDB_SPH_V1,
	SDB_SPH_V2,
	SDB_SPH_VN,
};

enum SDB_CITY_VER {
	SDB_CITY_V1,
	SDB_CITY_V2,
	SDB_CITY_VN,
};

enum SDB_WUBAO_VER {
	SDB_WUBAO_V1,
	SDB_WUBAO_V2,
	SDB_WUBAO_V3,
	SDB_WUBAO_V4,
	SDB_WUBAO_VN,
};

enum SDB_GENE_VER {
	SDB_GENE_V1,
	SDB_GENE_V2,
	SDB_GENE_V3,
	SDB_GENE_V4,
	SDB_GENE_VN,
};

enum SDB_ARMY_VER {
	SDB_ARMY_V1,
	SDB_ARMY_VN,
};

enum SDB_CMD_TRANS_VER {
	SDB_CMD_TRANS_V1,
	SDB_CMD_TRANS_VN,
};

enum SDB_ORDER_VER {
	SDB_ORDER_V1,
	SDB_ORDER_V2,
	SDB_ORDER_VN,
};

enum SDB_SELL_ORDER_VER {
	SDB_SELL_ORDER_V1, 
	SDB_SELL_ORDER_VN,
};

enum SDB_GUANKA_VER {
	SDB_GUANKA_V1, 
	SDB_GUANKA_VN,
};

enum SDB_ROOM_VER {
	SDB_ROOM_V1, 
	SDB_ROOM_VN,
};

typedef struct {
	const char *name;
	int id;
	int sz;
	int ver;
}SdbInfo;

extern bool create_sdb(int type, Shmem *shm, Game *g);
extern bool parse_sdb(int type, Shmem*src, Game *g);

extern SdbInfo g_sdb_info[SDB_ALL + 1];


#endif
