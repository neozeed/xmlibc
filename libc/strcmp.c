#include <stdlib.h>
#include <strings.h>

int
strcmp (const char *s1, const char *s2)
{
  for ( ; *s1 == *s2; s1++, s2++)
   if (*s1 == '\0' && *s2 == '\0') return 0;

  return *s1 - *s2;
}
