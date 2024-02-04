#include <stdio.h>
#include <fcntl.h>

void
_cleanup(void)
{
  int fd;

  fflush(NULL);

  for (fd = 0; fd < FOPEN_MAX; fd++)
   if (fd >= 0) close(fd);
}
