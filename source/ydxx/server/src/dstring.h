#ifndef _DSTRING_H_
#define _DSTRING_H_
#include "defines.h"

#define DSTRING_DEFAULT_LEN 4

struct dstring {
	char *buf;
	unsigned  offset;
	unsigned  sz;
	unsigned  pos;
	byte is_big_endian; 
};
typedef struct dstring dstring;

#define DSTRING_INITIAL {NULL, 0, 0, 0, 0}


extern dstring *dstring_new(unsigned sz);
extern void dstring_free(dstring *str);
extern void dstring_set(dstring *str, const char *src);
extern void dstring_init(dstring *str);
extern void dstring_uninit(dstring *str);

extern int dstring_write_byte(dstring *str, byte v);	
extern int dstring_write_short(dstring *str, short v);
extern int dstring_write_ushort(dstring *str, ushort v);
extern int dstring_write_int(dstring *str,int v);
extern int dstring_write_uint(dstring *str,uint v);
extern int dstring_write_float(dstring *str,float v);
extern int dstring_write_double(dstring *str, double v);
extern int dstring_write_string(dstring *src, const char *str);
extern int dstring_write_string1(dstring *src, const char *str, int len);

extern int dstring_read_byte(dstring *str,byte *ret);
extern int dstring_read_short(dstring *str, short *ret);
extern int dstring_read_ushort(dstring *str, ushort *ret);
extern int dstring_read_int(dstring *str,int *ret);
extern int dstring_read_uint(dstring *str,uint *ret);
extern int dstring_read_float(dstring *str, float *ret);
extern int dstring_read_double(dstring *str, double *ret);
extern bool dstring_read_string(dstring *str, char **ret);
extern bool dstring_read_string1(dstring *str, dstring *ret);

extern void dstring_set_big_endian(dstring *str);
extern void dstring_erase(dstring *str, int start, int len);
extern void dstring_clear(dstring *str);

extern void dstring_to_lower(dstring *str);
extern void dstring_to_upper(dstring *str);

extern tinyint dstring_to_tinyint(dstring *s);
extern utinyint dstring_to_utinyint(dstring *s);

extern smallint dstring_to_smallint(dstring *s);
extern usmallint dstring_to_usmallint(dstring *s);

extern int dstring_to_int(dstring *s);
extern uint dstring_to_uint(dstring *s);

extern bigint dstring_to_bigint(dstring *s);
extern ubigint dstring_to_ubigint(dstring *s);


extern void dstring_strip(dstring *str, const char*chs);
extern int dstring_append(dstring *str, const char *src, int len);
extern int dstring_append_printf(dstring *str, const char *fmt, ...);
extern int dstring_printf(dstring *str, const char *fmt, ...);

extern const char *dstring_buf(dstring *str);
extern int dstring_offset(dstring *str);

extern int dstring_cmp(dstring *p1, dstring *p2);

#endif

