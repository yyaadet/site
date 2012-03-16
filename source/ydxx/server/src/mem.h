#ifndef _MEM_H_
#define _MEM_H_

#define MNODE_SIZE 256

struct Mnode {
	char buf[MNODE_SIZE];

	TAILQ_ENTRY(Mnode) link;
};
typedef struct Mnode Mnode;

extern Mnode *mnode_new();
extern void mnode_free(Mnode *p);


struct Mem {
	int node_num;
	TAILQ_HEAD(, Mnode) nodes;

	int off;
	int pos;
	int is_big;
};
typedef struct Mem Mem;

extern Mem *mem_new();
extern void mem_free(Mem *m);

extern int mem_size(Mem *p);

extern const dstring * mem_get_buf(Mem *m, int pos, int len);
extern int mem_append_buf(Mem *p, const char *buf, int len);
extern void mem_erase(Mem *m, int pos, int len);

extern int mem_cmp(Mem *p1, Mem *p2);
extern int mem_cmp1(Mem *p1, const char *p2, int len);

extern void mem_set_big(Mem *m);

extern int mem_write_byte(Mem *m, byte *v);
extern int mem_write_short(Mem *m, short *v);
extern int mem_write_int(Mem *m,int *v);
extern int mem_write_string(Mem *m, dstring *s);
extern int mem_write_string1(Mem *m, const char *s, int len);
extern int mem_write_mem(Mem *m, Mem *v);

extern int mem_read_byte(Mem *str,byte *ret);
extern int mem_read_short(Mem *str, short *ret);
extern int mem_read_int(Mem *str,int *ret);
extern int mem_read_string(Mem *str, dstring *ret);
extern int mem_read_mem(Mem *src, Mem *ret);


#endif

