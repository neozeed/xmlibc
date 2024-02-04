#ifndef _TIME_H
#define _TIME_H

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned long size_t;
#endif /* _SIZE_T */

typedef long	clock_t;

#ifndef _TIME_T
#define _TIME_T
typedef long	time_t;
#endif /* _TIME_T */

typedef struct tm {
	int	tm_sec;
	int	tm_min;
	int	tm_hour;
	int	tm_mday;
	int	tm_mon;
	int	tm_year;
	int	tm_wday;
	int	tm_yday;
	int	tm_isdst;
} tm;

#undef NULL
#define NULL ((void *) 0)

#define CLOCKS_PER_SEC		100
#define CLK_TCK			100

time_t  time(time_t *);
double  difftime(time_t, time_t);
time_t  mktime(struct tm *);
clock_t  clock(void);

struct tm  *localtime(const time_t *);
struct tm  *gmtime(const time_t *);
char  *asctime(const struct tm *);
char  *ctime(const time_t *);
size_t  strftime(char *, size_t, const char *, const struct tm *);

#endif
