/*   
	Library program for GCC on DOS-Extender		

	(c) Copyright by h.yama,  1990  ver 1.00

*/ 

#include <stdio.h>
#include <string.h>

char * strpbrk( const char *s1, const char * breakchar)
{
	register char *s;
	char t[256];
	
	memset(t,0,256);
	for (s = breakchar; *s; s++) t[*s] = 1;
	for (s = s1; *s; s++) {
		if (t[*s]) return s;
		}
	return NULL;
}		
