#ifndef _CMD_H_
#define _CMD_H_

enum CMD_TYPE {
	CMD_NONE,
	CMD_TRANS,
	CMD_MAX,
};


enum TRANS_TYPE {
	TRANS_NONE,
	TRANS_WU_TO_CI,
	TRANS_CI_TO_CI,
	TRANS_CI_TO_WU,
};

enum GOOD_TYPE {
	GOOD_NONE,
	GOOD_GENE,
	GOOD_RES,
};


struct CmdTrans {
	int id;
	int from_id;
	int to_id;
	int type;
	int sph_id;
	int good_type;
	int good_id;
	int good_num;
	int end;
	
	RB_ENTRY(CmdTrans) tlink;
};
typedef struct CmdTrans CmdTrans;

extern CmdTrans *cmd_trans_new1();

extern CmdTrans *cmd_trans_new(int from_id, int to_id, int type, int sph_id, \
				int good_type, int good_id, int good_num, int end);

extern void cmd_trans_free(CmdTrans *cmd);

extern void execute_all_cmds();

extern void do_execute_cmd_transfer(CmdTrans *cmd, bool cancel);

#endif


