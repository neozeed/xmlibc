#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/extender.h>
#include "handle.h"

int
write(int fd, const char *buf, int nbytes)
{
  int bytes;

  if (nbytes < 0) return -1;

  if (nbytes == 0) return 0;

  if ((_handle_mode[fd] & _TEXT) == _TEXT) {
    const char *p = buf;
    const char *q = buf + nbytes;
    const char *r = buf;

    for (; p < q; p++)
     if (*p == '\n') {
       if (_dos_write(fd, r, p - r) >= 0) {
	 _dos_write(fd, "\r\n", 2);
	 r = p + 1;
       } else {
	 errno = _dos_errno;
	 return -1;
       }
     }

    if ((r < p) && (_dos_write(fd, r, p - r) < 0)) {
      errno = _dos_errno;
      return -1;
    }

    bytes = p - buf;
  } else {
    if ((bytes = _dos_write(fd, buf, nbytes)) < 0) {
      errno = _dos_errno;
      return -1;
    }
  }

  return bytes;
}