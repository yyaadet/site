#include "hf.h"

void create_sdb_sphere1(int version, Sph *sph, dstring *dst)
{
	if (!( dst && sph))
		return;
	dstring_write_int(dst, sph->id);
	dstring_write_string1(dst, sph->name.buf, sph->name.offset);
	dstring_write_int(dst, sph->uid);
	dstring_write_int(dst, sph->level);
	dstring_write_int(dst, sph->prestige);
	dstring_write_string1(dst, sph->desc.buf, sph->desc.offset);
	dstring_write_byte(dst, sph->is_npc);
}

bool parse_sdb_sphere1(int ver, Shmem *src, Sph *sph)
{
	if (!(src && sph))
		return false;
	shmem_read_int(src, &sph->id);
	shmem_read_string(src, &sph->name);
	shmem_read_int(src, &sph->uid);
	shmem_read_int(src, &sph->level);
	shmem_read_int(src, &sph->prestige);
	shmem_read_string(src, &sph->desc);
	shmem_read_byte(src, &sph->is_npc);
	return true;
}

void create_sdb_city1(int version, City *city, dstring * dst)
{
	if (!(city && dst)) 
		return;

		dstring_write_int(dst, city->id);
	dstring_write_int(dst, city->sph_id);
	dstring_write_byte(dst, city->level);
	dstring_write_string1(dst, city->name.buf, city->name.offset);
	dstring_write_string1(dst, city->jun_name.buf, city->jun_name.offset);
	dstring_write_string1(dst, city->zhou_name.buf, city->zhou_name.offset);
	dstring_write_string1(dst, city->desc.buf, city->desc.offset);
	dstring_write_float(dst, city->defense);
	dstring_write_byte(dst, city->is_alloted);
	dstring_write_int(dst, city->x);
	dstring_write_int(dst, city->y);
	dstring_write_byte(dst, city->jun_code);
	dstring_write_byte(dst, city->zhou_code);
	dstring_write_int(dst, city->sol);

}	
	
bool parse_sdb_city1(int ver, Shmem *src, City *city)
{
	if (!(src && city)) 
		return false;
	
		shmem_read_int(src, &city->id);
	shmem_read_int(src, &city->sph_id);
	shmem_read_byte(src, &city->level);
	shmem_read_string(src, &city->name);
	shmem_read_string(src, &city->jun_name);
	shmem_read_string(src, &city->zhou_name);
	shmem_read_string(src, &city->desc);
	shmem_read_float(src, &city->defense);
	shmem_read_byte(src, &city->is_alloted);
	shmem_read_int(src, &city->x);
	shmem_read_int(src, &city->y);
	shmem_read_byte(src, &city->jun_code);
	shmem_read_byte(src, &city->zhou_code);
	shmem_read_int(src, &city->sol);

	return true; 
}	
	
void create_sdb_general1(int version, Gene *gene, dstring *dst)
{
	if (!(gene && dst))
		return;

	int i = 0;
	dstring_write_int(dst, gene->id);
	dstring_write_int(dst, gene->uid);
	dstring_write_string1(dst, gene->first_name.buf, gene->first_name.offset);
	dstring_write_string1(dst, gene->last_name.buf, gene->last_name.offset);
	dstring_write_string1(dst, gene->zi.buf, gene->zi.offset);
	dstring_write_byte(dst, gene->type);
	dstring_write_byte(dst, gene->sex);
	dstring_write_byte(dst, gene->is_dead);
	dstring_write_short(dst, gene->born_year);
	dstring_write_short(dst, gene->init_year);
	dstring_write_short(dst, gene->die_year);
	dstring_write_int(dst, gene->face_id);
	dstring_write_byte(dst, gene->place);
	dstring_write_int(dst, gene->place_id);
	dstring_write_int(dst, gene->kongfu);
	dstring_write_int(dst, gene->speed);
	dstring_write_int(dst, gene->polity);
	dstring_write_int(dst, gene->intel);
	dstring_write_float(dst, gene->faith);
	dstring_write_uint(dst, gene->skill);
	dstring_write_uint(dst, gene->zhen);
	dstring_write_uint(dst, gene->used_zhen);
	dstring_write_uint(dst, gene->sol_num);
	dstring_write_float(dst, gene->sol_spirit);
	dstring_write_int(dst, gene->fri);
	dstring_write_uint(dst, gene->hurt_num);
	dstring_write_int(dst, gene->fol);


	for(i = 0; i < GENE_WEAP_NUM; i++) {
		dstring_write_int(dst, gene->weap[i].id);
		dstring_write_int(dst, gene->weap[i].level);
	}
}
	
	
bool parse_sdb_general1(int ver, Shmem *src, Gene *gene)
{
	if (!(src && gene))
		return false;

	int i = 0;
	shmem_read_int(src, &gene->id);
	shmem_read_int(src, &gene->uid);
	shmem_read_string(src, &gene->first_name);
	shmem_read_string(src, &gene->last_name);
	shmem_read_string(src, &gene->zi);
	shmem_read_byte(src, &gene->type);
	shmem_read_byte(src, &gene->sex);
	shmem_read_byte(src, &gene->is_dead);
	shmem_read_short(src, &gene->born_year);
	shmem_read_short(src, &gene->init_year);
	shmem_read_short(src, &gene->die_year);
	shmem_read_int(src, &gene->face_id);
	shmem_read_byte(src, &gene->place);
	shmem_read_int(src, &gene->place_id);
	shmem_read_int(src, &gene->kongfu);
	shmem_read_int(src, &gene->speed);
	shmem_read_int(src, &gene->polity);
	shmem_read_int(src, &gene->intel);
	shmem_read_float(src, &gene->faith);
	shmem_read_uint(src, &gene->skill);
	shmem_read_uint(src, &gene->zhen);
	shmem_read_uint(src, &gene->used_zhen);
	shmem_read_uint(src, &gene->sol_num);
	shmem_read_float(src, &gene->sol_spirit);
	shmem_read_int(src, &gene->fri);
	shmem_read_uint(src, &gene->hurt_num);
	shmem_read_int(src, &gene->fol);

	
	for(i = 0; i < GENE_WEAP_NUM; i++) {
		shmem_read_int(src, &gene->weap[i].id);
		shmem_read_int(src, &gene->weap[i].level);
	}
	return true;
}

	
void create_sdb_army1(int version, Army *army, dstring *dst)
{

	if (!(army && dst)) 
		return ;

	dstring_write_int(dst, army->id);
	dstring_write_int(dst, army->x);
	dstring_write_int(dst, army->y);
	dstring_write_int(dst, army->money);
	dstring_write_int(dst, army->food);
	dstring_write_int(dst, army->original);
	dstring_write_int(dst, army->gene_id);
	dstring_write_byte(dst, army->type);
	dstring_write_byte(dst, army->state);
	dstring_write_byte(dst, army->from_place);
	dstring_write_int(dst, army->from_place_id);

}
	
bool parse_sdb_army1(int ver, Shmem *src, Army *army)
{

	if (!(src && army))
		return false;

	shmem_read_int(src, &army->id);
	shmem_read_int(src, &army->x);
	shmem_read_int(src, &army->y);
	shmem_read_int(src, &army->money);
	shmem_read_int(src, &army->food);
	shmem_read_int(src, &army->original);
	shmem_read_int(src, &army->gene_id);
	shmem_read_byte(src, &army->type);
	shmem_read_byte(src, &army->state);
	shmem_read_byte(src, &army->from_place);
	shmem_read_int(src, &army->from_place_id);

	return true;
}	
	
void create_sdb_wubao1(int version, Wubao *w, dstring *dst)
{

	if (!(w && dst)) 
		return ;
	
	int i = 0;
	int j = 0;
	Key *k ;
	dstring_write_int(dst, w->id);
	dstring_write_int(dst, w->uid);
	dstring_write_int(dst, w->people);
	dstring_write_int(dst, w->family);
	dstring_write_int(dst, w->prestige);
	dstring_write_int(dst, w->city_id);
	dstring_write_int(dst, w->sph_id);
	dstring_write_int(dst, w->dig_id);
	dstring_write_int(dst, w->off_id);
	dstring_write_int(dst, w->sol);
	dstring_write_int(dst, w->got_sol);
	dstring_write_int(dst, w->used_made);
	dstring_write_int(dst, w->cure_sol);
	dstring_write_int(dst, w->max_gene);
	dstring_write_int(dst, w->task_id);
	dstring_write_int(dst, w->task_is_fin);
	dstring_write_int(dst, w->last_welfare_time);


	for(i = 0; i < RES_MAX - 1; i++) {
		dstring_write_int(dst, w->res[i]);
	}
	
	for(i = 0; i < WEAP_MAX - 1; i++) {
		for(j = 0; j < WEAP_LEVEL_MAX; j++) {
			dstring_write_int(dst, w->weap[i].id);
			dstring_write_int(dst, w->weap[i].num[j]);
		}
	}
	
	for(i = 0; i < BUILDING_MAX - 1; i++) {
		dstring_write_int(dst, w->build[i].id);
		dstring_write_int(dst, w->build[i].level);
		dstring_write_int(dst, w->build[i].up_end_time);
	}
	
	for(i = 0; i < TECH_MAX - 1; i++) {
		dstring_write_int(dst, w->tech[i].id);
		dstring_write_int(dst, w->tech[i].level);
		dstring_write_int(dst, w->tech[i].up_end_time);
	}

	dstring_write_int(dst, w->fri_num);
	RB_FOREACH(k, KeyMap, &w->fris) {
		dstring_write_int(dst, k->id);
		dstring_write_int(dst, (int)k->arg);
	}
	
	dstring_write_int(dst, w->task_fin_num);
	RB_FOREACH(k, KeyMap, &w->task_fins) {
		dstring_write_int(dst, k->id);
	}
	
}
	
bool parse_sdb_wubao1(int ver, Shmem *src, Wubao *w)
{

	if (!(src && w))
		return false;

	Game *g = GAME;
	int i = 0;
	int j = 0;
	int num = 0;
	shmem_read_int(src, &w->id);
	shmem_read_int(src, &w->uid);
	shmem_read_int(src, &w->people);
	shmem_read_int(src, &w->family);
	shmem_read_int(src, &w->prestige);
	shmem_read_int(src, &w->city_id);
	shmem_read_int(src, &w->sph_id);
	shmem_read_int(src, &w->dig_id);
	shmem_read_int(src, &w->off_id);
	shmem_read_int(src, &w->sol);
	shmem_read_int(src, &w->got_sol);
	shmem_read_int(src, &w->used_made);
	shmem_read_int(src, &w->cure_sol);
	shmem_read_int(src, &w->max_gene);
	shmem_read_int(src, &w->task_id);
	shmem_read_int(src, &w->task_is_fin);
	shmem_read_int(src, &w->last_welfare_time);


	for(i = 0; i < RES_MAX - 1; i++) {
		shmem_read_int(src, &w->res[i]);
	}
	
	for(i = 0; i < WEAP_MAX - 1; i++) {
		for(j = 0; j < WEAP_LEVEL_MAX; j++) {
			shmem_read_int(src, &w->weap[i].id);
			shmem_read_int(src, &w->weap[i].num[j]);
		}
	}
	
	for(i = 0; i < BUILDING_MAX - 1; i++) {
		shmem_read_int(src, &w->build[i].id);
		shmem_read_int(src, &w->build[i].level);
		shmem_read_int(src, &w->build[i].up_end_time);
	}
	
	for(i = 0; i < TECH_MAX - 1; i++) {
		shmem_read_int(src, &w->tech[i].id);
		shmem_read_int(src, &w->tech[i].level);
		shmem_read_int(src, &w->tech[i].up_end_time);
	}
	
	shmem_read_int(src, &num);
	for(i = 0; i < num; i++) {
		int gene_id = 0;
		int fri = 0;

		shmem_read_int(src, &gene_id);
		shmem_read_int(src, &fri);

		wubao_add_fri(w, gene_id, fri);
	}
	
	shmem_read_int(src, &num);
	for(i = 0; i < num; i++) {
		int task_id = 0;
		Task *t = NULL;

		shmem_read_int(src, &task_id);
		if (!(t = game_find_task(g, task_id)))
			continue;

		wubao_add_task_fin(w, t);
	}

	return true;
}	
	
void create_sdb_cmd_trans1(int version, CmdTrans *cmd, dstring *dst)
{

	if (!(cmd && dst)) 
		return ;

	dstring_write_int(dst, cmd->id);
	dstring_write_int(dst, cmd->type);
	dstring_write_int(dst, cmd->from_id);
	dstring_write_int(dst, cmd->to_id);
	dstring_write_int(dst, cmd->sph_id);
	dstring_write_int(dst, cmd->good_type);
	dstring_write_int(dst, cmd->good_id);
	dstring_write_int(dst, cmd->good_num);
	dstring_write_int(dst, cmd->end);

	
}
	
bool parse_sdb_cmd_trans1(int ver, Shmem *src, CmdTrans *cmd)
{

	if (!(src && cmd))
		return false;
	shmem_read_int(src, &cmd->id);
	shmem_read_int(src, &cmd->type);
	shmem_read_int(src, &cmd->from_id);
	shmem_read_int(src, &cmd->to_id);
	shmem_read_int(src, &cmd->sph_id);
	shmem_read_int(src, &cmd->good_type);
	shmem_read_int(src, &cmd->good_id);
	shmem_read_int(src, &cmd->good_num);
	shmem_read_int(src, &cmd->end);

	
	return true;
}	
	
void create_sdb_order1(int version, Order *o, dstring *dst)
{

	if (!(o && dst)) 
		return ;

	dstring_write_int(dst, o->id);
	dstring_write_int(dst, o->uid);
	dstring_write_int(dst, o->type);
	dstring_write_int(dst, o->res);
	dstring_write_int(dst, o->num);
	dstring_write_int(dst, o->deal_num);
	dstring_write_int(dst, o->unit_money);
	dstring_write_int(dst, o->last_unit_money);
	dstring_write_int(dst, o->money);
	dstring_write_int(dst, o->ts);

	
}
	
bool parse_sdb_order1(int ver, Shmem *src, Order *o)
{

	if (!(src && o))
		return false;
	shmem_read_int(src, &o->id);
	shmem_read_int(src, &o->uid);
	shmem_read_int(src, &o->type);
	shmem_read_int(src, &o->res);
	shmem_read_int(src, &o->num);
	shmem_read_int(src, &o->deal_num);
	shmem_read_int(src, &o->unit_money);
	shmem_read_int(src, &o->last_unit_money);
	shmem_read_int(src, &o->money);
	shmem_read_int(src, &o->ts);

	
	return true;
}	
	
void create_sdb_sell_order1(int version, SellOrder *o, dstring *dst)
{

	if (!(o && dst)) 
		return ;

	dstring_write_int(dst, o->id);
	dstring_write_int(dst, o->uid);
	dstring_write_int(dst, o->weap_id);
	dstring_write_int(dst, o->weap_level);
	dstring_write_int(dst, o->weap_num);
	dstring_write_int(dst, o->gold);
	dstring_write_int(dst, o->ts);

	
}
	
bool parse_sdb_sell_order1(int ver, Shmem *src, SellOrder *o)
{

	if (!(src && o))
		return false;
	shmem_read_int(src, &o->id);
	shmem_read_int(src, &o->uid);
	shmem_read_int(src, &o->weap_id);
	shmem_read_int(src, &o->weap_level);
	shmem_read_int(src, &o->weap_num);
	shmem_read_int(src, &o->gold);
	shmem_read_int(src, &o->ts);

	
	return true;
}	
	
void create_sdb_gk1(int version, Guanka *o, dstring *dst)
{
	if (!(o && dst)) 
		return ;

	dstring_write_int(dst, o->id);
	dstring_write_int(dst, o->used);

	
}
	
bool parse_sdb_gk1(int ver, Shmem *src, Guanka *o)
{
	if (!(src && o))
		return false;
	shmem_read_int(src, &o->id);
	shmem_read_int(src, &o->used);

	
	return true;
}	
	
void create_sdb_room1(int version, Room *p, dstring *dst)
{

    if (!(p && dst)) 
        return ;
    
    int i = 0;
	dstring_write_int(dst, p->id);
	dstring_write_int(dst, p->attack_sph_id);
	dstring_write_int(dst, p->defense_sph_id);
	dstring_write_int(dst, p->city_id);
	dstring_write_int(dst, p->ts);


    for(i = 0; i < ROOM_USER_NUM; i++) {
        dstring_write_int(dst, p->attack_uid[i]);
    }
    
    for(i = 0; i < ROOM_USER_NUM; i++) {
        dstring_write_int(dst, p->defense_uid[i]);
    }
    
}
    
bool parse_sdb_room1(int ver, Shmem *src, Room *p)
{

    if (!(src && p))
        return false;

    int i = 0;
	shmem_read_int(src, &p->id);
	shmem_read_int(src, &p->attack_sph_id);
	shmem_read_int(src, &p->defense_sph_id);
	shmem_read_int(src, &p->city_id);
	shmem_read_int(src, &p->ts);


    for(i = 0; i < ROOM_USER_NUM; i++) {
        shmem_read_int(src, &p->attack_uid[i]);
    }
    
    for(i = 0; i < ROOM_USER_NUM; i++) {
        shmem_read_int(src, &p->defense_uid[i]);
    }


    return true;
}   
    
