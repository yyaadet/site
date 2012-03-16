#ifndef _GAMEROOM_H_
#define _GAMEROOM_H_
#include "common.h"
#include "city.h"
#include "general.h"
#include "army.h"
#include "diplomacy.h"
#include "sphere.h"
#include "user.h"
#include "treasure.h"
#include "cmd.h"
#include "wubao.h"
#include "trade.h"
#include "task.h"
#include "box.h"
#include "cron.h"
#include "room.h"

#define VIP_GENE_MIN_PROP 75
#define VIP_GENE_MAX_PROP 85
#define NOR_GENE_MIN_PROP 70
#define NOR_GENE_MAX_PROP 80
#define WILD_GENE_LEN 5

enum GAME_INIT_STATE {
	GAME_INIT_NONE = 0,
	GAME_INIT_TASK,
	GAME_INIT_SHOP,
	GAME_INIT_USER, 
	GAME_INIT_SPHERE, 
	GAME_INIT_CITY, 
	GAME_INIT_WUBAO,
	GAME_INIT_GENE, 
	GAME_INIT_ARMY, 
	GAME_INIT_TREA, 
	GAME_INIT_DIPL,
	GAME_INIT_CMD_TRANSFER, 
	GAME_INIT_ORDER,
	GAME_INIT_SELL_ORDER,
	GAME_INIT_ZHANYI,
	GAME_INIT_GUANKA,
	GAME_INIT_BOX,
	GAME_INIT_ROOM,
	GAME_INIT_FIN,
};

extern int game_trea_info_map_cmp(TreaInfo*p1, TreaInfo*p2);

extern int game_city_map_cmp(City *p1, City *p2);

extern int game_gene_map_cmp(Gene *p1, Gene *p2);

extern int game_army_map_cmp(Army *p1, Army *p2);

extern int game_sph_map_cmp(Sph *p1, Sph *p2);

extern int game_user_map_cmp(User *p1, User *p2);

extern int game_treasure_map_cmp(Trea *p1, Trea *p2);

extern int game_dipl_map_cmp(Dipl *p1, Dipl *p2);

extern int game_cmd_transfer_map_cmp(CmdTrans *p1, CmdTrans *p2);

extern int game_wubao_map_cmp(Wubao *w1, Wubao *w2);

extern int game_order_map_cmp(Order *o1, Order *o2);

extern int game_sell_order_map_cmp(SellOrder *o1, SellOrder *o2);

extern int game_task_map_cmp(Task *t1, Task *t2);

extern int game_box_map_cmp(Box *p1, Box *p2);

extern int game_guanka_map_cmp(Guanka *p1, Guanka *p2);

extern int game_zhanyi_map_cmp(Zhanyi *p1, Zhanyi *p2);

extern int game_room_map_cmp(Room *p1, Room *p2);



RB_HEAD(GameTreaInfoMap, TreaInfo);
RB_PROTOTYPE(GameTreaInfoMap, TreaInfo,  tlink, game_trea_info_map_cmp);

RB_HEAD(GameCityMap, City);
RB_PROTOTYPE(GameCityMap, City,  tlink, game_city_map_cmp);

RB_HEAD(GameGeneMap, Gene);
RB_PROTOTYPE(GameGeneMap, Gene, tlink, game_gene_map_cmp);

RB_HEAD(GameArmyMap, Army);
RB_PROTOTYPE(GameArmyMap, Army, tlink, game_army_map_cmp);

RB_HEAD(GameSphMap, Sph);
RB_PROTOTYPE(GameSphMap, Sph, tlink, game_sph_map_cmp);


RB_HEAD(GameUserMap, User);
RB_PROTOTYPE(GameUserMap, User, tlink, game_user_map_cmp);

RB_HEAD(GameTreaMap, Trea);
RB_PROTOTYPE(GameTreaMap, Trea, tlink, game_trea_map_cmp);


RB_HEAD(GameDiplMap, Dipl);
RB_PROTOTYPE(GameDiplMap, Dipl, tlink, game_dipl_map_cmp);


RB_HEAD(GameCmdPolicyMap, CmdPolicy);
RB_PROTOTYPE(GameCmdPolicyMap, CmdPolicy, tlink, game_cmd_policy_map_cmp);


RB_HEAD(GameCmdTransferMap, CmdTrans);
RB_PROTOTYPE(GameCmdTransferMap, CmdTrans, tlink, game_cmd_transfer_map_cmp);


RB_HEAD(GameWubaoMap, Wubao);
RB_PROTOTYPE(GameWubaoMap, Wubao, tlink, game_wubao_map_cmp);

RB_HEAD(GameOrderMap, Order);
RB_PROTOTYPE(GameOrderMap, Order, tlink, game_order_map_cmp);

RB_HEAD(GameSellOrderMap, SellOrder);
RB_PROTOTYPE(GameSellOrderMap, SellOrder, tlink, game_sell_order_map_cmp);


RB_HEAD(GameTaskMap, Task);
RB_PROTOTYPE(GameTaskMap, Task, tlink, game_task_map_cmp);

RB_HEAD(GameBoxMap, Box);
RB_PROTOTYPE(GameBoxMap, Box, tlink, game_box_map_cmp);

RB_HEAD(GameGuankaMap, Guanka);
RB_PROTOTYPE(GameGuankaMap, Guanka, tlink, game_guanka_map_cmp);

RB_HEAD(GameZhanyiMap, Zhanyi);
RB_PROTOTYPE(GameZhanyiMap, Zhanyi, tlink, game_zhanyi_map_cmp);

RB_HEAD(GameRoomMap, Room);
RB_PROTOTYPE(GameRoomMap, Room, tlink, game_room_map_cmp);

struct Game {
	/*
	 * for init 
	 */
	byte init_state;
	int start;

	int time;

	unsigned trea_info_total;
	unsigned city_total ;
	unsigned gene_total ;
	unsigned army_total;
	unsigned sph_total ;
	unsigned user_total;
	unsigned trea_total ;
	unsigned dipl_total;
	unsigned cmd_transfer_total ;
	unsigned wubao_total;
	unsigned order_total;
	unsigned sell_order_total;
	unsigned task_total;
	unsigned box_total;
	unsigned guanka_total;
    unsigned zhanyi_total;
    unsigned room_total;

	unsigned trea_info_num;
	unsigned city_num ;
	unsigned gene_num ;
	unsigned army_num;
	unsigned sph_num ;
	unsigned user_num;
	unsigned trea_num ;
	unsigned dipl_num;
	unsigned cmd_transfer_num ;
	unsigned wubao_num;
	unsigned order_num;
	unsigned sell_order_num;
	unsigned task_num;
	unsigned box_num;
	unsigned guanka_num;
	unsigned zhanyi_num;
    unsigned room_num;

	int max_army_id;
	int max_gene_id;
	int max_sph_id;
	int max_face_id;
	int max_stage_id;
	int max_city_id;
	int max_cmd_trans_id;
	int max_order_id;
	int max_sell_order_id;
    int max_room_id;
	int rank[MAX_RANK];

	struct GameTreaInfoMap trea_infos;
	struct GameCityMap cities;
	struct GameGeneMap genes;
	struct GameArmyMap armies;
	struct GameSphMap sphs;
	struct GameUserMap  users;
	struct GameTreaMap treas;
	struct GameDiplMap dipls;
	struct GameCmdTransferMap cmd_trans;
	struct GameWubaoMap wubaos;
	struct GameOrderMap orders;
	struct GameSellOrderMap sell_orders;
	struct GameTaskMap tasks;
	struct GameBoxMap boxes;
	struct GameGuankaMap guankas;
	struct GameZhanyiMap zhanyis;
	struct GameRoomMap rooms;

	struct NameMap user_names;
	struct NameMap sph_names;

	KeyList res_buy_orders[RES_MAX - 1];
	KeyList res_sell_orders[RES_MAX - 1];

	int job_num;
	TAILQ_HEAD(, Job) jobs;
};
typedef struct Game Game;

extern Game * game_new(void);
extern void game_free(Game *game);

extern void game_flush(Game *game);

extern void game_init(Game *game);

extern bool game_is_unified(Game *game);

extern void game_end(Game *g);

extern TreaInfo * game_find_trea_info(Game *g, int id);
extern bool game_add_trea_info(Game *g, TreaInfo *t);
extern bool game_del_trea_info(Game *g, TreaInfo *t);


extern City *game_find_city(Game *g, int city_id);
extern bool  game_add_city(Game *g, City *city);
extern City *game_get_city_is_alloted(Game *g, int alloted);
extern City *game_find_city_by_pos(Game *g, int x, int y);
extern City *game_get_random_city(Game *g);


extern Sph *game_find_sph_by_uid(Game *g, int id);
extern Sph *game_find_sph(Game *g, int id);
extern Sph *game_find_sph_by_name(Game *g, const char  *name);
extern bool game_add_sph(Game *g, Sph *sph);
extern bool game_del_sph(Game *g, Sph *sph);

extern Army * game_find_army(Game *g, int id);
extern Army * game_find_army_by_xy(Game *g, int x, int y);
extern bool  game_add_army(Game *g, Army *army);
extern bool  game_del_army(Game *g, Army * army);

extern bool game_add_gene(Game *g, Gene *gene);
extern bool game_del_gene(Game *g, Gene *gene);
extern Gene *game_find_gene(Game *g, int gene_id);
extern Gene *game_get_wild_gene_for_wubao(Game *g, Wubao *w);
extern Gene *game_find_max_gene(Game *g);
extern void game_update_gene_for_wubao(Game *g, Gene *gene, Wubao *w);
extern Gene *game_gen_new_gene(Game *g, Wubao *w);

extern User *game_find_user(Game *g, int uid);
extern User *game_find_user_by_sphere_id(Game *g, int sph_id);
extern User *game_find_user_by_name(Game *g, const char *name);
extern bool  game_add_user(Game *g, User *u);
extern bool  game_del_user(Game *g, User *u);

extern bool game_add_trea(Game *g, Trea * t);
extern bool game_del_trea(Game *g, Trea *t);
extern Trea * game_find_trea(Game *g, int id);

extern bool game_add_dipl(Game *g, Dipl *dipl);
extern Dipl *game_find_dipl(Game *g, int id);
extern bool game_del_dipl(Game *g, Dipl *dipl);


extern bool game_add_cmd_trans(Game *g, CmdTrans *cmd);
extern bool game_del_cmd_trans(Game *g, CmdTrans *cmd);
extern CmdTrans *game_find_cmd_trans(Game *g, int id);


extern bool game_add_wubao(Game *g, Wubao *w);
extern bool game_del_wubao(Game *g, Wubao *w);
extern Wubao * game_find_wubao(Game *g, int id);
extern Wubao * game_find_wubao_by_uid(Game *g, int id);


extern bool game_add_order(Game *g, Order *o);
extern bool game_del_order(Game *g, Order *o);
extern Order * game_find_order(Game *g, int id);

extern bool game_add_sell_order(Game *g, SellOrder *o);
extern bool game_del_sell_order(Game *g, SellOrder *o);
extern SellOrder * game_find_sell_order(Game *g, int id);

extern bool game_add_task(Game *g, Task *t);
extern bool game_del_task(Game *g, Task *t);
extern Task * game_find_task(Game *g, int id);

extern bool game_add_box(Game *g, Box *b);
extern bool game_del_box(Game *g, Box *b);
extern Box * game_find_box(Game *g, int id);

extern bool game_add_guanka(Game *g, Guanka *b);
extern bool game_del_guanka(Game *g, Guanka *b);
extern Guanka * game_find_guanka(Game *g, int id);

extern bool game_add_zhanyi(Game *g, Zhanyi *b);
extern bool game_del_zhanyi(Game *g, Zhanyi *b);
extern Zhanyi * game_find_zhanyi(Game *g, int id);

extern bool game_add_room(Game *g, Room *b);
extern bool game_del_room(Game *g, Room *b);
extern Room * game_find_room(Game *g, int id);
extern void game_find_room_num_by_uid(Game *g, int uid, int *attack_num, int *defense_num);
extern Room * game_find_room_by_city_id(Game *g, int city_id);
extern Room * game_find_room_by_attack_sph_id(Game *g, int sph_id);
extern int game_find_room_num_by_defense_sph_id(Game *g, int sph_id);

extern void game_rerank(Game *g);
extern int game_get_rank(Game *g);
extern bool game_alloc_rank(Game *g, Wubao *w);
extern void game_trans_rank(Game *g, Wubao *w, Wubao *w1);

extern bool game_add_job(Game *g, Job *p);

extern void game_reset_wubao(Game *g, Wubao *w);

extern void parse_all_user(const char *data, int len, void *arg, int code);

extern void parse_all_wubao(const char *data, int len, void *arg, int code);

#endif

