/* gcc library
	(c) h.yama	1990,

	cmpdf2.c 
	both imput must be IEEE format. and does not care for denormal, NAN
*/

long int
__cmpdf2(double a, double b)
{
	unsigned long al,bl;
	signed long   ah,bh;
	int result;

	al = *(unsigned long*) & a;  
	bl=  *(unsigned long*) & b;
	ah = *((signed long*) &a +1); 
	bh = *((signed long*) &b +1);
	
	result = 1;
	
	if (al == bl && (ah == bh || (ah^bh) == 0x80000000))  return 0;
	else if (ah > bh)  {
		if (ah < 0) result = -result;
		}
	else if (ah < bh)	{
		if (bh < 0) ;
		else 	result = - result;
		}
	else {
		result = (ah >= 0) ?  1 : -1;
		if (al > bl)	;
		else result =  -result;
		}
	return result;
}
