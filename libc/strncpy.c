#include <stdlib.h>
#include <strings.h>

char *
strncpy(char *s1, const char *s2, size_t n)
{
  char *s = s1;

  if (n <= 0) return s1;

  for ( ; (n > 0) && *s2; n--)
   *s++ = *s2++;

  for ( ; n > 0; n--)
   *s++ = '\0';

  return s1;
}
