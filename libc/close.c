#include <fcntl.h>
#include <errno.h>
#include <sys/extender.h>

int
close(int fd)
{
  int  result;

  if ((result = _dos_close(fd)) < 0) {
    errno = _dos_errno;
    return -1;
  }

  return 0;
}
