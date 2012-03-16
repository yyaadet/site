#include "hf.h"

Dipl *dipl_new(int type, int self_sph, int target_sph, int start, int end)
{
	Dipl *d = (Dipl *) cache_pool_alloc(POOL_DIPLOMACY);
	if (!d)
		return NULL;
	d->id = 0;
	d->type = type;
	d->self_id = self_sph;
	d->target_id = target_sph;
	d->start = start;
	d->end = end;
	return d;
}

void dipl_free(Dipl *dipl)
{
	if (!dipl)
		return;
	cache_pool_free(POOL_DIPLOMACY, dipl);
}


