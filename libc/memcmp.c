#include <stdlib.h>
#include <strings.h>

int
memcmp(const void *s1, const void *s2, size_t n)
{
  const unsigned char *p1 = s1;
  const unsigned char *p2 = s2;

  for ( ; n > 0; p1++, p2++, n--)
   if (*p1 != *p2) return *p1 - *p2;

  return 0;
}
