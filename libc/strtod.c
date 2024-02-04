#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <ctype.h>
#include <errno.h>

#define LONG_LONG_MAX	0x7FFFFFFFFFFFFFFFLL
#define LONG_LONG_MIN	0x8000000000000000LL


#define CHECK(x) \
  if (fabs(x) > (DBL_MAX / 10)) { \
    errno = ERANGE;		\
    return HUGE_VAL;		\
  }

#define	signbit(x) ((x > 0)? 1: ((x < 0)? -1: 0))

static __inline__ double
fabs(double x)
{
  return (x < 0)? -x: x;
}

static __inline__ long long
llabs(long long x)
{
  return (x < 0)? -x: x;
}

double
strtod(const char *s, char **endptr)
{
  const char *p  = s;
  const char *p1 = s;
  int base = 0;
  int sign;
  int psign;
  long long dval;
  int power;
  double dpower;
  double result;

  double _pow10(int);

/* skip spaces */
  while (isspace(*p))
   p++;

  p1 = p;

/* check sign */
  if ((*p == '-') || (*p == '+'))
   sign = (*p++ == '-')? 1: 0;
  else
   sign = 0;

/* */
  for (dval = 0; isdigit(*p); p++)
   if (llabs(dval) > (LONG_LONG_MAX / 10))
    base++;
  else
   dval = (*p - '0') + 10 * dval;

/* */
  if (*p == '.')
   for (p++; isdigit(*p); p++, base--)
    if (llabs(dval) > (LONG_LONG_MAX / 10))
     base++;
    else
     dval = (*p - '0') + 10 * dval;

/* */
  if ((*p == 'e') || (*p == 'E')) {
/* skip */
    p++;

/* check sign */
    if ((*p == '-') || (*p == '+'))
     psign = (*p++ == '-')? 1: 0;
    else
     psign = 0;

/* */
    for (power = 0; isdigit(*p); p++)
     power = (*p - '0') + 10 * power;
  } else {
    psign = 0;
    power = 0;
  }

/* */
  if (endptr)
   if (p1 == p)
    *endptr = s;
   else
    *endptr = p;

/* calculate result */
#if 0
  if (sign)
   dval = -dval;
#endif

  if (psign)
   power = -power;

  power += base;

#if 0
  dpower = 1.0;

  if (power > 0)
   while (power-- > 0) {
     CHECK(dpower);
     dpower *= 10.0;
   }
  else
   while (power++ < 0) {
     CHECK(dpower);
     dpower /= 10.0;
   }
#else
  dpower = _pow10(power);
#endif

  if (fabs(dpower) > (DBL_MAX / (double) dval)) {
    errno = ERANGE;
    return sign? -HUGE_VAL: HUGE_VAL;
  }

  result =  (double) ((unsigned int) (dval >> 32)) * dpower;
  result =  ldexp(result, 32);
  result += (double) ((unsigned int) (dval & ((1LL << 32) - 1))) * dpower;

  return result;
}
