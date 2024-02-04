#ifndef _MATH_H
#define _MATH_H

#define HUGE_VAL \
	({						\
	  extern unsigned long long _ieee_huge_val;	\
	  * (double *) &_ieee_huge_val;			\
	})

#undef EDOM
#define EDOM	128

#undef ERANGE
#define ERANGE	129

double sqrt(double);
double fmod(double, double);
double pow(double, double);
double modf(double, double *);

double exp(double);
double ldexp(double, int);

double log(double);
double log10(double);
double frexp(double, int *);

double fabs(double);

double ceil(double);
double floor(double);

double sin(double);
double cos(double);
double tan(double);

double asin(double);
double acos(double);
double atan(double);
double atan2(double, double);

double sinh(double);
double cosh(double);
double tanh(double);

#endif /* _MATH_H */
