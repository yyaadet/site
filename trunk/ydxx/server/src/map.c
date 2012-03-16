#include "hf.h"


Zhou g_zhou[] = {
	{ ZHOU_RONGDI, "戎狄"},
	{ZHOU_YOUZHOU, "幽州"},
	{ZHOU_LIANGZHOU, "凉州"},
	{ZHOU_JIZHOU, "冀州"},
	{ZHOU_BINGZHOU, "并州"},
	{ZHOU_QINGZHOU, "青州"},
	{ZHOU_YUNZHOU, "兖州"},
	{ZHOU_SILI, "司隶"},
	{ZHOU_YONGZHOU, "雍州"},
	{ZHOU_XUZHOU, "徐州"},
	{ZHOU_YUZHOU, "豫州"},
	{ZHOU_YANGZHOU, "扬州"},
	{ZHOU_JINZHOU, "荆州"},
	{ZHOU_YIZHOU, "益州"},
	{ZHOU_JIAOZHOU, "交州"},
	{ZHOU_HAIWAI , "海外"},
};

Region g_region[] = {
	{REGION_NONE, "无"},
	{REGION_CHENGSHI, "城市"},
	{REGION_GUANAI, "关隘"},
	{REGION_DALU, "大路"},
	{REGION_XIAOLU, "小路"},
	{REGION_SHANLU, "山路"},
	{REGION_HELIU, "河流"},
	{REGION_JIANGHAI, "江海"},
	{REGION_PINGYAN, "平原"},
	{REGION_CAOYAN, "草原"},
	{REGION_SENGLIN, "森林"},
	{REGION_SHAMU, "沙漠"},
	{REGION_QIULIN, "丘陵"},
	{REGION_SHANDI, "山地"},
	{REGION_GAODI, "高地"},
	{REGION_GAOYAN, "高原"},
};

static int g_global_map_w = 0;
static int g_global_map_h = 0;
static MapRegion *g_global_map = NULL;


bool map_init()
{
	char *path = (char *)g_cycle->conf->core.map;
	int w = 0;
	int h = 0;


	if (!(g_global_map = load_map_region(path, &w, &h))) 
		return false;

	g_global_map_w = w;
	g_global_map_h = h;

	DEBUG(LOG_FMT"GLOBAL MAP size %d * %d\n", LOG_PRE, w, h);

	return true;
}

void map_uninit()
{
	safe_free(g_global_map);
}


MapRegion *load_map_region(const char *path, int *w, int *h)
{
	MapRegion *r = NULL;
	int w1 = 0;
	int h1 = 0;
	uint *bm = NULL;
	int x = 0;
	int y = 0;
	int t = 0;
	MapRegion *reg = NULL;

	if (!(bm = load_bitmap(path, &w1, &h1))) {
		return NULL;
	}
	
	if (!(r = xmalloc(sizeof(MapRegion) * h1 * w1))) {
		safe_free(bm);
		return NULL;
	}

	for (y = 0; y < h1; y++) {
		for (x = 0; x < w1; x++) {

			t = *(bm + x + y * w1);
			reg = r + x + y * w1;

			reg->m_consume = t & 0xff;
			reg->m_jun = (t >> 8) & 0xff;
			reg->m_zhou = (t >> 16) & 0xf;
			reg->m_reg = (t >> 20) & 0xf;
		}
	}
	safe_free(bm);

	(*w) = w1;
	(*h) = h1;

	return r;
}

MapRegion * get_map_region(MapRegion *m, int w, int h, int x, int y)
{
	static MapRegion *r = NULL;

	if (!m)
		return NULL;

	if (x < 0 || x > w)
		return NULL;
	if ( y < 0 || y > h)
		return NULL;

	r = (m + x + y * w);

	
	DEBUG(LOG_FMT" (%d %d) reg %d, zhou %d, jun %d, consume %d\n", LOG_PRE, \
					x, y, r->m_reg, r->m_zhou, r->m_jun, r->m_consume);
	return r;
}


MapRegion * get_global_region(int x, int y)
{
	MapRegion *r = NULL;
	int offset = 0;

	if (x < 0 || x > g_global_map_w)
		return NULL;
	if ( y < 0 || y > g_global_map_h)
		return false;

	offset  = y * g_global_map_w + x;
	
	r = g_global_map + offset;
	
	DEBUG(LOG_FMT" (%d %d) reg %d, zhou %d, jun %d, consume %d\n", LOG_PRE, \
					x, y, r->m_reg, r->m_zhou, r->m_jun, r->m_consume);
	return r;
}

