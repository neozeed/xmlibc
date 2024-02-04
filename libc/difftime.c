/*
	difftime
			by elfin	V0.8  1990-07-30
*/
#include <time.h>

double
difftime(time_t time1, time_t time0)
{
	return (double)(time1 - time0);
}


