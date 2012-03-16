#ifndef _ROOM_H_
#define _ROOM_H_


#define ROOM_USER_NUM 20

typedef struct Room{
    int id;
    int attack_sph_id;
    int defense_sph_id;
    int city_id;
    int ts;
    int attack_uid[ROOM_USER_NUM];
    int defense_uid[ROOM_USER_NUM];
    int is_win;
    int is_npc;
	
    RB_ENTRY(Room) tlink;
}Room;


extern Room *room_new();
extern void room_free(Room *room);

extern bool room_run(Room *r);
extern bool room_has_uid(Room *r, int uid);
extern void room_alloc_defense_uid(Room *r);

#endif
