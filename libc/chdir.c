#include <stdlib.h>
#include <errno.h>
#include <sys/extender.h>

int
chdir (const char *path)
{
  int  status;
  char  *msdos_path;

  msdos_path = _msdos_filename(path);

  if ((status = _dos_chdir(msdos_path)) < 0)
   errno = _dos_errno;

  free(msdos_path);

  return status;
}
