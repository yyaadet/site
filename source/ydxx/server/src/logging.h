#ifndef _LOGGING_H
#define _LOGGING_H
#include <stdio.h>

enum LOGGING_LEVEL {
	LOGGING_NONE=0,
	LOGGING_DEBUG=1,
	LOGGING_WARNING=2,
	LOGGING_ERROR=3,
};

struct Logging 
{
	FILE *file;
	int level;
};

typedef struct Logging Logging;

extern bool logging_init(const char *path, int level);
extern void logging_uninit();

extern Logging *logging_new(const char *path, int level);
extern void logging_free(Logging *log);
extern void logging_printf(Logging *log, int level, const char *fmt, va_list ap);

extern const char *logging_level_name(int level);
extern int logging_level_get(const char *name);
extern const char *logging_time(void);

extern void logging_debug(const char *fmt, ...);
extern void logging_warning(const char *fmt, ...);
extern void logging_error(const char *fmt, ...);

extern int logging_fd();
#endif

