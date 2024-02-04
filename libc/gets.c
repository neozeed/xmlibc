#include <stdio.h>

char *
gets(char *buffer)
{
  char *ptr = buffer;
	
  for (; EOF != (*ptr = getchar()); ptr++)
   if (*ptr == '\n') {
     *ptr = '\0';
     return buffer;
   }

  *ptr = '\0';

  if (ptr == buffer) return NULL;

  return buffer;
}
