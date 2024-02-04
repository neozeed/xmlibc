extern int target_flags;
enum reg_class {
  NO_REGS, AREG, DREG, ADREG, CREG, BREG, Q_REGS,
  INDEX_REGS, GENERAL_REGS, FLOAT_REGS, ALL_REGS, LIM_REG_CLASSES };
union flt_or_int { int i; float f; };
typedef void (*vfp)();
void
__builtin_delete (ptr)
     char *ptr;
{
  if (ptr)
    free (ptr);
}

void
__builtin_vec_delete (ptr, maxindex, size, dtor, auto_delete_vec, auto_delete)
     char *ptr;
     int maxindex, size;
     void (*dtor)();
     int auto_delete;
{
  int i, nelts = maxindex + 1;
  char *p = ptr;
  ptr += nelts * size;
  for (i = 0; i < nelts; i++)
    {
      ptr -= size;
      (*dtor) (ptr, auto_delete);
    }
  if (auto_delete_vec)
    free (p);
}
