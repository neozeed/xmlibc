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
long int 
__cmpdi2 (a, b)
     long long a, b;
{
  long_long au, bu;
  au.ll = a, bu.ll = b;
  if (au.s.high < bu.s.high)
    return 0;
  else if (au.s.high > bu.s.high)
    return 2;
  if ((unsigned) au.s.low < (unsigned) bu.s.low)
    return 0;
  else if ((unsigned) au.s.low > (unsigned) bu.s.low)
    return 2;
  return 1;
}
