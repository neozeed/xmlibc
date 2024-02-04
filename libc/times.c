#include <sys/types.h>
#include <sys/times.h>
#include <sys/time.h>
#include <stdlib.h>

extern unsigned long _start_time;
extern unsigned long _start_subsec_time;

long
times(struct tms *buffer)
{
  buffer->tms_utime	= time((long *) 0) - _start_time;
  buffer->tms_stime	= 0;
  buffer->tms_cutime	= 0;
  buffer->tms_cstime	= 0;

  return 0;
}

clock_t
clock()
{
  clock_t seconds;
  time_t subsecs;

  seconds = _subsec_time(&subsecs) - _start_time;
  seconds = seconds * 100 + subsecs - _start_subsec_time;

  return seconds;
}
