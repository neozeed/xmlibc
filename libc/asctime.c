/*
	asctime
			by elfin	V0.8  1990-07-30
*/
#include <time.h>

char *
asctime(const struct tm *timeptr)
{
	struct tm	time;
	time_t		tt;

	time = *timeptr;	/* mktime requires copy */
	tt = mktime(&time);
	return ctime(&tt);
}


