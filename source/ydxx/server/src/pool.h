#ifndef _POOL_H_
#define _POOL_H_

enum POOL_TYPE {
	POOL_NONE = 0,
	POOL_HEADER_ENTRY,
	POOL_HTTP_STATU,
	POOL_HTTP_RESP,
	POOL_HTTP_REQ,
	POOL_HTTP_CONN,
	POOL_HTTP_URL,
	POOL_EV,
	POOL_POS,
	POOL_TIME_POS,
	/* req */
	POOL_REQ,
	POOL_REQ_LOGIN_BODY,
	POOL_REQ_CREATE_ROLE_BODY,
	POOL_REQ_LEVEL_UP_BODY,
	POOL_REQ_CANCEL_LEVEL_UP_BODY,
	POOL_REQ_SPEED_BODY,
	POOL_REQ_MADE_BODY,
	POOL_REQ_COMBIN_BODY,
	POOL_REQ_DESTROY_BODY,
	POOL_REQ_CONFIG_SOL_BODY,
	POOL_REQ_EXP_BODY,
	POOL_REQ_RECOVER_BODY,
	POOL_REQ_USE_GENE_BODY,
	POOL_REQ_TRAN_GENE_BODY,
	POOL_REQ_VISIT_GENE_BODY,
	POOL_REQ_GIVE_BODY,
	POOL_REQ_BUY_BODY,
	POOL_REQ_FIRE_BODY,
	POOL_REQ_CREATE_SPH_BODY,
	POOL_REQ_SHAN_SPH_BODY,
	POOL_REQ_EDIT_SPH_BODY,
	POOL_REQ_REMOVE_SPH_BODY,
	POOL_REQ_FIRE_MEM_BODY,
	POOL_REQ_APPLY_JOIN_SPH_BODY,
	POOL_REQ_TELL_APPLY_JOIN_SPH_BODY,
	POOL_REQ_AWAY_SPH_BODY,
	POOL_REQ_APPLY_OFF_BODY,
	POOL_REQ_APPLY_LEAGUE_BODY,
	POOL_REQ_TELL_APPLY_LEAGUE_BODY,
	POOL_REQ_READY_WAR_BODY,
	POOL_REQ_MOVE_BODY,
	POOL_REQ_CHANGE_ZHEN_BODY,
	POOL_REQ_MAIL_BODY,
	POOL_REQ_TALK_BODY,
	POOL_REQ_LEARN_BODY,	
	POOL_REQ_SYS_TRADE_BODY,
	POOL_REQ_ORDER_BODY,
	POOL_REQ_SELL_ORDER_BODY,
	POOL_REQ_BUY_WEAP_BODY,
	POOL_REQ_CANCEL_ORDER_BODY,
	POOL_REQ_ACCEPT_TASK_BODY,
	POOL_REQ_BOX_BODY,
	POOL_REQ_PLUNDER_BODY,
	POOL_REQ_TRAIN_BODY,
	POOL_REQ_MOVE_CITY_BODY,
	POOL_REQ_PK_BODY,
	POOL_REQ_SET_FRESH_STEP_BODY,
	POOL_REQ_DONATE_TREA_BODY,
	POOL_REQ_DECLARE_WAR_BODY,
	POOL_REQ_APPLY_WAR_BODY,
	POOL_REQ_EXIT_WAR_BODY,
	/* other */
	POOL_TWO_ARG,
	POOL_GAME_CONN,
	POOL_MAIL,
	POOL_FLEX_CONN,
	POOL_CMD_TRANSFER,
	POOL_ARMY,
	POOL_USER,
	POOL_DIPLOMACY,
	POOL_TREA,
	POOL_SPHERE,
	POOL_GENERAL,
	POOL_CITY,
	POOL_WUBAO,
	POOL_KEY,
	POOL_NAME,
	POOL_TALK,
	POOL_ORDER,
	POOL_SELL_ORDER,
	POOL_TASK,
	POOL_WAR_GENE,
	POOL_WAR_ROUND,
	POOL_WAR,
	POOL_MNODE,
	POOL_MEM,
    POOL_JOB,
    POOL_ROOM,
	POOL_MAX,
};

extern bool cache_pool_init();
extern void cache_pool_uninit();
extern void cache_pool_reset();

extern void *cache_pool_alloc(byte type);
extern void cache_pool_free(byte type, void *p);

extern void cache_pool_dump(dstring *dst);

#endif
