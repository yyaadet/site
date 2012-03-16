
#ifndef _SDB2_H_
#define _SDB2_H_

#include "game.h"


extern void create_sdb_sphere1(int ver, Sph *sph, dstring *dst);
extern void create_sdb_general1(int ver, Gene *gene, dstring *dst);
extern void create_sdb_army1(int ver, Army *army, dstring *dst);
extern void create_sdb_city1(int ver, City *city, dstring *dst);
extern void create_sdb_wubao1(int ver, Wubao *w, dstring *dst);
extern void create_sdb_cmd_trans1(int ver, CmdTrans *cmd, dstring *dst);
extern void create_sdb_order1(int ver, Order *o, dstring *dst);
extern void create_sdb_sell_order1(int ver, SellOrder *o, dstring *dst);
extern void create_sdb_gk1(int ver, Guanka *o, dstring *dst);
extern void create_sdb_room1(int ver, Room *o, dstring *dst);

extern bool parse_sdb_sphere1(int ver, Shmem *src, Sph *sph);
extern bool parse_sdb_city1(int ver, Shmem *src, City *city);
extern bool parse_sdb_general1(int ver, Shmem *src, Gene *gene);
extern bool parse_sdb_army1(int ver, Shmem *src, Army *army);
extern bool parse_sdb_wubao1(int ver, Shmem *src, Wubao *w);
extern bool parse_sdb_cmd_trans1(int ver, Shmem *src, CmdTrans *cmd);
extern bool parse_sdb_order1(int ver, Shmem *src, Order *o);
extern bool parse_sdb_sell_order1(int ver, Shmem *src, SellOrder *o);
extern bool parse_sdb_gk1(int ver, Shmem *src, Guanka *o);
extern bool parse_sdb_room1(int ver, Shmem *src, Room *o);

#endif


