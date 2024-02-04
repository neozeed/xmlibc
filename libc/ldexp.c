#include <math.h>
#include <errno.h>
#include <sys/ieee.h>

double
ldexp(double x, int n)
{
  int exponent;
  int sign;

  exponent = _ieee_get_exponent(x);
  sign = _ieee_get_sign(x);

  if (isnan(x) || isinf(x)) return x;
  
  if (iszero(x) || issubnormal(x)) return sign? -0.0: 0.0;

  if (!isnormal(x)) return x;

  exponent += n;

  if (exponent <= 0) {
    errno = ERANGE;
    return sign? -0: 0;
  } else if (exponent >= _IEEE_DOUBLE_REAL_MAX_EXPONENT) {
    errno = ERANGE;
    return sign? -HUGE_VAL: HUGE_VAL;
  }

  x = _ieee_set_exponent(x, exponent);

  return x;
}
