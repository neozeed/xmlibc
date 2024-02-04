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
long long 
__muldi3 (u, v)
     long long u, v;
{
  long a[2], b[2], c[2][2];
  long_long w;
  long_long uu, vv;
  uu.ll = u;
  vv.ll = v;
  a[1 ] = uu.s.high;
  a[0 ] = uu.s.low;
  b[1 ] = vv.s.high;
  b[0 ] = vv.s.low;
  bmul (a, b, c, sizeof a, sizeof b);
  w.s.high = c[0 ][1 ];
  w.s.low = c[0 ][0 ];
  return w.ll;
}
static void 
bmul (a, b, c, m, n)
    unsigned short *a, *b, *c;
    size_t m, n;
{
  int i, j;
  unsigned long acc;
  memset (c,0, m + n) ;
  m /= sizeof *a;
  n /= sizeof *b;
  for (j = 0 ; ((j) < ( n)) ; j = ((j) + 1) )
    {
      unsigned short *c1 = c + j + 0 ;
      acc = 0;
      for (i = 0 ; ((i) < ( m)) ; i = ((i) + 1) )
	{
	  acc += (unsigned long) a[i] * b[j] + c1[i];
	  c1[i] = acc & (0x10000  - 1) ;
	  acc = acc >> 16;
	}
      c1[i] = acc;
    }
}
