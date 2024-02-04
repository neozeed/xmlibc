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
__udivdi3 (u, v)
     long long u, v;
{
  unsigned long a[2][2], b[2], q[2], r[2];
  long_long w;
  long_long uu, vv;
  uu.ll = u;
  vv.ll = v;
  a[1 ][1 ] = 0;
  a[1 ][0 ] = 0;
  a[0 ][1 ] = uu.s.high;
  a[0 ][0 ] = uu.s.low;
  b[1 ] = vv.s.high;
  b[0 ] = vv.s.low;
  __bdiv (a, b, q, r, sizeof a, sizeof b);
  w.s.high = q[1 ];
  w.s.low = q[0 ];
  return w.ll;
}
