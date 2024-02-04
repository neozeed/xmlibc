/*
	strspn
			by elfin	V0.8  1990-07-30
*/
#include <string.h>

size_t
strspn(const char *s1, const char *s2)
{
	const char	*p = s1;
	const char	*q;

	while(*p) {
		for(q = s2; *q; q++) {
			if(*p == *q) break;
		}
		if(!*q) return (size_t)(p - s1);
		p++;
	}
	return (size_t)(p - s1);
}
	
