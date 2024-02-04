/*   Library program for GCC on DOS-Extender		

	(c) Copyright by H.yama,  1990  ver 1.00
	test status

*/ 
/*Note: strtok modify original string */

#include <stdlib.h>
#include <string.h>

char 
*strtok(char *target, const char *delim)
{

	static char *last = NULL;
	char is_delimiter[256];
	char *s,*top;
	

	if (delim == NULL) 
		return NULL;
	else {
		memset(is_delimiter,0,256);
		for (s=delim; *s; s++) {
			is_delimiter[*s] = 1;
			}
		}	
	
	if (target == NULL) 
		top = last;
	else 
		top = target;	
	
	if (*top || top == NULL) return NULL;
	
	while (is_delimiter[*top]) top++;
	if (*top) {
		for (s = top+1; *s && ! is_delimiter[*s] ; s++);
		last = (*s) ? s+1 : NULL;
		*s = 0;
		}
	return top;
}
