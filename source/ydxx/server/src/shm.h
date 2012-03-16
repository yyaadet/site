#ifndef _SHM_H_
#define _SHM_H_

#define SHMEM_INITIAL {0, (byte *) -1, 0, 0, -1}

struct Shmem {
	int sid;
	byte *ptr;
	int pos;
	int size;
	int flag;
	key_t key;
};
typedef struct Shmem Shmem;


extern Shmem *shmem_new();
extern void shmem_free(Shmem *shm);

extern bool shmem_load(Shmem *shm, const char *path, int size, int flag, int id);
extern bool shmem_get(Shmem *shm, int offset, int len, char *dst, int dst_len);
extern bool shmem_set(Shmem * shm, const char *buf, int len);
extern void shmem_detach(Shmem *shm);
extern void shmem_remove(Shmem *shm);

extern bool shmem_read_byte(Shmem *shm, byte *ret);	
extern bool shmem_read_ushort(Shmem *shm, ushort *ret);
extern bool shmem_read_short(Shmem *shm, short *ret);
extern bool shmem_read_uint(Shmem *shm, uint *ret);
extern bool shmem_read_int(Shmem *shm, int *ret);
extern bool shmem_read_float(Shmem *shm, float *ret);
extern bool shmem_read_double(Shmem *shm, double *ret);
extern bool shmem_read_string(Shmem *shm, dstring *dst);

#endif
