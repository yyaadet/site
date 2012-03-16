#ifndef _XALLOC_H_
#define _XALLOC_H_


extern void *xmalloc(unsigned int size);
extern void xfree(void *p);

extern int g_malloc_num;
extern int g_malloc_failed;
extern int g_free_num ;

#endif
