#include <fcntl.h>
#include <errno.h>
#include <sys/extender.h>

long
lseek(int fd, long offset, int pos)
{
  long position;

  if (fd < 0) return -1;

  if (!_file_p(fd)) return -1;

  position = _dos_lseek(fd, offset, pos);

  if (position >= 0) return position;

  errno = _dos_errno;

  return -1;
}
