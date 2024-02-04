extern int target_flags;
enum reg_class {
  NO_REGS, AREG, DREG, ADREG, CREG, BREG, Q_REGS,
  INDEX_REGS, GENERAL_REGS, FLOAT_REGS, ALL_REGS, LIM_REG_CLASSES };
union flt_or_int { int i; float f; };
typedef void (*vfp)();
extern vfp __new_handler;
char *
__builtin_new (sz)
     long sz;
{
  char *p;
  p = (char *)malloc (sz);
  if (p == 0)
    (*__new_handler) ();
  return p;
}
