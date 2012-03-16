#ifndef _ARMY_H_
#define _ARMY_H_
#include "defines.h"
#include "ev.h"
#include "city.h"
#include "tree.h"
#include "queue.h"
#include "tools.h"



enum ARMY_STATE {
	ARMY_NONE,
	ARMY_NORMAL,
	ARMY_FIGHT,
	ARMY_DEAD,
};

enum WAR_TARGET {
	WAR_TARGET_NONE = 0,
	WAR_TARGET_ARMY,
	WAR_TARGET_CITY,
};

enum EXPEDITION_TYPE {
	EXPEDITION_NONE, 
	EXPEDITION_JIXI,
	EXPEDITION_NORMAL,
	EXPEDITION_GENE,
};


struct Army {
	int id;
	int gene_id;
	int x;
	int y;
	int money;
	int food;
	int original;
	byte type;
	byte state;
	byte move_target;
	int move_target_id;
	int last_change_zhen_time;
	byte from_place;
	int from_place_id;
	
	int move_tp_num;
	TAILQ_HEAD(, TimePos) move_tp;
	
	byte war_target_type;
	int war_target_id;
	Ev *ev;

	RB_ENTRY(Army) tlink;
	TAILQ_ENTRY(Army) link;
};
typedef struct Army Army;

extern Army * army_new();

extern Army * army_new1(int gene_id, int x, int y, int money, int food, int type, int orig);

extern void army_free(Army *army);

extern bool army_move(Army *army);

extern void army_continue_to_move(Army *army);

extern void army_end_move(Army *army);

extern int  army_get_speed(Army *army);

extern bool army_set_state(Army *army, byte state);

extern bool army_get_war_target(Army *army, Gene *gene);

extern bool is_neighbour(Pos *p1, Pos *p2);

extern City  *find_fightable_city(Army *army, Gene *gene);
extern Army  *find_fightable_army(Army *army, Gene *gene);

extern bool is_fightable(Army *army, Gene *gene, City *city);
extern bool is_fightable1(Army *army, Gene *gene, Army *enemy);

extern void army_go_in_city(Army *army, Gene *gene, City *city);

extern uint gen_army_id();

extern bool pos_in_city_region(int x, int y, City *city, int dist);

extern bool is_deny_war(int *h);

extern void update_army_position(int fd, short flag, void *arg);

#endif

