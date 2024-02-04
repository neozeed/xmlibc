#include <stdlib.h>
#include <strings.h>

int
strlen(const char *string)
{
  const char *p = string;

  for ( ; *p; p++)
   ;

  return p - string;
}
