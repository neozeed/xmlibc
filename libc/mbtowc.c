/*
	mbtowc: multi-byte char to wide char
			by elfin	V0.8  1990-07-29
*/
#include <stdlib.h>

int
mbtowc(wchar_t *pwc, const char *s, size_t n)
{
	unsigned char	*p = (unsigned char *)s;
	int nb = mblen(s, 2);

	if(pwc == NULL) return nb;
	switch(nb) { 
	  case 1:
		*pwc = (wchar_t)*p;
		break;
	  case 2:
		*pwc = (wchar_t)(*p << 8 | *(p + 1));
		break;
	  default:
		break;
	}
	return nb;
}
	
