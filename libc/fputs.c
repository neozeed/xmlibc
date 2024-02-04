#include <stdio.h>

int
fputs(const char *s, FILE *stream)
{
  while (*s)
   if (putc(*s++, stream) == EOF) return EOF;

  return 0;
}
