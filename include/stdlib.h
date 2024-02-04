#ifndef _STDLIB_H
#define _STDLIB_H

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned long size_t;
#endif /* _SIZE_T */

#ifndef _WCHAR_T
#define _WCHAR_T
typedef int wchar_t;
#endif /* _WCHAR_T */

typedef struct {
  int  quot;
  int  rem;
} div_t;

typedef struct {
  long int  quot;
  long int  rem;
} ldiv_t;

#undef NULL
#define NULL	((void *) 0)

#define RAND_MAX	32767
#define MB_CUR_MAX	2

#define EXIT_SUCCESS	0
#define EXIT_FAILURE	33

int  mblen(const char *, size_t);
int  wctomb(char *, wchar_t);
int  mbtowc(wchar_t *, const char *, size_t);

size_t  wcstombs(char *, const wchar_t *, size_t);
size_t  mbstowcs(wchar_t *, const char *, size_t);

void  abort(void);
void  exit(int);
void  _exit(int);
int  atexit(void (*func)(void));

char  *getenv(const char *);
int  system(const char *);

void  *malloc(size_t);
void  *calloc(size_t, size_t);
void  *realloc(void *, size_t);
void  free(void *);

int  atoi(const char *);
long int  atol(const char *);
double  atof(const char *);
double  strtod(const char *, char **);
long int  strtol(const char *, char **, int);
unsigned long int  strtoul(const char *, char **, int);

int  abs(int);
long int labs(long int);

int  rand(void);
void  srand(unsigned int);

void  *bsearch(const void *, const void *, size_t, size_t, int (*)(const void *, const void *));
void  qsort(void *, size_t, size_t, int (*)(const void *, const void *));

/* System depend functions. */
int  chdir(const char *);
int  chmod(const char *, int);
char  *getcwd(char *, size_t);
int  getpagesize(void);
char  *mktemp(char *);

#if 1
char  *_msdos_filename(const char *);
char  *_change_path_char(char *, char);
int  _legal_fd(int);
int  _file_p(int);
int  _eof(int);
int  _get_file_size(const char *);
int  _fget_file_size(int);
int  _get_file_type(const char *);
int  _fget_file_type(int);
int  _get_file_mode(const char *);
void  _text_mode(int);
void  _binary_mode(int);
int  _raw_read(int, unsigned char *, int);
void  _flush_all_stream(void);
void  _close_all_stream(void);
int  _mjd(int, int, int);
int  _dayofweek(int);
unsigned long int _get_file_time (char *);
unsigned long int _fget_file_time(int);
#endif

#endif
