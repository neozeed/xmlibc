#include <sys/types.h>
#include <strings.h>
#include <stdlib.h>
#include <stdarg.h>
#include <limits.h>
#include <stdio.h>
#include <ctype.h>
#include <jctype.h>
#include <sys/ieee.h>

#ifdef __GNUC__
#define alloca(x) __builtin_alloca(x)
#endif

typedef enum {
  Minus	= 1 << 0,
  Plus	= 1 << 1,
  Blank	= 1 << 2,
  Sharp	= 1 << 3,
  Zero	= 1 << 4,
} Flag;

typedef enum {
  Supress,
  Regular,
  Small,
  Double,
  LongDouble,	/* Unsupported */
} Size;

typedef struct {
  Flag	flag;
  Size	size;
  int	min;
  int	prec;
  char	fchar;
} format_info;


extern double _pow10(int);
extern int _log10(double);

extern char *_dtoa(double, char, int, int);


static int  _printf_long  (FILE *, format_info, long);
static int  _printf_ulong (FILE *, format_info, u_long);
static int  _printf_double(FILE *, format_info, double);
static int  _printf_string(FILE *, int, char *);

static __inline__ int
max(int x, int y)
{
  return (x > y)? x: y;
}

static __inline__ int
min(int x, int y)
{
  return (x > y)? y: x;
}

int
printf(const char *fmt,...)
{
  int  r;

  va_list args;
  va_start(args, fmt);

  r = vfprintf(stdout, fmt, args);

  va_end(args);

  return r;
}

int
fprintf(FILE *stream, const char *fmt,...)
{
  int  r;

  va_list args;
  va_start(args, fmt);

  r = vfprintf(stream, fmt, args);

  va_end(args);

  return r;
}

int
sprintf(char *string, const char *fmt,...)
{
  int  r;
  FILE stream;
  va_list args;

  va_start(args, fmt);

  stream._bufsiz = INT_MAX;
  stream._cnt    = INT_MAX;
  stream._base   = (unsigned char *) string;
  stream._ptr    = (unsigned char *) string;
  stream._flag   = _IOWRITE | _IOSTRING;
  stream._file   = -1;


  r = vfprintf(&stream, fmt, args);
  putc('\0', &stream);

  va_end(args);

  return r;
}

int
vprintf(const char *fmt, va_list args)
{
  int  r;

  r = vfprintf(stdout, fmt, args);

  return r;
}

int
vsprintf(char *string, const char *fmt, va_list args)
{
  int  r;
  FILE stream;

  stream._bufsiz = INT_MAX;
  stream._cnt    = INT_MAX;
  stream._base   = (unsigned char *) string;
  stream._ptr    = (unsigned char *) string;
  stream._flag   = _IOWRITE | _IOSTRING;
  stream._file   = -1;

  r = vfprintf(&stream, fmt, args);
  putc('\0', &stream);

  return r;
}

/* parse_format recognize format string */

static const char *
parse_format(const char *p, va_list *args, format_info *info)
{
  /* set default infomation */
  info->flag = 0;
  info->size = Regular;
  info->min  = 0,
  info->prec = -1;

  /* check */
  if (*p != '%') return NULL;

  p++;
  while (index("+- #0", *p)) {
    switch (*p++) {
     case '+': info->flag |= Plus;  break;
     case '-': info->flag |= Minus; break;
     case ' ': info->flag |= Blank; break;
     case '#': info->flag |= Sharp; break;
     case '0': info->flag |= Zero;  break;
     default: break;
    }
  }

  if (*p == '*') {
    info->min = va_arg(*args, int);
    p++;
  } else {
    while (isdigit(*p)) {
      info->min = 10 * info->min + (*p - '0');
      p++;
    }
  }

  if (*p == '.') {
    p++;

    if (*p == '*') {
      info->prec = va_arg(*args, int);
      p++;
    } else {
      info->prec = 0;
      while (isdigit(*p)) {
        info->prec = 10 * info->prec + (*p - '0');
        p++;
      }
    }
  }

  if (*p == 'h') {
    info->size = Small;
    p++;
  } else if (*p == 'l') {
    info->size = Double;
    p++;
  } else if (*p == 'L') {
    info->size = LongDouble;
    p++;
  }

  if (!index("diouxXeEfgGscpn%", *p))   return NULL;

  if (info->prec == -1) {
    if (index("diouxX", *p)) info->prec = 1;
    if (index("eEfgG",  *p)) info->prec = 6;
    if (index("s",  *p))     info->prec = INT_MAX;
  }

  info->fchar = *p;
  return p;
}

#define UINT_BUF	(12)

static char *
itoa(char *buf, int n, int radix, u_long l, char *ctab)
{
  int index, i = n;

  for (index = n - 1; index >= 0; index--, l /= radix)
   if (l > 0)
    buf[index] = ctab[l % radix], i = index;
   else
    buf[index] = ctab[0];

  buf[n] = '\0';

  return &buf[i];
}

static char *
_printf_conv_integer(char *buf, int length, format_info info, int sign, u_long l)
{
  char *p;
  char *ctab;
  int  radix;
  int  len;

  switch (info.fchar) {
   case 'X':
    radix = 16;
    ctab = "0123456789ABCDEF";
    break;

   case 'p':
    info.prec = 8;
   case 'x':
    radix = 16;
    ctab = "0123456789abcdef";
    break;

   case 'o':
    radix = 8;
    ctab = "01234567";
    break;

  default:
   radix = 10;
   ctab = "0123456789";
   break;
  }

  if ((info.prec == 0) && (l == 0))
   p = "";
  else
   p = itoa(buf, length, radix, l, ctab);

  len = strlen(p);
  if (info.prec > len) {
    p -= info.prec - len;
    len = info.prec;
  }

  if ((info.flag & Zero) && !(info.flag & Minus) && (len < info.min)) {
    int n = 0;
    if ((sign < 0) || (info.flag & Plus) || (info.flag & Blank))
     n = 1;
    if (info.flag & Sharp)
     n = radix == 8? 1: 2;
    if (info.min > (len + n)) {
      p -= info.min - (len + n);
      len = info.min;
    }
  }

  if ((sign < 0) || ((info.flag & Plus) && (radix == 10))) {
    *--p = (sign > 0)? '+': '-';
    len++;
  } else if ((info.flag & Blank) && (radix == 10)) {
    *--p =' ';
    len++;
  }

  if (info.flag & Sharp) {
    if (radix == 8) {
      p--;
      len ++;
    } else if (radix == 16) {
      *--p = info.fchar;
      p--;
      len += 2;
    }
  }

  if (!(info.flag & Minus) && (len < info.min)) {
    p -= info.min - len;
    if (info.flag & Zero)
     memset(p, '0', info.min - len);
    else
     memset(p, ' ', info.min - len);

    len = info.min;
  }

  if ((info.flag & Minus) && (len < info.min)) {
    memcpy(&buf[0], &buf[length - len], len);
    memset(&buf[len], ' ', info.min - len);
    buf[info.min] = '\0';

    p = &buf[0];
  } else if (len < info.min) {
    memset(&buf[length - info.min] , ' ', info.min - len);
    p = &buf[length - len];
  }

  return p;
}

static char *
lltoa(char *buf, int n, long long ll)
{
  int index, i = n - 1;

  for (index = n - 1; index >= 0; index--) {
    if (ll > 0) {
      buf[index] = (ll % 10) + '0';
      i = index;
    } else {
      buf[index] = '0';
    }

    ll /= 10;
  }

  return &buf[i];
}

static int
_printf_long (FILE *stream, format_info info, long i)
{
  int  count, l;
  char *p, *q;

  l = max(UINT_BUF, max(info.min, info.prec));
  p = alloca(l + 1);
  q = _printf_conv_integer(p, l, info, (i < 0)? -1: 1, (i < 0)? -i: i);
  count = _printf_string(stream, INT_MAX, q);

  return count;
}

static int
_printf_ulong (FILE *stream, format_info info, u_long i)
{
  int  count, l;
  char *p, *q;

  l = max(UINT_BUF, max(info.min, info.prec));
  p = alloca(l + 1);
  q = _printf_conv_integer(p, l, info, 1, i);
  count = _printf_string(stream, INT_MAX, q);

  return count;
}

static int
_printf_double(FILE *stream, format_info info, double x)
{
  char *p;
  char *ptr;
  int  count = 0;
  int  n;
  int  length;

  p = _dtoa(x, info.fchar, (info.flag & Sharp)? 1: 0, info.prec);

  if (p[0] == '-')
   ptr = p;
  else if (info.flag & Plus)
   ptr = p;
  else if (info.flag & Blank)
   ptr = p, ptr[0] = ' ';
  else
   ptr = p + 1;

  length = strlen(ptr);

  if (!(info.flag & Minus)) {
    n = (info.min > length)? (info.min - length): 0;
    while(n-- > 0)
     putc(' ', stream), count++;
  }

  count += _printf_string(stream, length, ptr);

  if (info.flag & Minus) {
    n = (info.min > length)? (info.min - length): 0;
    while(n-- > 0)
     putc(' ', stream), count++;
  }

  free(p);
  return count;
}

static int
_printf_string(FILE *stream, int n, char *string)
{
  char *p;

  if (!string) string = "(null)";

  for (p = string; *p && (n > 0); p++, n--)
   putc(*p, stream);

  return p - string;
}

int
vfprintf(FILE *stream, const char *fmt, va_list args)
{
  format_info info;
  const char *p;
  int count;

  double df;
  long   si;
  u_long usi;
  u_char uhi;
  char *s;

  for(count = 0, p = fmt; *p; p++) {
    if ((char) *p != '%') {
      if (iskanji(*p)) {
        putc(p[0], stream);
        putc(p[1], stream);
	count += 2;
	p++;
      } else {
        putc(*p, stream);
        count++;
      }
    } else {
      p = parse_format(p, &args, &info);

      switch (*p) {
       case '%':
	putc('%', stream);
	count++;
	break;

       case 'd':
       case 'i':
	if (info.size == Regular)
	 si = va_arg(args, long);
	else if (info.size == Double)
	 si = va_arg(args, int);
	else if (info.size == Small)
	 si = va_arg(args, short);
	else
	 return count;

	count += _printf_long(stream, info, si);
	break;

       case 'u':
       case 'o':
	if (info.size == Regular)
	 usi = va_arg(args, u_int);
	else if (info.size == Double)
	 usi = va_arg(args, u_long);
	else if (info.size == Small)
	 usi = va_arg(args, u_short);
	else
	 return count;

	count += _printf_ulong(stream, info, usi);
	break;

       case 'p':
       case 'x':
       case 'X':
	if (info.size == Regular)
	 usi = va_arg(args, u_int);
	else if (info.size == Double)
	 usi = va_arg(args, u_long);
	else if (info.size == Small)
	 usi = va_arg(args, u_short);
	else
	 return count;

	count += _printf_ulong(stream, info, usi);
	break;

       case 'f':
       case 'e':
       case 'E':
       case 'g':
       case 'G':
	if (info.size == Regular)
	 df = va_arg(args, double);
	else if (info.size == LongDouble)
	 df = va_arg(args, long double);
	else
	 return count;

	count += _printf_double(stream, info, df);
	break;

       case 'c':
	uhi = va_arg(args, char);
	putc(uhi, stream);
	count++;
	break;

       case 's':
	s = va_arg(args, char *);
	count += _printf_string(stream, info.prec, s);
	break;

       case 'n':
	*va_arg(args, int *) = count;
	break;

       default:
	break;
      }
    }
  }
  return count;
}