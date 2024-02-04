/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-4-10		version 0.5

	double	sin(double x)		
	double	cos(double x)		

*/	

#include  <math.h>
#ifdef test_all
#define make_sin  1
#define make_cos  1
#define make_tan  1
#endif

#if	make_sin
double
  sin( double x)
{
	double m,s;
	int  i,flg;
	char c;
	
	if (x < 0) {
		c = -1; 
		x = -x;
		}
	else c = 1;
	
    if (x < ldexp(1,-7)) {		/* easy case */
        return c * x *( 1 - x*x/6 *( 1- x*x/20));
		}
	
	m = modf(x / M_PI_2, &s) * M_PI_2;
	flg = ((int)s) % 4;
	if (flg >= 2) {
		flg -= 2;
		c = -c;
		}
	if (flg == 1) {
/* here m' == m - PI_2, so PI-m == PI_2 - m' */

		m = M_PI_2 - m;
		}
	if (m > ldexp(M_PI_2, -3)) {
		m = ldexp(m,-2);
		s = sin(m);	
		s = c * s * sqrt(1- s*s) * ((1 - s*s) - s*s);
		return ldexp(s,2);
		}
	else 		/* about 15 digit accuracy	for m < 0.2*/
		return c * m * (1 - m*m/6*( 1 - m*m/20*( 1 - m*m/42*( 1 - m*m/72))));
}		
#endif
#if make_cos
 double
 	cos(double x)
 {
 	return sin(M_PI_2 - x);
 }
#endif

#ifdef test_all

main(int argc, char **argv)
{
	double b,a;
	int c;
	for (c=0; c<38; c++) {
		b = (c*M_PI)/18;
		a = sin(b);
		printf("%3.20e %3.20e \n",a, cos(b)*cos(b)+a*a);
		}
}	
#endif

