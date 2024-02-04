/*
	frexp: mantissa and exponent decomposition
					1990-08-25 elfin
					1990-09-02 modefied by kay
*/
#include <math.h>
#include <sys/ieee.h>

double
frexp(double value, int *exponent)
{
  union { double df; struct _ieee_double_real di; } d;

  if(value == 0) {
    *exponent = 0;
    return value;
  }

  d.df = value;

  *exponent = d.di.exponent - 0x3fe;
  d.di.exponent = 0x3fe;

  return d.df;
}

