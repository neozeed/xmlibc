#include <stdio.h>
#include <sys/file.h>

long int
tell(int fd)
{
  return lseek(fd, 0L, L_INCR);
}
