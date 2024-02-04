#include <strings.h>
#include <stdlib.h>
#include <stdio.h>

#define MAX_LENGTH	8

static __inline__ int
min(int x, int y)
{
  if (x > y)
   return y;
  return x;
}

char *
mktemp(char *template)
{
  char proc[MAX_LENGTH + 1];
  char *p = rindex(template, 'X');
  char *q = proc + MAX_LENGTH - 1;
  char *e = template + strlen(template) - 1;

  sprintf(proc, "%08d", (int) mktemp % 65536);

  if ((p == NULL) || (p != e)) return template;

  for ( ; (template <= p) && (p[-1] == 'X'); p--, q--)
   ;

  strcpy(p, q);

  return template;
}
