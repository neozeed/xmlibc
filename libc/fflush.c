#include <stdio.h>
#include <fcntl.h>


int
_fflush()
{
    FILE *file;

    for (file = &_iob[0]; file <= &_iob[FOPEN_MAX]; file++)
     fflush(file);

    return 0;
}


int
fflush(FILE *fp)
{
  if (fp == NULL) return _fflush();

  if (!fp->_base || !fp->_ptr || fp->_base == fp->_ptr)
   return 0;

  if ((fp->_flag & _IOSTRING) || (fp->_ptr < fp->_base)) {
    fp->_flag |= _IOERR;
    return EOF;
  }

  if ((fp->_flag & _IOWRITE) && !(fp->_flag & _IODIR_IN)) {
    int nchars;
    int nwrites;

    nchars = fp->_ptr - fp->_base;
    nwrites = write(fileno(fp), (char *) fp->_base, nchars);

    if (nchars != nwrites) {
      fp->_flag |= _IOERR;
      return EOF;
    }
  } else if ((fp->_flag & _IOREAD) && (fp->_flag & _IODIR_IN)) {
    if (!_file_p(fileno(fp)))
     return 0;
    lseek(fileno(fp), -fp->_cnt, 1);
  } else
   return EOF;

  fp->_ptr  = fp->_base;
  fp->_cnt  = 0;

/* clear err flag */
  fp->_flag &= ~_IOERR;

/* clear direction flag */
  fp->_flag &= ~_IODIR_IN;

  return 0;
}