#include <stdlib.h>
#include <float.h>
#include <math.h>
#include <ctype.h>

#define MAXALLOWABLE	(0x7fffffffffffffffLL / 10)

double _pow10(int);

double
atof(const char *s)
{
  int sign = 0;
  int exp  = 0;
  int i;
  long long mant = 0;
  double ipart;
  double fpart;
  double result;

/* skip white spaces */
  while (*s && isspace(*s))
   s++;

/* sign */
  if (*s && ((*s == '-') || (*s == '+'))) {
    sign = (*s == '-')? 1: 0;
    s++;
  }

/* mant */
  for (; *s && isdigit(*s); s++) {
    if (mant < MAXALLOWABLE)
     mant = mant * 10 + (*s - '0');
    else
     exp++;
  }
  ipart = (double) mant;

  if (*s && *s == '.')
   for (fpart = 0, i = 0, s++ ;*s && isdigit(*s); s++)
    fpart = fpart + (*s - '0') * _pow10(--i);
  else
   fpart = 0;

/* exp */
  if (*s && toupper(*s) == 'E') {
    int sign = 0;

    s++;
    if (*s && ((*s == '-') || (*s == '+')))
     sign = (*s++ == '-')? 1: 0;

    if (*s && isdigit(*s))
     exp = (sign? -atol(s): atol(s)) + exp;
  }

#if 1
  if (exp > 0) {
    double epart = _pow10(exp);
    result = ipart * epart + fpart * epart;
  } else if (exp < DBL_MIN_10_EXP) {
    double epart = _pow10(DBL_MIN_10_EXP);
    result = ipart * epart + fpart * epart;
    result *= _pow10(exp - DBL_MIN_10_EXP);
  } else {
    double epart = _pow10(exp);
    result = ipart * epart + fpart * epart;
  }
#else
  {
    double fpart = _pow10(iexp2 - ((iexp1 < 1)? 0: (iexp1 - 1)));
    double epart = (exp > 0)? _pow10(exp): _pow10(-exp);

    result =  (double) ((unsigned int) (mant & ((1LL << 32) - 1)));
    result =  ldexp(result, -32);
    result += (double) ((unsigned int) (mant >> 32));
    result =  ldexp(result, 32);
 
    if (exp > 0)
     result *= epart;
    else
     result /= epart;

    result /= fpart;
  }
#endif
 
  return sign? -result: result;
}