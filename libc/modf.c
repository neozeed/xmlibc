#include <stdlib.h>
#include <math.h>
#include <sys/ieee.h>

double
modf(double x, double *ipartptr)
{
  int sign;
  int exponent, fexponent, iexponent;
  unsigned long long int fraction, ffraction, ifraction;
  double ipart = 0, fpart = 0;

  if (iszero(x) || isinf(x) || isnan(x)) {
    *ipartptr = x;
    return x;
  }

  if (issubnormal(x)) {
    *ipartptr = x;
    return x;
  }

/*  */
  sign     = _ieee_get_sign(x);
  exponent = _ieee_get_exponent(x);
  fraction = _ieee_get_fraction(x);

  if (exponent < _IEEE_DOUBLE_REAL_BIAS) {
    ifraction = 0;
    iexponent = 0;

    ffraction = fraction;
    fexponent = exponent;
  } else if (exponent >= (_IEEE_DOUBLE_REAL_BIAS + 52)) {
    ifraction = fraction;
    iexponent = exponent;

    ffraction = 0;
    fexponent = 0;
  } else {
    int exp = exponent - _IEEE_DOUBLE_REAL_BIAS;
    unsigned long long mask = (1LL << (52 - exp)) - 1;

    ifraction = fraction & ~mask;
    iexponent = exponent;

    ffraction = fraction & mask;
    fexponent = exponent;

    if (ffraction == 0) {
      fexponent = 0;
    } else {
      while (ffraction < (1LL << 52)) {
	ffraction <<= 1;
	fexponent--;
      }
    }
  }

/* compose double */
  ipart = _ieee_compose_double_real(sign, iexponent, ifraction);
  fpart = _ieee_compose_double_real(sign, fexponent, ffraction);

  if (ipartptr != NULL) *ipartptr = ipart;

  return fpart;
}