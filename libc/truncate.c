#include <stdlib.h>
#include <stddef.h>
#include <fcntl.h>
#include <sys/extender.h>

int
truncate(const char *path, int length)
{
  int fd;

  fd = open (path, O_RDWR);

  if (fd < 0) return -1;

  return ftruncate(fd, length);
}
