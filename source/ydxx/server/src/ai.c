#include "hf.h"


static int min_path(int d1, int d2);
static int add_path(int d1, int d2);


int computer_distance(int x, int y, int x1, int y1)
{
	int d1 = abs(x - x1);
	int d2 = abs(y - y1);

	return d1 + d2;
}


float computer_move_second(int x, int y, int x1, int y1, int move_speed)
{
	int distance = 0;
	float sec = 0.0;
	int consume = 8;
	MapRegion *reg;

	
	if (move_speed <= 0) {
		return 0.0;
	}
	
	{consume = (reg = get_global_region(x, y)) ? reg->m_consume : consume;}

	distance = computer_distance(x, y, x1, y1);

	sec = ((float)((float)distance / GRID_PER_LI / move_speed * consume * GAME_HOUR_PER_SEC)) / ((float)20);

	DEBUG(LOG_FMT"move from (%d, %d) to (%d, %d), speed %d, " \
					"consume %d, need %f seconds\n", LOG_PRE, \
				   	x, y, x1, y1, move_speed, consume, sec);
	return sec;
}


int computer_move_hour(int x, int y, int x1, int y1, int speed)
{
	float sec = 0;
	int hour = 0;

	sec = computer_move_second(x, y, x1, y1, speed);
	hour = (int) ceil(sec / GAME_HOUR_PER_SEC);
	return hour;
}

int gen_random(int min, int max)
{
	int dst = 0;
	int t = 0;

	if (max <= 0 || max < min)
		return -1;

	t = max - min;

	dst = random();

	dst %= (t + 1);

	if (dst < min)
		dst += min;

	return dst;
}

bool gen_prop(int prop)
{
	int ran = gen_random(0, 100);

	if (ran <= prop)
		return true;
	return false;
}

bool floyd(int num, int *w, int *d)
{                   
	if (!w)             
		return false;

	int i = 0;
	int j = 0;
	int k = 0;

	for( i = 0; i < num; i ++) {
		for(j = 0; j < num; j++) {
			*(d + i * num + j) = *(w + i *num + j);
		}
	}

	for(k = 0; k < num; k++) {
		for( i = 0; i < num; i ++) {
			for(j = 0; j < num; j++) {
				if (i == j || i == k || j == k)
					continue;
				*(d + i*num + j) = min_path(*(d + i * num + j), add_path(*(d + i*num + k), *(d + k*num + j)));
			}
		}
	}
	return true;
}

static int min_path(int d1, int d2)
{
	if (d1 == -1)
		return d2;
	else if (d2 == -1)
		return d1;
	return MIN(d1, d2);
}

static int add_path(int d1, int d2)
{
	if (d1 == -1 || d2 == -1)
		return -1;
	return d1 + d2;
}



