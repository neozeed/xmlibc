#include <stdlib.h>

static __inline__ long int _labs(long int i) { return (i < 0)? -i: i; }

ldiv_t
ldiv(long int numer, long int denom)
{
  ldiv_t d;
  long int abs_numer = _labs(numer);
  long int abs_denom = _labs(denom);

  d.quot = abs_numer / abs_denom;
  d.rem  = abs_numer % abs_denom;

  if (((numer > 0) && (denom < 0)) || ((numer < 0) && (denom > 0)))
   d.quot = -d.quot;

  if (numer < 0)
   d.rem = -d.rem;

  return d;
}