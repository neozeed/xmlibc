#include <stdlib.h>
#include <ctype.h>

long
atol(const char *string)
{
  char *t;
  return (long) strtol (string, &t, 0);
}