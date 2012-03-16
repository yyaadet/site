#ifndef _CITY_H_
#define _CITY_H_
#include "general.h"
#include "wubao.h"


struct Sph;


enum CITY_STATE {
	CITY_NONE = 0,
	CITY_NORMAL,
	CITY_FIGHT,
};

enum CITY_LEVEL {
	CITY_LEVEL_NONE, 
	CITY_WUBAO,
	CITY_JUN,
	CITY_ZHOU,
	CITY_DU,
};

struct City;


struct City {
	int id;
	int sph_id;
	int x;
	int y;
	dstring name;
	dstring jun_name;
	dstring zhou_name;
	dstring desc;
	float defense;
	byte level;
	byte jun_code;
	byte zhou_code;
	byte is_alloted;
	byte state;
	int sol;
	
	int gene_num;
	struct KeyMap genes;

	int idle_wubao_num;
	int wubao_num;
	struct KeyMap wubaos;
	
	RB_ENTRY(City) tlink;
};
typedef struct City City;

extern City *city_new();
extern void city_free(City *c);

extern bool city_set_state(City *city, byte state);
extern int  city_is_war(City *city);

extern bool city_change_sphere(City *city, struct Sph *sph);

extern bool city_add_general(City *city, Gene *gene);
extern bool city_del_general(City *city, Gene *gene);
extern Gene * city_find_general(City *city, int gene_id);
extern Gene * city_find_general_by_min_sol(City *city);

extern bool city_add_wubao(City *city, Wubao *w);
extern bool city_del_wubao(City *city, Wubao *w);
extern Wubao * city_find_wubao(City *city, int id);
extern Wubao * city_get_idle_wubao(City *city);

extern int city_sol_num(City *city);

extern bool city_get_idle_xy(City *city, int *x, int *y);

extern void city_add_defense(City *city, float num);

extern void city_add_sol(City *city, int num);

#endif

