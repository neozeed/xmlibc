/*   Library program for GCC on DOS-Extender		

	(c) Copyright by Keisuke Yoshida, 1989, 1990  ver 1.00

*/ 

#include <ctype.h>
#include <string.h>

char *
  strlwr(char *d)
{
	unsigned char *s;
    for (s=d; *s; s++) {
    	if (isupper(*s))  *s = _tolower(*s);
    	s++;
    	}
   return d;
  }
