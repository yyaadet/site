#include "hf.h"

int g_malloc_num = 0;
int g_malloc_failed = 0;
int g_free_num = 0;


void *xmalloc(unsigned int size)
{
	void *p = NULL;
	unsigned int sz = size;

	if (sz <= 0) {
		sz = 1;
	}
	g_malloc_num++;
	while (true) {
		p = malloc(sz);
		if (p) {
			memset(p, 0, sz);
			return p;
		}
		else {
			g_malloc_failed++;
		}
		break;
	}
	return NULL;
}

void xfree(void *p)
{
	g_free_num++;
	free(p);
	return;
}


