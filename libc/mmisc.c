#include <stdlib.h>
#include <limits.h>
#include <float.h>
#include <math.h>
#include <sys/ieee.h>

static const double e0 = 1.0e+0L;

static const double exponent_table1[] = {
  1.0e+0L,   1.0e+1L,   1.0e+2L,   1.0e+3L,
  1.0e+4L,   1.0e+5L,   1.0e+6L,   1.0e+7L,
  1.0e+8L,   1.0e+9L,   1.0e+10L,  1.0e+11L,
  1.0e+12L,  1.0e+13L,  1.0e+14L,  1.0e+15L,
};

static const double exponent_table2[] = {
  1.0e+0L,   1.0e+16L,    1.0e+32L,    1.0e+48L,
  1.0e+64L,  1.0e+80L,    1.0e+96L,    1.0e+112L,
  1.0e+128L, 1.0e+144L,   1.0e+160L,   1.0e+176L,
  1.0e+192L, 1.0e+208L,   1.0e+224L,   1.0e+240L,
  1.0e+256L, 1.0e+272L,   1.0e+288L,   1.0e+304L,
};

static const double m_exponent_table1[] = {
  1.0e-0L,   1.0e-1L,   1.0e-2L,   1.0e-3L,
  1.0e-4L,   1.0e-5L,   1.0e-6L,   1.0e-7L,
  1.0e-8L,   1.0e-9L,   1.0e-10L,  1.0e-11L,
  1.0e-12L,  1.0e-13L,  1.0e-14L,  1.0e-15L,
};

static const double m_exponent_table2[] = {
  1.0e-0L,   1.0e-16L,    1.0e-32L,    1.0e-48L,
  1.0e-64L,  1.0e-80L,    1.0e-96L,    1.0e-112L,
  1.0e-128L, 1.0e-144L,   1.0e-160L,   1.0e-176L,
  1.0e-192L, 1.0e-208L,   1.0e-224L,   1.0e-240L,
  1.0e-256L, 1.0e-272L,   1.0e-288L,   1.0e-304L,
};

double
_pow10(int exponent)
{
  if (exponent == 0) return e0;

  if (exponent < DBL_MIN_10_EXP) return 0;

  if (exponent > DBL_MAX_10_EXP) return HUGE_VAL;

  if (exponent > 0) {
    if (exponent < 0x10)
     return exponent_table1[exponent & 0xf];

    return exponent_table1[exponent & 0xf] *
	   exponent_table2[exponent >> 4];
  } else {
    exponent = -exponent;

    if (exponent < 0x10)
     return m_exponent_table1[exponent & 0xf];

    return m_exponent_table1[exponent & 0xf] *
	   m_exponent_table2[exponent >> 4];
  }
}

int
_log10(double x)
{
  double d = x;
  int exp1 = 0;
  int exp2 = 0;

  if (d <= 0)
   return INT_MIN;

  if (isinf(d))
   return INT_MAX;

  if (d > 1.0L) {
    exp1 = 0;
    exp2 = DBL_MAX_10_EXP;

    while ((_pow10(exp1) != d) && (_pow10(exp2) != d) && ((exp2 - exp1) > 1))
     if (d > _pow10((exp2 + exp1) / 2))
      exp1 = (exp2 + exp1) / 2;
     else
      exp2 = (exp2 + exp1) / 2;
  } else {
    exp1 = DBL_MIN_10_EXP;
    exp2 = 0;

    while ((_pow10(exp1) != d) && (_pow10(exp2) != d) && ((exp2 - exp1) > 1))
     if (d > _pow10((exp2 + exp1) / 2))
      exp1 = (exp2 + exp1) / 2;
     else
      exp2 = (exp2 + exp1) / 2;
  }

  if (_pow10(exp1) == d) return exp1;

  if (_pow10(exp2) == d) return exp2;
 
  return exp1;
}