#ifndef _IEEE_H
#define _IEEE_H 1

struct _ieee_single_real {
  unsigned int fraction : 23;
  unsigned int exponent : 8;
  unsigned int sign     : 1;
};

#ifdef _SUPPORT_LONG_LONG_BITFIELD
struct _ieee_double_real {
  unsigned long long fraction : 52;
  unsigned long long exponent : 11;
  unsigned long long sign     : 1;
};
#else
struct _ieee_double_real {
  unsigned int fraction_l : 32;
  unsigned int fraction_h : 20;
  unsigned int exponent   : 11;
  unsigned int sign       : 1;
};
#endif

struct _ieee_extended_real {
  unsigned long long fraction;
  unsigned int zero           : 16;
  unsigned int exponent       : 15;
  unsigned int sign           : 1;
};

#if 0
#error _ieee_packed_decimal_real not supported.
struct _ieee_packed_decimal_real {
};
#endif

#define _IEEE_SINGLE_REAL_BIAS    0x7f
#define _IEEE_DOUBLE_REAL_BIAS    0x3ff
#define _IEEE_EXTENDED_REAL_BIAS  0x3fff

#define _IEEE_SINGLE_REAL_MAX_EXPONENT    0xff
#define _IEEE_DOUBLE_REAL_MAX_EXPONENT    0x7ff
#define _IEEE_EXTENDED_REAL_MAX_EXPONENT  0x7fff

#define _IEEE_SINGLE_REAL_INTEGER   (1   << 23)
#define _IEEE_DOUBLE_REAL_INTEGER   (1LL << 52)
#define _IEEE_EXTENDED_REAL_INTEGER 0

int finite(double);
int isinf(double);
int isnan(double);
int isnormal(double);
int issubnormal(double);
int iszero(double);
int signbit(double);

static __inline__ int
_ieee_get_sign(double x)
{
  union { double df; struct _ieee_double_real di; } real;
  real.df = x;
  return real.di.sign;
}

static __inline__ int
_ieee_get_exponent(double x)
{
  union { double df; struct _ieee_double_real di; } real;
  real.df = x;
  return real.di.exponent;
}

static __inline__ long long
_ieee_get_fraction(double x)
{
  union { double df; struct _ieee_double_real di; } real;
  real.df = x;
#ifdef _SUPPORT_LONG_LONG_BITFIELD
  return real.di.fraction;
#else
  return (long long) real.di.fraction_l
       + ((long long) real.di.fraction_h << 32);
#endif
}

static __inline__ double
_ieee_set_sign(double x, int sign)
{
  union { double df; struct _ieee_double_real di; } real;
  real.df = x;
  real.di.sign = sign;
  return real.df;
}

static __inline__ double
_ieee_set_exponent(double x, int exponent)
{
  union { double df; struct _ieee_double_real di; } real;
  real.df = x;
  real.di.exponent = exponent;
  return real.df;
}

static __inline__ double
_ieee_set_fraction(double x, long long fraction)
{
  union { double df; struct _ieee_double_real di; } real;
  real.df = x;

#ifdef _SUPPORT_LONG_LONG_BITFIELD
  real.di.fraction   = fraction;
#else
  real.di.fraction_l = (unsigned long int) ((1LL << 32) -1) & fraction;
  real.di.fraction_h = (unsigned long int) ((1LL << 20) -1) & (fraction >> 32);
#endif

  return real.df;
}

static __inline__ double
_ieee_compose_double_real(int sign, int exponent, long long fraction)
{
  union { double df; struct _ieee_double_real di; } real;

  real.di.fraction_l = ((1LL << 32) -1) & fraction;
  real.di.fraction_h = ((1LL << 20) -1) & (fraction >> 32);
  real.di.exponent   = exponent;
  real.di.sign       = sign;

  return real.df;
}

#endif /* _IEEE_H */