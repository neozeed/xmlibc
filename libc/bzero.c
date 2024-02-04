#include <strings.h>

void
bzero(void *buffer, int bytes)
{
  unsigned char *p = buffer;

  for ( ; bytes > 0; bytes--)
   *p++ = (unsigned char) 0;
}
