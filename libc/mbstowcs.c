/*
	mbstowcs: multi-byte char string to wide char string
			by elfin	V0.8  1990-07-29
*/
#include <stdlib.h>

size_t
mbstowcs(wchar_t *pwcs, const char *s, size_t n)
{
	int	nc, nb;

	for(nc = 0; nc < n; nc++) {
		nb = mbtowc(pwcs, s, MB_CUR_MAX);
		if(nb < 0) {
			return -1;
		} else if (!nb) {
			*pwcs = 0;
			return nc;
		}
		if(!*s) break;
		pwcs++;
		s += nb;
	}
	return nc;
}

		
