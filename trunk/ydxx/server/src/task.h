#ifndef _TASK_H_
#define _TASK_H_

#define TASK_NUM 3
#define TASK_TREA_NUM 5

enum TASK_TYP {
	TASK_TYPE_NONE = -1, 
	TASK_TYPE_READ = 0, 
	TASK_TYPE_BUILD_LEVEL_UP,
	TASK_TYPE_TECH_LEVEL_UP,
	TASK_TYPE_MADE,
	TASK_TYPE_USE_GENE,
	TASK_TYPE_PRAC,
	TASK_TYPE_BUY_TREA,
	TASK_TYPE_RES_TRADE,
	TASK_TYPE_WEAP_TRADE,
	TASK_TYPE_CONFIG_SOL,
	TASK_TYPE_BOX,
	TASK_TYPE_MAX,
};


struct Task {
	int id;
	int type;
	int before_id;
	int num[TASK_NUM];
	/* return value */
	int prestige;
	int gold;
	int res[RES_MAX - 1];
	int trea[TASK_TREA_NUM];
	int sol;

	RB_ENTRY(Task) tlink;
};
typedef struct Task Task;

extern Task *task_new();
extern void task_free(Task *t);

extern bool task_fin(Wubao *w);

extern bool task_is_fin(Wubao *w);

#endif

