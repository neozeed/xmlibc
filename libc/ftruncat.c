#include <stdlib.h>
#include <stddef.h>
#include <sys/extender.h>

int
ftruncate(int fd, int length)
{
  if (!_file_p(fd)) return -1;

  if (lseek(fd, length, 0) != length) return -1;

  if (_dos_write(fd, "", 0) < 0) return -1;

  return 0;
}