/*   
	Library program for GCC on DOS-Extender		

	(c) Copyright by h.yama,  1990  ver 1.0

strset sets all characters in the string s to the character ch.
*/ 

#include <string.h>

char * strset( char *s1, const int ch)
{
	register char *s;
	
	for (s = s1; *s ; s++) *s = ch;
	return s;
}		

