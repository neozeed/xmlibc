#include <sys/types.h>
#include <sys/time.h>
#include <stdlib.h>
#include <fcntl.h>
#include <time.h>
#include <sys/extender.h>

#define JST	(-9)

int
utime(const char *filename, time_t timep[2])
{
  struct _file_date_time date;
  time_t time;
  int mjd, y, m, d, fd;

  time = timep[1];

  date.seconds	= (time)		% 60;
  date.minutes	= (time / 60)		% 60;
  date.hours	= (time / 3600 - JST)	% 24;

  mjd = (time / 3600 - JST) / 24 + _mjd(1970, 1, 1);

  for(y = 1970; mjd >= _mjd(y, 1, 1); y++) ;
  y--;
  for(m = 1; mjd >= _mjd(y, m, 1); m++) ;
  m--;
  for(d = 1; mjd > _mjd(y, m, d); d++) ;

  date.day	= d;
  date.month	= m;
  date.year	= y - 1980;

  if ((fd = open(filename, O_RDONLY)) < 0)
   return -1;

  _dos_set_file_date_time(fd, date);
  close(fd);

  return 0;
}

int
utimes(const char *filename, struct timeval tvp[2])
{
  time_t timep[2] = { tvp[0].tv_sec, tvp[1].tv_sec, };

  return utime(filename, timep);
}
