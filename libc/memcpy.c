#include <stdlib.h>
#include <strings.h>

void *
memcpy(void *s1, const void *s2, size_t n)
{
  unsigned char       *dest = s1;
  const unsigned char *src  = s2;

  for ( ; n > 0; n--)
   *dest++ = *src++;

  return s1;
}
