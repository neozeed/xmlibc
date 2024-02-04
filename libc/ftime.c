#include <stdlib.h>
#include <fcntl.h>
#include <sys/extender.h>

#define	JST	(-9)

unsigned long int
_get_file_time(char *path)
{
  int fd;
  unsigned long int time;

  if ((fd = open(path, 0)) > 0) {
    time = _fget_file_time(fd);
    close(fd);
  } else
   return -1;

  return time;
}

unsigned long int
_fget_file_time(int handle)
{
  struct _file_date_time date;
  unsigned long int today;
  int year, month, day, hour, minute, second;

  date = _dos_get_file_date_time(handle);

  year	= date.year + 1980;
  month	= date.month;
  day	= date.day;
  hour	= date.hours;
  minute= date.minutes;
  second= date.seconds;

  second *= 2;

  today = _mjd(year, month, day) - _mjd(1970, 1, 1);

  return ((today * 24 + hour + JST) * 60 + minute)  * 60 + second;
}