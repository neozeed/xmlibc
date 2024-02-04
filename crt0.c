/*
 *  crt0.c	c runtime routine.
 */
#include <stdio.h>
#include <ctype.h>
#include <strings.h>
#include <sys/extender.h>

#ifdef __GNUC__
#define alloca(x) __builtin_alloca(x)
#endif

#define NULL	((void *) 0)

#define LSEG_PSP2		(_dos_get_psp_address())
#define LSEG_CODE_READ_WRITE	(_get_ds())
#define LSEG_CODE_READ_ONLY	(_get_cs())

/* environment variable list */
char  **environ;

/* for clock */
unsigned long  _start_time;
unsigned long  _start_subsec_time;

/* global variables */
int  _dos_errno;
int  _dos_errclass;
int  _dos_errsugested;
int  _dos_errlocus;

extern char  etext;
extern char  edata;
extern char  end;

extern void  *malloc (int);
extern void  *realloc(void *, int);
extern long  time    (long *);

static __inline__ char		*strsave(const char *);
static __inline__ unsigned long	_get_esp();
static __inline__ void		_set_esp(unsigned long);
static __inline__ const char	*savearg(const char *, int);
static __inline__ const char	*find(const char *, int);
static __inline__ char		*skip_space(const char *);
static __inline__ char		*next_arg(const char *, const char **);
static __inline__ void		make_argument_list(int *, char **[], char *);
static __inline__ int		isoctal(int);

void _start(void);


static __inline__ char *
strsave(const char *str)
{
  return strcpy (malloc (strlen(str) + 1), str);
}

static __inline__ unsigned long
_get_cs()
{
  unsigned short cs;

  asm("movw %%cs,%0": "=r"(cs): /* no */);

  return cs;
}

static __inline__ unsigned long
_get_ds()
{
  unsigned short ds;

  asm("movw %%ds,%0": "=r"(ds): /* no */);

  return ds;
}


static __inline__ unsigned long
_get_esp()
{
  unsigned long  esp;

  asm("movl %%esp,%0": "=r"(esp): /* no */);

  return esp;
}

static __inline__ void
_set_esp(unsigned long sp)
{
  asm("movl %0,%%esp": /* no */: "r"(sp));
}

static __inline__ int
isoctal(int c)
{
  if (('0' <= c) && (c < '8'))
   return 1;
  return 0;
}

static __inline__ const char *
savearg(const char *s, int n)
{
  const char *p;
  const char *q;
  char *buf;
  char *r;

  if ((('\'' == s[0]) || ('"' == s[0])) && (s[0] == s[n - 1]) && (n > 1))
    s++, n -= 2;

  buf = malloc (n + 1);

  for (p = s, q = p + n, r = buf; p < q; p++) {
    if (p[0] != '\\')
     *r++ = *p;
#ifdef EXPAND_ESCAPE_SEQUENCE
    else if (tolower(p[1]) == 'x') {
     if (isxdigit(p[2]) && isxdigit(p[3]))
      *r++ = (toupper(p[2]) - '0') * 0x10 + (toupper(p[3]) - '0'), p += 3;
    else if (isxdigit(p[2]))
     *r++ = (toupper(p[2]) - '0'), p += 2;
    else
     *r++ = p[1], p++;
    } else if (p[1] == '0') {
     if (isoctal(p[2]) && isoctal(p[3]) && isoctal(p[4]))
      *r++ = (p[2] - '0') * 0100 + (p[3] - '0') * 010 + (p[4] - '0'), p += 4;
     else if (isoctal(p[2]) && isoctal(p[3]))
      *r++ = (p[2] - '0') * 010 + (p[3] - '0'), p += 3;
     else if (isoctal(p[2]))
      *r++ = (toupper(p[2]) - '0'), p += 2;
     else
      *r++ = p[1], p++;
    }
#endif
    else
     *r++ = p[1], p++;
  }

  r[0] = '\0';

  return buf;
}

static __inline__ const char  *
find(const char *string, int c)
{
  const char *p = string;

  for ( ; *p != (unsigned char) c; p++)
    if (p[0] == '\\' && p[1])
     p++;
    else if (!*p)
     return NULL;

  return (char *) p;
}

static __inline__ char *
skip_space(const char *s)
{
  while (isspace(*s))
   s++;

  return (char *) s;
}

static __inline__ char *
next_arg(const char *string, const char **endp)
{
  const char *cur = string;
  const char *end;
  const char *start;

  while (isspace(*cur))
   cur++;

  if (!*cur) return (char *) 0;

  start = cur;

  if (((*cur == '\'') || (*cur == '"')) && (end = find(&cur[1], *cur)))
   cur = end + 1;
  else
   while (*cur && !isspace(*cur))
    cur++;

  *endp = cur;

  return (char *) start;
}

void
start()
{
/* set esp */
  _set_esp((_peek_longword(LSEG_PSP2, 0x60) - 4) & ~0xf);

/* call start up code */
  _start();
}

void
_start_fixed_stack()
{
  unsigned long  pages = (_get_esp() + 0xfff) / 0x1000;

/* free real memory */
/* I don't know how to get free real memory size */

/* free native memory */
  _dos_adjust_memory_block_size(LSEG_CODE_READ_ONLY, pages);

/* call start up code */
  _start();
}

void
_start()
{
  char *param;
  char *work;
  int  index;
  char **argv;
  char **envp;
  int  argc;
  int  len;

/* clear BBS */
  bzero(&edata, &end - &edata);

/* set start time */
  _start_time = _subsec_time(&_start_subsec_time);

/* parameter */
  len = _peek_byte(LSEG_PSP2, 0x80);
  param = (char *) malloc(len + 1);
  _memcpyfar(LSEG_PSP2, 0x81, LSEG_CODE_READ_WRITE, (int) param, len);

  param[len] = '\0';

/* default size */
  argc = 1;
  argv = malloc(2 * sizeof(char *));

/* Make argv[] */
  make_argument_list(&argc, &argv, param);

/* End of argument */
  argv[argc] = (void *)0;

/* environment */
  {
    int size;
    int index;
    char *env;
    char *p;

    envp = malloc(2 * sizeof(char *));
    size = _envsize();
    env  = malloc(size);
    _envcpy(env, size);

    for(p = env, index = 0; ; index++) {
      envp = realloc ((void *) envp, (index + 2) * sizeof(char *));
      if (!*p) break;
      envp[index] = p;
      p += (strlen(envp[index]) + 1);
    }

    envp[index] = 0;
    argv[0] = p + 3;
  }

  environ = envp;
  exit(main(argc, argv, envp));
}

static __inline__ void
make_argument_list(int *argc, char **argv[], char *string)
{
  const char *startp;
  const char *endp;
  const char *work;
  int  arglen;

  for (work = string; startp = next_arg(work, &endp);) {
    if (!startp) break;

    work = endp;
    arglen = endp - startp;

    if (startp[0] == '@') {
      int  fd, size;
      char *buf, *name;

      name = alloca(arglen);
      strncpy(name, &startp[1], arglen);
      name[arglen - 1] = '\0';

      fd   = open(name, 0);
      size = _fget_file_size(fd);
      buf  = alloca(size + 1);

      if (!_file_p(fd)) {
        fputs("Respose file '", stderr);
        fputs(name, stderr);
	fputs("' not found.\n", stderr);
        abort();
      }

      size = read(fd, buf, size);
      if (buf[size - 1] == '\032')
       size--;
      buf[size] = '\0';

      make_argument_list(argc, argv, buf);

      close(fd);
    } else {
      *argv = realloc (*argv, (*argc + 2) * sizeof(char *));
      (*argv)[*argc] = (char *) savearg(startp, arglen);
      (*argc)++;
    }
  }

  return;
}