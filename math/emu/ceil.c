/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-4-25		version 0.7

*/

#include <math.h>

double 
  ceil(double x)
{
	double frac,body;
	frac = modf(x, &body);
	if (frac == 0.0L) return x;
	else if (x > 0.0L) return body + 1.0L;
		else  		return body;
}
