#include <strings.h>

int
bcmp(const void *v1, const void *v2, int length)
{
  const unsigned char  *b1 = v1;
  const unsigned char  *b2 = v2;

  for ( ; length > 0; length--, b1++, b2++)
   if (*b1 != *b2) return *b1 - *b2;

  return 0;
}
