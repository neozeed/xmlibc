#include <strings.h>

void
bcopy(const void *source, void *destination, int bytes)
{
  const unsigned char  *src  = source;
  unsigned char  *dest = destination;

  for ( ; bytes > 0; bytes--)
   *dest++ = *src++;
}
