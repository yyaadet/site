
g_sdb1_cpp="sdb1.c"
g_sdb1_h="sdb1.h"

g_sphere_fields = [
    ["id", "int"], 
    ["name","string"], 
    ["uid","int"],
    ["level", "int"],
    ["prestige", "int"],
    ['desc', 'string'],
    ['is_npc', 'byte'],
    ]

g_city_fields = [
    ["id", "int"],
    ["sph_id","int"],
    ["level","byte"],
    ["name","string"],
    ["jun_name","string"],
    ["zhou_name","string"],
    ["desc","string"],
    ["defense","float"],
    ["is_alloted","byte"],
    ["x","int"],
    ["y","int"],
    ["jun_code","byte"],
    ["zhou_code","byte"],
    ['sol', 'int'],
    ]


g_general_fields = [
    ["id","int"], 
    ["uid","int"], 
    ["first_name","string"], 
    ["last_name","string"], 
    ["zi","string"], 
    ['type', 'byte'],
    ["sex","byte"], 
    ["is_dead","byte"], 
    ["born_year","short"], 
    ["init_year","short"], 
    ["die_year","short"], 
    ["face_id","int"], 
    ["place","byte"], 
    ["place_id","int"], 
    ["kongfu","int"], 
    ["speed","int"], 
    ["polity","int"], 
    ["intel","int"], 
    ["faith", "float"],
    ["skill", "uint"], 
    ["zhen", "uint"], 
    ["used_zhen", "uint"],
    ["sol_num", "uint"], 
    ["sol_spirit", "float"],
    ['level', 'int'],
    ['level_percent', 'int'],
    ['fri', 'int'],
    ['hurt_num', 'uint'],
    ['fol', 'int'],
    ]

g_army_fields = [
    ["id","int"],
    ["x","int"], 
    ["y","int"], 
    ["money","int"], 
    ["food","int"], 
    ["original","int"], 
    ["gene_id", "int"],
    ["type", "byte"],
    ['state', 'byte'],
    ['from_place', 'byte'],
    ['from_place_id', 'int'],
    ]

g_wubao_fields = [
    ["id", 'int'],
    ["uid", 'int'],
    ["people", 'int'],
    ["family", 'int'],
    ["prestige", 'int'],
    ["city_id", 'int'],
    ["sph_id", 'int'],
    ["dig_id", 'int'],
    ["off_id", 'int'],
    ["sol", 'int'],
    ["got_sol", 'int'],
    ["used_made", 'int'],
    ["cure_sol", 'int'], 
    ["max_gene", "int"],
    ["task_id", "int"],
    ["task_is_fin", "int"],
    ["last_welfare_time", "int"],
    ["last_login_time", "int"],
    ["been_plunder_num", "int"],
    ['use_gx_trea_num', 'int'],
    ['war_sleep_end_time', 'int'],
    ['train_sleep_end_time', 'int'],
    ['box_level', 'int'],
    ['rank', 'int'],
    ['gx', 'int'],
    ['jl', 'int'],
    ['fresh_step', 'int'],
    ]

g_cmd_trans_fields = [
    ["id", 'int'],
    ["type", 'int'],
    ["from_id", 'int'],
    ["to_id", 'int'],
    ["sph_id", 'int'],
    ["good_type", 'int'],
    ["good_id", 'int'],
    ["good_num", 'int'],
    ["end", 'int'],
    ]

g_order_fields = [
    ["id", 'int'],
    ["uid", 'int'],
    ["type", 'int'],
    ["res", 'int'],
    ["num", 'int'],
    ["deal_num", 'int'],
    ["unit_money", 'int'],
    ["last_unit_money", 'int'],
    ["money", 'int'],
    ["ts", 'int'],
    ]

g_sell_order_fields = [
    ["id", 'int'],
    ["uid", 'int'],
    ["weap_id", 'int'],
    ["weap_level", 'int'],
    ["weap_num", 'int'],
    ["gold", 'int'],
    ["ts", 'int'],
    ]

g_gk_fields = [
    ["id", 'int'],
    ["used", 'int'],
    ]

g_room_fields = [
    ["id", "int"],
    ["attack_sph_id", "int"],
    ["defense_sph_id", "int"],
    ["city_id", "int"],
    ["ts", "int"],
    ]


def write_header(f):
    buf = '''
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

'''
    f.write(buf)


def write_sphere_func(f):
    create_buf = '''
void create_sdb_sphere(int version, Sph *sph, dstring *dst)
{
    if (!( dst && sph))
        return;''' + "\n"

    parse_buf = '''
bool parse_sdb_sphere(int ver, Shmem *src, Sph *sph)
{
    if (!(src && sph))
        return false;''' + "\n"


    for [k, v] in g_sphere_fields:
        t = "\tdstring_write_%s(dst, sph->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, sph->%s.buf, sph->%s.offset);\n" % (v, k, k)

        create_buf = create_buf + t

        t = "\tshmem_read_%s(src, &sph->%s);\n" % (v, k)
        parse_buf = parse_buf + t

    
    create_buf = create_buf + "}\n"
    parse_buf = parse_buf + "\treturn true;\n}\n"
    f.write(create_buf)
    f.write(parse_buf)


def write_city_func(f):
    create_buf = '''
void create_sdb_city(int version, City *city, dstring * dst)
{
    if (!(city && dst)) 
        return;

    '''
    parse_buf = '''
bool parse_sdb_city(int ver, Shmem *src, City *city)
{
    if (!(src && city)) 
        return false;
    
    '''
    for [k, v] in g_city_fields:
        t = "\tdstring_write_%s(dst, city->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, city->%s.buf, city->%s.offset);\n" % (v, k, k)
        create_buf = create_buf + t

        t = "\tshmem_read_%s(src, &city->%s);\n" % (v, k)
        parse_buf = parse_buf + t
    
    create_buf = create_buf + '''
}   
    '''
    
    parse_buf = parse_buf + '''
    return true; 
}   
    '''
    f.write(create_buf)
    f.write(parse_buf)
    


def write_general_func(f):
    create_buf = '''
void create_sdb_general(int version, Gene *gene, dstring *dst)
{
    if (!(gene && dst))
        return;

    int i = 0;
'''
    parse_buf = '''
bool parse_sdb_general(int ver, Shmem *src, Gene *gene)
{
    if (!(src && gene))
        return false;

    int i = 0;
'''
    for [k, v] in g_general_fields:
        t = "\tdstring_write_%s(dst, gene->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, gene->%s.buf, gene->%s.offset);\n" % (v, k, k)
        create_buf = create_buf + t
        t = "\tshmem_read_%s(src, &gene->%s);\n" % (v, k)
        parse_buf = parse_buf + t

    create_buf = create_buf + '''

    for(i = 0; i < GENE_WEAP_NUM; i++) {
        dstring_write_int(dst, gene->weap[i].id);
        dstring_write_int(dst, gene->weap[i].level);
    }
}
    
    '''
    
    parse_buf = parse_buf + '''
    
    for(i = 0; i < GENE_WEAP_NUM; i++) {
        shmem_read_int(src, &gene->weap[i].id);
        shmem_read_int(src, &gene->weap[i].level);
    }
    return true;
}

    '''
    f.write(create_buf)
    f.write(parse_buf)

def write_army_func(f):
    create_buf = '''
void create_sdb_army(int version, Army *army, dstring *dst)
{

    if (!(army && dst)) 
        return ;

'''
    parse_buf = '''
bool parse_sdb_army(int ver, Shmem *src, Army *army)
{

    if (!(src && army))
        return false;

'''
    for [k, v] in g_army_fields:
        t = "\tdstring_write_%s(dst, army->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, army->%s.buf, army->%s.offset);\n" % (v, k, k)
        create_buf = create_buf + t
        t = "\tshmem_read_%s(src, &army->%s);\n" % (v, k)
        parse_buf = parse_buf + t
    
    create_buf = create_buf + '''
}
    '''
    parse_buf = parse_buf + '''
    return true;
}   
    '''
    f.write(create_buf)
    f.write(parse_buf)


def write_wubao_func(f):
    create_buf = '''
void create_sdb_wubao(int version, Wubao *w, dstring *dst)
{

    if (!(w && dst)) 
        return ;
    
    int i = 0;
    int j = 0;
    Key *k ;
'''
    parse_buf = '''
bool parse_sdb_wubao(int ver, Shmem *src, Wubao *w)
{

    if (!(src && w))
        return false;

    Game *g = GAME;
    int i = 0;
    int j = 0;
    int num = 0;
'''
    for [k, v] in g_wubao_fields:
        t = "\tdstring_write_%s(dst, w->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, w->%s.buf, w->%s.offset);\n" % (v, k, k)
        create_buf = create_buf + t
        t = "\tshmem_read_%s(src, &w->%s);\n" % (v, k)
        parse_buf = parse_buf + t
    
    create_buf = create_buf + '''

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
    '''
    
    parse_buf = parse_buf + '''

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
    '''
    f.write(create_buf)
    f.write(parse_buf)


def write_cmd_trans_func(f):
    create_buf = '''
void create_sdb_cmd_trans(int version, CmdTrans *cmd, dstring *dst)
{

    if (!(cmd && dst)) 
        return ;

'''
    parse_buf = '''
bool parse_sdb_cmd_trans(int ver, Shmem *src, CmdTrans *cmd)
{

    if (!(src && cmd))
        return false;
'''
    for [k, v] in g_cmd_trans_fields:
        t = "\tdstring_write_%s(dst, cmd->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, cmd->%s.buf, cmd->%s.offset);\n" % (v, k, k)
        create_buf = create_buf + t
        t = "\tshmem_read_%s(src, &cmd->%s);\n" % (v, k)
        parse_buf = parse_buf + t
    
    create_buf = create_buf + '''
    
}
    '''
    
    parse_buf = parse_buf + '''
    
    return true;
}   
    '''
    f.write(create_buf)
    f.write(parse_buf)

def write_order_func(f):
    create_buf = '''
void create_sdb_order(int version, Order *o, dstring *dst)
{

    if (!(o && dst)) 
        return ;

'''
    parse_buf = '''
bool parse_sdb_order(int ver, Shmem *src, Order *o)
{

    if (!(src && o))
        return false;
'''
    for [k, v] in g_order_fields:
        t = "\tdstring_write_%s(dst, o->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, o->%s.buf, o->%s.offset);\n" % (v, k, k)
        create_buf = create_buf + t
        t = "\tshmem_read_%s(src, &o->%s);\n" % (v, k)
        parse_buf = parse_buf + t
    
    create_buf = create_buf + '''
    
}
    '''
    
    parse_buf = parse_buf + '''
    
    return true;
}   
    '''
    f.write(create_buf)
    f.write(parse_buf)


def write_sell_order_func(f):
    create_buf = '''
void create_sdb_sell_order(int version, SellOrder *o, dstring *dst)
{

    if (!(o && dst)) 
        return ;

'''
    parse_buf = '''
bool parse_sdb_sell_order(int ver, Shmem *src, SellOrder *o)
{

    if (!(src && o))
        return false;
'''
    for [k, v] in g_sell_order_fields:
        t = "\tdstring_write_%s(dst, o->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, o->%s.buf, o->%s.offset);\n" % (v, k, k)
        create_buf = create_buf + t
        t = "\tshmem_read_%s(src, &o->%s);\n" % (v, k)
        parse_buf = parse_buf + t
    
    create_buf = create_buf + '''
    
}
    '''
    
    parse_buf = parse_buf + '''
    
    return true;
}   
    '''
    f.write(create_buf)
    f.write(parse_buf)

def write_gk_func(f):
    create_buf = '''
void create_sdb_gk(int version, Guanka *o, dstring *dst)
{
    if (!(o && dst)) 
        return ;

'''
    parse_buf = '''
bool parse_sdb_gk(int ver, Shmem *src, Guanka *o)
{
    if (!(src && o))
        return false;
'''
    for [k, v] in g_gk_fields:
        t = "\tdstring_write_%s(dst, o->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, o->%s.buf, o->%s.offset);\n" % (v, k, k)
        create_buf = create_buf + t
        t = "\tshmem_read_%s(src, &o->%s);\n" % (v, k)
        parse_buf = parse_buf + t
    
    create_buf = create_buf + '''
    
}
    '''
    
    parse_buf = parse_buf + '''
    
    return true;
}   
    '''
    f.write(create_buf)
    f.write(parse_buf)


def write_room_func(f):
    create_buf = '''
void create_sdb_room(int version, Room *p, dstring *dst)
{

    if (!(p && dst)) 
        return ;
    
    int i = 0;
'''
    parse_buf = '''
bool parse_sdb_room(int ver, Shmem *src, Room *p)
{

    if (!(src && p))
        return false;

    int i = 0;
'''
    for [k, v] in g_room_fields:
        t = "\tdstring_write_%s(dst, p->%s);\n" % (v, k)
        if v == "string":
            t = "\tdstring_write_%s1(dst, p->%s.buf, p->%s.offset);\n" % (v, k, k)
        create_buf = create_buf + t
        t = "\tshmem_read_%s(src, &p->%s);\n" % (v, k)
        parse_buf = parse_buf + t
    
    create_buf = create_buf + '''

    for(i = 0; i < ROOM_USER_NUM; i++) {
        dstring_write_int(dst, p->attack_uid[i]);
    }
    
    for(i = 0; i < ROOM_USER_NUM; i++) {
        dstring_write_int(dst, p->defense_uid[i]);
    }
    
}
    '''
    
    parse_buf = parse_buf + '''

    for(i = 0; i < ROOM_USER_NUM; i++) {
        shmem_read_int(src, &p->attack_uid[i]);
    }
    
    for(i = 0; i < ROOM_USER_NUM; i++) {
        shmem_read_int(src, &p->defense_uid[i]);
    }


    return true;
}   
    '''
    f.write(create_buf)
    f.write(parse_buf)

if __name__  == '__main__':
    header = open(g_sdb1_h, "w")
    cpp = open(g_sdb1_cpp, "w")
    cpp.write("#include \"hf.h\"\n")

    write_header(header)
    write_sphere_func(cpp)
    write_city_func(cpp)
    write_general_func(cpp)
    write_army_func(cpp)
    write_wubao_func(cpp)
    write_cmd_trans_func(cpp)
    write_order_func(cpp)
    write_sell_order_func(cpp)
    write_gk_func(cpp)
    write_room_func(cpp)

    header.write("\n")
    header.close()
    cpp.write("\n")
    cpp.close()


