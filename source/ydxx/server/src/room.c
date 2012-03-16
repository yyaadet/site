#include "hf.h"

struct RoomNpc {
	int id;
	int level;
	int face_id;
	const char *name;
	uint skill;
	int zhen;
	int kongfu;
	int intel;
	int polity;
	struct GeneWeap weap[GENE_WEAP_NUM];
	float train;
	float spirit;
	int sol;
    int has_sph;
};
typedef struct RoomNpc RoomNpc;

static RoomNpc g_room_npcs[] = {
    {1, 0, 661, "弩兵偏将", 32, 2, 60, 80, 60, {{3, 3}, {0, 0}, {5, 2}, {0, 0}}, 30, 90, 2000, 0},
    {2, 0, 661, "弩兵偏将", 32, 2, 60, 80, 60, {{3, 3}, {0, 0}, {5, 2}, {0, 0}}, 30, 90, 2000, 0},
    {3, 0, 661, "弩兵偏将", 32, 2, 60, 80, 60, {{3, 3}, {0, 0}, {5, 2}, {0, 0}}, 30, 90, 2000, 0},
    {4, 0, 663, "弩兵牙将", 192, 2, 60, 90, 60, {{3, 5}, {0, 0}, {6, 3}, {0, 0}}, 60, 100, 2000, 1},
    {5, 0, 663, "弩兵牙将", 192, 2, 60, 90, 60, {{3, 5}, {0, 0}, {6, 3}, {0, 0}}, 60, 100, 2000, 1},
    {6, 0, 663, "弩兵牙将", 192, 2, 60, 90, 60, {{3, 5}, {0, 0}, {6, 3}, {0, 0}}, 60, 100, 2000, 1},
    {7, 0, 663, "弩兵牙将", 192, 2, 60, 90, 60, {{3, 5}, {0, 0}, {6, 3}, {0, 0}}, 60, 100, 2000, 1},
    {8, 0, 663, "弩兵牙将", 192, 2, 60, 90, 60, {{3, 5}, {0, 0}, {6, 3}, {0, 0}}, 60, 100, 2000, 1},
    {9, 0, 663, "弩兵牙将", 192, 2, 60, 90, 60, {{3, 5}, {0, 0}, {6, 3}, {0, 0}}, 60, 100, 2000, 1},
};


static bool room_user_fight(Room *r, User *attack, User *defense);
static bool room_npc_fight(Room *r, User *attack, int npc_uid);
static bool room_attack_is_null(Room *r);

Room *room_new()
{
    int now = 0;
    int futhur = 0;
    Room *r = cache_pool_alloc(POOL_ROOM);

    if (!r)
        return NULL;

    memset(r, 0, sizeof(*r));

    now = time(NULL);

    futhur = get_next_timestamp(19, 30);

    r->ts = GAME_NOW + ((futhur - now) / GAME_HOUR_PER_SEC);
    /*
    r->ts = GAME_NOW + 6;
    */

    return r;
}

void room_alloc_defense_uid(Room *r)
{
    if (!r)
        return ;

    int i = 0;

    for(i = 0; i < ROOM_USER_NUM; i++) {
        r->defense_uid[i] = -(i + 1);
    }

}

void room_free(Room *room)
{
    cache_pool_free(POOL_ROOM, room);
}

bool room_run(Room *r)
{
    if (!r) 
        return false;

    Game *g = GAME;
    int i = 0;
    int t = 0;
    User *attack, *defense;
    City *city = NULL;
    Sph *sph = NULL;

    if (!(city = game_find_city(g, r->city_id))) {
       return false;
    }
    
    if (!(sph = game_find_sph(g, r->attack_sph_id))) {
       return false;
    }

    r->is_win = 1;

    if (room_attack_is_null(r)) {
        r->is_win = 0;
    }
    else {
        for (i = 0; i < ROOM_USER_NUM; i++) {
            if (r->attack_uid[i] <= 0) {
                continue;
            }

            if (!(attack = game_find_user(g, r->attack_uid[i]))) {
                continue;
            }

            for ( ; t < ROOM_USER_NUM; t++) {
                if (r->defense_uid[t] == 0) 
                    continue;

                defense = game_find_user(g, r->defense_uid[t]);

                if (r->is_npc) {
                    r->is_win = room_npc_fight(r, attack, r->defense_uid[t]);
                } 
                else {
                    r->is_win = room_user_fight(r, attack, defense);
                }

                DEBUG(LOG_FMT"attack %d, defense %d\n", LOG_PRE, r->attack_uid[i], \
                        r->defense_uid[t]);

                if (!r->is_win) {
                    break;
                }
            }
        }
    }


    if (r->is_win) {
        if (city->sph_id != sph->id) {
            sph->prestige += 2000;
            city_change_sphere(city, sph);
            send_nf_city_where(city, WHERE_ALL);
        }

        send_got_city_talk_msg(sph, city, 1);
    } 
    else {
        send_got_city_talk_msg(sph, city, 0);
    }
	

    return false;
}

static bool room_attack_is_null(Room *r)
{
    int i = 0;

    for (i = 0; i < ROOM_USER_NUM; i++) {
        if (r->attack_uid[i] > 0) {
            return false;
        }
    }

    return true;
}

static bool room_user_fight(Room *r, User *attack, User *defense) 
{
    if (!(attack && r))
        return false;
    if (!defense)
        return true;
  
    Game *g = GAME;  
    War *war = NULL;
    Key *k = NULL;
    Wubao *w, *w1;
    Gene *gene = NULL;
    WarGene *war_gene = NULL;
    int id = 1;
    int j = 0;
    bool ret = false;

	
    if (!(w = game_find_wubao(g, attack->wid))) {
		goto error;
	}

	if (!(w1 = game_find_wubao(g, defense->wid))) {
		goto error;
	}

    if (!(war = war_new())) {
		goto error;
	}

    war->room_id = r->id;
    war->uid = attack->id;
    war->target_uid = defense->id;

	dstring_append(&war->name, dstring_buf(&attack->name), dstring_offset(&attack->name));
	
	dstring_append(&war->target_name, dstring_buf(&defense->name), dstring_offset(&defense->name));
	
	RB_FOREACH(k, KeyMap, &w->genes) {
		if (!(gene = game_find_gene(g, k->id))) {
			continue;
		}

		if (gene->uid != attack->id || gene->sol_num <= 0) 
			continue;

		if (!(war_gene = war_gene_new())) {
			goto error;
		}

        dstring_set(&war_gene->name, gene_get_full_name(gene));
		war_gene->id = id++;
		war_gene->gene_id = gene->id;
		war_gene->kongfu = gene_get_kongfu(gene);
		war_gene->intel = gene_get_intel(gene);
		war_gene->polity = gene_get_polity(gene);
        war_gene->speed = gene_get_speed(gene);
		war_gene->zhen = gene->used_zhen;
		war_gene->skill = gene->skill;
		war_gene->old_train = gene->level;
		war_gene->train = gene->level;
		war_gene->old_spirit = gene->sol_spirit;
		war_gene->spirit = gene->sol_spirit;
		war_gene->sol = gene->sol_num;
		war_gene->old_sol = gene->sol_num;
		war_gene->hurt = gene->hurt_num;
		war_gene->uid = gene->uid;
		for(j = 0; j < GENE_WEAP_NUM; j++) {
			war_gene->weap[j].id = gene->weap[j].id;
			war_gene->weap[j].level = gene->weap[j].level;
		}

		TAILQ_INSERT_TAIL(&war->genes, war_gene, link);
		war->gene_num++;
	}
	
	RB_FOREACH(k, KeyMap, &w1->genes) {
		if (!(gene = game_find_gene(g, k->id))) {
			continue;
		}

		if (gene->uid != defense->id || gene->sol_num <= 0) 
			continue;

		if (!(war_gene = war_gene_new())) {
			goto error;
		}

        dstring_set(&war_gene->name, gene_get_full_name(gene));
		war_gene->id = id++;
		war_gene->gene_id = gene->id;
		war_gene->kongfu = gene_get_kongfu(gene);
		war_gene->intel = gene_get_intel(gene);
		war_gene->polity = gene_get_polity(gene);
        war_gene->speed = gene_get_speed(gene);
		war_gene->zhen = gene->used_zhen;
		war_gene->skill = gene->skill;
		war_gene->old_train = gene->level;
		war_gene->train = gene->level;
		war_gene->old_spirit = gene->sol_spirit;
		war_gene->spirit = gene->sol_spirit;
		war_gene->sol = gene->sol_num;
		war_gene->old_sol = gene->sol_num;
		war_gene->hurt = gene->hurt_num;
		war_gene->uid = gene->uid;
		for(j = 0; j < GENE_WEAP_NUM; j++) {
			war_gene->weap[j].id = gene->weap[j].id;
			war_gene->weap[j].level = gene->weap[j].level;
		}

		TAILQ_INSERT_TAIL(&war->target_genes, war_gene, link);
		war->target_gene_num++;
	}
		

	/* fight */
	do_war(war);

	send_nf_fight_where(war, WHERE_ALL);
	
    TAILQ_FOREACH(war_gene, &war->genes, link) {
		if ((gene = game_find_gene(g, war_gene->gene_id))) {
			gene->sol_num = war_gene->sol;
			gene->hurt_num = war_gene->hurt;
			gene->sol_spirit = war_gene->spirit;
			if (gene->sol_spirit < DEF_SOL_SPIRIT) {
				gene->sol_spirit = DEF_SOL_SPIRIT;
			}
			else if (gene->sol_spirit > MAX_SOL_SPIRIT) {
				gene->sol_spirit = MAX_SOL_SPIRIT;
			}

			send_nf_gene_where(gene, WHERE_ALL);
		}
	}
    
    TAILQ_FOREACH(war_gene, &war->target_genes, link) {
		if ((gene = game_find_gene(g, war_gene->gene_id))) {
			gene->sol_num = war_gene->sol;
			gene->hurt_num = war_gene->hurt;
			gene->sol_spirit = war_gene->spirit;
			if (gene->sol_spirit < DEF_SOL_SPIRIT) {
				gene->sol_spirit = DEF_SOL_SPIRIT;
			}
			else if (gene->sol_spirit > MAX_SOL_SPIRIT) {
				gene->sol_spirit = MAX_SOL_SPIRIT;
			}

			send_nf_gene_where(gene, WHERE_ALL);
		}
	}

    ret = war->is_win;

    war_free(war);

    return ret;

error:
    war_free(war);
    return false;
}

static bool room_npc_fight(Room *r, User *attack, int npc_uid) 
{
    if (!(r && attack))
        return false;
  
    Game *g = GAME;  
    War *war = NULL;
    Key *k = NULL;
    Wubao *w;
    Gene *gene = NULL;
    WarGene *war_gene = NULL;
    int id = 1;
    int j = 0;
    int i = 0;
    bool ret = false;

	
    if (!(w = game_find_wubao(g, attack->wid))) {
		goto error;
	}

    if (!(war = war_new())) {
		goto error;
	}

    war->room_id = r->id;
    war->uid = attack->id;
    war->target_uid = npc_uid;

	dstring_append(&war->name, dstring_buf(&attack->name), dstring_offset(&attack->name));
	
	dstring_append(&war->target_name, "NPC", 3);
	
	RB_FOREACH(k, KeyMap, &w->genes) {
		if (!(gene = game_find_gene(g, k->id))) {
			continue;
		}

		if (gene->uid != attack->id || gene->sol_num <= 0) 
			continue;

		if (!(war_gene = war_gene_new())) {
			goto error;
		}

        dstring_set(&war_gene->name, gene_get_full_name(gene));
		war_gene->id = id++;
		war_gene->gene_id = gene->id;
		war_gene->kongfu = gene_get_kongfu(gene);
		war_gene->intel = gene_get_intel(gene);
		war_gene->polity = gene_get_polity(gene);
        war_gene->speed = gene_get_speed(gene);
		war_gene->zhen = gene->used_zhen;
		war_gene->skill = gene->skill;
		war_gene->old_train = gene->level;
		war_gene->train = gene->level;
		war_gene->old_spirit = gene->sol_spirit;
		war_gene->spirit = gene->sol_spirit;
		war_gene->sol = gene->sol_num;
		war_gene->old_sol = gene->sol_num;
		war_gene->hurt = gene->hurt_num;
		war_gene->uid = gene->uid;
		for(j = 0; j < GENE_WEAP_NUM; j++) {
			war_gene->weap[j].id = gene->weap[j].id;
			war_gene->weap[j].level = gene->weap[j].level;
		}

		TAILQ_INSERT_TAIL(&war->genes, war_gene, link);
		war->gene_num++;
	}

    for (i = 0; i < ARRAY_LEN(g_room_npcs, RoomNpc); i++) {

        RoomNpc *npc = &g_room_npcs[i];

        if (r->defense_sph_id > 0 && npc->has_sph == 0) {
            continue;
        }
        else if (r->defense_sph_id <= 0 && npc->has_sph == 1) {
            continue;
        }

        if (!(war_gene = war_gene_new())) {
            goto error;
        }

        dstring_set(&war_gene->name, npc->name);
        war_gene->id = id++;
        war_gene->gene_id = 0;
        war_gene->kongfu = npc->kongfu;
        war_gene->intel = npc->intel;
        war_gene->polity = npc->polity;
        war_gene->speed = 0;
        war_gene->zhen = npc->zhen;
        war_gene->skill = npc->skill;
        war_gene->old_train = npc->train;
        war_gene->train = npc->train;
        war_gene->old_spirit = npc->spirit;
        war_gene->spirit = npc->spirit;
        war_gene->sol = npc->sol;
        war_gene->old_sol = npc->sol;
        war_gene->hurt = 0;
        war_gene->uid = 0;
        for (j = 0; j < GENE_WEAP_NUM; j++) {
            war_gene->weap[j].id = npc->weap[j].id;
            war_gene->weap[j].level = npc->weap[j].level;
        }

        TAILQ_INSERT_TAIL(&war->target_genes, war_gene, link);
        war->target_gene_num++;
    }

		

	/* fight */
	do_war(war);

	send_nf_fight_where(war, WHERE_ALL);
    
    TAILQ_FOREACH(war_gene, &war->genes, link) {
		if ((gene = game_find_gene(g, war_gene->gene_id))) {
			gene->sol_num = war_gene->sol;
			gene->hurt_num = war_gene->hurt;
			gene->sol_spirit = war_gene->spirit;
			if (gene->sol_spirit < DEF_SOL_SPIRIT) {
				gene->sol_spirit = DEF_SOL_SPIRIT;
			}
			else if (gene->sol_spirit > MAX_SOL_SPIRIT) {
				gene->sol_spirit = MAX_SOL_SPIRIT;
			}

			send_nf_gene_where(gene, WHERE_ALL);
		}
	}
    
    ret = war->is_win;

    war_free(war);

    return ret;

error:
    war_free(war);
    return false;
}

bool room_has_uid(Room *r, int uid)
{
    if (!r)
        return false;
    int i = 0;

    for(i = 0; i < ROOM_USER_NUM; i++) {
        if (r->attack_uid[i] == uid)
            return true;
    }
    
    for(i = 0; i < ROOM_USER_NUM; i++) {
        if (r->defense_uid[i] == uid)
            return true;
    }

    return false;
}

