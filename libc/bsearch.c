/*  
	gnu cc library 	ver 1.0
	
	(c) by  h.yama 1990,
*/
#include <stdlib.h>

void *
bsearch(const void *key, const void *base, size_t elements, size_t width,
  	int (*compair)(const void *, const void *))
{
	int a,b,j,k;
	void *now;
	
	a = 0; b = elements-1;

	while (a < b) {
		k = (a + b)/2;
		now = base + width * k;
		j = compair( key, now);
		if (j < 0)
		    a = k+1;	
		else if (j > 0)
		    b = k-1;
		else
		    return now;
	}

	return NULL;
}
