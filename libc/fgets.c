#include <stdio.h>

char *
fgets(char *s, int n, FILE *stream)
{
  char *p = s;
  int c;
	
  if (n > 0) {
    while (n-- > 0) {
      c = getc(stream);

      if (c == EOF) {
	if (p == s) return NULL;
	break;
      }

      *p++ = c;

      if (c == '\n') break;
    }

    *p = '\0';

    return s;
  }

  return NULL;
}
