#include <stdlib.h>
#include <strings.h>

void *
memset(void *s, int c, size_t n)
{
  unsigned char *p = s;

  for ( ; n > 0; n--)
   *p++ = (unsigned char) c;

  return s;
}
