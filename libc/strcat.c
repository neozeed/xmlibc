#include <stdlib.h>
#include <strings.h>

char *
strcat(char *s1, const char *s2)
{
  char *s = s1;

  for ( ; *s; s++)
   ;

  strcpy(s, s2);

  return s1;
}
