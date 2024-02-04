#include <stdlib.h>

int
_mjd(int year, int month, int day)
{
  unsigned long int today;

  if ((month == 1) || (month == 2)) {
    month += 12;
    year  -= 1;
  }

  today	= (unsigned) ((36525 * year) / 100)
	+ (unsigned) (year / 400)
	- (unsigned) (year / 100)
	+ (unsigned) ((3059 * (month - 2)) / 100)
	+ day
	- 678912;

  return today;
}

int
_dayofweek(int mjd)
{
  return (mjd - 4) % 7;
}