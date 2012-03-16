#ifndef _DIPLOMACY_H_
#define _DIPLOMACY_H_

enum LEAGUE_FLAG {
	LEAGUE_CANCEL = 0,
	LEAGUE_CREAT,
};

enum DIPL_TYPE{
	DIPL_NONE = 0,
	DIPL_LEAGUE,
	DIPL_ENEMY,
};

struct Dipl {
	int id;
	int type;
	int self_id;
	int target_id;
	int start;
	int end;
	
	RB_ENTRY(Dipl) tlink;
};
typedef struct Dipl Dipl;

extern Dipl *dipl_new(int type, int self_sph, int target_sph, int start, int end);

extern void dipl_free(Dipl *dipl);

#endif

