#include <stdlib.h>
#include <time.h>

struct tm *
localtime(const time_t *timer)
{
  static struct tm time;
  const int JST = -9;
  time_t mjd;

  time.tm_sec  = (*timer)              % 60;
  time.tm_min  = (*timer / 60)         % 60;
  time.tm_hour = (*timer / 3600 - JST) % 24;

  mjd = (*timer / 3600 - JST) / 24 + _mjd(1970, 1, 1);

  time.tm_wday = _dayofweek(mjd);

  for(time.tm_year = 1970; mjd >= _mjd(time.tm_year, 1, 1); time.tm_year++)
   ;
  time.tm_year--;

  for(time.tm_mon = 1; mjd >= _mjd(time.tm_year, time.tm_mon, 1); time.tm_mon++)
   ;
  time.tm_mon--;

  for(time.tm_mday = 1; mjd > _mjd(time.tm_year, time.tm_mon, time.tm_mday); time.tm_mday++)
   ;

  time.tm_yday  = mjd - _mjd(time.tm_year, 1, 1);

  time.tm_year = time.tm_year - 1900;
  time.tm_mon  = time.tm_mon  - 1;
  time.tm_mday = time.tm_mday;

  time.tm_isdst = 0;

  return &time;
}

