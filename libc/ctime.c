#include <stdio.h>
#include <stdlib.h>

char *
ctime(const long  *clock)
{
  const static char *dayname[] = {
    "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
  };
  const static char *monthname[] = {
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  };

  int mjd, year, month, day, hour, minute, second;
  static char tstring[26];
  const int JST = -9;

  second = (*clock)              % 60;
  minute = (*clock / 60)         % 60;
  hour   = (*clock / 3600 - JST) % 24;

  mjd = (*clock / 3600 - JST) / 24 + _mjd(1970, 1, 1);

  for(year = 1970; mjd >= _mjd(year, 1, 1); year++)
   ;
  year--;

  for(month = 1; mjd >= _mjd(year, month, 1); month++)
   ;
  month--;

  for(day = 1; mjd > _mjd(year, month, day); day++)
   ;

  sprintf(tstring, "%s %s %02d %02d:%02d:%02d %4d\n",
	  dayname[_dayofweek(mjd)], monthname[month-1],
	  day, hour, minute, second, year);

  return tstring;
}
