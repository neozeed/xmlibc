#include <stdlib.h>
#include <ctype.h>

int
atoi (const char *string)
{
  long  i = 0;
  int   s = 1;

/* skip white space */
  while(isspace(*string))
   string++;

/* sign flag check */
  if ((*string == '+') || (*string == '-')) {
    s = (*string == '-')? -1: 1;
    string++;
  }

/* digit string to number */
  while(isdigit(*string))
   i = i * 10 + s * (*string++ - '0');

  return i;
}
