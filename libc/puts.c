#include <stdio.h>

int
puts(const char *s)
{
  int n;

  if ((n = fputs(s, stdout)) < 0)
   return EOF;
  if (putc('\n', stdout) < 0)
   return EOF;
  n++;

  return n;
}
