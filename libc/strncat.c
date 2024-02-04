#include <stdlib.h>
#include <strings.h>

char *
strncat(char *s1, const char *s2, size_t n)
{
  char *s = s1;

  for ( ; *s; s++)
   ;

  strncpy(s, s2, n);

  s[n] = '\0';

  return s1;
}
