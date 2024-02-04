#include <stdlib.h>
#include <stdio.h>
#include <sys/extender.h>

int
remove(const char *filename)
{
  int r;
  char *path;

  path = _msdos_filename(filename);
  r    = _dos_unlink(path);
  free(path);

  if (r > 0)
   return 0;

  return r;
}

int
unlink(const char *filename)
{
  return remove(filename);
}
