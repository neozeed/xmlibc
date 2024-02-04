#include <stdlib.h>
#include <strings.h>

void *
memchr(const void *s, int c, size_t n)
{
  const unsigned char *ss = s;

  for ( ; n > 0; n--, ss++)
   if (*ss == (unsigned char) c) return (void *) ss;

  return NULL;
}