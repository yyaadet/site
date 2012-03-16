#include "hf.h"

#if 0
static bool shmem_reset(Shmem *sh, int sz);
#endif

Shmem  *shmem_new()
{
	Shmem *shm = (Shmem *) xmalloc(sizeof(Shmem));
	if (!shm) 
		return NULL;
	shm->size = 0;
	shm->ptr = (byte *) -1;
	shm->sid = 0;
	shm->pos = 0;
	shm->key = -1;
	shm->flag = 0;
	return shm;
}

void shmem_free(Shmem *shm)
{
	if (!shm) 
		return;
	free(shm);
}

#if 0
static bool shmem_reset(Shmem *sh, int sz)
{
	if (!sh)
		return false;

	int sid = 0;
	void *ptr = NULL;

	if ((sid = shmget(sh->key, sz, sh->flag)) == -1) {
		ERROR(LOG_FMT"shmget failed: %s\n",  LOG_PRE, error_string());
		return false;
	}
	if ((ptr = (byte *) shmat(sid, NULL, 0)) == (byte *) -1) {
		ERROR(LOG_FMT"shmat failed: %s\n", LOG_PRE, error_string());
		return false;
	}

	shmem_detach(sh);

	sh->size = sz;
	sh->ptr = ptr;
	sh->sid = sid;
	
	return true;
}
#endif

bool shmem_load(Shmem *shm, const char *path, int size, int flag, int id)
{
	if (!shm) 
		return false;

	int t = 0;

	if (!path)
		return false;
	shm->size = size;
	shm->flag = flag;
	if ((shm->key= ftok(path, id)) == -1) {
		ERROR(LOG_FMT"ftok failed to load %s:%d: %s\n",  LOG_PRE, path, id, error_string());
		return false;
	}
	if ((shm->sid = shmget(shm->key, shm->size, flag)) == -1) {
		ERROR(LOG_FMT"shmget failed to load %s:%d: %s\n",  LOG_PRE, path, id, error_string());
		return false;
	}
	if ((shm->ptr = (byte *) shmat(shm->sid, NULL, 0)) == (byte *) -1) {
		ERROR(LOG_FMT"shmat failed to load %s:%d: %s\n", LOG_PRE, path, id, error_string());
		return false;
	}
	t = *((int *)shm->ptr);
	DEBUG(LOG_FMT"load %s:%d success. Test data %d\n", LOG_PRE, path, id, t);
	return true;
}

bool shmem_get(Shmem *shm, int offset, int len, char *dst, int dst_len)
{
	if (!shm) 
		return false;

	if (shm->size < len + offset)
		return false;
	if (shm->ptr == (void *) -1) 
		return false;
	if (!dst) 
		return false;
	if (dst_len < len) 
		return false;
	
	memcpy(dst, (void *)((char *)shm->ptr + offset), len);
	DEBUG(LOG_FMT"shmid(%d) get %d byte from position %d\n", LOG_PRE, shm->sid, len, offset);
	return true;
}

bool shmem_set(Shmem *shm, const char *buf, int len)
{
	if (!shm)
		return false;
	if (!buf) 
		return false;
	if (shm->ptr == (byte *) -1) 
		return false;

	if (shm->size < len) {
		WARN(LOG_FMT"shm(%d) size less than required %d\n", LOG_PRE, shm->sid, len);
		return false;
	}

	memcpy((char *)shm->ptr, buf, len);
	
	//DEBUG(LOG_FMT"shmid(%d) set %d byte\n", LOG_PRE, shm->sid, len);
	return true;
}

void shmem_detach(Shmem *shm)
{
	if (!shm) 
		return;
	if(shm->ptr != (void *) -1) {
		shmdt(shm->ptr);
		shm->ptr = (void *)-1;
	}
}
	
void shmem_remove(Shmem *shm)
{
	if (!shm) 
		return;
	if (shmctl(shm->sid, IPC_RMID, NULL) == -1) {
		ERROR(LOG_FMT"shmctl failed: %s\n", LOG_PRE, error_string());
	}
}

bool shmem_read_byte(Shmem *shm, byte *ret)
{
	if (!shm) 
		return false;

	unsigned int sz = sizeof(byte);
	byte t = 0;

	if(shm->ptr == (void *) -1) 
		return false;
	if ((uint)(shm->size - shm->pos) < sz)
		return false;
	t = *((byte *) ((char *)shm->ptr + shm->pos));
	shm->pos += sz;
	(*ret) = t;
	return true;
}

bool shmem_read_short(Shmem *shm, short *ret)
{
	if (!shm)
		return false;

	int sz = sizeof(short);
	short t = 0;

	if(shm->ptr == (void *) -1) 
		return false;
	if ((shm->size - shm->pos) < sz)
		return false;
	t = *((short *) ((char *)shm->ptr + shm->pos));
	shm->pos += sz;
	(*ret) = t;
	return true;
}

bool shmem_read_ushort(Shmem *shm, ushort *ret)
{
	if (!shm)
		return false;

	int sz = sizeof(short);
	ushort t = 0;

	if(shm->ptr == (void *) -1) 
		return false;
	if ((shm->size - shm->pos) < sz)
		return false;
	t = *((ushort *) ((char *)shm->ptr + shm->pos));
	shm->pos += sz;
	(*ret) = t;
	return true;
}

bool shmem_read_uint(Shmem *shm, uint *ret)
{
	if (!shm)
		return false;

	int sz = sizeof(uint);
	uint t = 0;

	if(shm->ptr == (void *) -1) 
		return false;
	if ((shm->size - shm->pos) < sz)
		return false;
	t = *((uint *) ((char *)shm->ptr + shm->pos));
	shm->pos += sz;
	(*ret) = t;
	return true;
}
bool shmem_read_int(Shmem *shm, int *ret)
{
	if (!shm)
		return false;

	int sz = sizeof(int);
	int t = 0;

	if(shm->ptr == (void *) -1) 
		return false;
	if ((shm->size - shm->pos) < sz)
		return false;
	t = *((int *) ((char *)shm->ptr + shm->pos));
	shm->pos += sz;
	(*ret) = t;

	//DEBUG(LOG_FMT"sid %d, pos %d, size %d\n", LOG_PRE, shm->sid, shm->pos, shm->size);
	return true;
}


bool shmem_read_float(Shmem *shm, float *ret)
{
	if (!shm)
		return false;
	int sz = sizeof(float);
	float t = 0;

	if(shm->ptr == (void *) -1) 
		return false;
	if (shm->size - shm->pos < sz)
		return false;
	t = *((float *) ((char *)shm->ptr + shm->pos));
	shm->pos += sz;
	(*ret) = t;
	return true;
}
bool shmem_read_double(Shmem *shm, double *ret)
{
	if (!shm)
		return false;
	int sz = sizeof(double);
	double t = 0;

	if(shm->ptr == (void *) -1) 
		return false;
	if (shm->size - shm->pos < sz)
		return false;
	t = *((double *) ((char *)shm->ptr + shm->pos));
	shm->pos += sz;
	(*ret) = t;
	return true;
}

bool shmem_read_string(Shmem *shm, dstring *dst)
{
	if (!shm) 
		return false;

	int t = 0;
	int sz = sizeof(int);

	if (shm->ptr == (void *) -1)
		return false;
	if (shm->size - shm->pos < sz) {
		return false;
	}
	t = *((int *) ((char *)shm->ptr + shm->pos));
	shm->pos += sz;
	if (t <0 || (int)(shm->size - shm->pos) < t) {
		return false;
	}
	if (t == 0)
		return true;

	dstring_append(dst, ((char *)shm->ptr + shm->pos), t);
	shm->pos += t;
	return true;
}


