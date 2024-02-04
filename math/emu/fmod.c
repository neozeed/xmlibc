/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-4-10		version 0.5

*/

double 
  fmod(double x, double y)
{
	long long i;
	if (y == 0.0L) return x;
	i = x/y;
	if (i >= 0) 
		return  x - i*y;
	else 
		return  x - (i-1)*y;
}
