/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-4-10		version 0.5

*/

double 
  floor(double x)
{
	double frac,body;
	frac = modf(x, &body);
	if (frac == 0.0L) return x;
	else 
		if (x >= 0.0L) return body;
		else 	return body - 1.0L;
}
