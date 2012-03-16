#include "hf.h"


static  Logging *g_log = NULL;

bool logging_init(const char *path, int level)
{
	if (!path)
		return false;
	if (g_log)
		return false;
	g_log = logging_new(path, level);
	if(!g_log) 
		return false;
	return true;
}

void logging_uninit()
{
	if (g_log) {
		logging_free(g_log);
	}
}


int logging_level_get(const char *name)
{
	if (!name)
		return LOGGING_NONE;
	else if(!strcasecmp(name, "none"))
		return LOGGING_NONE;
	else if (!strcasecmp(name, "warning"))
		return LOGGING_WARNING;
	else if(!strcasecmp(name, "debug"))
		return LOGGING_DEBUG;
	else if (!strcasecmp(name, "error"))
		return LOGGING_ERROR;
	else
		return LOGGING_NONE;
}

const char *logging_level_name(int level)
{
	switch (level) {
		case LOGGING_NONE:
			return "NONE";
		case LOGGING_DEBUG:
			return "DEBUG";
		case LOGGING_WARNING:
			return "WARNI";
		case LOGGING_ERROR:
			return "ERROR";
		default:
			return "NONE";
	}
}

Logging * logging_new(const char *path, int level)
{
	Logging *log = NULL;
	
	if (!path)
		return NULL;
	log = (Logging *)xmalloc(sizeof(Logging));
	if (!log)
		return NULL;

	log->level = level;
	log->file = fopen(path, "a");
	if (log->file == NULL) {
		fprintf (stderr, "%s %d: %s\n", __FILE__, __LINE__, strerror(errno));
		free(log);
		return NULL;
	}
	return log;
}

void logging_free(Logging *log)
{
	if (!log)
		return;
	if (log->file)
		fclose(log->file);
	free(log);
}


void logging_printf(Logging *log, int level, const char *fmt, va_list ap)
{
	time_t now = time(NULL);

	if (!log)
		return;
	if ( !(level >= log->level && log->file)) 
		return;

	fprintf(log->file, "[%s] %s %d| ", logging_level_name(level), \
					format_time(now, LOG_TIME_FMT), g_cycle->pid);
	vfprintf(log->file, fmt, ap);	
	va_end(ap);
	fflush(log->file);
}


void logging_debug(const char *fmt, ...)
{
	va_list ap;
	
	va_start(ap, fmt);
	logging_printf(g_log, LOGGING_DEBUG, fmt, ap);
}

void logging_warning(const char *fmt, ...)
{
	va_list ap;
	
	va_start(ap, fmt);
	logging_printf(g_log, LOGGING_WARNING, fmt, ap);
}


void logging_error(const char *fmt, ...)
{
	va_list ap;
	
	va_start(ap, fmt);
	logging_printf(g_log, LOGGING_ERROR, fmt, ap);
}

int logging_fd()
{
	if (!g_log)
		return -1;

	return fileno(g_log->file);
}
