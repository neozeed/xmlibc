/*
	wcstombs: wide char string to multi-byte string
				by elfin	V0.8  1990-07-29
*/
#include <stdlib.h>

size_t
wcstombs(char *s, const wchar_t *pwcs, size_t n)
{
	unsigned char	*p, ss[MB_CUR_MAX];
	int	nb, nnb;

	for(nb = 0; nb < n; ) {
		nnb = wctomb((char *)ss, *pwcs++);
		if(nnb < 0) {
			return -1;
		}
		if(!*ss) {
			*s = 0;
			return nb + 1;
		}
		if(nb + nnb <= n) {
			for(p = ss; nnb-- ; nb++)  {
				*s++ = *p++;
			}
		} else break;
		if(!*(pwcs - 1)) break;
	}
	return nb;
}
