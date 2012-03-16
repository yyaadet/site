#include "hf.h"

static int mem_incr(Mem *p);
static Mnode * mem_get_last_data_node(Mem *p);

Mnode *mnode_new()
{
	Mnode *n = cache_pool_alloc(POOL_MNODE);

	if (!n)
		return NULL;

	return n;
}

void mnode_free(Mnode *p)
{
	cache_pool_free(POOL_MNODE, p);
}


Mem *mem_new()
{
	Mem *p = cache_pool_alloc(POOL_MEM);

	if (!p)
		return NULL;

	p->off = 0;
	p->pos = 0;
	p->is_big = 0;

	p->node_num = 0;
	TAILQ_INIT(&p->nodes);

	return p;
}

void mem_free(Mem *m)
{
	if (!m)
		return;

	Mnode *e, *t;

	TAILQ_FOREACH_SAFE(e, &m->nodes, link, t) {
		TAILQ_REMOVE(&m->nodes, e, link);
		mnode_free(e);
	}

	cache_pool_free(POOL_MEM, m);
}

int mem_size(Mem *p)
{
	if (!p)
		return 0;

	return p->node_num * MNODE_SIZE;
}

static int mem_incr(Mem *p)
{
	if (!p)
		return 0;

	Mnode *n = NULL;

	if (!(n = mnode_new()))
		return 0;

	TAILQ_INSERT_TAIL(&p->nodes, n, link);
	p->node_num++;

	return mem_size(p);
}

const dstring * mem_get_buf(Mem *m, int pos, int len)
{
	if (!m)
		return NULL;

	static dstring dst = DSTRING_INITIAL;
	Mnode *node = NULL;
	Mnode *first_node = NULL;
	int off = 0;
	int get = 0;
	int start = 0;

	if (pos + len > m->off) {
		return NULL;
	}

	dstring_clear(&dst);

	/* find first node of pos */
	TAILQ_FOREACH(node, &m->nodes, link) {
		if (pos < off + MNODE_SIZE) {
			first_node = node;
			break;
		}

		off += MNODE_SIZE;
	}
	
	/* get node data from pos */
	for(start = pos - off; first_node; first_node = TAILQ_NEXT(first_node, link)) {
		int sz = MIN(MNODE_SIZE - start, len - get);

		dstring_append(&dst, first_node->buf + start, sz);

		get += sz;
		if (get >= len) 
			break;

		start = 0;
	}

	DEBUG(LOG_FMT"require %d from %d, get %d\n", LOG_PRE, len, pos, dst.offset);

	return &dst;
}

static Mnode * mem_get_last_data_node(Mem *p)
{
	if (!p)
		return NULL;

	Mnode *e;
	int off = 0;

	TAILQ_FOREACH(e, &p->nodes, link) {
		if (off + MNODE_SIZE  > p->off)
			return e;

		off += MNODE_SIZE;
	}

	return NULL;
}

int mem_append_buf(Mem *p, const char *buf, int len)
{
	if (!(p && buf && len))
		return 0;

	Mnode *n = NULL;
	int off = 0;
	int left = 0;
	int node_off = 0;
	int app_len = 0;

	/* check left mem space */
	while (p->off + len > mem_size(p)) {
		if (!mem_incr(p))
			return 0;
	}

	while(off < len) {
		n = mem_get_last_data_node(p);
		if (!n)
			break;
		node_off = p->off % MNODE_SIZE; 
		left = MNODE_SIZE - node_off;

		DEBUG(LOG_FMT"last node %p, offset %d, left %d\n", LOG_PRE, n, node_off, left);

		app_len = MIN(len - off, left);
			
		memcpy(n->buf + node_off, buf + off, app_len);

		p->off += app_len;
		
		off += app_len;
	}

	DEBUG(LOG_FMT"mem %p, offset %d\n", LOG_PRE, p, p->off);

	return off;
}

void mem_erase(Mem *m, int pos, int len)
{
	if (!(m && pos + len <= m->off))
		return;

	static dstring pre = DSTRING_INITIAL;
	static dstring post = DSTRING_INITIAL;
	const dstring *t = NULL;

	dstring_clear(&pre);
	dstring_clear(&post);

	if (pos > 0) {
		if (!(t = mem_get_buf(m, 0, pos)))
			return;
	}
	if (t)
		dstring_append(&pre, t->buf, t->offset);
	
	if (pos + len < m->off) {
		if (!(t = mem_get_buf(m, pos + len, m->off - pos - len)))
			return ;
	}
	if (t)
		dstring_append(&post, t->buf, t->offset);

	m->off = 0;
	
	mem_append_buf(m, pre.buf, pre.offset);
	mem_append_buf(m, post.buf, post.offset);

	DEBUG(LOG_FMT"erase %d from %d, left %d\n", LOG_PRE, len, pos, m->off);
}

int mem_cmp(Mem *p1, Mem *p2)
{
	if (!(p1 && p2))
		return 1;

	if (p1->node_num > p2->node_num)
		return 1;
	else if (p1->node_num < p2->node_num)
		return -1;

	int ret = 0;
	Mnode *e1, *e2;

	for(e1 = TAILQ_FIRST(&p1->nodes), e2 = TAILQ_FIRST(&p2->nodes); \
			e1 && e2; \
			e1 = TAILQ_NEXT(e1, link), e2 = TAILQ_NEXT(e2, link)) {

		if ((ret = memcmp(e1->buf, e2->buf, MNODE_SIZE)))
			return ret;
	}

	return ret;
}

int mem_cmp1(Mem *p1, const char *p2, int len)
{
	if (!(p1 && p2 && len > 0)) 
		return 1;

	int off = 0;
	int cmp_len = 0;
	int ret = 0;
	Mnode *e1 = NULL;

	
	for(e1 = TAILQ_FIRST(&p1->nodes);\
			e1; \
			e1 = TAILQ_NEXT(e1, link)) {

		cmp_len = (len - off) > MNODE_SIZE ? MNODE_SIZE : (len - off);

		if ((ret = memcmp(e1->buf, p2 + off, cmp_len)))
			return ret;

		off += cmp_len;
		if (off >= len) 
			break;
	}

	return ret;
}

void mem_set_big(Mem *m)
{
	if (!m)
		return ;
	m->is_big = 1;
}

int mem_write_byte(Mem *m, byte *v)
{
	if (!(m && v))
		return 0;

	return mem_append_buf(m, (const char *)v, sizeof(byte));
}

int mem_write_short(Mem *m, short *v)
{
	if (!(m && v))
		return 0;

	ushort t;

	if (m->is_big) 
		t = htons(*v);
	else 
		t = *v;

	return mem_append_buf(m, (const char *)&t, sizeof(t));
}

int mem_write_int(Mem *m,int *v)
{
	if (!(m && v))
		return 0;

	uint t;

	if (m->is_big) 
		t = htonl(*v);
	else 
		t = *v;

	return mem_append_buf(m, (const char *) &t, sizeof(t));
}

int mem_write_string1(Mem *m, const char *s, int len)
{
	if (!m)
		return 0;

	uint t;
	int n = 0;

	if (m->is_big) 
		t = htonl(len);
	else 
		t = len;

	n = mem_append_buf(m, (const char *)&t, sizeof(t));

	n+= mem_append_buf(m, s, len);

	return n;
}

int mem_write_string(Mem *m, dstring *s)
{
    if (!(m && s))
        return 0;

    return mem_write_string1(m, s->buf, s->offset);
}

int mem_write_mem(Mem *m, Mem *s)
{
	if (!(m && s))
		return 0;

	uint t;
	int n = 0;
    const dstring *tmp;

    if (!(tmp = mem_get_buf(s, 0, s->off)))
        return 0;

	if (m->is_big) 
		t = htonl(tmp->offset);
	else 
		t = tmp->offset;

	n = mem_append_buf(m, (const char *)&t, sizeof(t));

	n += mem_append_buf(m, tmp->buf, tmp->offset);

	return n;
}

int mem_read_byte(Mem *m, byte *ret)
{
	if (!(m && ret))
		return 0;

	const dstring *s;
	byte v;
	int len = sizeof(v);


	if (!(s = mem_get_buf(m, m->pos, len)))
		return 0;
	if (s->offset != len)
		return 0;

	memcpy(&v, s->buf, s->offset);

	(*ret) = v;

	m->pos += s->offset;

	return s->offset;
}

int mem_read_short(Mem *m, short *ret)
{
	if (!(m && ret))
		return 0;

	const dstring *s;
	short v;
	int len = sizeof(v);


	if (!(s = mem_get_buf(m, m->pos, len)))
		return 0;
	if (s->offset != len)
		return 0;

	memcpy(&v, s->buf, s->offset);

	if(m->is_big) 
		v = ntohs(v);

	(*ret) = v;
	
	m->pos += s->offset;

	return s->offset;
}

int mem_read_int(Mem *m, int *ret)
{
	if (!(m && ret))
		return 0;

	const dstring *s;
	int v;
	int len = sizeof(v);


	if (!(s = mem_get_buf(m, m->pos, len)))
		return 0;
	if (s->offset != len)
		return 0;

	memcpy(&v, s->buf, s->offset);

	if(m->is_big) 
		v = ntohl(v);

	(*ret) = v;
	
	m->pos += s->offset;

	return s->offset;
}

int mem_read_string(Mem *m, dstring *ret)
{
	if (!(m && ret))
		return 0;

	const dstring *s;
	int str_len = 0;
	int len = sizeof(int);


	if (!(s = mem_get_buf(m, m->pos, len)))
		return 0;
	if (s->offset != len)
		return 0;

	memcpy(&str_len, s->buf, s->offset);

	if(m->is_big) 
		str_len = ntohl(str_len);
	m->pos += s->offset;

	len = str_len;
	if (!(s = mem_get_buf(m, m->pos, len)))
		return 0;
	if (s->offset != len)
		return 0;

	dstring_append(ret, s->buf, s->offset);

	return s->offset + sizeof(int);
}

int mem_read_mem(Mem *m, Mem *ret) 
{
	if (!(m && ret))
		return 0;

	const dstring *s;
	int str_len = 0;
	int len = sizeof(int);


	if (!(s = mem_get_buf(m, m->pos, len)))
		return 0;
	if (s->offset != len)
		return 0;

	memcpy(&str_len, s->buf, s->offset);

	if(m->is_big) 
		str_len = ntohl(str_len);
	m->pos += s->offset;

	len = str_len;
	if (!(s = mem_get_buf(m, m->pos, len)))
		return 0;
	if (s->offset != len)
		return 0;

	mem_append_buf(ret, s->buf, s->offset);

	return s->offset + sizeof(int);
}
