#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include "handle.h"
#include "iob.h"

int
fclose(FILE *fp)
{
  int fd;

  if (!fp) return EOF;

  if (fp->_flag & _IOWRITE)
   fflush(fp);

  if (!(fp->_flag & _SETBUF))
   free(fp->_base);

  fd = fp->_file;

  fp->_bufsiz = fp->_cnt = fp->_flag = 0;
  fp->_ptr  = fp->_base = NULL;
  fp->_file = -1;

  if (close(fd) < 0)
   return EOF;

  return 0;
}