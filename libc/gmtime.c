/*
	gmtime
			by elfin	V0.8  1990-07-30
*/
#include <time.h>

#define	JST	(-9)

struct tm *
gmtime(const time_t *timer)
{
	time_t	tt;

	tt = *timer + JST * 3600;
	return localtime(&tt);
}

