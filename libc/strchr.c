#include <stdlib.h>
#include <strings.h>

char *
strchr(const char *s, int c)
{
  for ( ; *s != (unsigned char) c; s++)
   if (!*s) return NULL;

  return (char *) s;
}
