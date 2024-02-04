/*   Library program for GCC on DOS-Extender		

	(c) Copyright by H.yama,  1990  ver 1.00
	test status

*/ 

#include <stdlib.h>
#include <strings.h>

char *
strstr(const char *within, const char *search)
{

	int  m;
	char *s = within;
	
	m = 0;
	do {
		if (*s == search[m]) {
			m++;
			s++; 
			if (! search[m] ) return s - m;
			}
		else {
			s -= (m-1);
			m = 0;
			}
		} while ((*s) && (search[m]));
	
	return NULL;
}
