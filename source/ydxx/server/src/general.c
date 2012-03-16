#include "hf.h"


static OfficeInfo g_office_info[] = {
	{OFFICE_NONE, ""},
	{OFFICE_XIANLIN, "县令"},
	{OFFICE_TAISHOU, "太守"},
	{OFFICE_ZHOUMU, "州牧"},
	{OFFICE_WANG, "王"},
	{OFFICE_HUANGDI, "皇帝"},
};


static DignitieInfo g_dignitie_info[]={
	{DIGNITIE_NONE,"平民"},
	{DIGNITIE_NAN,"男"},
	{DIGNITIE_ZI,"子"},
	{DIGNITIE_BO, "伯"},
	{DIGNITIE_HOU,"侯"},
	{DIGNITIE_GONG, "公"},
	{DIGNITIE_WANG, "王"},
	{DIGNITIE_MAX,""},
};


static OfficialInfo g_official_info[] = {
		{OFFICIAL_NONE, ""},
		{1, "威东将军"},
		{2, "威南将军"},
		{3, "威西将军"},
		{4, "威北将军"},
		{5, "郎中"},
		{6, "从事郎中"},
		{7, "长史"},
		{8, "司马"},
		{9, "军师将军"},
		{10, "安国将军"},
		{11, "破虏将军"},
		{12, "讨逆将军"},
		{13, "谒者仆射"},
		{14, "都尉"},
		{15, "黄门侍郎"},
		{16, "太史令"},
		{17, "左将军"},
		{18, "右将军"},
		{19, "前将军"},
		{20, "后将军"},
		{21, "秘书令"},
		{22, "侍中"},
		{23, "留府长史"},
		{24, "太学博士"},
		{25, "安东将军"},
		{26, "安南将军"},
		{27, "安西将军"},
		{28, "安北将军"},
		{29, "中书令"},
		{30, "御史中丞"},
		{31, "执金吾"},
		{32, "少府"},
		{33, "镇东将军"},
		{34, "镇南将军"},
		{35, "镇西将军"},
		{36, "镇北将军"},
		{37, "尚书令"},
		{38, "太仆"},
		{39, "太常"},
		{40, "光禄大夫"},
		{41, "征东将军"},
		{42, "征南将军"},
		{43, "征西将军"},
		{44, "征北将军"},
		{45, "光禄动"},
		{46, "大司农"},
		{47, "卫尉"},
		{48, "延尉"},
		{OFFICIAL_MAX, ""},
};



Gene * gene_new(void)
{
	Gene *g = (Gene *) cache_pool_alloc(POOL_GENERAL);
	if(!g)
		return NULL;

	g->id = 0;
	dstring_clear(&g->first_name);
	dstring_clear(&g->last_name);
	dstring_clear(&g->zi);
	g->born_year = 0;
	g->sex = 0;
	g->face_id = 0;
	g->die_year = 0;
	g->place = 0;
	g->place_id = 0;
	g->kongfu = 0;
	g->speed = 0;
	g->polity = 0;
	g->intel = 0;
	g->is_dead = 0;
	g->fol = 2000;
	g->fri = 0;

	g->init_year = 0;
	g->skill = 0;
	g->zhen = 0;
	g->used_zhen = 0;
	g->sol_num = 0;
	g->hurt_num = 0;
	g->level = 0;
	g->sol_spirit = 0;
	g->level = 0;
	g->level_percent = 0;

	g->trea_num = 0;
	RB_INIT(&g->treas);

	return g;
}

void gene_free(Gene *gene)
{
	Key *k, *next;

	if (!gene) 
		return;

	for(k = RB_MIN(KeyMap, &gene->treas); k != NULL; k = next) {
		next = RB_NEXT(KeyMap, &gene->treas, k);
		RB_REMOVE(KeyMap, &gene->treas, k);
		key_free(k);
	}
	cache_pool_free(POOL_GENERAL, gene);
}

bool gene_add_trea(Gene *gene, Trea *trea)
{
	Key * k = NULL;

	if (!(gene && trea)) 
		return false;
	if (gene_find_trea(gene, trea->id))
		return false;
	if (gene_find_trea_by_type(gene, trea_get_type(trea)))
		return false;
	k = key_new(trea->id);
	if (!k) 
		return false;
	if (RB_INSERT(KeyMap, &gene->treas, k)) {
		key_free(k);
		return false;
	}
	return true;
}

bool gene_del_trea(Gene *gene, Trea *t)
{
	Key *r ;
	Key k ;

	if (!(gene && t))
		return false;

	k.id = t->id;
	if ((r = RB_FIND(KeyMap, &gene->treas, &k)) == NULL)
		return false;

	if (RB_REMOVE(KeyMap, &gene->treas, r) == NULL)
		return false;

	key_free(r);
	
	return true;
}

Trea * gene_find_trea(Gene *gene, int id)
{
	if (!gene)
		return NULL;

	Game *g = GAME;
	Key k;
	Key *r = NULL;
	Trea *t = NULL;

	k.id = id;
	if ((r = RB_FIND(KeyMap, &gene->treas, &k)) == NULL) 
		return NULL;
	if (!(t = game_find_trea(g,r->id)))
		return NULL;
	return t;
}

Trea * gene_find_trea_by_type(Gene *gene, int type)
{
	Key *c, *next;
	Game *g = GAME;
	Trea *t = NULL;

	if(!gene) 
		return NULL;
	for(c = RB_MIN(KeyMap, &gene->treas); c!= NULL; c = next) {
		next = RB_NEXT(KeyMap, &gene->treas, c);
		if (!(t = game_find_trea(g,c->id))) 
			continue;
		if (trea_get_type(t) == type)
			return t;
	}
	return NULL;
}

int gene_get_fol(Gene *gene)
{
	if (!gene) 
		return 0;

	return gene->fol;
}


void gene_change_place(Gene *gene, byte place, int place_id)
{
	if (!gene)
		return ;

	City *city = NULL;
	Wubao *w = NULL;
	Game *g = GAME;
	byte old_place = 0;
	int old_place_id = 0;


	if (place == gene->place && gene->place_id == place_id)
		return;

	old_place = gene->place;
	old_place_id = gene->place_id;

	//substract old place general num
	if (gene->place == GENE_PLACE_CITY && gene->place_id > 0) {
		if ((city = game_find_city(g, gene->place_id))) {
			city_del_general(city, gene);
		}
	}
	else if(gene->place == GENE_PLACE_WUBAO && gene->place_id > 0 && gene->uid <= 0) {
		if ((w = game_find_wubao(g, gene->place_id))) 
			wubao_del_gene(w, gene);
	}

	//add new place general num
	if(place == GENE_PLACE_CITY && place_id > 0) {
		if ((city = game_find_city(g, place_id))) {
			city_add_general(city, gene);
		}
	}
	else if (place == GENE_PLACE_WUBAO && place_id > 0) {
		if ((w = game_find_wubao(g, place_id))) {
			wubao_add_gene(w, gene);
		}
	}
	
	gene->place = place;
	gene->place_id = place_id;

	DEBUG(LOG_FMT"gene %d, old place %d:%d, new place %d:%d\n", LOG_PRE,  \
					gene->id, old_place, old_place_id, gene->place, gene->place_id);
}

uint gene_get_skill(Gene *gene)
{
	if (!gene)
		return 0;
	return gene->skill;
}

int gene_get_speed(Gene *gene)
{
	if (!gene)
		return 0;

	Trea *t = NULL;
	Game *g = GAME;
	int count = gene->speed;
	Key *c, *next;

	for(c = RB_MIN(KeyMap, &gene->treas); c; c = next) {
		next = RB_NEXT(KeyMap, &gene->treas, c);

		if(!(t = game_find_trea(g, c->id)))
			continue;
		
		if (trea_get_type(t) != TREA_SPEE) 
			continue;

		count += gene->speed * trea_get_num(t) / 100;
	}

	return count;
}

int gene_get_polity(Gene *gene)
{
	if (!gene)
		return 0;

	Trea *t = NULL;
	Game *g = GAME;
	int count = gene->polity;
	Key *c, *next;

	for(c = RB_MIN(KeyMap, &gene->treas); c; c = next) {
		next = RB_NEXT(KeyMap, &gene->treas, c);

		if(!(t = game_find_trea(g, c->id)))
			continue;
		
		if (trea_get_type(t) != TREA_POLI) 
			continue;

		count += trea_get_num(t);
	}

	return count;
}

int gene_get_kongfu(Gene *gene)
{
	if (!gene)
		return 0;

	Trea *t = NULL;
	Game *g = GAME;
	int count = gene->kongfu;
	Key *c, *next;

	for(c = RB_MIN(KeyMap, &gene->treas); c; c = next) {
		next = RB_NEXT(KeyMap, &gene->treas, c);

		if(!(t = game_find_trea(g, c->id)))
			continue;
		
		if (trea_get_type(t) != TREA_KONG) 
			continue;

		count += trea_get_num(t);
	}

	return count;
}

int gene_get_intel(Gene *gene)
{
	if (!gene)
		return 0;

	Trea *t = NULL;
	Game *g = GAME;
	int count = gene->intel;
	Key *c, *next;

	for(c = RB_MIN(KeyMap, &gene->treas); c; c = next) {
		next = RB_NEXT(KeyMap, &gene->treas, c);

		if(!(t = game_find_trea(g, c->id)))
			continue;
		
		if (trea_get_type(t) != TREA_INTE) 
			continue;

		count += trea_get_num(t);
	}

	return count;
}

const char * gene_get_full_name(Gene *gene)
{
	if (!gene)
		return NULL;
	static char name[128];
	int n = 0;
	
	n = snprintf(name, 127, "%s%s", safe_str(gene->first_name.buf), safe_str(gene->last_name.buf));
	name[n] = '\0';
	return name;
}


bool  gene_has_skill(Gene *gene, int skill_type)
{
	if (!gene) 
		return false;
	if (skill_type <= SKILL_NONE || skill_type >= SKILL_MAX)
		return false;
	return ((gene->skill >> (skill_type - 1)) & 0x1);
}

bool  gene_has_zhen(Gene *gene, int zhen_type)
{
	if (!gene) 
		return false;
	if (zhen_type <= ZHEN_NONE || zhen_type >= ZHEN_MAX)
		return false;
	return ((gene->zhen >> (zhen_type - 1)) & 0x1);
}

int gene_get_age(Gene *gene)
{
	if (!gene)
		return 0;
	int now = GAME_NOW;
	return (game_time_year(now) - gene->born_year);
}


void gene_add_sol(Gene * gene, int sol_num, float train, float spirit)
{
	float train_total = 0;
	float spirit_total = 0;

	if (!gene) 
		return;
	if (sol_num <= 0) 
		return;
	train_total = sol_num * train + gene->sol_num * gene->level;
	spirit_total = sol_num * spirit + gene->sol_num * gene->sol_spirit;
	gene->sol_num += sol_num;
	gene->level = train_total / gene->sol_num;
	gene->sol_spirit = spirit_total / gene->sol_num;
}


int  gene_change_faith(Gene *gene, int num)
{
	if (!gene)
		return 0;

	gene->faith += num;
	gene->faith = gene->faith > MAX_FAITH ? MAX_FAITH : gene->faith;
	return gene->faith;
}

float gene_change_sol_spirit(Gene *gene, float num)
{
	if (!gene)
		return 0;

	safe_add(gene->sol_spirit, num);
	
	if (gene->sol_spirit > MAX_SOL_SPIRIT)
		gene->sol_spirit = MAX_SOL_SPIRIT;

	return gene->sol_spirit;
}


OfficeInfo * get_office_info_by_id(int id)
{
	if (id <= OFFICE_NONE || id >= OFFICE_MAX)
		return NULL;

	return &g_office_info[id];
}

DignitieInfo * get_dignitie_info_by_id(int id)
{
	if (id <= DIGNITIE_NONE || id >= DIGNITIE_MAX)
		return NULL;

	return &g_dignitie_info[id];	
}


OfficialInfo * get_official_info_by_id(int id)
{
	if (id <= OFFICIAL_NONE || id>= OFFICIAL_MAX) 
		return NULL;

	return &g_official_info[id];
}


bool  gene_prop_in_area(Gene *gene, int mn, int mx)
{
	if (!gene)
		return false;

	if (gene->intel < mn && gene->intel >mx)
		return false;

	if (gene->kongfu < mn && gene->kongfu >mx)
		return false;

	if (gene->polity < mn && gene->polity >mx)
		return false;

	return true;
}

void gene_away(Gene *gene) 
{
	if (!gene) 
		return;

	Game *g = GAME;
	Wubao *w = NULL;
	int uid = 0;
	Key *k, *next;
	Trea *trea;


	uid = gene->uid;
	
	if ((w = game_find_wubao_by_uid(g, uid))) {
		wubao_del_gene(w, gene);
	}
	
	for(k = RB_MIN(KeyMap, &gene->treas); k; k = next) {
		next = RB_NEXT(KeyMap, &gene->treas, k);

		if(!(trea = game_find_trea(g, k->id)))
			continue;
		trea_recycle(trea);
		send_nf_trea_where(trea, WHERE_ME);
		
		webapi_treasure(g, trea, ACTION_EDIT, NULL, NULL);
	}

	gene->faith = 0;

	gene->uid = 0;
}

int gene_gen_face()
{
	return gen_random(657, 714);
}

const char *skill_name(int id)
{
	switch(id) {
		case SKILL_TUPO:
			return "突破";
		case SKILL_TUJIN:
			return "突进";
		case SKILL_TUJI:
			return "突击";
		case SKILL_SUGONG:
			return "速攻";
		case SKILL_QISHE:
			return "齐射";
		case SKILL_LIANSHE:
			return "连射";
		case SKILL_LIANNU:
			return "连弩";
		case SKILL_HUOJIAN:
			return "火箭";
		case SKILL_FENGZHAN:
			return "奋战";
		case SKILL_FENGDOU:
			return "奋斗";
		case SKILL_FENGXUN:
			return "奋迅";
		case SKILL_LUANZHAN:
			return "乱战";
		case SKILL_QUSHE:
			return "骑射";
		case SKILL_BENSHE:
			return "奔射";
		case SKILL_FEISHE:
			return "飞射";
		case SKILL_HUISHE:
			return "回射";
		case SKILL_JUNLAN:
			return "井栏";
		case SKILL_CHONGCHE:
			return "冲车";
		case SKILL_FASHI:
			return "发石";
		case SKILL_QIANGJI:
			return "强击";
		case SKILL_MENGTONG:
			return "艨艟";
		case SKILL_LUOCHUAN:
			return "楼船";
		case SKILL_ZHANJIAN:
			return "战舰";
		case SKILL_QIANGXI:
			return "强袭";
		case SKILL_WUSHUANG:
			return "无双";
		case SKILL_POZHEN:
			return "破阵";
		case SKILL_MAZHEN:
			return "骂阵";
		case SKILL_QIANGXING:
			return "强行";
		case SKILL_ZHILIAO:
			return "治疗";
		case SKILL_HUNLUAN:
			return "混乱";
		case SKILL_GUWU:
			return "鼓舞";
		case SKILL_CHENZHUO:
			return "沉着";
		default:
			return "";
	}
}


bool gene_get_pos(Gene *gene, int *x, int *y)
{
	if (!gene)
		return false;

	Game *g = GAME;
	Wubao *w = NULL;
	City *c = NULL;
	Army *a = NULL;
	int ret_x = 0;
	int ret_y = 0;

	if (gene->place == GENE_PLACE_WUBAO && (w = game_find_wubao(g, gene->place_id))) {
        wubao_get_xy(w, &ret_x, &ret_y);
	}
	else if (gene->place == GENE_PLACE_CITY && (c = game_find_city(g, gene->place_id))) {
		ret_x = c->x;
		ret_y = c->y;
	}
	else if (gene->place == GENE_PLACE_ARMY && (a = game_find_army(g, gene->place_id))) {
		ret_x = c->x;
		ret_y = c->y;
	}

	if (x) 
		(*x) = ret_x;

	if (y)
		(*y) = ret_y;

	return true;
}
