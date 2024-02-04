#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/extender.h>
#include "handle.h"

int
creat(const char *p, int mode)
{
  int fd;
  int md = ((mode & 0200) == 0)? 1: 0;
  char *msdos_filename = _msdos_filename(p);

  fd = _dos_creat(msdos_filename, md);

  if (fd < 0) {
    errno = _dos_errno;
    fd = -1;
  }

  free(msdos_filename);

  return fd;
}
