#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

extern char *sys_errlist[];

void
perror (const char *p)
{
  if (!p || (*p == '\0'))
   fprintf(stderr, "%s", sys_errlist[errno]);
  else
   fprintf(stderr, "%s: %s", p, sys_errlist[errno]);

  return;
}
