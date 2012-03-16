#include "hf.h"

SdbInfo g_sdb_info[] = { 
	{"SDB_NONE", SDB_NONE, 0, 0},
	{"SDB_TIME", SDB_TIME, 16, SDB_TIME_VN},
	{"SDB_SPH", SDB_SPH,  1024 * 500, SDB_SPH_VN},
	{"SDB_CITY", SDB_CITY, 143 * 500, SDB_CITY_VN},
	{"SDB_WUBAO", SDB_WUBAO, 20000 * 4096, SDB_WUBAO_VN},
	{"SDB_GENE", SDB_GENE, 30000 * 1024, SDB_GENE_VN},
	{"SDB_ARMY", SDB_ARMY, 4096 * 100, SDB_ARMY_VN},
	{"SDB_CMD_TRANS", SDB_CMD_TRANS, 4096 * 100, SDB_CMD_TRANS_VN},
	{"SDB_ORDER", SDB_ORDER, 2000 * 100, SDB_ORDER_VN},
	{"SDB_SELL_ORDER", SDB_SELL_ORDER, 20000 * 100, SDB_SELL_ORDER_VN},
	{"SDB_GUANKA", SDB_GUANKA, 2000 * 8, SDB_GUANKA_VN},
	{"SDB_ROOM", SDB_ROOM, 2000 * 100, SDB_ROOM_VN},
	{"SDB_ALL", SDB_ALL, 0, 0},
};


bool create_sdb(int type, Shmem *shm, Game *g)
{
	if (!(shm && g))
		return false;

	static dstring dst  = DSTRING_INITIAL;
	static dstring tmp = DSTRING_INITIAL;
	int sz = 0;


	/*
	  * body
	  */

	dstring_clear(&dst);
	dstring_clear(&tmp);

	dstring_write_int(&tmp, g_sdb_info[type].ver);

	if (type == SDB_TIME) {
		dstring_write_int(&tmp, g->time);
	}
	else if (type == SDB_SPH) {
		Sph *p = NULL;
		
		RB_FOREACH(p, GameSphMap, &g->sphs) {
			create_sdb_sphere(SDB_SPH_VN, p, &tmp);
		}
	}
	else if (type == SDB_CITY) {
		City*p = NULL;

		RB_FOREACH(p, GameCityMap, &g->cities) {
			create_sdb_city(SDB_CITY_VN, p, &tmp);
		}
	}
	else if (type == SDB_WUBAO) {
		Wubao*p = NULL;

		RB_FOREACH(p, GameWubaoMap, &g->wubaos) {
			create_sdb_wubao(SDB_WUBAO_VN, p, &tmp);
		}
	}
	else if (type == SDB_GENE) {
		Gene *p = NULL;

		RB_FOREACH(p, GameGeneMap, &g->genes) {
			create_sdb_general(SDB_GENE_VN, p, &tmp);
		}
	}
	else if (type == SDB_ARMY) {
		Army *p = NULL;

		RB_FOREACH(p, GameArmyMap, &g->armies) {
			create_sdb_army(SDB_ARMY_VN, p, &tmp);
		}
	}
	else if (type == SDB_CMD_TRANS) {
		CmdTrans *p = NULL;

		RB_FOREACH(p, GameCmdTransferMap, &g->cmd_trans) {
			create_sdb_cmd_trans(SDB_CMD_TRANS_VN, p, &tmp);
		}
	}
	else if (type == SDB_ORDER) {
		Order *p = NULL;

		RB_FOREACH(p, GameOrderMap, &g->orders) {
			create_sdb_order(SDB_ORDER_VN, p, &tmp);
		}
	}
	else if (type == SDB_SELL_ORDER) {
		SellOrder *p = NULL;

		RB_FOREACH(p, GameSellOrderMap, &g->sell_orders) {
			create_sdb_sell_order(SDB_SELL_ORDER_VN, p, &tmp);
		}
	}
	else if (type == SDB_GUANKA) {
		Guanka *p = NULL;

		RB_FOREACH(p, GameGuankaMap, &g->guankas) {
			create_sdb_gk(SDB_GUANKA_VN, p, &tmp);
		}
	}
	else if (type == SDB_ROOM) {
		Room *p = NULL;

		RB_FOREACH(p, GameRoomMap, &g->rooms) {
			create_sdb_room(SDB_ROOM_VN, p, &tmp);
		}
	}
	else {
		return false;
	}

	/* 
	  * write header 
	  */

	sz = tmp.offset + sizeof(int);

	dstring_write_int(&dst, sz);
	dstring_append(&dst, tmp.buf, tmp.offset);

	DEBUG(LOG_FMT"type %s, shm(sid: %d) %d, total size %d\n", LOG_PRE, g_sdb_info[type].name, shm->sid, shm->size, sz);

	return shmem_set(shm, dst.buf, dst.offset);
	  
}


bool parse_sdb(int type, Shmem *src, Game *g)
{
	if (!(src && g))
		return false;

	int sz = 0;
	int ver = 0;

	if (!shmem_read_int(src, &sz))
		return false;

	if (!shmem_read_int(src, &ver))
		return false;

	if (sz <= 0 && ver <= 0)
		return false;

	if (ver != g_sdb_info[type].ver)
		return false;

	while(src->pos < sz) {
		if (type == SDB_TIME) {
			if (!shmem_read_int(src, &g->time)) 
				return false;
		}
		else if (type == SDB_SPH) {
			Sph * sph = sph_new();

			if (!sph) 
				break;

			if (g_opt_up_shm) {
				if (parse_sdb_sphere1(ver, src, sph) == false) {
					sph_free(sph);
					continue;
				}
			}
			else {
				if (parse_sdb_sphere(ver, src, sph) == false) {
					sph_free(sph);
					continue;
				}
			}

			if (!game_add_sph(g, sph))
				sph_free(sph);
		}
		else if (type == SDB_ARMY) {
			Army* p = army_new();

			if (!p) 
				break;

			if (g_opt_up_shm) {
				if (parse_sdb_army1(ver, src, p) == false) {
					army_free(p);
					continue;
				}
			}
			else {
				if (parse_sdb_army(ver, src, p) == false) {
					army_free(p);
					continue;
				}
			}

			if (!game_add_army(g, p))
				army_free(p);
		}
		else if (type == SDB_CITY) {
			City* p = city_new();

			if (!p) 
				break;


			if (g_opt_up_shm) {
				if (parse_sdb_city1(ver, src, p) == false) {
					city_free(p);
					continue;
				}
			}
			else {
				if (parse_sdb_city(ver, src, p) == false) {
					city_free(p);
					continue;
				}
			}
			if (!game_add_city(g, p))
				city_free(p);
		}
		else if (type == SDB_WUBAO) {
			Wubao* p = wubao_new();

			if (!p) 
				break;

			if (g_opt_up_shm) {
				if (parse_sdb_wubao1(ver, src, p) == false) {
					wubao_free(p);
					continue;
				}
			}
			else {
				if (parse_sdb_wubao(ver, src, p) == false) {
					wubao_free(p);
					continue;
				}
			}

			if (!game_add_wubao(g, p))
				wubao_free(p);
		}
		else if (type == SDB_GENE) {
			Gene* p = gene_new();

			if (!p) 
				break;

			if (g_opt_up_shm) {
				if (parse_sdb_general1(ver, src, p) == false) {
					gene_free(p);
					continue;
				}
			}
			else {
				if (parse_sdb_general(ver, src, p) == false) {
					gene_free(p);
					continue;
				}
			}

			if (!game_add_gene(g, p))
				gene_free(p);
		}
		else if (type == SDB_CMD_TRANS) {
			CmdTrans *p = cmd_trans_new1();

			if (!p) 
				break;
			
			if (g_opt_up_shm) {
				if (parse_sdb_cmd_trans1(ver, src, p) == false) {
					cmd_trans_free(p);
					continue;
				}
			}
			else {
				if (parse_sdb_cmd_trans(ver, src, p) == false) {
					cmd_trans_free(p);
					continue;
				}
			}

			if (!game_add_cmd_trans(g, p))
				cmd_trans_free(p);
		}
		else if (type == SDB_ORDER) {
			Order *p = order_new();

			if (!p) 
				break;

			if (g_opt_up_shm) {
				if (parse_sdb_order1(ver, src, p) == false) {
					order_free(p);
					continue;
				}
			}
			else {
				if (parse_sdb_order(ver, src, p) == false) {
					order_free(p);
					continue;
				}
			}
			if (!game_add_order(g, p))
				order_free(p);
		}
		else if (type == SDB_SELL_ORDER) {
			SellOrder *p = sell_order_new();

			if (!p) 
				break;
			
			if (g_opt_up_shm) {
				if (parse_sdb_sell_order1(ver, src, p) == false) {
					sell_order_free(p);
					continue;
				}
			}
			else {
				if (parse_sdb_sell_order(ver, src, p) == false) {
					sell_order_free(p);
					continue;
				}
			}
			if (!game_add_sell_order(g, p))
				sell_order_free(p);
		}
		else if (type == SDB_GUANKA) {
			Guanka *p = guanka_new();
			Guanka *old = NULL;

			if (!p)
				break;
			
			if (g_opt_up_shm) {
				if (parse_sdb_gk1(ver, src, p) == false) {
					guanka_free(p);
					continue;
				}
			}
			else {
				if (parse_sdb_gk(ver, src, p) == false) {
					guanka_free(p);
					continue;
				}
			}

			if ((old = game_find_guanka(g, p->id))) {
				old->used = p->used;
				guanka_free(p);
			}
			else if (!game_add_guanka(g, p)) {
				guanka_free(p);
			}
		}
		else if (type == SDB_ROOM) {
			Room *p = room_new();

			if (!p) 
				break;
			
			if (g_opt_up_shm) {
				if (parse_sdb_room1(ver, src, p) == false) {
					room_free(p);
					continue;
				}
			}
			else {
				if (parse_sdb_room(ver, src, p) == false) {
					room_free(p);
					continue;
				}
			}
			if (!game_add_room(g, p))
				room_free(p);
		}
		else {
			return false;
		}
	}

	
	DEBUG(LOG_FMT"type %s, shm(sid: %d) size %d, total size %d\n", LOG_PRE, \
			g_sdb_info[type].name, src->sid, src->size, sz);

	return true;
}




