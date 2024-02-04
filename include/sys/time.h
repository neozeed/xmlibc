#ifndef _SYS_TIME_H
#define _SYS_TIME_H

#include <time.h>

struct timeval {
  long	tv_sec;		/* second */
  long	tv_usec;	/* micro second */
};

int  utimes(const char *, struct timeval[2]);
int  utime(const char *, time_t[2]);

#endif