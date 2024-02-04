/*
	fgetpos nad fsetpos		by elfin	V0.8  1990-07-29
*/
#include <errno.h>
#include <stdio.h>

int
fgetpos(FILE *stream, fpos_t *pos)
{
	long int	fpi;

	fpi = ftell(stream);
	if(fpi == -1L) {
		errno = 25;
		return !0;
	} else {
		*pos = (fpos_t)fpi;
		return 0;
	}
}

int
fsetpos(FILE *stream, const fpos_t *pos)
{
	return (fpos_t)fseek(stream, (long)*pos, SEEK_SET);
}

