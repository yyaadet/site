#ifndef _FLOW_H_
#define _FLOW_H_

#define GIGA (1024 * 1024 * 1024)
#define FLOW_INITIAL  {0, 0, 0, 0, 0}
#define FLOW_STATISTICS_TIME 60

struct Flow {
	int giga;
	int byte;
	int old_giga;
	int old_byte;
	/* byte/sec  is unit*/
	int peak;  
	int statistics_time;
};
typedef struct Flow Flow;

enum FLOW_TYPE {
	FLOW_NONE, 
	FLOW_HTTP_IN, 
	FLOW_HTTP_OUT, 
	FLOW_GAME_IN, 
	FLOW_GAME_OUT,
};

extern Flow *flow_new();
extern void flow_free(Flow *f);
extern void flow_add(Flow *f, int sz);
extern void flow_statistics(Flow *f);

extern void flow_init();
extern void flow_uninit();
extern void flow_incr_byte(short type, int sz);

extern  Flow * g_http_in_flow;
extern  Flow * g_http_out_flow;
extern  Flow * g_game_in_flow;
extern  Flow  * g_game_out_flow;

#endif
