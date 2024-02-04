/*
	mblen: multi-byte character length
			by elfin	V0.8  1990-07-29
*/
#include <stdlib.h>

int
mblen(const char *s, size_t n)
{
	unsigned char	*p;
	int	c;

	p = (unsigned char *)s;
	if(!p || (n <= 0)) return 0;
	if((	(*p >= 0x81) && (*p <= 0x9f)) 
	     || ((*p >= 0xe0) && (*p <= 0xfc))) {
		if(n < 2) return -1;		/* invalid 1byte code */
		c = *(p + 1);
		if(((c >= 0x40) && (c <= 0xfc)) && (c != 0x7f)) {
			return  2;		/* valid MS Š¿Žš */
		} else {
			return -1;		/* invalid 2byte code */
		}
	}
	return 1;				/* valid 1byte code */
}

			
			
