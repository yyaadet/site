#ifndef _MAP_H_
#define _MAP_H_

#include "defines.h"

enum ZHOU {
	ZHOU_RONGDI = 0x0,
	ZHOU_YOUZHOU,
	ZHOU_LIANGZHOU,
	ZHOU_JIZHOU,
	ZHOU_BINGZHOU,
	ZHOU_QINGZHOU,
	ZHOU_YUNZHOU,
	ZHOU_SILI,
	ZHOU_YONGZHOU,
	ZHOU_XUZHOU,
	ZHOU_YUZHOU,
	ZHOU_YANGZHOU,
	ZHOU_JINZHOU,
	ZHOU_YIZHOU,
	ZHOU_JIAOZHOU,
	ZHOU_HAIWAI = 0xf,
};

enum REGION {
	REGION_NONE = 0X0,
	REGION_CHENGSHI,
	REGION_GUANAI,
	REGION_DALU,
	REGION_XIAOLU,
	REGION_SHANLU,
	REGION_HELIU,
	REGION_JIANGHAI,
	REGION_PINGYAN,
	REGION_CAOYAN,
	REGION_SENGLIN,
	REGION_SHAMU,
	REGION_QIULIN,
	REGION_SHANDI,
	REGION_GAODI,
	REGION_GAOYAN=0XF, 
	REGION_ATTACK,
	REGION_DEFEND,
};


typedef struct Zhou {
	int m_id;
	const char *m_name;
}Zhou;

typedef struct Region {
	int m_id;
	const char *m_name;
}Region;

typedef struct MapRegion {
	byte m_reg;
	byte m_zhou;
	byte m_jun;
	byte m_consume;
}MapRegion;

extern bool map_init();
extern void map_uninit();

extern MapRegion *load_map_region(const char *path, int *w, int *h);

extern MapRegion *get_map_region(MapRegion *m, int w, int h, int x, int y);

extern MapRegion *get_global_region(int x, int y);

//[x][y]
extern Zhou g_zhou[ZHOU_NUM];
extern Region g_region[REGION_NUM];

#endif

