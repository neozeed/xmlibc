#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

size_t
fwrite(const void *ptr, size_t size, size_t n, FILE *stream)
{
  int nwrite;

  fflush(stream);

  if (size == 0 || n == 0)
   return 0;

  nwrite = write(fileno(stream), ptr, size * n);

  if (nwrite <= 0)
   return -1;

  if (nwrite != (size * n))
   return nwrite / size;

  return n;
}
