#include <sys/stat.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/extender.h>

int
chmod(const char *p, int mode)
{
  int  attr;
  int  state;
  char *path;

  switch ((mode >> 7) & 0x3) {
   case 00:
   case 02:
    attr = 1;
    break;

   case 01:
   case 03:
   default:
    attr = 0;
    break;
  }

  path = _msdos_filename(p);
  state = _dos_set_file_attributes(path, attr);
  free(path);

  if (state < 0) {
    errno = _dos_errno;
    return -1;
  }

  return 0;
}

int
_get_file_mode (const char *p)
{
  int attr;
  int mode;
  char *path;

  path = _msdos_filename(p);
  attr = _dos_get_file_attributes(path);
  free(path);

  if (attr < 0) {
    errno = _dos_errno;
    return -1;
  }

  if (0x1 & attr)
   mode = 0444;
  else
   mode = 0666;

  if (attr & 0x10) {
    mode |= S_IFDIR;
  }

  return mode;
}
