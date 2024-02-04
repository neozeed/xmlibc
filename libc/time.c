#include <stdlib.h>
#include <time.h>
#include <sys/extender.h>

#define JST	(-9)	/* Japan standard time */

time_t _subsec_time(time_t *);

time_t
time(time_t *tloc)
{
  unsigned long int ctime;

  ctime = _subsec_time(NULL);

  if (tloc) *tloc = ctime;

  return ctime;
}

time_t
_subsec_time(time_t *subsec)
{
  unsigned long int  today, ctime;
  struct _system_date  date;
  struct _system_time  time;

  date = _dos_get_current_date();
  time = _dos_get_current_time();
  today = _mjd(date.year, date.month, date.day) - _mjd(1970, 1, 1);

  ctime = ((today * 24 + time.hours + JST) * 60 + time.minutes)  * 60
          + time.seconds;

  if (subsec) *subsec = time.subsecs;

  return ctime;
}
