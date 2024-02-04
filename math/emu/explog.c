/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-4-10		version 0.5

	double	log(double x)		return natulal logarithm
	double	exp2(double x)		return	2**x
	double	exp(double x)		return E**x,  where E=2.71828...
	
*/

#include <math.h>
#define  MAX_REAL   (1.180e308)

#ifdef test_all
#define   make_log		1
#define   make_log2		1
#define   make_log10	1
#define   make_exp		1
#define   make_const	1
#define   make_table    1
#endif

#if make_const
double LOG_2_OF_E =	 (6.93147180559945286e-1);
double LOG_E_OF_2 =	 (1.44269504088896339);
double LOG_10_OF_E = (2.30258509299404590);
double LOG_E_OF_10 = (4.34294481903251817e-1);
#else
extern double LOG_2_OF_E ;
extern double LOG_E_OF_2 ;
extern double LOG_10_OF_E;
extern double LOG_E_OF_10;
#endif

#define  table_size	52

#if make_table
 double __logtbl[table_size] = {
 4.05465108108164385e-001,
 2.23143551314209765e-001, 
 1.17783035656383456e-001, 
 6.06246218164348399e-002, 
 3.07716586667536873e-002, 
 1.55041865359652545e-002, 
 7.78214044205494896e-003, 
 3.89864041565732289e-003, 
 1.95122013126174934e-003, 
 9.76085973055458925e-004, 
 4.88162079501351187e-004, 
 2.44110827527362707e-004, 
 1.22062862525677371e-004, 
 6.10332936806385270e-005, 
 3.05171124731863797e-005, 
 1.52586726483623980e-005, 
 7.62936542756757244e-006, 
 3.81468998968588967e-006, 
 1.90734681382540949e-006, 
 9.53673861659188269e-007, 
 4.76837044516323436e-007, 
 2.38418550679857596e-007, 
 1.19209282445354462e-007, 
 5.96046429990338584e-008, 
 2.98023219436061126e-008, 
 1.49011610828253554e-008, 
 7.45058056916825251e-009, 
 3.72529029152302016e-009, 
 1.86264514749623356e-009, 
 9.31322574181797647e-010, 
 4.65661287199319041e-010, 
 2.32830643626764575e-010, 
 1.16415321820158551e-010, 
 5.82076609117733413e-011, 
 2.91038304563101871e-011, 
 1.45519152282609727e-011, 
 7.27595761415695612e-012, 
 3.63797880708509551e-012, 
 1.81898940354420211e-012, 
 9.09494701772514648e-013, 
 4.54747350886360721e-013, 
 2.27373675443206210e-013, 
 1.13686837721609567e-013, 
 5.68434188608063993e-014, 
 2.84217094304036035e-014, 
 1.42108547152019027e-014, 
 7.10542735760097662e-015, 
 3.55271367880049462e-015, 
 1.77635683940024889e-015, 
 8.88178419700124838e-016, 
 4.44089209850062518e-016, 
 2.22044604925031283e-016 
}; 
#else
extern  double	__logtbl[table_size];
#endif

#if make_log
double
 log(double x)
{
	int  i,j;
	double  s,m;
	
	if (x <= 0) return - MAX_REAL;
	
	m = frexp(x,&j);
	s = 0.0;
	
	for (i=0; i<sizeof(__logtbl)/sizeof(__logtbl[0]); i++) {
		if ( m + ldexp(m,-1-i) < 1.0) {
			m = m + ldexp(m,-1-i);
			s = s - __logtbl[i];
			}
		}
	
	return (j)*LOG_2_OF_E  + s;
}
#endif

#if  make_log2
double
  log2(double x)
{
	return (log(x) * LOG_E_OF_2);
}
#endif

#if  make_log10
double
  log10(double x)
{
	return (log(x) * LOG_E_OF_10);
}
#endif


#if  make_exp
double
 exp2(double x)
{
	double s,m,d;
	int	i;
	m = modf(x, &d) * LOG_2_OF_E;
	m = ldexp(m, -1);
	s = 1.0;
	for (i = 0; i<sizeof(__logtbl)/sizeof(__logtbl[0]); i++) {
		if (m > __logtbl[i]) {
			m = m - __logtbl[i];
			s = s + ldexp(s,-1-i);
			}
		}
	return ldexp(s*s,d);
}

double 
  exp(double x)
 { 
 return  exp2( x * LOG_E_OF_2);
 }
#endif 
 
#if test_all
main(int argc,char **argv)
{
	printf("%d ", sizeof(__logtbl)/sizeof(__logtbl[0]));
}
#endif
