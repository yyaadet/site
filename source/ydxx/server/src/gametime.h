#ifndef _GAMETIME_H_
#define _GAMETIME_H_

extern const char *readable_game_time(int t);
extern bool game_time_is_year_end(int t);
extern bool game_time_is_season_end(int t);
extern bool game_time_is_month_end(int t);
extern bool game_time_is_weak_end(int t);
extern bool game_time_is_day_end(int t);
extern bool game_time_is_hour_end(int t);

extern int game_time_add_hour(int t, int h);
extern int game_time_add_day(int t, int d);
extern int game_time_add_month(int t, int m);
extern int game_time_add_year(int t, int y);

extern int game_time_year(int t);
extern int game_time_month(int t);
extern int game_time_day(int t);
extern int game_time_hour(int t);
#endif

