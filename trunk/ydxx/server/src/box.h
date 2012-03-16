#ifndef _BOX_H_
#define _BOX_H_

#define MAX_GENE_ROUND 3
#define MAX_ROUND 3
#define MAX_FIGHT_ROUND 80

struct GeneWeap;

struct Zhanyi {
    int id;
    dstring pic_u1;
    dstring title;
    dstring info;
    int site;

    RB_ENTRY(Zhanyi) tlink;
};
typedef struct Zhanyi Zhanyi;

extern Zhanyi * zhanyi_new();
extern void zhanyi_free(Zhanyi *p);


struct Guanka {
	int id;
    int zy_id;
	dstring name;
    int x;
    int y;
	int gx;
	int weap_id;
	int weap_level;
	int weap_num;
	int percent;
	int total;
	int used;
	int cd;
	
	RB_ENTRY(Guanka) tlink;
};
typedef struct Guanka Guanka;

extern Guanka *guanka_new();
extern void guanka_free(Guanka *b);

struct Box {
	int id;
	int level;
	int face_id;
	dstring name;
	uint skill;
	int zhen;
	int kongfu;
	int intel;
	int polity;
	struct GeneWeap weap[GENE_WEAP_NUM];
	float train;
	float spirit;
	int sol;
	int gx;
	int sleep_hour;

	RB_ENTRY(Box) tlink;
};
typedef struct Box Box;

extern Box *box_new();
extern void box_free(Box *b);


struct WarGene{
	dstring name;
	int id;
	int gene_id;
	int kongfu;
	int intel;
	int polity;
    int speed;
	int zhen;
	uint skill;
	float old_train;
	float train;
	float old_spirit;
	float spirit;
	int old_sol;
	int sol;
	int hurt;
	int kill;
	int uid;
	GeneWeap weap[GENE_WEAP_NUM];
	
	TAILQ_ENTRY(WarGene) link;
};
typedef struct WarGene WarGene;

extern WarGene * war_gene_new();
extern void war_gene_free(WarGene *p);

struct WarRound {
	int id;
	int gene_id;
	int dead;
	int skill;
	float spirit;
	float train;
	
	int id1;
	int gene_id1;
	int dead1;
	int skill1;
	float spirit1;
	float train1;
	
	TAILQ_ENTRY(WarRound) link;
};
typedef struct WarRound WarRound;

extern WarRound * war_round_new();
extern void war_round_free(WarRound *p);


struct War {
	int guan_id;
    int room_id;

	dstring name;
	int gene_num;
	TAILQ_HEAD(, WarGene) genes;
	int dead;
	int is_win;
	int gx;
	int weap_id;
	int weap_level;
	int weap_num;
    int uid;

	dstring target_name;
	int target_gene_num;
	TAILQ_HEAD(, WarGene) target_genes;
	int dead1;
    int target_uid;

	int round_num;
	TAILQ_HEAD(, WarRound) rounds;
};
typedef struct War War;

extern War *war_new();
extern void war_free(War *p);

extern WarGene * war_get_gene(War *war, int index);
extern WarGene * war_get_target_gene(War *war, int index);

extern int war_get_sol(War *war);
extern int war_get_target_sol(War *war);

extern void do_war(War *p);

#endif

