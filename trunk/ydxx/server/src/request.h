#ifndef _REQUEST_H_
#define _REQUEST_H_
#include "hf.h"


typedef void (*ReqCb) (int, void *); 

enum WHERE {
	WHERE_NONE, 
	WHERE_ME,
	WHERE_SPH,
	WHERE_ALL,
};

enum RESP_TYPE{
	RESP_NONE = 0, 
	RESP_OK = 300,
	RESP_ERR,
};

enum REQ_TYPE {
	REQ_NONE = 0,
	/* c --> s */
	REQ_LOGIN = 100,
	REQ_CREATE_ROLE,
	REQ_LEVEL_UP,
	REQ_CANCEL_LEVEL_UP,
	REQ_SPEED,
	REQ_CHECK_LEVEL,
	REQ_MADE,
	REQ_COMBIN,
	REQ_DESTROY,
	REQ_CONFIG_SOL,
	REQ_EXP,
	REQ_RECOVER,
	REQ_FLUSH_GENE,
	REQ_USE_GENE,
	REQ_TRAN_GENE,
	REQ_VISIT_GENE,
	REQ_GIVE,
	REQ_BUY,
	REQ_FIRE,
	REQ_CREATE_SPH,
	REQ_SHAN_SPH,
	REQ_EDIT_SPH,
	REQ_REMOVE_SPH,
	REQ_FIRE_MEM,
	REQ_APPLY_JOIN_SPH,
	REQ_TELL_APPLY_JOIN_SPH,
	REQ_AWAY_SPH,
	REQ_APPLY_OFF,
	REQ_APPLY_LEAGUE,
	REQ_TELL_APPLY_LEAGUE,
	REQ_READY_WAR,
	REQ_MOVE,
	REQ_CHANGE_ZHEN,
	REQ_MAIL,
	REQ_TALK,
	REQ_LEARN,	
	REQ_SYS_TRADE,
	REQ_ORDER,
	REQ_SELL_ORDER,
	REQ_BUY_WEAP,
	REQ_CANCEL_ORDER,
	REQ_ACCEPT_TASK,
	REQ_CANCEL_TASK,
	REQ_CHECK_TASK,
	REQ_GET_PRIZE,
	REQ_BOX,
	REQ_WELFARE,
	REQ_PLUNDER,
	REQ_TRAIN,
	REQ_MOVE_CITY,
	REQ_PK,
	REQ_ADD_MADE,
	REQ_ADD_SOL,
	REQ_SPEED_TRAIN,
	REQ_SPEED_JUNLIN,
	REQ_BUY_JUNLIN,
	REQ_APPLY_SPH_BOSS,
	REQ_UP_KUFANG,
	REQ_SET_FRESH_STEP,
	REQ_DECLARE_WAR,
	REQ_APPLY_WAR,
	REQ_EXIT_WAR,
	/* s --> c */
	REQ_NF_OFFLINE=200,
	REQ_NF_CREATE_ROLE,
	REQ_NF_TIME,
	REQ_NF_WUBAO,
	REQ_NF_GENE, 
	REQ_NF_CITY, 
	REQ_NF_SPH,
	REQ_NF_ARMY,
	REQ_NF_USER, 
	REQ_NF_DIPL,
	REQ_NF_TREA,
	REQ_NF_WAR,
	REQ_NF_MAIL,
	REQ_NF_TALK,
	REQ_NF_CMD_TRANS,
	REQ_NF_ORDER,
	REQ_NF_SELL_ORDER,
	REQ_NF_FIGHT,
	REQ_NF_WELFARE,
	REQ_NF_ZHANYI,
	REQ_NF_GUANKA,
	REQ_NF_BOX,
	REQ_NF_ROOM,
	REQ_NF_GOTO_ROOM,
	REQ_NF_EXIT_ROOM,
	REQ_NF_END_ROOM,
	/* other */
	REQ_POOL = 900,
	REQ_DONATE_TREA,
};

struct Req {
	int total;
	int type;
	int sid;
	int mid;
	dstring body;
	int resp_code;
	GameConn *conn;
	void *bs;
	ReqCb cb;
	void *arg;
	TAILQ_ENTRY(Req) link;
};
typedef struct Req Req;

extern Req *req_new(int type, int send_id, int msg_id, const char *body, int len, GameConn *conn);
extern Req *req_new1(int type, int send_id, int msg_id, void *bs, GameConn *conn);
extern void req_free(Req *req);

extern bool req_parse(Req *req, const char *buf, int len);

extern void req_send_resp(Req *req, int code, const char *reason);
extern void req_send_resp1(Req *req, int code, const char *reason, int len);
extern void req_set_cb(Req *req, ReqCb cb, void *arg);
extern void req_to_string(Req *req, Mem *dst);

struct  ReqLoginBody {
	int ver;
};
typedef struct ReqLoginBody ReqLoginBody;

extern ReqLoginBody *req_login_body_new();
extern void req_login_body_free(void *b);
extern void * req_login_body_parse(dstring *src);

struct  ReqCreateRoleBody {
	dstring name;
	int city_id;
};
typedef struct ReqCreateRoleBody ReqCreateRoleBody;

extern ReqCreateRoleBody *req_create_role_body_new();
extern void req_create_role_body_free(void *b);
extern void * req_create_role_body_parse(dstring *src);


enum LEVEL_UP_TYPE {
	LEVEL_UP_NONE,
	LEVEL_UP_BUILD,
	LEVEL_UP_TECH,
	LEVEL_UP_MAX,
};

typedef struct {
	byte type;
	int id;
}ReqLevelUpBody;

extern ReqLevelUpBody * req_level_up_body_new();
extern void req_level_up_body_free(void *b);
extern void * req_level_up_body_parse(dstring *src);

typedef struct {
	byte type;
	int id;
}ReqCancelLevelUpBody;

extern ReqCancelLevelUpBody * req_cancel_level_up_body_new();
extern void req_cancel_level_up_body_free(void *b);
extern void * req_cancel_level_up_body_parse(dstring *src);

enum SPEED_TYPE {
	SPEED_NONE,
	SPEED_BUILD,
	SPEED_TECH,
	SPEED_TRANS,
	SPEED_MAX,
};

typedef struct {
	byte type;
	int id;
}ReqSpeedBody;

extern ReqSpeedBody * req_speed_body_new();
extern void req_speed_body_free(void *b);
extern void * req_speed_body_parse(dstring *src);


typedef struct {
	byte type;
	int num;
}ReqMadeBody;

extern ReqMadeBody * req_made_body_new();
extern void req_made_body_free(void *b);
extern void * req_made_body_parse(dstring *src);


typedef struct {
	byte type;
	int level;
	int num;
}ReqCombBody;

extern ReqCombBody * req_comb_body_new();
extern void req_comb_body_free(void *b);
extern void * req_comb_body_parse(dstring *src);

typedef struct {
	byte type;
	int level;
}ReqDestroyBody;

extern ReqDestroyBody * req_destroy_body_new();
extern void req_destroy_body_free(void *b);
extern void * req_destroy_body_parse(dstring *src);


struct ReqConfigSolBody{
	int gene_id;
	int num;
	int zhen;
	struct {
		int id;
		int level;
	}weap[GENE_WEAP_NUM];
};
typedef struct ReqConfigSolBody ReqConfigSolBody;

extern ReqConfigSolBody * req_config_sol_body_new();
extern void req_config_sol_body_free(void *b);
extern void * req_config_sol_body_parse(dstring *src);


enum EXP_TYPE {
	EXP_NONE,
	EXP_JIXI,
	EXP_NORMAL,
	EXP_TRANS_GENE,
	EXP_PLUNDER,
};

typedef struct {
	int gene_id;
	byte type;
	int day;
	uint zhen;
}ReqExpBody;

extern ReqExpBody * req_exp_body_new();
extern void req_exp_body_free(void *b);
extern void * req_exp_body_parse(dstring *src);

typedef struct {
	int gene_id;
}ReqRecoverBody;

extern ReqRecoverBody * req_recover_body_new();
extern void req_recover_body_free(void *b);
extern void * req_recover_body_parse(dstring *src);



typedef struct {
	int gene_id;
}ReqUseGeneBody;

extern ReqUseGeneBody * req_use_gene_body_new();
extern void req_use_gene_body_free(void *b);
extern void * req_use_gene_body_parse(dstring *src);

typedef struct {
	int gene_id;
	byte type;
	int to_id;
	int is_speed;
}ReqTranGeneBody;

extern ReqTranGeneBody * req_tran_gene_body_new();
extern void req_tran_gene_body_free(void *b);
extern void * req_tran_gene_body_parse(dstring *src);


typedef struct {
	int gene_id;
}ReqVisitGeneBody;

extern ReqVisitGeneBody * req_visit_gene_body_new();
extern void req_visit_gene_body_free(void *b);
extern void * req_visit_gene_body_parse(dstring *src);

enum REQ_GIVE_TYPE {
	REQ_GIVE_YES = 1,
	REQ_GIVE_NO,
	REQ_GIVE_USE,
};

typedef struct {
	int type;
	int gene_id;
	int tid;
}ReqGiveBody;

extern ReqGiveBody * req_give_body_new();
extern void req_give_body_free(void *b);
extern void * req_give_body_parse(dstring *src);


typedef struct {
	int trea_id;
}ReqBuyBody;

extern ReqBuyBody * req_buy_body_new();
extern void req_buy_body_free(void *b);
extern void * req_buy_body_parse(dstring *src);


typedef struct {
	int gene_id;
}ReqFireBody;

extern ReqFireBody * req_fire_body_new();
extern void req_fire_body_free(void *b);
extern void * req_fire_body_parse(dstring *src);


typedef struct {
	dstring name;
	dstring desc;
}ReqCreateSphBody;

extern ReqCreateSphBody * req_create_sph_body_new();
extern void req_create_sph_body_free(void *b);
extern void * req_create_sph_body_parse(dstring *src);

typedef struct {
	int sph_id;
	int recv_uid;
}ReqShanSphBody;

extern ReqShanSphBody * req_shan_sph_body_new();
extern void req_shan_sph_body_free(void *b);
extern void * req_shan_sph_body_parse(dstring *src);


typedef struct {
	int sph_id;
	dstring desc;
}ReqEditSphBody;

extern ReqEditSphBody *req_edit_sph_body_new();
extern void req_edit_sph_body_free(void *b);
extern void *req_edit_sph_body_parse(dstring *src);

typedef struct {
	int sph_id;
}ReqRemoveSphBody;

extern ReqRemoveSphBody * req_remove_sph_body_new();
extern void req_remove_sph_body_free(void *b);
extern void * req_remove_sph_body_parse(dstring *src);


typedef struct {
	int sph_id;
	int uid;
}ReqFireMemBody;

extern ReqFireMemBody * req_fire_mem_body_new();
extern void req_fire_mem_body_free(void *b);
extern void * req_fire_mem_body_parse(dstring *src);


typedef struct {
	int sph_id;
}ReqApplyJoinSphBody;

extern ReqApplyJoinSphBody * req_apply_join_sph_body_new();
extern void req_apply_join_sph_body_free(void *b);
extern void * req_apply_join_sph_body_parse(dstring *src);

typedef struct {
	int uid;
	byte is_agree;
}ReqTellApplyJoinSphBody;

extern ReqTellApplyJoinSphBody * req_tell_apply_join_sph_body_new();
extern void req_tell_apply_join_sph_body_free(void *b);
extern void * req_tell_apply_join_sph_body_parse(dstring *src);


typedef struct {
	int sph_id;
}ReqAwaySphBody;

extern ReqAwaySphBody *req_away_sph_body_new();
extern void req_away_sph_body_free(void *b);
extern void * req_away_sph_body_parse(dstring *src);

typedef struct {
	int sph_id;
	int off_id;
}ReqApplyOffBody;

extern ReqApplyOffBody * req_apply_off_body_new();
extern void req_apply_off_body_free(void *b);
extern void * req_apply_off_body_parse(dstring *src);

typedef struct {
	int sph_id;
	int target_sph_id;
	int year;
}ReqApplyLeagueBody;

extern ReqApplyLeagueBody * req_apply_league_body_new();
extern void req_apply_league_body_free(void *b);
extern void * req_apply_league_body_parse(dstring *src);


typedef struct {
	int sph_id;
	int year;
	byte is_agree;
}ReqTellApplyLeagueBody;

extern ReqTellApplyLeagueBody * req_tell_apply_league_body_new();
extern void req_tell_apply_league_body_free(void *b);
extern void * req_tell_apply_league_body_parse(dstring *src);


typedef struct {
	int sph_id;
	int target_sph_id;
}ReqReadyWarBody;

extern ReqReadyWarBody * req_ready_war_body_new();
extern void req_ready_war_body_free(void *b);
extern void * req_ready_war_body_parse(dstring *src);


enum MOVE_TARGET {
	MOVE_TO_WUBAO = 1,
	MOVE_TO_CITY,
	MOVE_TO_WAR,
};

typedef struct {
	int aid;
	byte target;
	int city_id;
	TAILQ_HEAD(, Pos) pos;
}ReqMoveBody;

extern ReqMoveBody * req_move_body_new();
extern void req_move_body_free(void *b);
extern void * req_move_body_parse(dstring *src);

typedef struct {
	int aid;
	int zhen;
}ReqChangeZhenBody;

extern ReqChangeZhenBody * req_change_zhen_body_new();
extern void req_change_zhen_body_free(void *b);
extern void * req_change_zhen_body_parse(dstring *src);

typedef struct {
	int uid;
	int type;
	dstring title;
	dstring content;
}ReqMailBody;

extern ReqMailBody * req_mail_body_new();
extern void req_mail_body_free(void *b);
extern void * req_mail_body_parse(dstring *src);

typedef struct {
	int uid;
	int target_uid;
	dstring msg;
}ReqTalkBody;

extern ReqTalkBody * req_talk_body_new();
extern void req_talk_body_free(void *b);
extern void * req_talk_body_parse(dstring *src);


typedef struct {
	int gene_id;
	byte type;
	byte id;
}ReqLearnBody;


extern ReqLearnBody * req_learn_body_new();
extern void req_learn_body_free(void *b);
extern void * req_learn_body_parse(dstring *src);


enum TRADE_TYPE {
	TRADE_NONE,
	TRADE_BUY,
	TRADE_SELL,
};

typedef struct {
	int type;
	int res;
	int num;
}ReqSysTradeBody;

extern ReqSysTradeBody * req_sys_trade_body_new();
extern void req_sys_trade_body_free(void *b);
extern void *req_sys_trade_body_parse(dstring *src);

typedef struct {
	int type;
	int res;
	int num;
	int unit_money;
}ReqOrderBody;

extern ReqOrderBody * req_order_body_new();
extern void req_order_body_free(void *b);
extern void *req_order_body_parse(dstring *src);



typedef struct {
	int weap_id;
	int weap_level;
	int num;
	int gold;
}ReqSellOrderBody;

extern ReqSellOrderBody * req_sell_order_body_new();
extern void req_sell_order_body_free(void *b);
extern void *req_sell_order_body_parse(dstring *src);

typedef struct {
	int oid;
}ReqBuyWeapBody;

extern ReqBuyWeapBody * req_buy_weap_body_new();
extern void req_buy_weap_body_free(void *b);
extern void *req_buy_weap_body_parse(dstring *src);

enum ORDER_TYPE {
	ORDER_NONE,
	ORDER_NORM,
	ORDER_SPEC,
};

typedef struct {
	int type;
	int oid;
}ReqCancelOrderBody;

extern ReqCancelOrderBody * req_cancel_order_body_new();
extern void req_cancel_order_body_free(void *b);
extern void *req_cancel_order_body_parse(dstring *src);


typedef struct {
	int id;
}ReqAcceptTaskBody;

extern ReqAcceptTaskBody * req_accept_task_body_new();
extern void req_accept_task_body_free(void *b);
extern void *req_accept_task_body_parse(dstring *src);

#define MAX_BOX_GENE 10

typedef struct {
	int level;
	int gene_num;
	int gene_id[MAX_BOX_GENE];
}ReqBoxBody;

extern ReqBoxBody * req_box_body_new();
extern void req_box_body_free(void *b);
extern void *req_box_body_parse(dstring *src);


typedef struct {
	int to_uid;
	int res[RES_MAX - 1];
}ReqPlunderBody;

extern ReqPlunderBody * req_plunder_body_new();
extern void req_plunder_body_free(void *b);
extern void *req_plunder_body_parse(dstring *src);



typedef struct {
	int gene_id;
	int is_double;
}ReqTrainBody;

extern ReqTrainBody * req_train_body_new();
extern void req_train_body_free(void *b);
extern void *req_train_body_parse(dstring *src);


typedef struct {
	int city_id;
}ReqMoveCityBody;

extern ReqMoveCityBody * req_move_city_body_new();
extern void req_move_city_body_free(void *b);
extern void *req_move_city_body_parse(dstring *src);

typedef struct {
	int uid;
}ReqPkBody;

extern ReqPkBody * req_pk_body_new();
extern void req_pk_body_free(void *b);
extern void *req_pk_body_parse(dstring *src);

typedef struct {
	int step;
}ReqSetFreshStepBody;


extern ReqSetFreshStepBody * req_set_fresh_step_body_new();
extern void req_set_fresh_step_body_free(void *b);
extern void *req_set_fresh_step_body_parse(dstring *src);


typedef struct {
	int uid;
	int trea_id;
}ReqDonateTreaBody;


extern ReqDonateTreaBody * req_donate_trea_body_new();
extern void req_donate_trea_body_free(void *b);
extern void *req_donate_trea_body_parse(dstring *src);

typedef struct {
	int city_id;
}ReqDeclareWarBody;


extern ReqDeclareWarBody * req_declare_war_body_new();
extern void req_declare_war_body_free(void *b);
extern void *req_declare_war_body_parse(dstring *src);

typedef struct {
	int room_id;
}ReqApplyWarBody;


extern ReqApplyWarBody * req_apply_war_body_new();
extern void req_apply_war_body_free(void *b);
extern void *req_apply_war_body_parse(dstring *src);

typedef struct {
	int room_id;
}ReqExitWarBody;


extern ReqExitWarBody * req_exit_war_body_new();
extern void req_exit_war_body_free(void *b);
extern void *req_exit_war_body_parse(dstring *src);

/*
 *  s --> c
 */

/* offline nf */
extern void send_nf_offline(GameConn * c);

/* create role nf */
extern dstring * req_nf_create_role_body_new(byte is_goto_create);

extern void send_nf_create_role(byte is_goto_create, GameConn * c);

/* time nf */
extern dstring * req_nf_time_body_new(int t);

extern void send_nf_time(int t, GameConn *c);

extern void send_nf_time_where(int t, int where);
/* wubao nf */
extern dstring * req_nf_wubao_body_new(Wubao *w);

extern void send_nf_wubao(Wubao *w, GameConn *c);

extern void send_nf_wubao_where(Wubao *w, int where);

/* nf gene */
extern dstring * req_nf_gene_body_new(Gene *gene);

extern void send_nf_gene(Gene *gene, GameConn *c);

extern void send_nf_gene_where(Gene *gene, int where);

/* nf city */
extern dstring * req_nf_city_body_new(City *city);

extern void send_nf_city(City *city, GameConn *c);

extern void send_nf_city_where(City *city, int where);

/* nf sph */
extern dstring * req_nf_sph_body_new(Sph *sph);

extern void send_nf_sph(Sph *sph, GameConn *c);

extern void send_nf_sph_where(Sph *sph, int where);

/* nf army */
extern dstring * req_nf_army_body_new(Army *army);

extern void send_nf_army(Army *a, GameConn *c);

extern void send_nf_army_where(Army *a, int where);

/* nf user */
extern dstring * req_nf_user_body_new(User *u);

extern void send_nf_user(User *u, GameConn *c);

extern void send_nf_user_where(User *u, int where);
/* nf dipl */
extern dstring * req_nf_dipl_body_new(Dipl *dipl);

extern void send_nf_dipl(Dipl *dipl, GameConn *c);

extern void send_nf_dipl_where(Dipl *dipl, int where);

/* nf trea */
extern dstring *req_nf_trea_body_new(Trea *t);

extern void send_nf_trea(Trea *t, GameConn *c);

extern void send_nf_trea_where(Trea *t, int where);

/* nf war */

#define WAR_WILD 1

#define WAR_CITY 2

extern dstring *req_nf_war_body_new(byte type, int id1, int dead1, int hurt1, int exp1, int id2, int dead2, int hurt2, int exp2, float def);

extern void send_nf_war(int type, int id1, int dead1, int hurt1, int exp1, int id2, int dead2, int hurt2, int exp2, float def, GameConn *c);

extern void send_nf_war_where(int type, int id1, int dead1, int hurt1, int exp1, int id2, int dead2, int hurt2, int exp2, float def, int where);

/* nf mail */

extern dstring *req_nf_mail_body_new(Mail *m);

extern void send_nf_mail(Mail *m, GameConn *c);

extern void send_nf_mail_where(Mail *m, int where);


extern dstring *req_nf_talk_body_new(Talk *t);

extern void send_nf_talk(Talk *t, GameConn *c);

extern void send_nf_talk_where(Talk *t, int where);


/* nf cmd trans */
extern dstring * req_nf_cmd_trans_body_new(CmdTrans *cmd);

extern void send_nf_cmd_trans(CmdTrans *cmd, GameConn *c);

extern void send_nf_cmd_trans_where(CmdTrans *cmd, int wh);

/* nf order */
extern dstring * req_nf_order_body_new(Order *o);

extern void send_nf_order(Order *o, GameConn *c);

extern void send_nf_order_where(Order *o, int wh);

/* nf sell order */
extern dstring * req_nf_sell_order_body_new(SellOrder *o);

extern void send_nf_sell_order(SellOrder *o, GameConn *c);

extern void send_nf_sell_order_where(SellOrder *o, int wh);

/* nf fight war */
extern dstring * req_nf_fight_body_new(War *war);

extern void send_nf_fight(War *war, GameConn *c);

extern void send_nf_fight_where(War *war, int wh);

/* nf welfare */
extern dstring * req_nf_welfare_body_new(int res[RES_MAX - 1], int gold);

extern void send_nf_welfare(int res[RES_MAX - 1], int gold, GameConn *c);

extern void send_nf_welfare_where(int res[RES_MAX - 1], int gold, int wh);

/* nf zhanyi */
extern dstring * req_nf_zhanyi_body_new(Zhanyi *p);

extern void send_nf_zhanyi(Zhanyi *p, GameConn *c);

extern void send_nf_zhanyi_where(Zhanyi *p, int wh);

/* nf guanka */
extern dstring * req_nf_guanka_body_new(Guanka *p);

extern void send_nf_guanka(Guanka *p, GameConn *c);

extern void send_nf_guanka_where(Guanka *p, int wh);

/* nf box */
extern dstring * req_nf_box_body_new(Box *p);

extern void send_nf_box(Box *p, GameConn *c);

extern void send_nf_box_where(Box *p, int wh);

/* nf room */
extern dstring * req_nf_room_body_new(Room *p);

extern void send_nf_room(Room *p, GameConn *c);

extern void send_nf_room_where(Room *p, int wh);

/* nf goto room */
extern dstring * req_nf_goto_room_body_new(Room *p, int uid);

extern void send_nf_goto_room(Room *p, int uid, GameConn *c);

extern void send_nf_goto_room_where(Room *p, int uid, int wh);

/* nf exit room */
extern dstring * req_nf_exit_room_body_new(Room *p, int uid);

extern void send_nf_exit_room(Room *p, int uid, GameConn *c);

extern void send_nf_exit_room_where(Room *p, int uid, int wh);

/* nf end room */
extern dstring * req_nf_end_room_body_new(Room *p);

extern void send_nf_end_room(Room *p, GameConn *c);

extern void send_nf_end_room_where(Room *p, int wh);
#endif

