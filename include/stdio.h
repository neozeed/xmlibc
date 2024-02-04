#ifndef _STDIO_H
#define _STDIO_H

extern int _fmode;

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned long size_t;
#endif /* _SIZE_T */

typedef	long fpos_t;

typedef struct _iobuf {
  int  _cnt;
  unsigned char *_ptr;
  unsigned char *_base;
  int  _bufsiz;
  int  _flag;
  int  _file;
} FILE;

#define fileno(p)	((p)->_file)

#undef NULL
#define NULL		((void *) 0)

#define	EOF		(-1)
#define BUFSIZ		1024

#define SEEK_SET	0
#define SEEK_CUR	1
#define SEEK_END	2


#define FOPEN_MAX	20
#define FILENAME_MAX	128

#define L_tmpnam	13
#define TMP_MAX		25


extern FILE _iob[FOPEN_MAX];

#define stdin	(&_iob[0])
#define stdout	(&_iob[1])
#define stderr	(&_iob[2])
#define stdaux	(&_iob[3])
#define stdprn	(&_iob[4])

#define _IOFBF		(1 << 0)
#define _IOLBF		(1 << 1)
#define _IONBF		(1 << 2)
#define _IOREAD		(1 << 3)
#define _IOWRITE	(1 << 4)
#define _IOEOF		(1 << 5)
#define _IOERR		(1 << 6)
#define _IOSTRING	(1 << 7)
#define _IOAPPEND	(1 << 8)

#define _SETBUF		(1 << 30)	/* use setbuf and setvbuf */
#define _IODIR_IN	(1 << 31)	/* direction flag */

#define _F_BINARY	(1 << 0)	/* _fmode */
#define _F_TEXT		(1 << 1)	/* _fmode */

#define stdin	(&_iob[0])
#define stdout	(&_iob[1])
#define stderr	(&_iob[2])
#define stdaux	(&_iob[3])
#define stdprn	(&_iob[4])


int  _fillbuf(FILE *);
int  _flushbuf(int, FILE *);
int  _istext(int);

#define feof(p)		(((p)->_flag & _IOEOF) != 0)
#define ferror(p)	(((p)->_flag & _IOERR) != 0)

#define putc(c, p)	fputc(c, p)
#define getc(p)		fgetc(p)

#define getchar()	getc(stdin)
#define putchar(c)	putc((c), stdout)

FILE  *tmpfile(void);
char  *tmpnam(char *);

int  remove(const char *);
int  rename(const char *, const char *);
int  unlink(const char *);

FILE  *fopen(const char *, const char *);
FILE  *freopen(const char *, const char *, FILE *);
FILE  *fdopen(int, const char *);
int  fclose(FILE *);

void  setbuffer(FILE *, char *, int);
void  setbuf(FILE *, char *);
int  setvbuf(FILE *, char *, int, size_t);
int  fflush(FILE *);

void  clearerr(FILE *);
void  perror(const char *);

int  fseek(FILE *, long int, int);
int  fgetpos(FILE *, fpos_t *);
int  fsetpos(FILE *, const fpos_t *);
long int  ftell(FILE *);
void  rewind(FILE *);

int  fgetc(FILE *);
char  *gets(char *);
char  *fgets(char *, int, FILE *);

int  scanf(const char *, ...);
int  fscanf(FILE *, const char *, ...);
int  sscanf(const char *, const char *, ...);

size_t  fread(void *, size_t, size_t, FILE *);

int  fputc(int, FILE *);
int  puts(const char *);
int  fputs(const char *, FILE *);

int  ungetc(int, FILE *);

int  printf(const char *, ...);
int  fprintf(FILE *, const char *, ...);
int  sprintf(char *, const char *, ...);

int  vprintf(const char *, char *);
int  vfprintf(FILE *, const char *, char *);
int  vsprintf(char *, const char *, char *);

size_t  fwrite(const void *, size_t, size_t, FILE *);

#endif
