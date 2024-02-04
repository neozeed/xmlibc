extern int target_flags;
enum reg_class {
  NO_REGS, AREG, DREG, ADREG, CREG, BREG, Q_REGS,
  INDEX_REGS, GENERAL_REGS, FLOAT_REGS, ALL_REGS, LIM_REG_CLASSES };
union flt_or_int { int i; float f; };
typedef struct _iobuf {
    int  bufsize;
    int  cnt;
    char *ptr;
    char *base;
    int  flag;
    int  fd;
} FILE;
extern FILE _iob[20 ];
enum _flags {
    _READ	= 1 << 0,
    _WRITE	= 1 << 1,
    _UNBUF	= 1 << 2,
    _EOF	= 1 << 3,
    _ERR	= 1 << 4,
};
int _fillbuf(FILE *);
int _flushbuf(int, FILE *);
void
__eprintf (string, line, filename)
     char *string;
     int line;
     char *filename;
{
  fprintf ((&_iob[2]) , string, line, filename);
}
