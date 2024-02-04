/* cmpsf2.c */
#include "ieee.h"

long int
__cmpsf2(union ieee_float a, union ieee_float b)
{
	int  flag   = a.f.s + b.f.s;
	int  result = 1;

	if (flag == 1) {
		if ((a.f.e == 0) && (b.f.e == 0) &&
		    (a.f.m == 0) && (b.f.m == 0))
			return 0;
		if (a.f.s == 0)
			return 1;
		return -1;
	} else {
		if (flag == 2)
			result = -1;

		if (a.f.e > b.f.e)
			return result;
		else if (a.f.e < b.f.e)
			return -result;
		else if (a.f.m > b.f.m)
			return result;
		else if (a.f.m < b.f.m)
			return -result;
		else
			return 0;
	}
}
