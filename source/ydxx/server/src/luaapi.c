#include "hf.h"

//war
#define LUA_GET_WAR_CITY "get_war_city"
#define LUA_GET_WAR_ARMY "get_war_army"
#define LUA_GET_WAR_TIME "get_war_time"
#define LUA_GET_ARMY_SPEED "get_army_speed"

//wubao
#define LUA_GET_WUBAO_CHANGE "get_wubao_change"
//general
#define LUA_GET_GENE_WUBAO "get_general_wubao"
#define LUA_GET_GENE_ARMY "get_general_army"
//sphere
#define LUA_GET_SPHERE_CHANGE "get_sphere_change"

#define LUA_LEVEL_UP "level_up"

#define LUA_MADE "made_weapon"

#define LUA_COMB "combin"

#define LUA_DESTROY "destroy"

#define LUA_CONFIG_SOL "config_sol"

#define LUA_EXP "create_army"

#define LUA_RECOVER "cure_solider"

#define LUA_USE_GENE "get_general"

#define LUA_GET_SOL_PER_WEAPON "get_sol_per_weapon"

#define LUA_CREATE_SPH "create_sphere"

#define LUA_JOIN_SPH "join_sphere"

#define LUA_APPLY_OFFICIAL "apply_official"

#define LUA_GET_LEARN_EFFECT "get_learn_effect"

#define LUA_GET_SOL_PROP "get_sol_prop"

#define LUA_GET_SOL_WEAP "get_sol_weap"

#define LUA_SYS_TRADE "sys_trade"

#define LUA_GET_GRID "get_grid"

#define LUA_GET_INIT_GENE "get_init_general"

#define LUA_GET_WELFARE "get_welfare"

#define LUA_GET_PLUNDER "get_plunder"

#define LUA_GET_VIEW "view_city"

#define LUA_GET_LEARN "learn_zhen_skill"

#define LUA_GET_PRAC_GOLD "get_learn_gold"

#define LUA_MOVE_CITY "moving_city"

#define LUA_GET_BUILDING_QUEUE "get_building_queue"

#define LUA_GET_TECH_QUEUE "get_tech_queue"

#define LUA_ADD_MADE "add_made"

#define LUA_ADD_SOL "add_sol"

#define LUA_GET_SPEED_MONEY "get_acc_money"

#define LUA_GET_WAR_SPEED_MONEY "get_war_acc_money"

#define LUA_GET_PK_INFO "get_tiaozhan_info"

#define LUA_GET_TRAIN_INFO "get_train_info"

#define LUA_GET_JL_INFO "get_junling_info"

#define LUA_BECOME_BOSS "become_boss"

#define LUA_UPDATE_GENE_FOR_FRESH "get_game_info"

#define LUA_LEVEL_UP_KUFANG "level_up_kufang"

#define LUA_LOST_WEAP "gain_weapon"

#define LUA_VISIT_GENE "visit_a_general"

#define LUA_TRADE_RES "trade_resource"

#define LUA_TRADE_WEAP "trade_weapon"


LuaScript * lua_script_new()
{
	LuaScript *lua = (LuaScript *) xmalloc(sizeof(LuaScript));
	if (!lua)
		return NULL;
	if (!(lua->state = luaL_newstate())) {
		lua_script_free(lua);
		return NULL;
	}
	luaL_openlibs(lua->state);
	lua_checkstack(lua->state, 100);
	return lua;
}

void lua_script_free(LuaScript *lua)
{
	if (!lua)
		return;
	if(lua->state)
		lua_close(lua->state);
	safe_free(lua);
}

bool lua_script_load(LuaScript *lua, const char *path)
{
	if (!lua)
		return false;
	if (luaL_dofile(lua->state, path) != 0) {
		ERROR(LOG_FMT"failed to load %s: %s\n", LOG_PRE, path, lua_tostring(lua->state, -1));
		return false;
	}
	return true;
}


/*
 * war 
 */
bool lua_get_war_city(Army *a, Gene *gene, City *city, Gene *gene1, \
		int *dead1, int *hurt1, int *skill1, float *spirit1, float *train1,\
		int *dead2, int *hurt2, int *skill2, float *spirit2, float *train2, float *defense)
{
	if (!(a && gene && city))
		return false;
	
	Game *g = GAME;
	User *u1 = NULL;
	User *u2 = NULL;
	int i = 0;
	int in = 0;
	int out = 11;
	float tr = 0;
	float sp = 0;
	

	u1 = game_find_user(g, gene->uid);
	if (gene1) {
		u2 = game_find_user(g, gene1->uid);
	}

	lua_getglobal(g_cycle->lua->state, LUA_GET_WAR_CITY);

	lua_pushnumber(g_cycle->lua->state, city->defense);
	in++;

	lua_pushinteger(g_cycle->lua->state, city->level);
	in++;

	lua_pushnumber(g_cycle->lua->state, gene->skill);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene->used_zhen);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene->sol_num);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene->hurt_num);
	in++;

	lua_pushnumber(g_cycle->lua->state, gene->sol_spirit);
	in++;

	lua_pushnumber(g_cycle->lua->state, gene->level);
	in++;

	for(i = 0; i < GENE_WEAP_NUM; i++) {
		lua_pushinteger(g_cycle->lua->state, gene->weap[i].id);
		in++;

		lua_pushinteger(g_cycle->lua->state, gene->weap[i].level);
		in++;
	}

	lua_pushinteger(g_cycle->lua->state, gene_get_kongfu(gene));
	in++;

	lua_pushinteger(g_cycle->lua->state, gene_get_intel(gene));
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene_get_polity(gene));
	in++;
	
    lua_pushinteger(g_cycle->lua->state, gene_get_speed(gene));
	in++;
	
	lua_pushinteger(g_cycle->lua->state, user_is_vip(u1));
	in++;

	lua_pushinteger(g_cycle->lua->state, gene1 ? gene1->sol_num: city->sol);
	in++;

	sp = gene1 ? gene1->sol_spirit : 0;
	lua_pushnumber(g_cycle->lua->state, sp);
	in++;
	
	tr = gene1 ? gene1->level : 0;
	
	lua_pushnumber(g_cycle->lua->state, tr);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, user_is_vip(u2));
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = out;

	if (dead1) {
		(*dead1) = lua_tointeger(g_cycle->lua->state, -out);
	}
	out--;

	if(hurt1){ 
		(*hurt1) = lua_tointeger(g_cycle->lua->state, -out);
	}
	out--;
	
	if(skill1){
		(*skill1) = lua_tointeger(g_cycle->lua->state, -out);
	}
	out--;

	if(spirit1){
		(*spirit1) = lua_tonumber(g_cycle->lua->state, -out);
	}
	out--;

	if(train1){ 
		(*train1) = lua_tonumber(g_cycle->lua->state, -out);
	}
	out--;
	
	if (dead2){ 
		(*dead2) = lua_tointeger(g_cycle->lua->state, -out);
	}
	out--;
	
	if(hurt2){ 
		(*hurt2) = lua_tointeger(g_cycle->lua->state, -out);
	}
	out--;

	if(skill2){
		(*skill2) = lua_tointeger(g_cycle->lua->state, -out);
	}
	out--;

	if(spirit2){
		(*spirit2) = lua_tonumber(g_cycle->lua->state, -out);
	}
	out--;
	
	if(train2){ 
		(*train2) = lua_tonumber(g_cycle->lua->state, -out);
	}
	out--;
	
	if(defense){ 
		(*defense) = lua_tonumber(g_cycle->lua->state, -out);
	}
	out--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}


bool lua_get_war_army(int r1, Gene *gene1, int r2, Gene *gene2, \
		int *dead1, int *hurt1, int *skill1, float *spirit1, float *train1,\
		int *dead2, int *hurt2, int *skill2, float *spirit2, float *train2)
{
	if (!(gene1 && gene2))
		return false;
	
	Game *g = GAME;
	User *u1 = NULL;
	User *u2 = NULL;
	int i = 0;
	int in = 0;
	int out = 10;


	u1 = game_find_user(g, gene1->uid);

	u2 = game_find_user(g, gene2->uid);

	lua_getglobal(g_cycle->lua->state, LUA_GET_WAR_ARMY);
	
	lua_pushnumber(g_cycle->lua->state, gene1->skill);
	in++;
	lua_pushinteger(g_cycle->lua->state, gene1->used_zhen);
	in++;
	lua_pushinteger(g_cycle->lua->state, gene1->sol_num);
	in++;
	lua_pushinteger(g_cycle->lua->state, gene1->hurt_num);
	in++;
	lua_pushnumber(g_cycle->lua->state, gene1->sol_spirit);
	in++;
	lua_pushnumber(g_cycle->lua->state, gene1->level);
	in++;
	lua_pushinteger(g_cycle->lua->state, r1);
	in++;
	for(i = 0; i < GENE_WEAP_NUM; i++) {
		lua_pushinteger(g_cycle->lua->state, gene1->weap[i].id);
		in++;
		lua_pushinteger(g_cycle->lua->state, gene1->weap[i].level);
		in++;
	}
	lua_pushinteger(g_cycle->lua->state, gene_get_kongfu(gene1));
	in++;

	lua_pushinteger(g_cycle->lua->state, gene_get_intel(gene1));
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene_get_polity(gene1));
	in++;
	
    lua_pushinteger(g_cycle->lua->state, gene_get_speed(gene1));
	in++;

	lua_pushinteger(g_cycle->lua->state, user_is_vip(u1));
	in++;
	
	lua_pushnumber(g_cycle->lua->state, gene2->skill);
	in++;
	lua_pushinteger(g_cycle->lua->state, gene2->used_zhen);
	in++;
	lua_pushinteger(g_cycle->lua->state, gene2->sol_num);
	in++;
	lua_pushinteger(g_cycle->lua->state, gene2->hurt_num);
	in++;
	lua_pushnumber(g_cycle->lua->state, gene2->sol_spirit);
	in++;
	lua_pushnumber(g_cycle->lua->state, gene2->level);
	in++;
	lua_pushinteger(g_cycle->lua->state, r2);
	in++;
	for(i = 0; i < GENE_WEAP_NUM; i++) {
		lua_pushinteger(g_cycle->lua->state, gene2->weap[i].id);
		in++;
		lua_pushinteger(g_cycle->lua->state, gene2->weap[i].level);
		in++;
	}
	
	lua_pushinteger(g_cycle->lua->state, gene_get_kongfu(gene2));
	in++;

	lua_pushinteger(g_cycle->lua->state, gene_get_intel(gene2));
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene_get_polity(gene2));
	in++;
	
    lua_pushinteger(g_cycle->lua->state, gene_get_speed(gene2));
	in++;

	lua_pushinteger(g_cycle->lua->state, user_is_vip(u2));
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = out;

	if (dead1) 
		(*dead1) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if(hurt1) 
		(*hurt1) = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if(skill1)
		(*skill1) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if(spirit1)
		(*spirit1) = lua_tonumber(g_cycle->lua->state, -out);
	out--;
	
	if(train1)
		(*train1) = lua_tonumber(g_cycle->lua->state, -out);
	out--;

	
	if (dead2) 
		(*dead2) = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if(hurt2) 
		(*hurt2) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if(skill2)
		(*skill2) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if(spirit2)
		(*spirit2) = lua_tonumber(g_cycle->lua->state, -out);
	out--;
	
	if(train2)
		(*train2) = lua_tonumber(g_cycle->lua->state, -out);
	out--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}

bool lua_get_war_army2(WarGene *gene1, WarGene *gene2, \
		int *dead1, int *hurt1, int *skill1, float *spirit1, float *train1,\
		int *dead2, int *hurt2, int *skill2, float *spirit2, float *train2)
{
	if (!(gene1 && gene2))
		return false;
	
	Game *g = GAME;
	int r1 = 0;
	int r2 = 0;	
	int i = 0;
	int in = 0;
	int out = 10;
	User *u1, *u2;

	r1 = r2 = REGION_PINGYAN; 
	
	u1 = game_find_user(g, gene1->uid);

	u2 = game_find_user(g, gene2->uid);
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_WAR_ARMY);
	
	lua_pushnumber(g_cycle->lua->state, gene1->skill);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene1->zhen);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene1->sol);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene1->hurt);
	in++;

	lua_pushnumber(g_cycle->lua->state, gene1->spirit);
	in++;

	lua_pushnumber(g_cycle->lua->state, gene1->train);
	in++;

	lua_pushinteger(g_cycle->lua->state, r1);
	in++;

	for(i = 0; i < GENE_WEAP_NUM; i++) {
		lua_pushinteger(g_cycle->lua->state, gene1->weap[i].id);
		in++;
		lua_pushinteger(g_cycle->lua->state, gene1->weap[i].level);
		in++;
	}
	lua_pushinteger(g_cycle->lua->state, gene1->kongfu);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene1->intel);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene1->polity);
	in++;
	
    lua_pushinteger(g_cycle->lua->state, gene1->speed);
	in++;

	lua_pushinteger(g_cycle->lua->state, user_is_vip(u1));
	in++;
	
	
	
	lua_pushnumber(g_cycle->lua->state, gene2->skill);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene2->zhen);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene2->sol);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene2->hurt);
	in++;

	lua_pushnumber(g_cycle->lua->state, gene2->spirit);
	in++;

	lua_pushnumber(g_cycle->lua->state, gene2->train);
	in++;

	lua_pushinteger(g_cycle->lua->state, r2);
	in++;

	for(i = 0; i < GENE_WEAP_NUM; i++) {
		lua_pushinteger(g_cycle->lua->state, gene2->weap[i].id);
		in++;
		lua_pushinteger(g_cycle->lua->state, gene2->weap[i].level);
		in++;
	}
	lua_pushinteger(g_cycle->lua->state, gene2->kongfu);
	in++;

	lua_pushinteger(g_cycle->lua->state, gene2->intel);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene2->polity);
	in++;
	
    lua_pushinteger(g_cycle->lua->state, gene2->speed);
	in++;

	lua_pushinteger(g_cycle->lua->state, user_is_vip(u2));
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = out;

	if (dead1) 
		(*dead1) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if(hurt1) 
		(*hurt1) = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if(skill1)
		(*skill1) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if(spirit1)
		(*spirit1) = lua_tonumber(g_cycle->lua->state, -out);
	out--;
	
	if(train1)
		(*train1) = lua_tonumber(g_cycle->lua->state, -out);
	out--;

	
	if (dead2) 
		(*dead2) = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if(hurt2) 
		(*hurt2) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if(skill2)
		(*skill2) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if(spirit2)
		(*spirit2) = lua_tonumber(g_cycle->lua->state, -out);
	out--;
	
	if(train2)
		(*train2) = lua_tonumber(g_cycle->lua->state, -out);
	out--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}


bool lua_get_war_time(float *h)
{

	lua_getglobal(g_cycle->lua->state, LUA_GET_WAR_TIME);
	if (lua_pcall(g_cycle->lua->state, 0, 1, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}
	if (h)
		(*h) = lua_tonumber(g_cycle->lua->state, -1);

	lua_pop(g_cycle->lua->state, 1);

	return true;
}


bool lua_get_army_speed(Gene *gene, int type, int *speed)
{
	if (!gene)
		return false;

	int in = 0;
	int out = 1;
	int i = 0;
	Trea *t = NULL;

	lua_getglobal(g_cycle->lua->state, LUA_GET_ARMY_SPEED);

	lua_pushinteger(g_cycle->lua->state, type);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene->used_zhen);
	in++;
	
	lua_pushnumber(g_cycle->lua->state, gene->skill);
	in++;

	t = gene_find_trea_by_type(gene, TREA_SPEE);

	lua_pushinteger(g_cycle->lua->state, trea_get_num(t));
	in++;
	
	for(i = 0; i <GENE_WEAP_NUM; i++) {
		lua_pushinteger(g_cycle->lua->state, gene->weap[i].id);
		in++;
	}
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = out;

	if (speed)
		(*speed) = lua_tointeger(g_cycle->lua->state, -i);
	i--;

	lua_pop(g_cycle->lua->state, out);

	return true;
}


bool lua_get_wubao_change(Wubao *w, int *res, int *peole, int *family, int *sol, int *dig, int *max_gene, int *made, int *cure)
{
	if (!w)
		return false;
	
	int input = 0;
	int output = 13;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_WUBAO_CHANGE);

	for(i = RES_NONE + 1; i < RES_MAX; i ++) {
		lua_pushinteger(g_cycle->lua->state, w->res[i-1]);
		input++;
		//DEBUG(LOG_FMT"res%d-->%d\n", LOG_PRE, i, w->res[i-1]);
	}

	for(i = BUILDING_NONE + 1; i < BUILDING_MAX; i ++) {
		lua_pushinteger(g_cycle->lua->state, w->build[i-1].level);
		input++;
		//DEBUG(LOG_FMT"building%d-->%d\n", LOG_PRE, i, w->build[i-1].level);
	}

	for(i = TECH_NONE + 1; i < TECH_MAX; i ++) {
		lua_pushinteger(g_cycle->lua->state, w->tech[i-1].level);
		input++;
		//DEBUG(LOG_FMT"tech%d-->%d\n", LOG_PRE, i, w->tech[i-1].level);
	}

	lua_pushinteger(g_cycle->lua->state, w->people);
	input++;
	//DEBUG(LOG_FMT"people-->%d\n", LOG_PRE, w->people);

	lua_pushinteger(g_cycle->lua->state, w->family);
	input++;
	//DEBUG(LOG_FMT"famil-->%d\n", LOG_PRE, w->family);

	lua_pushinteger(g_cycle->lua->state, w->got_sol);
	input++;
	//DEBUG(LOG_FMT"got_sol-->%d\n", LOG_PRE, w->got_sol);

	lua_pushinteger(g_cycle->lua->state, w->sol);
	input++;
	//DEBUG(LOG_FMT"sol-->%d\n", LOG_PRE, w->sol);

	lua_pushinteger(g_cycle->lua->state, w->prestige);
	input++;
	//DEBUG(LOG_FMT"prestige-->%d\n", LOG_PRE, w->prestige);

	lua_pushinteger(g_cycle->lua->state, w->dig_id);
	input++;
	//DEBUG(LOG_FMT"dig_id-->%d\n", LOG_PRE, w->dig_id);

	lua_pushinteger(g_cycle->lua->state, w->used_made);
	input++;
	//DEBUG(LOG_FMT"used_made-->%d\n", LOG_PRE, w->used_made);
	
	lua_pushinteger(g_cycle->lua->state, w->cure_sol);
	input++;
	//DEBUG(LOG_FMT"cur_sol->%d\n", LOG_PRE, w->cure_sol);

	lua_pushinteger(g_cycle->lua->state, wubao_is_vip(w));
	input++;
	//DEBUG(LOG_FMT"is_vip-->%d\n", LOG_PRE, wubao_is_vip(w));

	lua_pushinteger(g_cycle->lua->state, GAME_NOW);
	input++;
	//DEBUG(LOG_FMT"time-->%d\n", LOG_PRE, GAME_NOW);

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if (res) {
		*(res) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 1) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 2) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 3) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 4) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 5) = lua_tointeger(g_cycle->lua->state, -output--);
	}else{
		output -= 6;
	}
	
	if(peole) 
		*(peole) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	if(family) 
		*(family) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	if(sol) 
		*(sol) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	if(dig){
		*(dig) = lua_tointeger(g_cycle->lua->state, -output--);
		//DEBUG(LOG_FMT"return_dig-->%d\n", LOG_PRE, *(dig));
	}
	else
		output--;
	
	if(max_gene){
		(*max_gene) = lua_tointeger(g_cycle->lua->state, -output--);
		//DEBUG(LOG_FMT"return_max_gen-->%d\n", LOG_PRE, (*max_gene));
	}
	else
		output--;

	if(made)
		(*made) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	if(cure) 
		(*cure) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}


bool lua_get_gene_wubao(Gene *gene, Wubao *w, User *u, int *money, int *food, float *faith, int *fol, float *spi, float *tra, int *sol)
{
	if (!gene) 
		return false;

	int input = 0;
	int output = 7;
	int i = 0;
	int j = 0;

	lua_getglobal(g_cycle->lua->state, LUA_GET_GENE_WUBAO);
	
	lua_pushinteger(g_cycle->lua->state, gene->type);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->born_year);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->init_year);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->place);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->kongfu);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->intel);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->polity);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->speed);
	input++;

	lua_pushnumber(g_cycle->lua->state, gene->faith);
	input++;

	lua_pushinteger(g_cycle->lua->state, w ? w->off_id : 0);
	input++;

	lua_pushnumber(g_cycle->lua->state, gene->skill);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->zhen);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->used_zhen);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->sol_num);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->hurt_num);
	input++;

	lua_pushnumber(g_cycle->lua->state, gene->level);
	input++;

	lua_pushnumber(g_cycle->lua->state, gene->sol_spirit);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->level_percent);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->fri);
	input++;
	
	for(i = 0; i < GENE_WEAP_NUM; i ++) {
		lua_pushinteger(g_cycle->lua->state, gene->weap[i].id);
		input++;
		
		lua_pushinteger(g_cycle->lua->state, gene->weap[i].level);
		input++;
	}

	lua_pushinteger(g_cycle->lua->state, w ? w->res[RES_MONEY - 1] : 0);
	input++;

	lua_pushinteger(g_cycle->lua->state, w ? w->res[RES_FOOD -1] : 0);
	input++;

	lua_pushinteger(g_cycle->lua->state, GAME_NOW); 
	input++;

	lua_pushinteger(g_cycle->lua->state, u ? user_is_vip(u) : 0);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, u ? user_is_npc(u) : 1);
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = output;


	if(money) 
		(*money) =  lua_tointeger(g_cycle->lua->state, -output);
	output--;

	if(food) 
		 (*food) = lua_tointeger(g_cycle->lua->state, -output);
	output--;

	if(faith){ 
		 (*faith) = lua_tonumber(g_cycle->lua->state, -output);
	}
	output--;

	if(fol) 
		 (*fol) = lua_tointeger(g_cycle->lua->state, -output);
	output--;

	if(spi){ 
		 (*spi) = lua_tonumber(g_cycle->lua->state, -output);
	}
	output--;

	if(tra){ 
		 (*tra) = lua_tonumber(g_cycle->lua->state, -output);
	}
	output--;

	if (sol) {
		 (*sol) = lua_tointeger(g_cycle->lua->state, -output);
	}
	output--;


	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_gene_army(Gene *gene, Army *a, Wubao *w, User *u, int *money, int *food, float *faith, int *fol, float *spi, float *tra, int *sol)
{
	if (!(gene && a)) 
		return false;

	int input = 0;
	int output = 7;
	int i = 0;

	lua_getglobal(g_cycle->lua->state, LUA_GET_GENE_ARMY);

	lua_pushinteger(g_cycle->lua->state, gene->type);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->born_year);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->init_year);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->place);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->kongfu);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->intel);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->polity);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->speed);
	input++;

	lua_pushnumber(g_cycle->lua->state, gene->faith);
	input++;

	lua_pushinteger(g_cycle->lua->state, w ? w->off_id : 0);
	input++;

	lua_pushnumber(g_cycle->lua->state, gene->skill);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->zhen);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->used_zhen);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->sol_num);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->hurt_num);
	input++;

	lua_pushnumber(g_cycle->lua->state, gene->level);
	input++;

	lua_pushnumber(g_cycle->lua->state, gene->sol_spirit);
	input++;

	lua_pushinteger(g_cycle->lua->state, gene->level_percent);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, gene->fri);
	input++;

	for(i = 0; i < GENE_WEAP_NUM; i ++) {
		lua_pushinteger(g_cycle->lua->state, gene->weap[i].id);
		input++;
		lua_pushinteger(g_cycle->lua->state, gene->weap[i].level);
		input++;
	}

	lua_pushinteger(g_cycle->lua->state, a->money);
	input++;

	lua_pushinteger(g_cycle->lua->state, a->food);
	input++;

	lua_pushinteger(g_cycle->lua->state, GAME_NOW);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, user_is_vip(u));
	input++;
	
	lua_pushinteger(g_cycle->lua->state, user_is_npc(u));
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(money){
		(*money) =  lua_tointeger(g_cycle->lua->state, -output);
	}
	output--;

	if(food){ 
		 (*food) = lua_tointeger(g_cycle->lua->state, -output);
	}
	output--;

	if(faith) 
		 (*faith) = lua_tonumber(g_cycle->lua->state, -output);
	output--;

	if(fol) 
		 (*fol) = lua_tointeger(g_cycle->lua->state, -output);
	output--;

	if(spi) 
		 (*spi) = lua_tonumber(g_cycle->lua->state, -output);
	output--;

	if(tra) 
		 (*tra) = lua_tonumber(g_cycle->lua->state, -output);
	output--;
	
	if(sol){ 
		 (*sol) = lua_tointeger(g_cycle->lua->state, -output);
	}
	output--;

	lua_pop(g_cycle->lua->state, i);

	return true;
}


bool lua_get_sphere_change(Sph * sph, int * level, int * max_member)
{
	if (!sph)
		return false;

	int input = 0;
	int output = 2;
	int i = 0;
	User *u = NULL;
	Game *g = GAME;

	u = game_find_user(g, sph->uid);

	lua_getglobal(g_cycle->lua->state, LUA_GET_SPHERE_CHANGE);

	lua_pushinteger(g_cycle->lua->state,  sph->level);
	input++;

	lua_pushinteger(g_cycle->lua->state,  sph->city_num);
	input++;

	lua_pushinteger(g_cycle->lua->state,  sph->prestige);
	input++;

	lua_pushinteger(g_cycle->lua->state,  GAME_NOW);
	input++;

	lua_pushinteger(g_cycle->lua->state,  user_is_vip(u));
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if (level) 
		(*level) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	if (max_member) 
		(*max_member) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	lua_pop(g_cycle->lua->state, i);

	return true;
}


bool lua_level_up(Wubao *w, int up_type, int up_id, int *is_allow, int *res, int *h)
{
	if (!w)
		return false;
	
	int input = 0;
	int output = 8;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_LEVEL_UP);

	for(i = RES_NONE + 1; i < RES_MAX; i ++) {
		lua_pushinteger(g_cycle->lua->state, w->res[i-1]);
		input++;
	}

	for(i = BUILDING_NONE + 1; i < BUILDING_MAX; i ++) {
		lua_pushinteger(g_cycle->lua->state, w->build[i-1].level);
		input++;
	}

	for(i = TECH_NONE + 1; i < TECH_MAX; i ++) {
		lua_pushinteger(g_cycle->lua->state, w->tech[i-1].level);
		input++;
	}

	lua_pushinteger(g_cycle->lua->state, w->people);
	input++;
	lua_pushinteger(g_cycle->lua->state, w->family);
	input++;
	lua_pushinteger(g_cycle->lua->state, w->got_sol);
	input++;
	lua_pushinteger(g_cycle->lua->state, w->sol);
	input++;
	lua_pushinteger(g_cycle->lua->state, w->prestige);
	input++;
	lua_pushinteger(g_cycle->lua->state, w->dig_id);
	input++;
	lua_pushinteger(g_cycle->lua->state, wubao_is_vip(w));
	input++;
	lua_pushinteger(g_cycle->lua->state, GAME_NOW);
	input++;
	lua_pushinteger(g_cycle->lua->state, up_type);
	input++;
	lua_pushinteger(g_cycle->lua->state, up_id);
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(is_allow) 
		*(is_allow) = lua_tointeger(g_cycle->lua->state, -output);
	output--;

	if (res) {
		*(res) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 1) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 2) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 3) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 4) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 5) = lua_tointeger(g_cycle->lua->state, -output--);
	}
	else
		output -= 6;
	
	if(h) 
		*(h) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}

bool lua_made(Wubao *w, int id, int num, int *is_allow, int *res, int *made)
{
	if (!w)
		return false;
	
	int input = 0;
	int output = 8;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_MADE);

	for(i = RES_NONE + 1; i < RES_MAX; i++) {
		lua_pushinteger(g_cycle->lua->state, w->res[i-1]);
		input++;
	}

	lua_pushinteger(g_cycle->lua->state, w->family);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, wubao_is_vip(w));
	input++;
	
	lua_pushinteger(g_cycle->lua->state, w->used_made);
	input++;

	lua_pushinteger(g_cycle->lua->state, id);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, num);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_GONGFANG - 1].level);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_KUFANG - 1].level);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, wubao_weap_id_num(w));
	input++;
	  
	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(is_allow) 
		*(is_allow) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	if (res) {
		*(res) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 1) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 2) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 3) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 4) = lua_tointeger(g_cycle->lua->state, -output--);
		*(res + 5) = lua_tointeger(g_cycle->lua->state, -output--);
	}
	else
		output -= 6;
	
	if(made) 
		(*made) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}

bool lua_destroy(int type, int level, int num, int *money)
{
	int in = 0;
	int out = 1;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_DESTROY);

	lua_pushinteger(g_cycle->lua->state, type);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, level);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, num);
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = out;

	if(money){ 
		(*money) = lua_tointeger(g_cycle->lua->state, -out);
	}
	out--;	
	
	lua_pop(g_cycle->lua->state, i);
	return true;
}

bool lua_comb(Wubao *w, int id, int level, int num, int *is_allow, int *ret_level, int *ret_num)
{
	if (!w)
		return false;
	
	int input = 0;
	int output = 3;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_COMB);

	lua_pushinteger(g_cycle->lua->state, id);
	input++;
	//DEBUG(LOG_FMT"id-->%d\n", LOG_PRE, id);
	
	lua_pushinteger(g_cycle->lua->state, level);
	input++;
	//DEBUG(LOG_FMT"level-->%d\n", LOG_PRE, level);
	
	lua_pushinteger(g_cycle->lua->state, num);
	input++;
	//DEBUG(LOG_FMT"num-->%d\n", LOG_PRE, num);
	
	lua_pushinteger(g_cycle->lua->state, w->weap[id-1].num[level]);
	input++;
	//DEBUG(LOG_FMT"total-->%d\n", LOG_PRE, w->weap[id-1].num[level]);
	
	for(i = 0; i < TECH_MAX - 1; i++) {
		lua_pushinteger(g_cycle->lua->state, w->tech[i].level);	
		//DEBUG(LOG_FMT"tech%d-->%d\n", LOG_PRE, i, w->tech[i].level);
		input++;
	}
	  
	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(is_allow){ 
		(*is_allow) = lua_tointeger(g_cycle->lua->state, -output--);
		//DEBUG(LOG_FMT"is_allow-->%d\n", LOG_PRE, (*is_allow));
	}
	else
		output--;

	
	if(ret_level) 
		(*ret_level) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	if(ret_num){ 
		(*ret_num) = lua_tointeger(g_cycle->lua->state, -output--); 
		//DEBUG(LOG_FMT"res_num-->%d\n", LOG_PRE, (*ret_num));
	}
	else
		output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}

bool lua_config_sol(struct ReqConfigSolBody *b, int *is_allow, int *num)
{
	if (!b)
		return false;
	
	int i = 0;
	int input = 0;
	int output = 5;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_CONFIG_SOL);

	for(i = 0; i < GENE_WEAP_NUM; i++) {
		lua_pushinteger(g_cycle->lua->state, b->weap[i].id);
		//DEBUG(LOG_FMT"weapon%d-->%d\n", LOG_PRE, i, b->weap[i].id);
		input++;
	}

	lua_pushinteger(g_cycle->lua->state, b->num);
		
	input++;
	  
	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = output;


	if(is_allow){ 
		(*is_allow) = lua_tointeger(g_cycle->lua->state, -output--);
		//DEBUG(LOG_FMT"is_ok-->%d\n", LOG_PRE, (*is_allow));
	}
	else
		output--;

	if (num) {
		for (i = 0; i < GENE_WEAP_NUM; i++) {
			*(num + i) = lua_tointeger(g_cycle->lua->state, -output--);
		}
	}
	
	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_exp(int money, int food, int type, int day, int num, int *is_allow, int *need_money, int *need_food)
{
	int input = 0;
	int output = 3;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_EXP);

	lua_pushinteger(g_cycle->lua->state, money);
	input++;

	lua_pushinteger(g_cycle->lua->state, food);
	input++;

	lua_pushinteger(g_cycle->lua->state, type);
	input++;

	lua_pushinteger(g_cycle->lua->state, day);
	input++;

	lua_pushinteger(g_cycle->lua->state, num);
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(is_allow) 
		(*is_allow) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	if(need_money) 
		(*need_money) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	if(need_food) 
		(*need_food) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}

bool lua_recover(Wubao * w, int num, int * rec)
{
	int input = 0;
	int output = 1;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_RECOVER);

	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_YIGUAN - 1].level);
	input++;

	lua_pushinteger(g_cycle->lua->state, num);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, w->cure_sol);
	input++;

	lua_pushinteger(g_cycle->lua->state, wubao_is_vip(w));
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(rec) 
		(*rec) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;

	lua_pop(g_cycle->lua->state, i);

	return true;
}

bool lua_use_gene(Wubao *w, int type, int fri, int min_fri, int *is_allow)
{
	int input = 0;
	int output = 1;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_USE_GENE);

	lua_pushinteger(g_cycle->lua->state, type);
	//DEBUG(LOG_FMT"type-->%d\n", LOG_PRE, type);
	input++;

	lua_pushinteger(g_cycle->lua->state, fri);
	//DEBUG(LOG_FMT"friendly-->%d\n", LOG_PRE, fri);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, min_fri);
	//DEBUG(LOG_FMT"min_friendly-->%d\n", LOG_PRE, min_fri);
	input++;

	lua_pushinteger(g_cycle->lua->state, wubao_is_vip(w));
	//DEBUG(LOG_FMT"vip-->%d\n", LOG_PRE, wubao_is_vip(w));
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(is_allow){ 
		(*is_allow) = lua_tointeger(g_cycle->lua->state, -output--);
		//DEBUG(LOG_FMT"is_ok-->%d\n", LOG_PRE, *is_allow);
	}
	else
		output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}


bool lua_get_sol_per_weapon(int weap_id, int *sol_num)
{
	int input = 0;
	int output = 1;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_SOL_PER_WEAPON);

	lua_pushinteger(g_cycle->lua->state, weap_id);
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(sol_num) 
		(*sol_num) = lua_tointeger(g_cycle->lua->state, -output--);
	else
		output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}

bool lua_create_sph(Wubao *w, int *is_agree)
{
	int input = 0;
	int output = 1;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_CREATE_SPH);

	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_YISHITANG - 1].level);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, wubao_is_vip(w));
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(is_agree) 
		(*is_agree) = lua_tointeger(g_cycle->lua->state, -output);
	output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}

bool lua_join_sph(Sph *sph, Wubao *w, int *is_agree)
{
	if (!(w && sph))
		return false;

	int input = 0;
	int output = 1;
	int i = 0;

	
	lua_getglobal(g_cycle->lua->state, LUA_JOIN_SPH);

	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_YISHITANG - 1].level);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, sph->level);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, sph->wubao_num);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, wubao_is_vip(w));
	input++;

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(is_agree) 
		(*is_agree) = lua_tointeger(g_cycle->lua->state, -output);
	output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}

bool lua_apply_official(Wubao *w, int off_id, int *is_agree)
{
	int input = 0;
	int output = 1;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_APPLY_OFFICIAL);

	lua_pushinteger(g_cycle->lua->state, off_id);
	input++;
	
	lua_pushinteger(g_cycle->lua->state, w->prestige);
	input++;
	

	if (lua_pcall(g_cycle->lua->state, input, output, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	i = output;

	if(is_agree) 
		(*is_agree) = lua_tointeger(g_cycle->lua->state, -output);
	output--;
	
	lua_pop(g_cycle->lua->state, i);

	return true;
}


bool lua_get_learn(Gene *gene, Wubao *w, int type, int id, int *is_allow, int *need_kill)
{
	if (!(w && gene))
		return false;

	int in = 0;
	int out = 2;
	int j = 0;


	lua_getglobal(g_cycle->lua->state, LUA_GET_LEARN);

	lua_pushinteger(g_cycle->lua->state, type);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, id);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, w->gx);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene_get_kongfu(gene));
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene_get_intel(gene));
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene_get_polity(gene));
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (is_allow) 
		(*is_allow) = lua_tointeger(g_cycle->lua->state,  -out);
	out--;
	
	if (need_kill) 
		(*need_kill) = lua_tointeger(g_cycle->lua->state,  -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_sol_prop(struct GeneWeap *w, int zhen, int *move_dis, int *attack_dis)
{
	if (!w)
		return false;

	int in = 0;
	int out = 2;
	int i = 0;
	int j = 0;

	lua_getglobal(g_cycle->lua->state, LUA_GET_SOL_PROP);

	lua_pushinteger(g_cycle->lua->state, zhen);
	in++;

	for(i = 0; i < GENE_WEAP_NUM; i++) {
		lua_pushinteger(g_cycle->lua->state, w[i].id);
		in++;

		lua_pushinteger(g_cycle->lua->state, w[i].level);
		in++;
	}

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (move_dis)
		(*move_dis) = lua_tointeger(g_cycle->lua->state,  -out);
	out--;

	if (attack_dis)
		(*attack_dis) = lua_tointeger(g_cycle->lua->state,  -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_sol_weap(int sol_id, struct GeneWeap *weap)
{
	if (!weap)
		return false;
	
	int in = 0;
	int out = 8;
	int j = 0;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_SOL_WEAP);

	lua_pushinteger(g_cycle->lua->state, sol_id);
	//DEBUG(LOG_FMT"sol_id-->%d\n", LOG_PRE,sol_id);
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	for(i = 0; i < GENE_WEAP_NUM; i ++) {
		weap[i].id = lua_tointeger(g_cycle->lua->state, -out);
		out--;
		weap[i].level = lua_tointeger(g_cycle->lua->state, -out);
		out--;
	}
	
	lua_pop(g_cycle->lua->state, j);

	return true;
}


bool lua_sys_trade(Wubao *w, int type, int res, int num, int *succ, int *money)
{
	if (!w)
		return false;
	
	int in = 0;
	int out = 2;
	int j = 0;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_SYS_TRADE);

	for ( i = 0; i < RES_MAX - 1; i++) {
		lua_pushinteger(g_cycle->lua->state, w->res[i]);
		in++;
	}

	lua_pushinteger(g_cycle->lua->state, type);
	in++;

	lua_pushinteger(g_cycle->lua->state, res);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, num);
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (succ) 
		(*succ) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if (money)
		(*money) = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	lua_pop(g_cycle->lua->state, j);

	return true;
}


bool lua_get_grid(Wubao *w, int *num)
{
	if (!w)
		return false;
	
	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_GRID);

	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_KUFANG - 1].level);
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (num) 
		(*num) = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_init_gene(int is_vip, int *kongfu, int *intel, int *polity, int *skill)
{
	int in = 0;
	int out = 4;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_INIT_GENE);

	lua_pushinteger(g_cycle->lua->state, is_vip);
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (kongfu) 
		(*kongfu) = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (intel) 
		(*intel) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if (polity) 
		(*polity) = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
    if (skill) 
		(*skill) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_welfare(Wubao *w, int *is_allow, int *res, int *gold)
{
	if (!(w && w->sph_id > 0))
		return false;
	
	int in = 0;
	int out = 8;
	int j = 0;
	int i = 0;
	int level = 0;
	Game *g = GAME;
	Sph *sph = NULL;
	City *city = NULL;
	Key *k = NULL;
	

	if (!(sph = game_find_sph(g, w->sph_id)))
		return false;

	RB_FOREACH(k, KeyMap, &sph->city) {
		if (!(city = game_find_city(g, k->id)))
			continue;
		level += city->level;
	}

	lua_getglobal(g_cycle->lua->state, LUA_GET_WELFARE);

	lua_pushinteger(g_cycle->lua->state, level);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, w->off_id);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, w->dig_id);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, w->last_welfare_time);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, GAME_NOW);
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (is_allow) 
		*(is_allow) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if (res) {
		for (i = 0; i < RES_MAX - 1; i++) {
			*(res + i) = lua_tointeger(g_cycle->lua->state, -out);
			out--;
		}
	}
	
	if (gold) 
		*(gold) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_plunder(Wubao *to, int req_res[RES_MAX - 1], int sol, int res[RES_MAX - 1], int *cd)
{
	if (!(to))
		return false;
	
	int in = 0;
	int out = 7;
	int j = 0;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_PLUNDER);

	lua_pushinteger(g_cycle->lua->state, sol);
	in++;

	for (i = 0; i < RES_MAX - 1; i++) {
		lua_pushinteger(g_cycle->lua->state, req_res[i]);
		in++;
	}
	
	for (i = 0; i < RES_MAX - 1; i++) {
		lua_pushinteger(g_cycle->lua->state, to->res[i]);
		in++;
	}
		
	lua_pushinteger(g_cycle->lua->state, to->been_plunder_num);
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (res) {
		for (i = 0; i < RES_MAX - 1; i++) {
			*(res + i) = lua_tointeger(g_cycle->lua->state, -out);
			out--;
		}
	}

	if (cd) {
		*(cd) = lua_tointeger(g_cycle->lua->state, -out);
	}
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_view(int type, int *need_hour, int *prestige, int *money, int *gold)
{
	int in = 0;
	int out = 4;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_VIEW);

	lua_pushinteger(g_cycle->lua->state, type);
	in++;
		

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (need_hour) 
		*(need_hour) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if (prestige) 
		*prestige = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (money) 
		*money = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_prac_gold(int *prac_num, int *gold)
{
	int in = 0;
	int out = 4;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_PRAC_GOLD);

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (prac_num) 
		*(prac_num) = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_move_city(int *gold)
{
	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_MOVE_CITY);

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}


bool lua_get_building_queue(Wubao *w, int *queue)
{
	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_BUILDING_QUEUE);
	
	lua_pushinteger(g_cycle->lua->state, wubao_is_vip(w));
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (queue) 
		*queue = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_tech_queue(Wubao *w, int *queue)
{
	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_TECH_QUEUE);
	
	lua_pushinteger(g_cycle->lua->state, wubao_is_vip(w));
	in++;

	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (queue) 
		*queue = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_add_made(int *num, int *gold)
{
	int in = 0;
	int out = 2;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_ADD_MADE);
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (num) 
		*num = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_add_sol(int *num, int *gold)
{
	int in = 0;
	int out = 2;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_ADD_SOL);
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;

	if (num) 
		*num = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_speed_gold(int hour, int *gold)
{
	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_SPEED_MONEY);
	
	lua_pushinteger(g_cycle->lua->state, hour);
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_war_speed_gold(int hour, int *gold)
{
	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_WAR_SPEED_MONEY);
	
	lua_pushinteger(g_cycle->lua->state, hour);
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_pk_info(int *cd)
{
	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_PK_INFO);
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	if (cd) 
		*cd = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}


bool lua_get_train_info(Wubao *w, Gene *gene, int is_double, int *percent, int *level, int *gold, int *cd)
{
	if (!(w && gene))
		return false;

	int in = 0;
	int out = 4;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_TRAIN_INFO);
	
	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_YISHITANG - 1].level);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_JUNYIN - 1].level);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene->level);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, gene->level_percent);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, is_double);
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	if (percent) 
		*percent = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (level) 
		*level = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (cd) 
		*cd = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_jl_info(int *gold, int *num)
{
	int in = 0;
	int out = 2;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_GET_JL_INFO);
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (num) 
		*num = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_become_boss(Wubao *old, Wubao *me, int *is_allow)
{
	if (!(old && me))
		return false;

	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_BECOME_BOSS);
	
	lua_pushinteger(g_cycle->lua->state, old->prestige);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, me->prestige);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, time(NULL));
	in++;
	
	lua_pushinteger(g_cycle->lua->state, old->last_login_time);
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	if (is_allow) 
		*is_allow = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_update_gene_for_fresh(Gene *gene)
{
	if (!gene)
		return false;

	int in = 0;
	int out = 17;
	int j = 0;
	int i = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_UPDATE_GENE_FOR_FRESH);
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	gene->kongfu = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	gene->intel = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	gene->polity = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	gene->skill = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	gene->zhen = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	gene->sol_num = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	for(i = 0; i < GENE_WEAP_NUM; i++) {
		gene->weap[i].id = lua_tointeger(g_cycle->lua->state, -out);
		out--;

		gene->weap[i].level = lua_tointeger(g_cycle->lua->state, -out);
		out--;
	}
	
	gene->used_zhen = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	gene->sol_spirit = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	gene->level = lua_tointeger(g_cycle->lua->state, -out);
	out--;

	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_level_up_kufang(Wubao *w, int *gold, int *is_allow)
{
	if (!w)
		return false;

	int in = 0;
	int out = 2;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_LEVEL_UP_KUFANG);
	
	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_KUFANG -1].level);
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (is_allow) 
		*is_allow = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_lost_weap(Wubao *w, int perc, int *is_yes)
{
    if (!w)
        return false;

	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_LOST_WEAP);
	
	lua_pushinteger(g_cycle->lua->state, perc);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_KUFANG - 1].level);
	in++;
	
	lua_pushinteger(g_cycle->lua->state, wubao_weap_id_num(w));
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	if (is_yes) 
		*is_yes = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_get_visit_gene_fri(Gene *gene, int *fri, int *hour)
{
    if (!gene)
        return false;

	int in = 0;
	int out = 2;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_VISIT_GENE);
	
	lua_pushinteger(g_cycle->lua->state, gene->fri);
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
	if (fri) 
		*fri = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
    if (hour) 
		*hour = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_trade_res(Wubao *w, int *is_allow, int *gold)
{
    if (!w)
        return false;

	int in = 0;
	int out = 2;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_TRADE_RES);
	
    lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_YISHITANG - 1].level);
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
    if (is_allow) 
		*is_allow = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	if (gold) 
		*gold = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	lua_pop(g_cycle->lua->state, j);

	return true;
}

bool lua_trade_weap(Wubao *w, int *is_allow)
{
    if (!w)
        return false;

	int in = 0;
	int out = 1;
	int j = 0;
	
	lua_getglobal(g_cycle->lua->state, LUA_TRADE_WEAP);
	
    lua_pushinteger(g_cycle->lua->state, w->build[BUILDING_YISHITANG - 1].level);
	in++;
	
	if (lua_pcall(g_cycle->lua->state, in, out, 0) != 0) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, lua_tostring(g_cycle->lua->state, -1));
		lua_pop(g_cycle->lua->state, 1);
		return false;
	}

	j = out;
	
    if (is_allow) 
		*is_allow = lua_tointeger(g_cycle->lua->state, -out);
	out--;
	
	lua_pop(g_cycle->lua->state, j);

	return true;
}
