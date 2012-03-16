#include "hf.h"


Flow * g_http_in_flow;
Flow * g_http_out_flow;
Flow * g_game_in_flow;
Flow  * g_game_out_flow;

static void flow_statistics_cb(int fd, short flag, void *arg);

static void flow_statistics_cb(int fd, short flag, void *arg)
{

	if (!(g_game_in_flow && g_game_out_flow && g_http_in_flow && g_http_out_flow))
		return;
	flow_statistics(g_http_in_flow);
	flow_statistics(g_http_out_flow);
	flow_statistics(g_game_in_flow);
	flow_statistics(g_game_out_flow);
}



Flow * flow_new()
{
	Flow *f = (Flow *) xmalloc(sizeof(Flow));
	if (!f)  
		return NULL;
	return f;
}

void flow_free(Flow *f)
{
	if (!f)
		return;
	free(f);
}

void flow_add(Flow *f, int sz)
{
	if (!f)
		return;
	int giga = 0;

	f->byte += sz;
	if (f->byte > GIGA) {
		giga = f->byte / GIGA;
		f->giga += giga;
		f->byte -= giga * GIGA;
	}
}

void flow_statistics(Flow *f)
{
	int giga_t = 0;
	int b_t = 0;
	int how_long = 0;
	time_t now = time(NULL);

	if (!f)
		return;
	giga_t = f->giga - f->old_giga;
	b_t = f->byte - f->old_byte;
	how_long = now - f->statistics_time;
	if (how_long <= 0)
		return;
	f->peak = (giga_t * GIGA + b_t) / how_long;
	f->statistics_time = now;

	DEBUG(LOG_FMT"flow %p '%dG %d', last '%dG %d', peak %d, %s\n", LOG_PRE, \
					f, f->giga, f->byte, f->old_giga, f->old_byte, f->peak, 
					format_time(f->statistics_time, DEF_TIME_FMT));
}

void flow_init()
{
	Ev *e = NULL;

	g_http_in_flow = flow_new();
	g_http_out_flow = flow_new();
	g_game_in_flow = flow_new();
	g_game_out_flow = flow_new();
	
	if (!(e = ev_new(g_cycle->evbase))) {
		return;
	}
	ev_update(e, -1, 0, flow_statistics_cb, e, FLOW_STATISTICS_TIME);
}

void flow_uninit()
{
	flow_free(g_game_in_flow);
	g_game_in_flow = NULL;
	flow_free(g_game_out_flow);
	g_game_out_flow = NULL;
	flow_free(g_http_in_flow);
	g_http_in_flow = NULL;
	flow_free(g_http_out_flow);
	g_http_out_flow = NULL;
}

void flow_incr_byte(short type, int sz)
{
	Flow *t = NULL;

	switch(type) {
		case FLOW_HTTP_IN:
			t = g_http_in_flow;
			break;
		case FLOW_HTTP_OUT:
			t = g_http_out_flow;
			break;
		case FLOW_GAME_IN:
			t = g_game_in_flow;
			break;
		case FLOW_GAME_OUT:
			t = g_game_out_flow;
			break;
		default:
			t = NULL;
			break;
	}
	if (!t)
		return;
	flow_add(t, sz);
}
