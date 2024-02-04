#include <stdlib.h>
#include <strings.h>

char *
rindex(const char *string, int c)
{
  const char *r = NULL;
  const char *s = string;

  while(s = index(string, c)) {
    string = s + 1;
    r = s;
  }

  return (char *) r;
}
