/*   Library program for GCC on DOS-Extender		

	(c) Copyright by Keisuke Yoshida, 1989, 1990  ver 0.92

*/ 

#include <stdlib.h>
#include <ctype.h>
#define MAX_UNSIGNED  0xffffffff

long long strtoll (const char *, char **, int);

unsigned long
strtoul (const char *string, char **endptr, int base)
{
    	union {
    		long long ll;
	    	struct { long l,h; } l; 
    	} w;
	
	w.ll = strtoll(string, endptr, base);
	if (w.ll >= 0) {
		if (w.l.h)  return MAX_UNSIGNED;
		else return w.l.l;
	} else
	 return 0L;
}
