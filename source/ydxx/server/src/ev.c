#include "hf.h"


EvBase *ev_base_new(void)
{
	EvBase *base = event_init();
	return base;
}

void ev_base_free(EvBase *base) 
{
	if (!base)
		return;
	event_base_free(base);
}

bool ev_base_loop(EvBase *base, int flags)
{
	if(!base)
		return false;
	event_base_loop(base, flags);
	return true;
}

Ev * ev_new(EvBase *base)
{
	Ev *e = (Ev *)cache_pool_alloc(POOL_EV);
	if(!(e && base)) {
		return NULL;
	}
	if (e->e == NULL) {
		e->e = (struct event *)xmalloc(sizeof(struct event));
		memset(e->e, 0, sizeof(struct event));
	}
	e->base = base;
	event_base_set(base, e->e);
	return e;
}

void ev_free(Ev *e)
{
	if (!e)
		return;
	e->base = NULL;
	if (e->e)
		event_del(e->e);
	safe_free(e->e);
	cache_pool_free(POOL_EV, e);
}

bool ev_update(Ev *e, int fd, short flags, EVCB cb, void *arg, float timeout)
{
	struct timeval tv;
	float t = 0;
	int usec= 1000000;
	bool suc = true;

	if (!(e && e->e))
		return false;

	event_del(e->e);
	event_set(e->e, fd, flags, cb, arg);
	if (e->base) 
		event_base_set(e->base, e->e);

	if(timeout <= 0) {
		if ( -1 == event_add(e->e, NULL))
			suc = false;
	} 
	else {
		t = timeout * usec;
		tv.tv_sec = (int) (t / usec);
		tv.tv_usec = ((int) t % usec);
		if ( -1 == event_add(e->e, &tv)) {
			suc = false;
		}
	}

	if(!suc) {
		WARN(LOG_FMT"fd %d, flag %d, cb %p, arg %p, timeout %.2f, %s.\n", LOG_PRE, fd, flags, cb, arg, timeout, \
			suc ? "True" : "False");
	} 
	else 
		DEBUG(LOG_FMT"fd %d, flag %d, cb %p, arg %p, timeout %.2f, %s.\n", LOG_PRE, fd, flags, cb, arg, timeout, \
			suc ? "True" : "False");

	return suc;
}

