/* cmpdf2.c */
#include "ieee.h"

long int
__cmpdf2(union ieee_double a, union ieee_double b)
{
	int  flag   = a.i.s + b.i.s;
	int  result = 1;

	if (flag == 1) {
		if ((a.i.e == 0) && (b.i.e  == 0) &&
		    (a.i.mh == 0) && (b.i.mh == 0) &&
		    (a.i.ml == 0) && (b.i.ml == 0))
			return 0;
		if (a.i.s == 0)
			return 1;
		return -1;
	} else {
		if (flag == 2)
			result = -1;

		if (a.i.e > b.i.e)
			return result;
		else if (a.i.e < b.i.e)
			return -result;
		else if (a.i.mh > b.i.mh)
			return result;
		else if (a.i.mh < b.i.mh)
			return -result;
		else if (a.i.ml > b.i.ml)
			return result;
		else if (a.i.ml < b.i.ml)
			return -result;
		else
			return 0;
	}
}
