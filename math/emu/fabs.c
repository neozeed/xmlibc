/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-4-10		version 0.5

*/

double 
   fabs(double x)
{
	union {
		double d;
		struct { long lo,hi; } i;
		} t;
	t.d = x;
	t.i.hi &= 0x7fffffff;
	
	return t.d;
}
