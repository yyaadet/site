#ifndef _EV_H_
#define _EV_H_
#include "common.h"

#define DEF_EV_TIMEOUT (-1)

typedef struct event_base EvBase;

struct Ev {
	EvBase *base;
	struct event *e;
};
typedef struct Ev Ev;


extern EvBase *ev_base_new(void);
extern void ev_base_free(EvBase *base);
extern bool ev_base_loop(EvBase *base, int flags);

extern Ev * ev_new(EvBase *base);
extern void ev_free(Ev *e);

extern bool ev_update(Ev *e, int fd, short flags, EVCB cb, void *arg, float timeout);
#endif
