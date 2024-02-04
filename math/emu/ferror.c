/* ferror.c */
#include <stdio.h>

void
_ferror(int code)
{
	switch (code) {
	  case 0 :
		fprintf(stderr," divide by 0 ");
		abort();
		break;

	  case 1 :
		fprintf(stderr," divide out of range");
		abort();
		break;

	  default:
		break;
 	}
}
