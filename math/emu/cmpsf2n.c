/* gcc library   cmpsf2.c 
   (c) h.yama	1990,
*/

long int
__cmpsf2(float a, float b)		/* both a and b must be IEEE format */
{								/* & does not care for denormal, NAN */
	int  result = 1;
	signed long ah,bh;

	ah = *(signed long*) &a;
	bh = *(signed long*) &b;
	
	if (ah == b || (ah ^ bh) == 0x80000000) return 0;
	else if (ah > bh) return 1;
	else  return -1;
}
