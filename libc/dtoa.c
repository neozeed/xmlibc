#include <strings.h>
#include <stdlib.h>
#include <limits.h>
#include <ctype.h>
#include <float.h>
#include <math.h>
#include <sys/ieee.h>

#define NAN	"NaN"
#define INF	"Inf"

#define as_double(X)	(* (double *) &(X))
#define as_longlong(X)	(* (long long *) &(X))

#define sign(X)     (_ieee_get_sign(X))
#define fraction(X) (_ieee_get_fraction(X))
#define exponent(X) (_ieee_get_exponent(X))

#define MAX_PRECISION 18

#if 1
#define PRECISION 16
#else
#define PRECISION 17
#endif

int _log10(double);
double _pow10(int);

static __inline__ void
reverse(char *str)
{
  char *p = str;
  char *q;

  for(q = str; q[1]; q++)
   ;

  for(; p < q; p++, q--) {
    int tmp = *p;
    *p = *q;
    *q = tmp;
  }
}

char *
_dtoa(double fpnum, char cvt, int force_dot, int prec)
{
  char *obuf;
  char *bufptr;
  double fractional;
  long long fracpart;
  long long frac;
  int intwidth;
  int exponent;
  int subnormal_exponent;
  int prec2;
  int adjust;
  int cvtflag;
  int supress;
  int neg;
  int i;

  if (isinf(fpnum)) {
    char *inffmt = (char *) malloc (sizeof(INF) + 2);

    strcpy(&inffmt[1], INF);
    inffmt[0] = sign(fpnum)? '-': '+';
    return inffmt;
  }

  if (isnan(fpnum)) {
    char *nanfmt = (char *) malloc (sizeof(NAN) + 2);

    strcpy(&nanfmt[1], NAN);
    nanfmt[0] = sign(fpnum)? '-': '+';
    return nanfmt;
  }

  neg = fpnum < 0;

  if (neg) fpnum = -fpnum;

  if (issubnormal(fpnum))
   subnormal_exponent = DBL_MIN_10_EXP, fpnum /= _pow10(DBL_MIN_10_EXP);
  else
   subnormal_exponent = 0;

  if (isnormal(fpnum))
   exponent = _log10(fpnum);
  else
   exponent = 0;

  if ((toupper(cvt) == 'G') && !force_dot)
   supress = 1;
  else
   supress = 0;

  if ((cvt == 'f') ||
      ((cvt == 'g' || cvt == 'G') &&
       (fpnum == 0.0 || (fpnum >= 1e-4) && fpnum < _pow10(prec)))) {

    cvtflag = 'f';
    intwidth = exponent + 1;
    if (intwidth < -prec) intwidth = -prec;
  } else {
    cvtflag = isupper(cvt)? 'E': 'e';
    intwidth = 1;
  }

  fractional = fpnum;

  {
    int expo = exponent + 1;
 
    if (expo > (-DBL_MIN_10_EXP))
     fractional *= _pow10(DBL_MIN_10_EXP),
     fractional *= _pow10(-expo - DBL_MIN_10_EXP);
    else if (expo > 0)
     fractional *= _pow10(-expo);
    else
     fractional *= _pow10(-expo);
  }

/* precision */
  if (toupper(cvt) == 'G')
    prec2 = prec;
  else if (cvt == 'f')
   prec2 = prec + intwidth;
  else
   prec2 = prec + 1;

  if (prec2 < 0)
   prec2 = 0;
  else if (prec2 > PRECISION)
   prec2 = PRECISION;

  adjust = MAX_PRECISION - prec2;

/* convert */
  if (fractional > 0)
   frac = fraction(fractional) + _IEEE_DOUBLE_REAL_INTEGER;
  else
   frac = 0;

/* radix convert */
  for (fracpart = 0, i = 0; i < 18; i++) {
    frac *= 10;
    fracpart = fracpart * 10 + (unsigned int) (frac >> 53);
    frac &= 0x001fffffffffffffLL;
  }

/*  */
  if (fracpart > 0) {
    int i = exponent(fractional) - _IEEE_DOUBLE_REAL_BIAS + 1;

    fracpart = (i > 0)? (fracpart <<= i): (fracpart >>= -i);
  }

  if (fracpart > 0) {
    unsigned long long adj = (unsigned long long) _pow10(adjust);

    fracpart += adj / 2;

    if (fracpart > 1000000000000000000LL) {
      fracpart /= 10, exponent++;
      if (cvtflag == 'f') intwidth++;
    }

    fracpart /= adj;
  }

  obuf = (char *) malloc (256);
  bufptr = obuf;

  if (cvtflag == 'f') {
    int n;

    n = (intwidth > prec2)? prec: (prec - (prec2 - intwidth));
    if (n > 0 && !supress) {
      force_dot = 1;
      while (n-- > 0)
       *bufptr++ = '0';
    }

    n = (intwidth > 0)? (prec2 - intwidth): prec2;
    if (n > 0)
     while (n-- > 0) {
       int c = fracpart % 10;
       if (c != 0 || !supress) *bufptr++ = '0' + c, force_dot = 1, supress = 0;
       fracpart /= 10;
     }

    n = ((intwidth < 0) && !supress) ? -intwidth: 0;
    if (n > 0) {
      force_dot = 1;
      while (n-- > 0)
       *bufptr++ = '0';
    }

    if (force_dot)
     *bufptr++ = '.';

    n = (intwidth > prec2)? (intwidth - prec2): 0;
    if (n > 0)
     while (n-- > 0)
      *bufptr++ = '0';

    n = (intwidth > 0)? ((intwidth < prec2)? intwidth: prec2): 1;
    if (n > 0)
     while (n-- > 0)
      *bufptr++ = '0' + fracpart % 10, fracpart /= 10;
  } else {
    int n;

    n = prec - prec2;
    if (n > 0)
     while (n-- > 0 && !supress)
      *bufptr++ = '0';

    n = prec2 - intwidth;
    if (n > 0)
     while (n-- > 0) {
       int c = fracpart % 10;
       if (c != 0 || !supress)
        *bufptr++ = '0' + c, force_dot = 1;
       fracpart /= 10;
     }

    if (force_dot)
     *bufptr++ = '.';

    n = (intwidth > 0)? intwidth: 1;
    while (n-- > 0)
     *bufptr++ = '0' + fracpart % 10, fracpart /= 10;
  }

  *bufptr++ = neg? '-': '+';
  *bufptr = '\0';

  reverse(obuf);

  if (0 > subnormal_exponent)
   exponent += DBL_MIN_10_EXP;

  if ((cvtflag == 'e') || (cvtflag == 'E')) {
    int esign = (exponent < 0);

    if (esign) exponent = -exponent;

    *bufptr++ = cvtflag;
    *bufptr++ = esign? '-': '+';

    if (exponent >= 100)
     *bufptr++ = '0' + exponent / 100;

    *bufptr++ = '0' + (exponent / 10) % 10;
    *bufptr++ = '0' + exponent % 10;
    *bufptr++ = '\0';
  }

  return obuf;
}