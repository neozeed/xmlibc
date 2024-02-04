#include <sys/file.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

FILE _iob[FOPEN_MAX] = {
  { 0, NULL, NULL, 0, _IOREAD | _IOLBF, 0 },
  { 0, NULL, NULL, 0, _IOWRITE| _IOLBF, 1 },
  { 0, NULL, NULL, 0, _IOWRITE| _IOLBF, 2 },
  { 0, NULL, NULL, 0, _IOREAD | _IOWRITE | _IOFBF, 3 },
  { 0, NULL, NULL, 0, _IOWRITE| _IOFBF, 4 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
  { 0, NULL, NULL, 0, 0, -1 },
};


static int
readline(int fd, unsigned char *buf, int nbytes)
{
  unsigned char *p;
  int  nread;

  for (p = buf; nbytes > 0; nbytes -= nread) {
    nread = _raw_read(fd, (char *) p, 1);

/* ERROR */
    if (nread < 0)  return -1;

    if (_eof(fd) && (nread > 0) && (p[nread - 1] == '\x1a'))
     nread--;

/* EOF */
    if (nread == 0) return p - buf;

    p += nread;
    if (p[-1] == '\n') return p - buf;
  }

  return p - buf;
}

int
_fillbuf(FILE *fp)
{
  if (fp->_flag & _IOSTRING) {
    fp->_flag |= _IOEOF;
    fp->_cnt  = 0;
    return EOF;
  }

  if ((fp->_flag & (_IOEOF| _IOERR)) || !(fp->_flag & _IOREAD))
   return EOF;

/* set up stream */
  if (fp->_bufsiz == 0) {
    fp->_bufsiz = (fp->_flag & _IONBF)? 1: BUFSIZ;

    fp->_base = fp->_ptr = malloc(fp->_bufsiz);
    if (fp->_base == NULL)
     return EOF;
  }

  fp->_ptr = fp->_base;

  if ((fp->_flag & _IOLBF) == _IOLBF)
   fp->_cnt = readline(fileno(fp), (unsigned char *) fp->_base, fp->_bufsiz);
  else
   fp->_cnt = _raw_read(fileno(fp), (unsigned char *) fp->_base, fp->_bufsiz);

  if (fp->_cnt > 0) {
    fp->_flag |= _IODIR_IN;
    return getc(fp);
  }

  fp->_flag |= ((fp->_cnt == 0)? _IOEOF: (_IOEOF | _IOERR));
  fp->_cnt = 0;

  return EOF;
}

int
_flushbuf(int c, FILE *fp)
{
  if (fp->_flag & _IOSTRING) {
    fp->_flag |= _IOERR;
    fp->_cnt  = 0;
    return EOF;
  }

  if ((fp->_flag & _IOERR) || !(fp->_flag & _IOWRITE))
   return EOF;

  /* set up stream */
  if (!fp->_bufsiz)
   fp->_bufsiz = (fp->_flag & _IONBF)? 1: BUFSIZ;

  if (!fp->_base) {
    fp->_base = fp->_ptr = (unsigned char *) malloc (fp->_bufsiz);
    fp->_cnt  = fp->_bufsiz;
  }

  if (fp->_ptr < fp->_base || !fp->_base || !fp->_ptr) {
    fp->_flag |= _IOERR;
    return EOF;
  }

  if (fp->_flag & _IOAPPEND)
   lseek(fileno(fp), 0L, L_XTND);

  write(fileno(fp), (char *) fp->_base, fp->_ptr - fp->_base);
  fp->_cnt = fp->_bufsiz;
  fp->_ptr = fp->_base;

  return putc(c, fp);
}
