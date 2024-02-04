#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/extender.h>
#include "handle.h"

int
open(const char *p, int mode, ...)
{
  int fd;
  int perm;

  va_list args;
  va_start(args, mode);

  perm = va_arg(args, int);

  va_end(args);

  if ((O_CREAT & mode) == O_CREAT) {
    if ((mode & 0x03) == O_RDONLY)
     return -1;

    fd = creat(p, perm);
    if (fd < 0)
     return -1;
  } else {
    char *msdos_filename = _msdos_filename(p);
    fd   = _dos_open(msdos_filename, (mode & 0x03));
    free(msdos_filename);

    if (fd < 0) {
      errno = _dos_errno;
      return -1;
    }

    if (_dos_get_device_infomation(fd) < 0) {
      errno = _dos_errno;
      fd = -1;
    }
  }

  if (fd < 0) return -1;

  if ((mode & O_TRUNC) == O_TRUNC)
   ftruncate(fd, 0);	/* Truncate */
	
  if ((mode & O_APPEND) == O_APPEND)
   lseek(fd, 0L, 2);
	
  if ((mode & O_TEXT) == O_TEXT)
   _handle_mode[fd] = _TEXT;
  else if ((mode & O_BINARY) == O_BINARY)
   _handle_mode[fd] = 0;
  else if (_fmode & O_TEXT)
   _handle_mode[fd] = _TEXT;
  else if (_fmode & O_BINARY)
   _handle_mode[fd] = 0;
  else
   _handle_mode[fd] = 0;
	
  return fd;
}
