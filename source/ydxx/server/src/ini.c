#include "hf.h"

static bool ini_parse(Ini *ini, const char *path);
static const  char *ini_build_key(const char *group, const char *name);


static const  char *ini_build_key(const char *group, const char *name)
{
	if (!(group && name))
		return NULL;
	static char buf[128];

	snprintf(buf, 127, "%s_%s", group, name);
	return buf;
}

static bool ini_parse(Ini *ini, const char *path)
{
	if (!(ini && path))
		return false;

	FILE *f = NULL;
	int linen = 0;
	char line[MAX_BUFFER];
	char *t = NULL;
	dstring g = DSTRING_INITIAL;

	if ( NULL == (f = fopen(path, "r"))) {
		fprintf(stderr, "%s: %s\n", __func__, strerror(errno));
		return false;
	}
	for ( ;fgets(line, MAX_BUFFER, f); linen++) {
		dstring k = DSTRING_INITIAL;
		dstring v = DSTRING_INITIAL;
		dstring n = DSTRING_INITIAL;

		if (line[0] == '#' || line[0] == '\r' || line[0] == '\n' || line[0] == ' ') 
			continue;
		//is group ?
		if (line[0] == '[') {
			dstring_clear(&g);
			dstring_set(&g, line);
			dstring_strip(&g, " \r\n\t[]");
			continue;
		}

		if(NULL == (t = strchr(line, '='))) {
			printf("%s %d: not found '='\n", path, linen);
			continue;
		}
		dstring_append(&k, line, t - line);
		dstring_strip(&k, " \r\n\t");
		dstring_append(&v, t + 1, strlen(t + 1));
		dstring_strip(&v, " \r\n\t");

		dstring_set(&n, ini_build_key(g.buf, k.buf));

		Entry *entry = entry_new(n.buf, v.buf);
		if(!entry) {
			break;
		}
		TAILQ_INSERT_TAIL(&ini->entries, entry, link);
	}
	fclose(f);
	return true;
}


Ini *ini_new(const char *path)
{
	if (!path)
		return NULL;
	Ini *ini = (Ini *) xmalloc(sizeof(Ini));
	if (!ini)
		return NULL;

	TAILQ_INIT(&ini->entries);
	if (!ini_parse(ini, path)) {
		ini_free(ini);
		return NULL;
	}
	return ini;
}

void ini_free(Ini *ini)
{
	if (!ini)
		return ;
	
	Entry *e, *t;

	TAILQ_FOREACH_SAFE(e, &ini->entries, link, t) {
		TAILQ_REMOVE(&ini->entries, e, link);
		entry_free(e);
	}
	free(ini);
}

const char *init_get_entry(Ini *ini, const char *g, const char *name)
{
	Entry *e = NULL;
	const char *k = NULL;

	if(!(ini && g && name))
		return NULL;
	k = ini_build_key(g, name);
	if (!k)
		return NULL;
	TAILQ_FOREACH(e, &ini->entries, link) {
		if (!strcasecmp(e->name.buf, k)) {
			return e->value.buf;
		}
	}
	return NULL;
}

