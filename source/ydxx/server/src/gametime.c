#include "hf.h"




int game_time_add_hour(int t, int hour)
{
	t += hour;
	return t;
}

int game_time_add_day(int t, int day)
{
	t += day * DAY_PER_HOUR;
	return t;
}

int game_time_add_month(int t, int month)
{
	t += month * MONTH_PER_DAY * DAY_PER_HOUR;
	return t;
}

int game_time_add_year(int t, int year)
{
	t += year * YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR;
	return t;
}


bool game_time_is_year_end(int t)
{
	int month = game_time_month(t);
	int day = game_time_day(t);
	int hour = game_time_hour(t);

	if (month == YEAR_PER_MONTH && day == MONTH_PER_DAY &&\
				   	hour == DAY_PER_HOUR)
		return true;
	return false;
}

bool game_time_is_season_end(int t)
{
	int month = game_time_month(t);
	int day = game_time_day(t);
	int hour = game_time_hour(t);

	if (day == MONTH_PER_DAY && hour == DAY_PER_HOUR && ((month % 3) == 0) )
		return true;
	return false;
}

bool game_time_is_month_end(int t)
{
	int day = game_time_day(t);
	int hour = game_time_hour(t);

	if (day == MONTH_PER_DAY && hour == DAY_PER_HOUR)
		return true;
	return false;
}

bool game_time_is_weak_end(int t)
{
	int day = game_time_day(t);
	int hour = game_time_hour(t);

	if (day % 7 == 0 && hour == DAY_PER_HOUR)
		return true;
	return false;
}

bool game_time_is_day_end(int t)
{
	int hour = game_time_hour(t);

	if (hour == DAY_PER_HOUR)
		return true;
	return false;
}



int game_time_year(int t)
{
	int  year = t / (YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR);
	year += 1;
	return year;
}

int game_time_month(int t)
{
	int year = game_time_year(t) - 1;
	int  month = (t - year * (YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR));

	month /= (MONTH_PER_DAY * DAY_PER_HOUR); 
	month += 1;
	return month;
}

int game_time_day(int t)
{
	int year = game_time_year(t) - 1;
	int month = game_time_month(t) - 1;
	int day = t - year * (YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR) - \
		month * (MONTH_PER_DAY * DAY_PER_HOUR);
	day /= DAY_PER_HOUR;
	day += 1;
	return day;
}

int game_time_hour(int t)
{
	int year = game_time_year(t) - 1;
	int month = game_time_month(t) - 1;
	int day = game_time_day(t) - 1;
	int hour = t - year * (YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR) - \
		month * (MONTH_PER_DAY * DAY_PER_HOUR) - day * DAY_PER_HOUR;
	hour += 1;
	return hour;
}



const char *readable_game_time(int t)
{
	int y = 0;
	int m = 0;
	int d = 0;
	int h = 0;
	static dstring dst = DSTRING_INITIAL; 


	y = t / (YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR);
	m = (t - y * YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR) / (MONTH_PER_DAY * DAY_PER_HOUR);
	d = (t -  y * YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR - m * MONTH_PER_DAY * DAY_PER_HOUR) / DAY_PER_HOUR;
	h = t -  y * YEAR_PER_MONTH * MONTH_PER_DAY * DAY_PER_HOUR - m * MONTH_PER_DAY * DAY_PER_HOUR - d * DAY_PER_HOUR;

	dstring_clear(&dst);

	if (y > 0) 
		dstring_append_printf(&dst, "%d年", y);
	if (m > 0) 
		dstring_append_printf(&dst, "%d月", m);
	if (d > 0) 
		dstring_append_printf(&dst, "%d日", d);
	if (h > 0) 
		dstring_append_printf(&dst, "%d时", h);

	return dst.buf;
}
