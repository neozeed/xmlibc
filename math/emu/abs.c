/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-4-10		version 0.5

*/

int 
   abs(int x)
{
	if (x <0) x = -x;
	return x;
}
