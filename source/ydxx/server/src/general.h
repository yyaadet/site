#ifndef _GENERAL_H_
#define _GENERAL_H_
#include "tools.h"
#include "treasure.h"

#define GENERAL_MAX_FIRST_NAME_LEN 8
#define GENERAL_MAX_LAST_NAME_LEN 12
#define GENERAL_MAX_DESC_LEN 200

#define VISIT_GENE_HOUR (12*30)

struct Trea;

enum OFFICE_TYPE {
	OFFICE_NONE,
	OFFICE_XIANLIN,
	OFFICE_TAISHOU,
	OFFICE_ZHOUMU,
	OFFICE_WANG,
	OFFICE_HUANGDI,
	OFFICE_MAX,
};

enum DIGNITIE_TYPE {
	DIGNITIE_NONE,
	DIGNITIE_NAN,
	DIGNITIE_ZI, 
	DIGNITIE_BO,
	DIGNITIE_HOU,
	DIGNITIE_GONG,
	DIGNITIE_WANG,
	DIGNITIE_MAX,
};


enum OFFICIAL_TYPE {
	OFFICIAL_NONE,
	OFFICIAL_WEIDONG,
	OFFICIAL_WEINAN,
	OFFICIAL_WEIXI,
	OFFICIAL_WEIBEI,
	OFFICIAL_LANGZHONG,
	OFFICIAL_CONGSHILANGZHONG,
	OFFICIAL_CHANGSHI,
	OFFICIAL_SIMA,
	OFFICIAL_JUNSHIJIANGJUN,
	OFFICIAL_ANGUOJIANGJUN,
	OFFICIAL_PONUJIANGJUN,
	OFFICIAL_TAONIJIANGJUN,
	OFFICIAL_JIEZHEPUSHE,
	OFFICIAL_DUWEI,
	OFFICIAL_HUANGMENSHILANG,
	OFFICIAL_TAISHILING,
	OFFICIAL_ZUOJIANGJUN,
	OFFICIAL_YOUJIANGJUN,
	OFFICIAL_QIANJIANGJUN,
	OFFICIAL_HOUJIANGJUN,
	OFFICIAL_MISHULING,
	OFFICIAL_SIZHONG,
	OFFICIAL_LIUFUCHANGSHI,
	OFFICIAL_TAIXUEBOSHI,
	OFFICIAL_ANDONGJIANGJUN,
	OFFICIAL_ANNANJIANGJUN,
	OFFICIAL_ANXIJIANGJUN,
	OFFICIAL_ANBEIJIANGJUN,
	OFFICIAL_ZHONGSHULING,
	OFFICIAL_YUSHIZHONGCHEN,
	OFFICIAL_ZHIJUNWU,
	OFFICIAL_SHAOFU,
	OFFICIAL_ZHENDONGJIANGJUN,
	OFFICIAL_ZHENNANJIANGJUN,
	OFFICIAL_ZHENXIJIANGJUN,
	OFFICIAL_ZHENBEIJIANGJUN,
	OFFICIAL_SHANGSHULING,
	OFFICIAL_TAIPU,
	OFFICIAL_TAICHANG,
	OFFICIAL_GUANGLUDAFU,
	OFFICIAL_ZHENGDONGJIANGJUN,
	OFFICIAL_ZHENGNANJIANGJUN,
	OFFICIAL_ZHENGXIJIANGJUN,
	OFFICIAL_ZHENGBEIJIANGJUN,
	OFFICIAL_GUANGLUDONG,
	OFFICIAL_DASIRONG,
	OFFICIAL_WEIWEI,
	OFFICIAL_YANWEI,
	OFFICIAL_MAX
};

enum ZHEN_TYPE {
	ZHEN_NONE,
	ZHEN_ZUIXING,
	ZHEN_HEYU,
	ZHEN_YULIN,
	ZHEN_YANXING,
	ZHEN_FENGCHI,
	ZHEN_CHANGSE,
	ZHEN_HENGZHOU,
	ZHEN_JUXING,
	ZHEN_YANYUE,
	ZHEN_FANGYUAN,
	ZHEN_MAX,
};

enum SKILL_TYPE {
	SKILL_NONE, 
	SKILL_TUPO,
	SKILL_TUJIN,
	SKILL_TUJI,
	SKILL_SUGONG,
	SKILL_QISHE,
	SKILL_LIANSHE,
	SKILL_LIANNU,
	SKILL_HUOJIAN,
	SKILL_FENGZHAN,
	SKILL_FENGDOU,
	SKILL_FENGXUN,
	SKILL_LUANZHAN,
	SKILL_QUSHE,
	SKILL_BENSHE,
	SKILL_FEISHE,
	SKILL_HUISHE,
	SKILL_JUNLAN,
	SKILL_CHONGCHE,
	SKILL_FASHI,
	SKILL_QIANGJI,
	SKILL_MENGTONG,
	SKILL_LUOCHUAN,
	SKILL_ZHANJIAN,
	SKILL_QIANGXI,
	/*
	 * SPECIAL SKILL
	 */
	SKILL_WUSHUANG,
	SKILL_POZHEN,
	SKILL_MAZHEN,
	SKILL_QIANGXING,
	SKILL_ZHILIAO,
	SKILL_HUNLUAN,
	SKILL_GUWU,
	SKILL_CHENZHUO,
	SKILL_MAX,
};

enum LEARN_TYPE {
	LEARN_SKILL = 1,
	LEARN_ZHEN,
};

enum GENE_PLACE {
	GENE_PLACE_NONE,
	GENE_PLACE_WUBAO,
	GENE_PLACE_CITY,
	GENE_PLACE_ARMY,
	GENE_PLACE_TRIP,
	GENE_PLACE_PLUNDER,
	GENE_PLACE_VIEW_ZOU,
	GENE_PLACE_VIEW_QUAN,
	GENE_PLACE_VIEW_WEI,
	GENE_PLACE_MAX,
};

enum GENE_TYPE {
	GENE_TYPE_NORM,
	GENE_TYPE_NAME, 
};

#define GENE_WEAP_NUM 4

struct GeneWeap {
	int id;
	int level;
};
typedef struct GeneWeap GeneWeap;

struct Gene {
	int id;
	int uid;
	dstring first_name;
	dstring last_name;
	dstring zi;
	byte sex;
	byte is_dead;
	byte place;
	int place_id;
	short init_year;
	short born_year;
	short die_year;
	int face_id;
	byte type;
	int speed;
	int kongfu;
	int polity;
	int intel;
	float faith;
	int fol;
	int fri;
	
	uint skill;
	uint zhen;
	
	uint used_zhen;
	uint sol_num;
	uint hurt_num;
	int level;
	int level_percent;
	float sol_spirit;

	GeneWeap weap[GENE_WEAP_NUM];
	
	int trea_num;
	struct KeyMap treas;

	RB_ENTRY(Gene) tlink;
};
typedef struct Gene Gene;

extern Gene *gene_new();

extern void gene_free(Gene *gene);

extern bool gene_add_trea(Gene *gene, Trea *trea);
extern bool gene_del_trea(Gene *gene, Trea *t);
extern Trea *gene_find_trea(Gene *gene, int id);
extern Trea *gene_find_trea_by_type(Gene *gene, int type);


extern void gene_change_place(Gene *gene, byte place, int place_id);

extern int  gene_change_faith(Gene *gene, int num);

extern uint gene_get_skill(Gene *gene);
extern int  gene_get_speed(Gene *gene);
extern int  gene_get_polity(Gene *gene);
extern int  gene_get_kongfu(Gene *gene);
extern int  gene_get_intel(Gene *gene);
extern int  gene_get_age(Gene *gene);
extern int  gene_get_fol(Gene *gene);
extern const char *gene_get_full_name(Gene *gene);

extern bool  gene_has_skill(Gene *gene, int skill_type);
extern bool  gene_has_zhen(Gene *gene, int zhen_type);

extern float gene_change_sol_spirit(Gene *gene, float num);
extern float gene_change_sol_train(Gene *gene, float num);

extern void  gene_add_sol(Gene *gene, int sol_num, float train, float spirit);

extern void  gene_away(Gene *gene);

extern bool  gene_prop_in_area(Gene *gene, int mn, int mx);

extern int gene_gen_face();

extern bool gene_get_pos(Gene *gene, int *x, int *y);

struct OfficeInfo {
	int m_id;
	const char *m_name;
};
typedef struct OfficeInfo OfficeInfo;

struct DignitieInfo {
	int m_id;
	const char *m_name;
};
typedef struct DignitieInfo DignitieInfo;

struct OfficialInfo {
	int m_id;
	const char *m_name;
};
typedef struct OfficialInfo OfficialInfo;


extern OfficeInfo   *get_office_info_by_id(int id);

extern DignitieInfo *get_dignitie_info_by_id(int id);

extern OfficialInfo *get_official_info_by_id(int id);

extern const char *skill_name(int id);

#endif


