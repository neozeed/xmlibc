/*
	strerror
			by elfin	V0.8  1990-07-31
*/
#include <errno.h>
#include <string.h>

extern	char *sys_errlist[];

char *
strerror(int errnum)
{
	return sys_errlist[errnum];
}


