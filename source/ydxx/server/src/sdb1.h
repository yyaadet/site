
#ifndef _SDB1_H_
#define _SDB1_H_

#include "game.h"


extern void create_sdb_sphere(int ver, Sph *sph, dstring *dst);
extern void create_sdb_general(int ver, Gene *gene, dstring *dst);
extern void create_sdb_army(int ver, Army *army, dstring *dst);
extern void create_sdb_city(int ver, City *city, dstring *dst);
extern void create_sdb_wubao(int ver, Wubao *w, dstring *dst);
extern void create_sdb_cmd_trans(int ver, CmdTrans *cmd, dstring *dst);
extern void create_sdb_order(int ver, Order *o, dstring *dst);
extern void create_sdb_sell_order(int ver, SellOrder *o, dstring *dst);
extern void create_sdb_gk(int ver, Guanka *p, dstring *dst);
extern void create_sdb_room(int ver, Room *p, dstring *dst);

extern bool parse_sdb_sphere(int ver, Shmem *src, Sph *sph);
extern bool parse_sdb_city(int ver, Shmem *src, City *city);
extern bool parse_sdb_general(int ver, Shmem *src, Gene *gene);
extern bool parse_sdb_army(int ver, Shmem *src, Army *army);
extern bool parse_sdb_wubao(int ver, Shmem *src, Wubao *w);
extern bool parse_sdb_cmd_trans(int ver, Shmem *src, CmdTrans *cmd);
extern bool parse_sdb_order(int ver, Shmem *src, Order *o);
extern bool parse_sdb_sell_order(int ver, Shmem *src, SellOrder *o);
extern bool parse_sdb_gk(int ver, Shmem *src, Guanka *p);
extern bool parse_sdb_room(int ver, Shmem *src, Room *p);

#endif


