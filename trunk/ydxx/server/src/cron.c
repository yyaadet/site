#include "hf.h"

#define ONE_MINU 60

static int g_reset_guanka_hours[] = {2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22};

#define RESET_WUBAO_HOUR 6

#define CLEAR_MAIL_HOUR 3

static int get_next_run_timestamp(Job *p);

static void do_job_run(int fd, short flag, void *arg);

/* 
 * arg type is Job 
 */
static void reset_guanka(void *arg);
static void reset_wubao(void *arg);
static void notify_stop_war(void *arg);
static void clear_mail(void *arg);
static void notify_reset_gk(void *arg);

static Ev *g_ev = NULL;


Job * job_new()
{
	Job *p = cache_pool_alloc(POOL_JOB);
	if (!p)
		return NULL;
	memset(p, 0, sizeof(Job));
	return p;
}

void job_free(Job *j)
{
	cache_pool_free(POOL_JOB, j);
}

bool job_reg(int h, int m, ARGCB cb, void *arg)
{
	Game *g = GAME;
	Job *p = job_new();
	char tmp[128];

	if (!p)
		return false;

	p->hour = h;
	p->minu = m;
	p->cb = cb;
	p->arg = arg;
	p->next_run_timestamp = get_next_run_timestamp(p);

	game_add_job(g, p);

	DEBUG(LOG_FMT"%02d:%02d cb %p, arg %p, next run at \"%s\"\n", LOG_PRE, p->hour, p->minu,\
			p->cb, p->arg, format_time_r(p->next_run_timestamp, LOG_TIME_FMT, tmp, 128));

	return true;
}

static int get_next_run_timestamp(Job *p)
{
	if (!p)
		return -1;
	
    return get_next_timestamp(p->hour, p->minu);
}


bool job_run()
{
	if (g_ev)
		return false;

	if (!(g_ev = ev_new(g_cycle->evbase))) 
		return false;

	if (!ev_update(g_ev, -1, 0, do_job_run, NULL, ONE_MINU))
		return false;

    int len = ARRAY_LEN(g_reset_guanka_hours, int);
    int i = 0;

    for (i = 0; i < len; i++) {
	    job_reg(g_reset_guanka_hours[i], 0, reset_guanka, NULL); 
	    job_reg(g_reset_guanka_hours[i] - 1, 30, notify_reset_gk, (void *)g_reset_guanka_hours[i]); 
    }
	
    job_reg(RESET_WUBAO_HOUR, 0, reset_wubao, NULL); 

	job_reg(g_cycle->conf->core.deny_war_begin, 0, notify_stop_war, NULL);

	job_reg(CLEAR_MAIL_HOUR, 0, clear_mail, NULL);

	return true;
}


static void do_job_run(int fd, short flag, void *arg)
{
	Game *g = GAME;
	int now = time(NULL);
	Job *p;

	ev_update(g_ev, -1, 0, do_job_run, NULL, ONE_MINU);
	
	TAILQ_FOREACH(p, &g->jobs, link) {
		if (p->next_run_timestamp <= now) {
			DEBUG(LOG_FMT"cb %p, arg %p, %d:%d\n", LOG_PRE, p->cb, p->arg, p->hour, p->minu);
			if (p->cb) 
				p->cb(p->arg);
			p->next_run_timestamp = get_next_run_timestamp(p);
		}
	}

}

static void reset_guanka(void *arg)
{
	Game *g = GAME;
	Guanka *p;

	RB_FOREACH(p, GameGuankaMap, &g->guankas) {
		p->used = 0;
		send_nf_guanka_where(p, WHERE_ALL);
	}
}

static void reset_wubao(void *arg)
{
	Game *g = GAME;
	Wubao *p, *next;
    int now = time(NULL);
    bool clear = false;

	for(p = RB_MIN(GameWubaoMap, &g->wubaos); p; p = next) {

		next = RB_NEXT(GameWubaoMap, &g->wubaos, p);
        
        if (p->uid > 0) {
            /*
            if (p->build[BUILDING_YISHITANG - 1].level < 1 && now - p->last_login_time > 60) {
                DEBUG(LOG_FMT"reset wubao level %d, id %d, uid %d\n", LOG_PRE, \
                        p->build[BUILDING_YISHITANG - 1].level, p->id, p->uid);
                game_reset_wubao(g, p);
                clear = true;
                continue;
            }
            */

            if (p->build[BUILDING_YISHITANG - 1].level < 1 && now - p->last_login_time > 3600 * 24 && p->rank > 100) {
                game_reset_wubao(g, p);
                clear = true;
                continue;
            }

            if (p->build[BUILDING_YISHITANG - 1].level < 6 && now - p->last_login_time > 3600 * 24 * 3 && p->rank > 100) {
                game_reset_wubao(g, p);
                clear = true;
                continue;
            }

            if (p->build[BUILDING_YISHITANG - 1].level < 11 && now - p->last_login_time > 3600 * 24 * 7 && p->rank > 100) {
                game_reset_wubao(g, p);
                clear = true;
                continue;
            }
        }

		p->been_plunder_num = 0;
		p->use_gx_trea_num = 0;
		if (p->jl < MAX_JL) {
			p->jl = MAX_JL;
		}
	}

    if (clear) {
		webapi_wubao(g, ACTION_GET, parse_all_wubao, NULL);
    }
}

static void notify_stop_war(void *arg)
{
	send_deny_war_talk();
}

static void clear_mail(void *arg)
{
	webapi_clear_mail(NULL, NULL);
}

static void notify_reset_gk(void *arg)
{
	send_reset_gk_talk((int)arg, 0);
}

