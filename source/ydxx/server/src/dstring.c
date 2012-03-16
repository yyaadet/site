#include "hf.h"


dstring *dstring_new(unsigned sz)
{
	unsigned size = sz > DSTRING_DEFAULT_LEN ? sz : DSTRING_DEFAULT_LEN;
	dstring *str = NULL;

	str = (dstring *)xmalloc(sizeof(dstring));
	if (!str) {
		return str;
	}
	str->sz = size;
	str->buf = (char *)xmalloc(size);
	if (!str->buf) {
		free(str);
		return NULL;
	}
	str->offset = 0;
	str->pos = 0;
	str->is_big_endian = 0;
	return str;
}

void dstring_free(dstring *str)
{
	if (!str)
		return;
	safe_free(str->buf);
	safe_free(str);
}

void dstring_set(dstring *str, const char *src)
{
	if (!(str && src))
		return;
	dstring_clear(str);
	dstring_append(str, src, strlen(src));
}

void dstring_init(dstring *str)
{
	if (!str)
		return;
	str->buf = NULL;
	str->is_big_endian = 0;
	str->offset = 0;
	str->pos = 0;
	str->sz = 0;
}
void dstring_uninit(dstring *str)
{
	if (!str)
		return;
	if (str->buf) {
		free(str->buf);
		str->buf = NULL;
	}
	str->sz = 0;
	str->pos = 0;
	str->offset = 0;
	str->is_big_endian = 0;
}

int dstring_write_byte(dstring *str, byte v)
{
	if(!str)
		return 0;
	return dstring_append(str, (char *)&v, sizeof(byte));
}

int dstring_write_short(dstring *str, short v)
{
	short t = 0;

	if (!str)
		return 0;
	if (str->is_big_endian) {
		t = htons(v);
	}
	else 
		t = v;
	return dstring_append(str, (char *)&t, sizeof(short));
}

int dstring_write_ushort(dstring *str, ushort v)
{
	ushort t = 0;

	if (!str)
		return 0;
	if (str->is_big_endian) {
		t = htons(v);
	}
	else 
		t = v;
	return dstring_append(str, (char *)&t, sizeof(short));
}

int dstring_write_int(dstring *str,int v)
{
	int t = 0;

	if (!str) 
		return 0;
	t = v;
	if (str->is_big_endian) 
		t = htonl(v);
	return dstring_append(str, (char *)&t, sizeof(int));
}

int dstring_write_uint(dstring *str,uint v)
{
	uint t = 0;

	if (!str) 
		return 0;
	t = v;
	if (str->is_big_endian) 
		t = htonl(v);
	return dstring_append(str, (char *)&t, sizeof(int));
}

int dstring_write_float(dstring *str, float v)
{
	if (!str) 
		return 0;
	return dstring_append(str, (char *)&v, sizeof(float));
}

int dstring_write_double(dstring *str,double v)
{
	if (!str) 
		return 0;
	return dstring_append(str, (char *)&v, sizeof(double));
}


int dstring_write_string(dstring *str,const char *src)
{
	int len = (src == NULL) ? 0: strlen(src);

	return dstring_write_string1(str, src, len);
}

int dstring_write_string1(dstring *str,const char *src, int len)
{
	if (!(str))
		return 0;
	dstring_write_int(str, len);
	return dstring_append(str, src, len);
}
int dstring_read_byte(dstring *str,byte *ret)
{
	unsigned int sz = sizeof(byte);
	byte t = 0;

	if(!str) {
		return 0;
	}
	if (str->offset - str->pos < sz)
		return 0;
	t = *((byte *)(str->buf + str->pos));
	str->pos += sz;
	(*ret) = t;
	return 1;
}

int dstring_read_short(dstring *str, short *ret)
{
	short t = 0;
	unsigned int sz = sizeof(short);

	if (!str) 
		return 0;
	if (str->offset - str->pos < sz) {
		return 0;
	}
	t = *((short *)(str->buf + str->pos));
	if (str->is_big_endian)
		t = ntohs(t);
	str->pos += sz;
	(*ret) = t;
	return 1;
}

int dstring_read_ushort(dstring *str, ushort *ret)
{
	ushort t = 0;
	unsigned int sz = sizeof(ushort);

	if (!str) 
		return 0;
	if (str->offset - str->pos < sz) {
		return 0;
	}
	t = *((ushort *)(str->buf + str->pos));
	if (str->is_big_endian)
		t = ntohs(t);
	str->pos += sz;
	(*ret) = t;
	return 1;
}

int dstring_read_int(dstring *str,int *ret)
{
	int t = 0;
	unsigned int sz = sizeof(int);

	if (!str) 
		return 0;
	if (str->offset - str->pos < sz) {
		return 0;
	}
	t = *((int *)(str->buf + str->pos));
	if (str->is_big_endian)
		t = ntohl(t);
	str->pos += sz;
	(*ret) = t;
	return 1;
}

int dstring_read_uint(dstring *str,uint *ret)
{
	uint t = 0;
	unsigned int sz = sizeof(uint);

	if (!str) 
		return 0;
	if (str->offset - str->pos < sz) {
		return 0;
	}
	t = *((uint *)(str->buf + str->pos));
	if (str->is_big_endian)
		t = ntohl(t);
	str->pos += sz;
	(*ret) = t;
	return 1;
}

int dstring_read_float(dstring *str,float *ret)
{
	float t = 0;
	unsigned int sz = sizeof(float);

	if (!str) 
		return 0;
	if (str->offset - str->pos < sz) {
		return 0;
	}
	t = *((float *)(str->buf + str->pos));
	str->pos += sz;
	(*ret) = t;
	return 1;
}

int dstring_read_double(dstring *str,double *ret)
{
	double t = 0;
	unsigned int sz = sizeof(double);

	if (!str) 
		return 0;
	if (str->offset - str->pos < sz) {
		return 0;
	}
	t = *((double *)(str->buf + str->pos));
	str->pos += sz;
	(*ret) = t;
	return 1;
}


bool dstring_read_string(dstring *str,char **ret)
{
	int t = 0;
	unsigned int sz = sizeof(int);
	static dstring dst = DSTRING_INITIAL;

	if(!str) 
		return false;
	if (str->offset - str->pos < sz) {
		return false;
	}
	t = *((int *)(str->buf + str->pos));
	str->pos += sz;
	if (str->is_big_endian)
		t = ntohl(t);
	if (t <0 || (int)(str->offset - str->pos) < t) {
		return false;
	}
	if (t == 0)
		return true;
	
	dstring_clear(&dst);
	dstring_append(&dst, str->buf + str->pos, t);
	str->pos += t;
	(*ret) = dst.buf;
	return true;
}

bool dstring_read_string1(dstring *str, dstring *ret)
{
	if (!(str && ret))
		return false;

	int t = 0;
	unsigned int sz = sizeof(int);

	if (str->offset - str->pos < sz) {
		return false;
	}

	t = *((int *)(str->buf + str->pos));
	str->pos += sz;
	if (str->is_big_endian)
		t = ntohl(t);
	if (t <0 || (int)(str->offset - str->pos) < t) {
		return false;
	}

	if (t == 0)
		return true;
	
	dstring_clear(ret);
	dstring_append(ret, str->buf + str->pos, t);

	str->pos += t;
	return true;
}

void dstring_set_big_endian(dstring *str)
{
	if (!str)
		return;
	str->is_big_endian = 1;
}

void dstring_erase(dstring *str, int start, int len)
{
	unsigned int new_offset = 0;

	if (!str) 
		return ;
	if (!(start >= 0 && len > 0 && len <= (int)(str->offset - start)))
		return;
	if (start == 0 && len == (int) str->offset) {
		str->offset = 0;
		str->buf[0] = '\0';
		return;
	}
	new_offset = str->offset - len;
	memmove(str->buf + start, str->buf + start + len, str->offset - start - len);
	str->offset = new_offset;
}

void dstring_clear(dstring *str)
{

	if (!str)
		return;
	str->offset = 0;
	str->pos = 0;
	str->is_big_endian = 0;
	if (str->sz > 0) {
		str->buf[0] = '\0';
	}
}

void dstring_to_lower(dstring *str)
{
	unsigned int i = 0;

	if(!str)
		return ;
	for (i = 0; i < str->offset; i ++) 
		str->buf[i] = tolower(str->buf[i]);
}

void dstring_to_upper(dstring *str)
{
	unsigned int i = 0;

	if(!str)
		return ;
	for (i = 0; i < str->offset; i ++) 
		str->buf[i] = toupper(str->buf[i]);
}

tinyint dstring_to_tinyint(dstring *s)
{
	if (!s) 
		return 0;

	return strtol(s->buf, (char **)NULL, 10);
}

utinyint dstring_to_utinyint(dstring *s)
{
	if (!s) 
		return 0;

	return strtol(s->buf, (char **)NULL, 10);
}

smallint dstring_to_smallint(dstring *s)
{
	if (!s) 
		return 0;

	return strtol(s->buf, (char **)NULL, 10);
}

usmallint dstring_to_usmallint(dstring *s)
{
	if (!s) 
		return 0;

	return strtol(s->buf, (char **)NULL, 10);
}

int dstring_to_int(dstring *s)
{
	if (!s) 
		return 0;

	return strtol(s->buf, (char **)NULL, 10);
}

uint dstring_to_uint(dstring *s)
{
	if (!s) 
		return 0;

	return strtoul(s->buf, (char **)NULL, 10);
}

bigint dstring_to_bigint(dstring *s)
{
	if (!s) 
		return 0;

	return strtoll(s->buf, (char **)NULL, 10);
}

ubigint dstring_to_ubigint(dstring *s)
{
	if (!s) 
		return 0;

	return strtoull(s->buf, (char **)NULL, 10);
}

void dstring_strip(dstring *str, const char*chs)
{
	char new_buf[MAX_BUFFER];
	int new_offset = 0;
	int start = 0;
	int end = 0;

	if (!str)
		return;
	if (str->buf == NULL || str->offset < 0 )
		return;

	while(strchr(chs, str->buf[start]))
		++start;

	end = str->offset;
	while(strchr(chs, str->buf[end-1]))
		--end;

	if (end <= start)
		return ;
	if (end - start == (int)str->offset) 
		return;

	new_offset = end - start;
	if (new_offset >= MAX_BUFFER) 
		return ;
	memcpy(new_buf, str->buf + start, new_offset);
	new_buf[new_offset] = '\0';
	dstring_clear(str);
	dstring_append(str, new_buf, new_offset);
}

int dstring_append(dstring *str, const char *src, int len)
{
	int new_size = 0;
	char *new_buf = NULL;
	int incr_size = 0;

	if (!(str && len > 0 && src))
		return 0;

	if (str->offset + len + 1 > str->sz) {
		incr_size = str->sz * DSTRING_INCR_FACTOR;
		new_size = str->offset + len + 1;
		new_size = new_size > incr_size ? new_size : incr_size;
		new_buf = (char *)xmalloc(new_size);
		if (!new_buf) {
			WARN(LOG_FMT"failed to xmalloc %d byte\n", LOG_PRE, new_size);
			return 0;
		}
		str->sz = new_size;
		memcpy(new_buf, str->buf, str->offset);
		safe_free(str->buf);
		str->buf = new_buf;
	}

	memcpy(str->buf + str->offset, src, len);
	str->offset += len;
	str->buf[str->offset] = '\0';
	return str->offset;
}

int dstring_append_printf(dstring *str, const char *fmt, ...)
{
	int res = -1;
	va_list ap;
	char t[MAX_BUFFER];

	if (!str) 
		return 0;
	va_start(ap, fmt);
	res = vsnprintf(t, MAX_BUFFER - 1, fmt, ap);
	va_end(ap);
	if (-1 == res)
		return 0;
	return dstring_append(str, t, res);
}

int dstring_printf(dstring *str, const char *fmt, ...)
{
	int res = -1;
	va_list ap;
	char t[MAX_BUFFER];

	if (!str) 
		return 0;
	
	dstring_clear(str);

	va_start(ap, fmt);
	res = vsnprintf(t, MAX_BUFFER - 1, fmt, ap);
	va_end(ap);
	if (-1 == res)
		return 0;
	return dstring_append(str, t, res);
}

const char *dstring_buf(dstring *str)
{
	if (!str)
		return "";
	return str->buf;
}

int dstring_offset(dstring *str)
{
	if (!str)
		return 0;

	return str->offset;
}


int dstring_cmp(dstring *p1, dstring *p2)
{
	if (!(p1 && p1->buf && p2 && p2->buf))
		return 1;

	return strcasecmp(p1->buf, p2->buf);
}

