/*
	wctomb: wide char to multi-byte char
			by elfin	V0.8  1990-07-29
*/
#include <stdlib.h>

int
wctomb(char *s, wchar_t wchar)
{
	int	nb = 0, c;
	int	n = MB_CUR_MAX;
	unsigned char	*p, ss[MB_CUR_MAX];

	if(!s) return 0;

	p = ss;
	while(n--) {
		c = (wchar >> (n << 3)) & 0xff;
		if(nb || c) {
			*p++ = c;
			nb++;
		}
	}
	if(nb != mblen((char *)ss, nb)) {
		return -1;		/* invalid wide char */
	} else {
		for(n = nb, p = ss; n--; *s++ = *p++) ;
		return nb;
	}
}

