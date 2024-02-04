#include <stdio.h>
#include <sys/file.h>

long int
ftell(FILE *fp)
{
  fflush(fp);
  return tell(fileno(fp));
}
