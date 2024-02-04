#include <math.h>
#include <sys/ieee.h>

#define sign(X)		(_ieee_get_sign(X))
#define exponent(X)	(_ieee_get_exponent(X))
#define fraction(X)	(_ieee_get_fraction(X))

unsigned long long  _ieee_huge_val = 0x7ff0000000000000LL;

int
finite(double x)
{
  if (iszero(x) || issubnormal(x) || isnormal(x))
   return 1;
  return 0;
}

int
isinf(double x)
{
  if ((exponent(x) == _IEEE_DOUBLE_REAL_MAX_EXPONENT) && (fraction(x) == 0LL))
   return 1;
  return 0;
}

int
isnan(double x)
{
  if ((exponent(x) == _IEEE_DOUBLE_REAL_MAX_EXPONENT) && (fraction(x) != 0LL))
   return 1;
  return 0;
}

int
isnormal(double x)
{
  if ((exponent(x) > 0) && (exponent(x) < _IEEE_DOUBLE_REAL_MAX_EXPONENT))
   return 1;
  return 0;
}

int
issubnormal(double x)
{
  if ((exponent(x) == 0) && (fraction(x) != 0LL))
   return 1;
  return 0;
}

int
iszero(double x)
{
  if ((exponent(x) == 0) && (fraction(x) == 0LL))
   return 1;
  return 0;
}

int
signbit(double x)
{
  return sign(x);
}
