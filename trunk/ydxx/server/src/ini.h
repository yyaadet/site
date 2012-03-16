#ifndef _INI_H_
#define  _INI_H_

#include "queue.h"

struct Entry;

struct Ini {
	TAILQ_HEAD(, Entry) entries; 
};
typedef struct Ini Ini;

extern Ini *ini_new(const char *path);
extern void ini_free(Ini *ini);
extern const char *init_get_entry(Ini *ini, const char *g, const char *name);
#endif

