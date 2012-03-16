#include "hf.h"

#define POOL_NAME_LEN 32

#define DEF_ITEM_NUM 1000

struct PoolNode {
	void * data;
	TAILQ_ENTRY(PoolNode) link;
};
typedef struct PoolNode PoolNode;


struct Pool {
	int type;
	int item_sz;
	int item_num;
	int alloc_num;
	int free_num;
	int failed_num;
	char name[POOL_NAME_LEN];

	int free_node_num;
	TAILQ_HEAD(, PoolNode) free_node;
	
	int used_node_num;
	TAILQ_HEAD(, PoolNode) used_node;
};
typedef struct Pool Pool;

struct PoolInfo {
	int type;
	int item_sz;
	const char *name;
	Pool *pool;
};
typedef struct PoolInfo PoolInfo;


static Pool *pool_new(int type, int item_sz, int size, const char *name);
static void  pool_free(Pool *p);
static PoolNode * pool_alloc_node(Pool *p);
static void pool_free_node(Pool *p, PoolNode *node);
static PoolNode * pool_find_used_node(Pool *p, void *ptr);


static PoolNode *pool_node_new();
static void pool_node_free(PoolNode *n);


static PoolInfo g_pool_info[] = {
	{POOL_HEADER_ENTRY, sizeof(HeaderEntry), "header entry", NULL},
	{POOL_HTTP_STATU, sizeof(HttpStatu), "http statu", NULL},
	{POOL_HTTP_RESP, sizeof(HttpResponse), "http response", NULL},
	{POOL_HTTP_REQ, sizeof(HttpRequest), "http request", NULL},
	{POOL_HTTP_CONN, sizeof(HttpConn), "http connection", NULL},
	{POOL_HTTP_URL, sizeof(HttpUrl), "http url", NULL},
	{POOL_EV, sizeof(Ev), "ev", NULL},
	{POOL_POS, sizeof(Pos), "position", NULL},
	{POOL_TIME_POS, sizeof(TimePos), "time position", NULL},
	/************************* c --> s ************************************/
	{POOL_REQ, sizeof(Req), "request", NULL},
	{POOL_REQ_LOGIN_BODY, sizeof(ReqLoginBody),  "req login body", NULL},
	{POOL_REQ_CREATE_ROLE_BODY, sizeof(ReqCreateRoleBody),  "req create role body", NULL},
	{POOL_REQ_LEVEL_UP_BODY, sizeof(ReqLevelUpBody), "req level up body", NULL},
	{POOL_REQ_CANCEL_LEVEL_UP_BODY, sizeof(ReqCancelLevelUpBody), "req cancel level up body",NULL},
	{POOL_REQ_SPEED_BODY, sizeof(ReqSpeedBody), "req speed body", NULL},
	{POOL_REQ_MADE_BODY, sizeof(ReqMadeBody), "req made body", NULL},
	{POOL_REQ_COMBIN_BODY, sizeof(ReqCombBody), "req combin body", NULL},
	{POOL_REQ_DESTROY_BODY, sizeof(ReqDestroyBody), "req desctroy body", NULL},
	{POOL_REQ_CONFIG_SOL_BODY, sizeof(ReqConfigSolBody), "req config sol body", NULL},
	{POOL_REQ_EXP_BODY, sizeof(ReqExpBody), "req exp body", NULL},
	{POOL_REQ_RECOVER_BODY, sizeof(ReqRecoverBody), "req recover body", NULL},
	{POOL_REQ_USE_GENE_BODY, sizeof(ReqUseGeneBody), "req use gene body", NULL},
	{POOL_REQ_TRAN_GENE_BODY, sizeof(ReqTranGeneBody), "req transfer gene body", NULL},
	{POOL_REQ_VISIT_GENE_BODY, sizeof(ReqVisitGeneBody), "req visit gene body", NULL},
	{POOL_REQ_GIVE_BODY, sizeof(ReqGiveBody), "req give body", NULL},
	{POOL_REQ_BUY_BODY, sizeof(ReqBuyBody), "req buy body", NULL},
	{POOL_REQ_FIRE_BODY, sizeof(ReqFireBody), "req fire body", NULL},
	{POOL_REQ_CREATE_SPH_BODY, sizeof(ReqCreateSphBody), "req create sph body", NULL},
	{POOL_REQ_SHAN_SPH_BODY, sizeof(ReqShanSphBody), "req shan sph body", NULL},
	{POOL_REQ_EDIT_SPH_BODY, sizeof(ReqEditSphBody), "req edit sph body", NULL},
	{POOL_REQ_REMOVE_SPH_BODY, sizeof(ReqRemoveSphBody), "req remove sph body", NULL},
	{POOL_REQ_FIRE_MEM_BODY, sizeof(ReqFireMemBody),  "req fire mem body", NULL},
	{POOL_REQ_APPLY_JOIN_SPH_BODY, sizeof(ReqApplyJoinSphBody), "req apply join sph body", NULL},
	{POOL_REQ_TELL_APPLY_JOIN_SPH_BODY, sizeof(ReqTellApplyJoinSphBody), "req tell join sph body", NULL},
	{POOL_REQ_AWAY_SPH_BODY, sizeof(ReqAwaySphBody), "req away sph body", NULL},
	{POOL_REQ_APPLY_OFF_BODY, sizeof(ReqApplyOffBody), "req apply off body", NULL},
	{POOL_REQ_APPLY_LEAGUE_BODY, sizeof(ReqApplyLeagueBody), "req apply league body", NULL},
	{POOL_REQ_TELL_APPLY_LEAGUE_BODY, sizeof(ReqTellApplyLeagueBody), "req tell apply league body", NULL},
	{POOL_REQ_READY_WAR_BODY, sizeof(ReqReadyWarBody), "req ready war body", NULL},
	{POOL_REQ_MOVE_BODY, sizeof(ReqMoveBody), "req move body", NULL},
	{POOL_REQ_CHANGE_ZHEN_BODY, sizeof(ReqChangeZhenBody), "req change zhen body", NULL},
	{POOL_REQ_MAIL_BODY, sizeof(ReqMailBody), "req mail body", NULL},
	{POOL_REQ_TALK_BODY, sizeof(ReqTalkBody), "req talk body", NULL},
	{POOL_REQ_LEARN_BODY, sizeof(ReqLearnBody), "req learn body", NULL},
	{POOL_REQ_SYS_TRADE_BODY, sizeof(ReqSysTradeBody), "req sys trade body", NULL},
	{POOL_REQ_ORDER_BODY, sizeof(ReqOrderBody), "req order body", NULL},
	{POOL_REQ_SELL_ORDER_BODY, sizeof(ReqSellOrderBody), "req sell order body", NULL},
	{POOL_REQ_BUY_WEAP_BODY, sizeof(ReqBuyWeapBody), "req buy weap body", NULL},
	{POOL_REQ_CANCEL_ORDER_BODY, sizeof(ReqCancelOrderBody), "req cancel order body", NULL},
	{POOL_REQ_ACCEPT_TASK_BODY, sizeof(ReqAcceptTaskBody), "req accept task body", NULL},
	{POOL_REQ_BOX_BODY, sizeof(ReqBoxBody), "req box body", NULL},
	{POOL_REQ_PLUNDER_BODY, sizeof(ReqPlunderBody), "req plunder body", NULL},
	{POOL_REQ_TRAIN_BODY, sizeof(ReqTrainBody), "req train body", NULL},
	{POOL_REQ_MOVE_CITY_BODY, sizeof(ReqMoveCityBody), "req move city body", NULL},
	{POOL_REQ_PK_BODY, sizeof(ReqPkBody), "req pk body", NULL},
	{POOL_REQ_SET_FRESH_STEP_BODY, sizeof(ReqSetFreshStepBody), "req set fresh step body", NULL},
	{POOL_REQ_DONATE_TREA_BODY, sizeof(ReqDonateTreaBody), "req donate trea body", NULL},
	{POOL_REQ_DECLARE_WAR_BODY, sizeof(ReqDeclareWarBody), "req declare war body", NULL},
	{POOL_REQ_APPLY_WAR_BODY, sizeof(ReqApplyWarBody), "req apply war body", NULL},
	{POOL_REQ_EXIT_WAR_BODY, sizeof(ReqExitWarBody), "req exit war body", NULL},
	/* other */
	{POOL_TWO_ARG, sizeof(TwoArg), "two arg", NULL},
	{POOL_GAME_CONN, sizeof(GameConn), "game conn", NULL},
	{POOL_MAIL, sizeof(Mail), "mail", NULL},
	{POOL_FLEX_CONN, sizeof(FlexConn), "flex conn", NULL},
	{POOL_CMD_TRANSFER, sizeof(CmdTrans), "cmd transfer", NULL},
	{POOL_ARMY, sizeof(Army), "army", NULL},
	{POOL_USER, sizeof(User), "user", NULL},
	{POOL_DIPLOMACY, sizeof(Dipl), "diplomacy", NULL},
	{POOL_TREA, sizeof(Trea), "game treasure", NULL},
	{POOL_SPHERE, sizeof(Sph), "sphere", NULL},
	{POOL_GENERAL, sizeof(Gene), "general", NULL},
	{POOL_CITY, sizeof(City), "city", NULL},
	{POOL_WUBAO, sizeof(Wubao), "wubao", NULL},
	{POOL_KEY, sizeof(Key), "key", NULL},
	{POOL_NAME, sizeof(Name), "name", NULL},
	{POOL_TALK, sizeof(Talk), "talk", NULL},
	{POOL_ORDER, sizeof(Order), "Order", NULL},
	{POOL_SELL_ORDER, sizeof(SellOrder), "sell order", NULL},
	{POOL_TASK, sizeof(Task), "task", NULL},
	{POOL_WAR_GENE, sizeof(WarGene), "war gene", NULL},
	{POOL_WAR_ROUND, sizeof(WarRound), "war round", NULL},
	{POOL_WAR, sizeof(War), "war", NULL},
	{POOL_MNODE, sizeof(Mnode), "mem node", NULL},
	{POOL_MEM, sizeof(Mem), "mem", NULL},
    {POOL_JOB, sizeof(Job), "job", NULL},
    {POOL_ROOM, sizeof(Room), "room", NULL},
};



static PoolNode *pool_node_new()
{
	return xmalloc(sizeof(PoolNode));
}

static void pool_node_free(PoolNode *n)
{
	if(!n)
		return;

	safe_free(n->data);
	free(n);
}

static PoolNode * pool_find_used_node(Pool *p, void *ptr)
{
	if (!(p && ptr))
		return NULL;
	
	PoolNode *node = NULL;

	TAILQ_FOREACH(node, &p->used_node, link) {
		if (node->data == ptr) 
			return node;
	}
	return NULL;
}

static Pool *pool_new(int type, int item_sz, int size, const char *name)
{
	Pool *p = (Pool *)xmalloc(sizeof(Pool));
	int i = 0;
	PoolNode *node = NULL;

	if (!p) {
		return NULL;
	}
	
	TAILQ_INIT(&p->free_node);
	TAILQ_INIT(&p->used_node);
	p->type = type;
	p->item_sz = item_sz;
	p->item_num = size;
	if (name) {
		strncpy(p->name, name, POOL_NAME_LEN - 1);
	}


	for ( i = 0; i < size; ++i) {
		if (!(node = pool_node_new())) {
			pool_free(p);
			return NULL;
		}

		if (!(node->data = xmalloc(p->item_sz))) {
			free(node);
			pool_free(p);
			return NULL;
		}

		TAILQ_INSERT_HEAD(&p->free_node, node, link);
		p->free_node_num++;
	}
	return p;
}

static void pool_free(Pool *p)
{
	if (!p) {
		return ;
	}

	PoolNode *e, *t;

	TAILQ_FOREACH_SAFE(e, &p->free_node, link, t) {
		TAILQ_REMOVE(&p->free_node, e, link);
		p->free_node_num--;
		pool_node_free(e);
	}
	
	TAILQ_FOREACH_SAFE(e, &p->used_node, link, t) {
		TAILQ_REMOVE(&p->used_node, e, link);
		p->used_node_num--;
		pool_node_free(e);
	}

	free(p);
}


static PoolNode * pool_alloc_node(Pool *p)
{
	if (!p)
		return NULL;
	
	PoolNode *node = NULL;

	
	p->alloc_num ++;
	while(!(node = TAILQ_FIRST(&p->free_node))) {
		if (!(node = pool_node_new())) {
			break;
		}

		if (!(node->data = xmalloc(p->item_sz))) {
			pool_node_free(node);
			break;
		}

		TAILQ_INSERT_HEAD(&p->free_node, node, link);
		p->free_node_num++;
	}
	
	if (node == NULL) {
		p->failed_num++;
		return NULL;
	}

	TAILQ_REMOVE(&p->free_node, node, link);
	p->free_node_num--;

	TAILQ_INSERT_HEAD(&p->used_node, node, link);
	p->used_node_num++;

	return node;
}

static void pool_free_node(Pool *p, PoolNode *node)
{
	if (!(p && node)) {
		return ;
	}
	
	p->free_num++;

	TAILQ_REMOVE(&p->used_node, node, link);
	p->used_node_num--;

	TAILQ_INSERT_HEAD(&p->free_node, node, link);
	p->free_node_num++;
}

bool cache_pool_init()
{
	int num = ARRAY_LEN(g_pool_info, PoolInfo);
	int i = 0;
	Pool *p = NULL;
	PoolInfo *info = NULL;

	for (i = 0; i < num; i ++ ) {
		info = &g_pool_info[i];

		p = pool_new(info->type, info->item_sz, DEF_ITEM_NUM, info->name);
		if (!p) {
			return false;
		}
		info->pool = p;
	}
	return true;
}

void cache_pool_uninit()
{
	int num = ARRAY_LEN(g_pool_info, PoolInfo);
	int i = 0;
	Pool *p = NULL;
	PoolInfo *info = NULL;

	for (i = 0; i < num; i ++ ) {
		info = &g_pool_info[i];
		p = info->pool;
		info->pool = NULL;
		pool_free(p);
	}
	return;
}


void * cache_pool_alloc(byte type)
{
	Pool *p = NULL;
	PoolInfo *info = NULL;
	PoolNode *node = NULL;

	if (type <= POOL_NONE || type >= POOL_MAX)
		return NULL;
	info = &g_pool_info[type - 1];
	p = info->pool;
	if(!(node = pool_alloc_node(p))) {
		ERROR(LOG_FMT"failed to alloc mem for %s\n", LOG_PRE, info->name);
		return NULL;
	}
	return node->data;
}

void cache_pool_free(byte type, void *data)
{
	Pool *p = NULL;
	PoolInfo *info = NULL;
	PoolNode *node = NULL;

	if (type <= POOL_NONE || type >= POOL_MAX)
		return;
	info = &g_pool_info[type - 1];
	p = info->pool;
	node = pool_find_used_node(p, data);
	if (node) {
		pool_free_node(p, node);
		return;
	}
}


void cache_pool_dump(dstring *dst)
{
	int num = ARRAY_LEN(g_pool_info, PoolInfo);
	int i = 0;
	Pool *p = NULL;
	PoolInfo *info = NULL;


	if (!dst)
		return;
	dstring_set_big_endian(dst);
	dstring_write_int(dst, g_malloc_num);
	dstring_write_int(dst, g_free_num);
	dstring_write_int(dst, g_malloc_failed);
	dstring_write_int(dst, num);
	for (i = 0; i < num; i ++ ) {
		info = &g_pool_info[i];
		p = info->pool;
		if (!p) 
			continue;
		dstring_write_string(dst, info->name);
		dstring_write_int(dst, p->type);
		dstring_write_int(dst, p->item_sz);
		dstring_write_int(dst, p->free_node_num + p->used_node_num);
		dstring_write_int(dst, p->alloc_num);
		dstring_write_int(dst, p->free_num);
		dstring_write_int(dst, p->failed_num);
		dstring_write_int(dst, p->free_node_num);
	}
}

