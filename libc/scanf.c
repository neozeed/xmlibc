#include <sys/types.h>
#include <strings.h>
#include <stdlib.h>
#include <stdarg.h>
#include <limits.h>
#include <stdio.h>
#include <ctype.h>
#include <jctype.h>

int scanf (const char *fmt, ...);
int fscanf(FILE *stream, const char *fmt, ...);
int sscanf(const char *buffer, const char *fmt, ...);
int vfscanf(FILE *stream, const char *fmt, va_list args);
int vsscanf(const char *buffer, const char *fmt, va_list args);


/* I'll try to allocate buffer dynamic */
#define MAX_LEN 256 /* max length for numeric format conversions */


typedef enum {
  Supress,
  Regular,
  Small,
  Long,
  LongDouble,	/* Unsupported */
} Size;

typedef struct {
  Size	size;
  int	width;
} format_info;


int
scanf(const char *fmt, ...)
{
  int   r;

  va_list args;
  va_start(args, fmt);

  r = vfscanf(stdin, fmt, args);

  va_end(args);
  return r;
}

int
fscanf(FILE *stream, const char *fmt, ...)
{
  int	r;

  va_list args;
  va_start(args, fmt);

  r = vfscanf(stream, fmt, args);

  va_end(args);
  return r;
}

int
sscanf(const char *string, const char *fmt, ...)
{
  int   r;
  FILE  stream;

  va_list args;
  va_start(args, fmt);

  stream._bufsiz =
  stream._cnt	= strlen(string);
  stream._base	= (unsigned char *) string;
  stream._ptr	= (unsigned char *) string;
  stream._flag	= _IOREAD | _IOSTRING;
  stream._file	= -1;

  r = vfscanf(&stream, fmt, args);

  va_end(args);
  return r;
}

static int _scanf_long  (FILE *, format_info, int , long *);
static int _scanf_ulong (FILE *, format_info, int , unsigned long *);
static int _scanf_double(FILE *, format_info, double *);
static int _scanf_string(FILE *, format_info, char *);
static int _scanf_chars (FILE *, format_info, const char *, const char *, char *);

static __inline__ int
isoctal(int c)
{
  if (isdigit(c) && (c != '8') && (c != '9'))
   return 1;
  return 0;
}

static __inline__ int
chartoi(int c)
{
  if (isdigit(c))
   return (c - '0');
  else if (isxdigit(c))
   return (toupper(c) - 'A' + 10);

  return 0;
}

static int
_scanf_long(FILE *stream, format_info info, int radix, long *ll)
{
  int c;
  int n1 = 0;
  int n2;
  int sign = 0;
  unsigned long l = 0;

  while ((EOF != (c = getc(stream))) && isspace(c))
   ;

  if (c == EOF) return EOF;

  if ((c == '-') || (c == '+'))
   sign = (c == '-')? 1: 0, n1++;
  else
   ungetc(c, stream);

  info.width -= n1;

  if ((n2 = _scanf_ulong(stream, info, radix, &l)) == EOF)
   return (n1 == 0)? EOF: n1;

  n1 += n2;

  *ll = sign? -l: l;

  return n1;
}

static int
_scanf_ulong(FILE *stream, format_info info, int radix, unsigned long *ll)
{
  unsigned long l = 0;
  int  c;
  int  n = 0;
  char buf[MAX_LEN];
  char *p = buf;
  char *q;

  while ((EOF != (c = getc(stream))) && isspace(c))
   ;

  if (c == EOF) return EOF;

  n++;

  if (c == '+')
   c = getc(stream), n++;

  if ((EOF == c) || !isxdigit(c) || (n > info.width)) {
    ungetc(c, stream);
    return (c == EOF)? EOF: n;
  }

  if (radix != 0)
   *p++ = c;
  else if (c == '0') {
    c = getc(stream);
    n++;

    if (n > info.width) {
      ungetc(c, stream);
      *ll = 0;
      return n;
    }

    if (toupper(c) == 'X')
     radix = 16;
    else if ((EOF != c) && isoctal(c)) {
      radix = 8;
      *p++ = c;
    } else {
      ungetc(c, stream);
      n--;
      *ll = 0;
      return n;
    }
  } else {
    radix = 10;
    *p++ = c;
  }

  while (((c = getc(stream)) != EOF)
	 && (((radix == 10) & (isdigit (c))) ||
	     ((radix == 16) & (isxdigit(c))) ||
	     ((radix == 8)  & (isoctal (c))))) {
    n++;

    if ((c == EOF) || (n > info.width)) break;
    *p++ = c;
  }

  ungetc(c, stream);

  for (q = buf; q < p; q++)
   l = l * radix + chartoi(*q);

  *ll = l;

  return n;
}

static int
_scanf_double(FILE *stream, format_info info, double *d)
{
  int  c;
  int  width = info.width;
  int  index = 0;
  char buf[MAX_LEN];

  double atof(const char *);

  while ((EOF != (c = getc(stream))) && isspace(c))
   ;

  if (c == EOF) return EOF;

  if ((c == '+') || (c == '-')) {
    buf[index++] = c;
    width--;
  } else
    ungetc(c, stream);

  while ((EOF != (c = getc(stream))) && isdigit(c)) {
    width--;

    if ((index < MAX_LEN) && (width > 0))
     buf[index++] = c;
    else
     return info.width - width;
  }

  if (c == '.') {
    buf[index++] = c;
    width--;

    while ((EOF != (c = getc(stream))) && isdigit(c)) {
      width--;
      if ((index < MAX_LEN) && (width > 0))
       buf[index++] = c;
      else
       return info.width - width;
    }
  }

/* Exponent part */
  if ((c == 'e') || (c == 'E')) {
    buf[index++] = c;
    width--;

    c = getc(stream);

    if ((c == '+') || (c == '-')) {
      buf[index++] = c;
      width--;
    } else
     ungetc(c, stream);

    while ((EOF != (c = getc(stream))) && isdigit(c)) {
      width--;

      if ((index < MAX_LEN) && (width > 0))
       buf[index++] = c;
      else
       return info.width - width;
    }
  }

  buf[index] = '\0';

  *d = atof(buf);

  return info.width - width;
}

static int
_scanf_string(FILE *stream, format_info info, char *string)
{
  int  c;
  int  n = 0;
  char *p = string;

  while ((EOF != (c = getc(stream))) && isspace(c))
   ;

  if (c == EOF) return EOF;

  ungetc(c, stream);

  while (info.width-- > 0) {
    c = getc(stream);
    n++;

    if (c == EOF) {
      if (info.size != Supress)
      n--;
      *p = '\0';
      return n;
    } else if (isspace(c)) {
      ungetc(c, stream);
      n--;
      break;
    } else {
      if (info.size != Supress)
       *p++ = c;
    }
  }

  if (info.size != Supress)
   *p = '\0';

  return n;
}

static int
_scanf_chars(FILE *stream, format_info info, const char *top, const char *bottom, char *string)
{
  const char *p = index(top, '[');
  char table[256];
  int  ichar = 0;
  int  index;
  int  c;
  int  n;

  if (p == NULL) return 0;

  p++;

  if (*p == '^') {
    ichar = !ichar;
    p++;
  }

  if (info.width <= 0) return 0;

  for (index = 0; index < 256; index++)
   table[index] = ichar;

  for (; p < bottom; p++)
   if ((p[0] == '-') && (p[-1] < p[1])) {
     for (index = p[-1]; index <= p[1]; index++)
      table[index] = !ichar;
     p++;
   } else
    table[*p] = !ichar;

  if (EOF == (c = getc(stream))) return EOF;

  for (n = 0; info.width > 0; info.width--, c = getc(stream)) {

    if ((c == EOF) || !table[c]) {
      ungetc(c, stream);
      return n;
    }
    n++;

    if (info.size != Supress)
     *string++ = c;
  }

  if ((info.size != Supress) && (n > 0))
   *string = '\0';

  return n;
}


static const char *
parse_format(const char *p, format_info *info)
{
  info->size  = Regular;
  info->width = -1;

  if (*p != '%') return NULL;

  p++;
  if (*p == '*') {
    info->size = Supress;
    p++;
  }

  if (isdigit(*p)) {
    int width = 0;

    while (isdigit(*p))
     width = 10 * width + (*p++ - '0');

    info->width = width;
  }

  if (*p == 'h') {
    info->size = Small;
    p++;
  } else if (*p == 'l') {
    info->size = Long;
    p++;
  } else if (*p == 'L') {
    info->size = LongDouble;
    p++;
  }

  if (*p == '[') {
    p++;
    if (*p == '^') p++;
    if (*p == ']') p++;

    p = index(p, ']');
  }

  if (index("diouxXeEfgGscpn]%", *p)) {
    if (info->width == -1)
     if (*p == 'c')
      info->width = 1;
     else
      info->width = INT_MAX;

    return p;
  }

  return NULL;
}

int
vfscanf (FILE *stream, const char *fmt, va_list args)
{
  const char *p;
  const char *q;
  char *r;
  int count = 0;
  int nchar = 0;
  int n;
  long l;
  double d;
  unsigned long ul;
  format_info info;

  for (p = fmt; *p; p++) {
    if (*p != '%') {
      char c;

      if (isspace(*p)) {
	while ((EOF != (c = getc(stream))) && isspace(c))
	 nchar++;
	if (c == EOF) return count;
	ungetc(c, stream);
      } else {
	nchar++;
	if (*p != (c = getc(stream))) {
	  ungetc(c, stream);
	  return count;
	}
	if (!iskanji(*p)) break;
	nchar++;
	if (*++p != (c = getc(stream))) {
	  ungetc(c, stream);
	  return count;
	}
      }
    } else {
      q = p;
      p = parse_format(p, &info);

      if (!p) return count;

      switch (*p) {
       case 'd':
       case 'i':
	n = _scanf_long (stream, info, 0, &l);
	if (n == EOF) return EOF;
	if (n == 0) return count;
	count++;

	nchar += n;

	if (info.size == Regular)
	 *va_arg(args, int *) = l;
	else if (info.size == Small)
	 *va_arg(args, short *) = l;
	else if (info.size == Long)
	 *va_arg(args, long *)  = l;
	else if (info.size == Supress)
	 ;				/* ignore */
	else
	 return count;
	break;

       case 'u':
	n = _scanf_ulong(stream, info, 0, &ul);
	if (n == EOF) return EOF;
	if (n == 0) return count;

	count++;

	nchar += n;
				
	if (info.size == Regular)
	 *va_arg(args, unsigned int *) = ul;
	else if (info.size == Small)
	 *va_arg(args, unsigned short *) = ul;
	else if (info.size == Long)
	 *va_arg(args, unsigned long *) = ul;
	else if (info.size == Supress)
	 ;					/* ignore */
	else
	 return count;

	break;

       case 'o':
	n = _scanf_ulong(stream, info, 8, &ul);
	if (n == EOF) return EOF;
	if (n == 0) return count;

	count++;

	nchar += n;
				
	if (info.size == Regular)
	 *va_arg(args, unsigned int *) = ul;
	else if (info.size == Small)
	 *va_arg(args, unsigned short *) = ul;
	else if (info.size == Long)
	 *va_arg(args, unsigned long *) = ul;
	else if (info.size == Supress)
	 ;					/* ignore */
	else
	 return count;

	break;

       case 'x':
       case 'X':
       case 'p':
	n = _scanf_ulong(stream, info, 16, &ul);
	if (n == EOF) return EOF;
	if (n == 0) return count;

	count++;

	nchar += n;

	if (info.size == Regular)
	 *va_arg(args, unsigned int *) = ul;
	else if (info.size == Small)
	 *va_arg(args, unsigned short *) = ul;
	else if (info.size == Long)
	 *va_arg(args, unsigned long *) = ul;
	else if (info.size == Supress)
	 ;				/* ignore */
	else
	 return count;

	break;

       case 'e':
       case 'E':
       case 'f':
       case 'g':
       case 'G':
	n = _scanf_double(stream, info, &d);
	if (n == EOF) return EOF;
	if (n == 0) return count;

	count++;

	nchar += n;

	if (info.size == Regular)
	 *va_arg(args, float *) = d;
	else if (info.size == Long)
	 *va_arg(args, double *) = d;
	else if (info.size == LongDouble)
	 *va_arg(args, long double *) = d;
	else if (info.size == Supress)
	 ;				/* ignore */
	else
	 return count;
	break;

       case 's':
	n = _scanf_string(stream, info, va_arg(args, char *));
	if (n == EOF) return EOF;
	if (n == 0) return count;

	count++;

	nchar += n;
	break;

       case ']':
	n = _scanf_chars (stream, info, q, p, va_arg(args, char *));
	if (n == EOF) return EOF;
	if (n == 0) return count;

	count++;

	nchar += n;
	break;

       case 'c':
	r = va_arg(args, char *);

	while (info.width-- > 0) {
	  int c = getc (stream);
	  if (c == EOF) return EOF;
	  nchar++;
	  *r++ = c;
	  count++;
	}
	break;

       case 'n':
	*va_arg(args, int *) = nchar;
	break;

       case '%':
	{
	  int c = getc(stream);
	  if ('%' != c) {
	    ungetc(c, stream);
	    return count;
	  }
	  nchar++;
	}
	break;

       default:
	return count;
	break;
      }
    }
  }

  return count;
}
