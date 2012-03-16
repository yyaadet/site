#ifndef _LUAAPI_H_
#define _LUAAPI_H_
#include "army.h"
#include "general.h"
#include "box.h"

struct ReqConfigSolBody;

struct LuaScript {
	struct lua_State *state;
	dstring path;
};
typedef struct LuaScript LuaScript;

extern LuaScript *lua_script_new();
extern void lua_script_free(LuaScript *lua);
extern bool lua_script_load(LuaScript *lua, const char *path);

/*
 * war 
 */
extern bool lua_get_war_city(Army *a, Gene *gene, City *city, Gene *gene1,\
		int *dead1, int *hurt1, int *skill1, float *spirit1, float *train1, \
		int *dead2, int *hurt2, int *skill2, float *spirit2, float *train2, float *defense);

extern bool lua_get_war_army(int r1, Gene *gene1, int r2, Gene *gene2, \
		int *dead1, int *hurt1, int *skill1, float *spirit1, float *train1,\
		int *dead2, int *hurt2, int *skill2, float *spirit2, float *train2);

extern bool lua_get_war_army2(WarGene *gene1, WarGene *gene2, \
		int *dead1, int *hurt1, int *skill1, float *spirit1, float *train1,\
		int *dead2, int *hurt2, int *skill2, float *spirit2, float *train2);

extern bool lua_get_army_speed(Gene *gene, int type, int *speed);

extern bool lua_get_war_time(float *h);

/*
  * wubao
  * res: lenght is 6
  */
extern bool lua_get_wubao_change(Wubao *w, int *res, int *peole, int *family, int *sol, int *dig, int *max_gene, int *made, int *cure);

//general
extern bool lua_get_gene_wubao(Gene *gene, Wubao *w, User *u, int *money, int *food, float *faith, int *fol, float *spi, float *tra, int *sol);

extern bool lua_get_gene_army(Gene *gene, Army *a, Wubao *w, User *u, int *money, int *food, float *faith, int *fol, float *spi, float *tra, int *sol);

//sphere
extern bool lua_get_sphere_change(Sph *sph, int *level, int *max_member);

extern bool lua_level_up(Wubao *w, int up_type, int up_id, int *is_allow, int *res, int *h);

extern bool lua_made(Wubao *w, int id, int num, int *is_allow, int *res, int *made);

extern bool lua_destroy(int type, int level, int num, int *money);

extern bool lua_comb(Wubao *w, int id, int level, int num, int *is_allow, int *ret_level, int *ret_num);

/* num length is GENE_WEAP_NUM */
extern bool lua_config_sol(struct ReqConfigSolBody *b, int *is_allow, int *num);

extern bool lua_get_sol_per_weapon(int weap_id, int *sol_num);

extern bool lua_exp(int money, int food, int type, int day, int num, int *is_allow, int *need_money, int *need_food);

extern bool lua_recover(Wubao *w, int num, int *rec);

extern bool lua_use_gene(Wubao *w, int type, int fri, int min_fri, int *is_allow);

extern bool lua_create_sph(Wubao *w, int *is_agree);

extern bool lua_join_sph(Sph *sph, Wubao *w, int *is_agree);

extern bool lua_apply_official(Wubao *w, int off_id, int *is_agree);

/* stage */
extern bool lua_get_learn(Gene *gene, Wubao *w, int type, int id, int *is_allow, int *need_kill);

/* w length is 4 */
extern bool lua_get_sol_prop(struct GeneWeap *w, int zhen, int *move_dis, int *attack_dis);

/* weap leagth is 4 */
extern bool lua_get_sol_weap(int sol_id, struct GeneWeap *weap);

extern bool lua_sys_trade(Wubao *w, int type, int res, int num, int *succ, int *money);

extern bool lua_get_grid(Wubao *w, int *num);

extern bool lua_get_init_gene(int is_vip, int *kongfu, int *intel, int *polity, int *skill);

/* res num is MAX_RES - 1 */
extern bool lua_get_welfare(Wubao *w, int *is_allow, int *res, int *gold);

extern bool lua_get_plunder(Wubao *to, int req_res[RES_MAX - 1], int sol, int res[RES_MAX - 1], int *cd);

extern bool lua_get_view(int type, int *need_hour, int *prestige, int *money, int *gold);

extern bool lua_get_prac_gold(int *prac_num, int *gold);

extern bool lua_move_city(int *gold);

extern bool lua_get_building_queue(Wubao *w, int *queue);

extern bool lua_get_tech_queue(Wubao *w, int *queue);

extern bool lua_add_made(int *num, int *gold);

extern bool lua_add_sol(int *num, int *gold);

extern bool lua_get_speed_gold(int hour, int *gold);

extern bool lua_get_war_speed_gold(int hour, int *gold);

extern bool lua_get_pk_info(int *cd);

extern bool lua_get_train_info(Wubao *w, Gene *gene, int is_double, int *percent, int *level, int *gold, int *cd);

extern bool lua_get_jl_info(int *gold, int *num);

extern bool lua_become_boss(Wubao *old, Wubao *me, int *is_allow);

extern bool lua_update_gene_for_fresh(Gene *gene);

extern bool lua_level_up_kufang(Wubao *w, int *gold, int *is_allow);

extern bool lua_lost_weap(Wubao *w, int perc, int *is_yes);

extern bool lua_get_visit_gene_fri(Gene *gene, int *fri, int *hour);

extern bool lua_trade_res(Wubao *w, int *is_allow, int *gold);

extern bool lua_trade_weap(Wubao *w, int *is_allow);

#endif


