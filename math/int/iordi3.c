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
__iordi3 (u, v)
     long long u, v;
{
  long_long w;
  long_long uu, vv;
  uu.ll = u;
  vv.ll = v;
  w.s.high = uu.s.high | vv.s.high;
  w.s.low = uu.s.low | vv.s.low;
  return w.ll;
}
