#ifndef _AI_H_
#define _AI_H_


extern int computer_distance(int x, int y, int x1, int y1);
extern int computer_move_hour(int x, int y, int x1, int y1, int speed);
extern float computer_move_second(int x, int y, int x1, int y1, int speed);

extern int gen_random(int min, int max);
/* 
 * prop: 0 ~ 100 
 */
extern bool gen_prop(int prop);

/*
 *
 * num: element number
 * w: adjacency matrix, size = num * num
 *
 */
extern bool get_reached_path(int num, int *w, int start, int end, int **path, int *path_num);

extern bool floyd(int num, int *w, int *d);
#endif


