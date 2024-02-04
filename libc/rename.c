#include <stdlib.h>
#include <stdio.h>
#include <sys/extender.h>

int
rename(const char *f, const char *t)
{
  int r;
  char *from, *to;

  from = _msdos_filename(f);
  to   = _msdos_filename(t);

  remove (to);

  r = _dos_rename(from, to);

  free(from);
  free(to);

  return r;
}
