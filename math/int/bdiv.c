extern int target_flags;
enum reg_class {
  NO_REGS, AREG, DREG, ADREG, CREG, BREG, Q_REGS,
  INDEX_REGS, GENERAL_REGS, FLOAT_REGS, ALL_REGS, LIM_REG_CLASSES };
typedef long ptrdiff_t;
typedef unsigned long size_t;
  struct longlong {long low, high;};
typedef union
{
  struct longlong s;
  long long ll;
  long int  i[2];
  unsigned long int  ui[2];
} long_long;
static int badd ();
static int bsub ();
static void bmul ();
static int bneg ();
static int bshift ();
void 
__bdiv (a, b, q, r, m, n)
     unsigned short *a, *b, *q, *r;
     size_t m, n;
{
  unsigned long qhat, rhat;
  unsigned long acc;
  unsigned short *u = (unsigned short *) __builtin_alloca(m) ;
  unsigned short *v = (unsigned short *) __builtin_alloca(n) ;
  unsigned short *u0, *u1, *u2;
  unsigned short *v0;
  int d, qn;
  int i, j;
  m /= sizeof *a;
  n /= sizeof *b;
  qn = m - n;
  while (b[((n) - 1) ] == 0)
    {
      r[((n) - 1) ] = 0;
      a += 0 ;
      b += 0 ;
      r += 0 ;
      m--;
      n--;
      if (n == 0)
	abort ();
    }
  if (n == 1)
    {
      acc = a[((m) - 1) ];
      a += 0 ;
      for (j = ((qn) - 1) ; ((j) >= 0) ; j = ((j) - 1) )
	{
	  acc = (acc << 16) | a[j];
	  q[j] = acc / *b;
	  acc = acc % *b;
	}
      *r = acc;
      return;
    }
  for (d = 0; d < 16; d++)
    if (b[((n) - 1) ] & (1 << (16 - 1 - d)))
      break;
  bshift (a, d, u, 0, m);
  bshift (b, d, v, 0, n);
  u0 = u + ((m) - 1)  - ((qn) - 1) ;
  u1 = ((u0) - 1) ;
  u2 = ((u1) - 1) ;
  u += 0 ;
  v0 = v + ((n) - 1) ;
  for (j = ((qn) - 1) ; ((j) >= 0) ; j = ((j) - 1) )
    {
      if (u0[j] == *v0)
	{
	  qhat = 0x10000  - 1;
	  rhat = (unsigned long) *v0 + u1[j];
	}
      else
	{
	  unsigned long numerator = ((unsigned long) u0[j] << 16) | u1[j];
	  qhat = numerator / *v0;
	  rhat = numerator % *v0;
	}
      while (rhat < 0x10000  && qhat * *((v0) - 1)  > ((rhat << 16) | u2[j]))
	{
	  qhat -= 1;
	  rhat += *v0;
	}
      acc = 0;
      for (i = 0 ; ((i) < ( n)) ; i = ((i) + 1) )
	{
	  acc += (unsigned long) (u + j)[i] - v[i] * qhat;
	  (u + j)[i] = acc & (0x10000  - 1) ;
	  if (acc < 0x10000 )
	    acc = 0;
	  else
	    acc = (acc >> 16) | -0x10000 ;
	}
      q[j] = qhat;
      if ((signed long) (acc + u0[j]) < 0)
	{
	  q[j] -= 1;
	  acc = 0;
	  for (i = 0 ; ((i) < ( n)) ; i = ((i) + 1) )
	    {
	      acc += (unsigned long) (u + j)[i] + v[i];
	      (u + j)[i] = acc & (0x10000  - 1) ;
	      acc = acc >> 16;
	    }
	}
    }
  r[((n) - 1) ] = bshift (u + 1 + 0 ,
			   16 - d,
			   r + 0 ,
			   u[0 ] >> d,
			   n - 1);
}
static int
bshift (u, k, w, carry_in, n)
     unsigned short *u, *w, carry_in;
     int k, n;
{
  unsigned long acc;
  int i;
  if (k == 0)
    {
      memcpy ( w,u, n * sizeof *u) ;
      return 0;
    }
  acc = carry_in;
  for (i = 0 ; ((i) < ( n)) ; i = ((i) + 1) )
    {
      acc |= (unsigned long) u[i] << k;
      w[i] = acc & (0x10000  - 1) ;
      acc = acc >> 16;
    }
  return acc;
}
