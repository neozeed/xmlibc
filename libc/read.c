#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/extender.h>
#include "handle.h"

static int
read_text_sub(int fd, char *buf, int nbytes)
{
  int i, j, bytes = _dos_read(fd, buf, nbytes);

  if (bytes < 0) {
    errno = _dos_errno;
    return -1;
  }

  if (_eof(fd) && (bytes > 0) && (buf[bytes - 1] == '\x1a'))
   bytes--;

  if (bytes == 0) return 0;

  for (i = 0, j = 0; i < bytes; i++)
   if (buf[i] != '\r')
    buf[j++] = buf[i];

  return j;
}

int
read(int fd, char *buf, int nbytes)
{
  int bytes = 0, nread;

  if ((_handle_mode[fd] & _TEXT) == _TEXT) {
    while (nread = read_text_sub(fd, &buf[bytes], nbytes - bytes))
     if (nread > 0)
      bytes += nread;
     else {
       errno = _dos_errno;
       return -1;
     }
  } else {
    if((bytes = _dos_read(fd, buf, nbytes)) < 0) {
      errno = _dos_errno;
      return -1;
    }
  }

  return bytes;
}

int
_raw_read(int fd, unsigned char *buf, int nbytes)
{
  int nread;

  if((nread = _dos_read(fd, buf, nbytes)) < 0) {
    errno = _dos_errno;
    return -1;
  }

  if (_eof(fd) && (nread > 0) && (buf[nread - 1] == '\x1a'))
   nread--;

  return nread;
}
