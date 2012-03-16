#ifndef _SPHERE_H_
#define _SPHERE_H_
#include "tools.h"
#include "user.h"
#include "diplomacy.h"
#include "talk.h"


struct Sph {
	int id;
	int uid;
	dstring name;
	dstring desc;
	int level;
	int prestige;
	int left_prestige;
	int max_member;
	byte is_npc;

	/* 
	 * use target sphere id as key, diplomacy id as value 
	 */
	struct KeyMap dipl;
	int dipl_num;
	
	struct KeyMap city;
	int city_num;

	struct KeyMap wubao;
	int wubao_num;
	
	RB_ENTRY(Sph) tlink;
};
typedef struct Sph Sph;


extern Sph *sph_new();
extern void sph_free(Sph *sph);

extern int sph_relation(Sph * sph1, Sph * sph2);

extern bool sph_add_dipl(Sph *sph, int target_sph_id, int dipl_id);
extern bool sph_del_dipl(Sph *sph, int target_sph_id);
extern Dipl * sph_find_dipl(Sph *sph, int target_sph_id);

extern bool sph_add_city(Sph *sph, int city_id);
extern bool sph_del_city(Sph *sph, int city_id);
extern City *sph_find_city(Sph *sph, int city_id);
extern City *sph_get_city(Sph *sph);

extern bool sph_add_wubao(Sph *sph, Wubao *w);
extern bool sph_del_wubao(Sph *sph, Wubao *w);
extern Wubao * sph_find_wubao(Sph *sph, int id);

extern int sph_add_prestige(Sph *sph, int num);
#endif


