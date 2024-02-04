/*
	mktime
		 	by elfin	V0.8  1990-07-31
*/
#include <time.h>

#define	JST	(-9)

time_t
mktime(struct tm *timeptr)
{
	struct tm *tmtime;
	time_t	time;

	time = _mjd(1900 + timeptr->tm_year, timeptr->tm_mon + 1, 
		timeptr->tm_mday) - _mjd(1970, 1, 1);

	time = (((time * 24) + timeptr->tm_hour + JST) * 60 + timeptr->tm_min)
		* 60 + timeptr->tm_sec;

	*timeptr = *localtime(&time);
	return time;
}
	
