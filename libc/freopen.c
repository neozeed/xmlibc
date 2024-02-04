#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <strings.h>
#include "handle.h"
#include "iob.h"

FILE *
freopen(const char *filename, const char *mode, FILE *fp)
{
  fclose(fp);

  switch (*mode) {
   case 'w':
    if (index(mode, '+')) {
      if ((fp->_file = open (filename, O_RDWR, 0)) < 0)
       fp->_file = creat (filename, PERM);
    } else
     fp->_file = creat (filename, PERM);
    break;

   case 'a':
    if (index(mode, '+')) {
      if ((fp->_file = open (filename, O_RDWR, 0)) < 0)
       fp->_file = creat (filename, PERM);
    } else {
      if ((fp->_file = open (filename, O_WRONLY, 0)) < 0)
       fp->_file = creat (filename, PERM);
    }
    lseek(fp->_file, 0L, 2);
    break;

   case 'r':
    if (index(mode, '+')) {
      if ((fp->_file = open(filename, O_RDWR, 0)) < 0)
       fp->_file = creat (filename, PERM);
    } else
     fp->_file = open (filename, O_RDONLY, 0);
    break;

   default:
    fp->_file = -1;
    break;
  }

  if (fp->_file < 0) {
    fp->_file = -1;
    return NULL;
  }

  if ((mode[1] == 'b') || (mode[2] == 'b'))
   _binary_mode(fp->_file);
  else if ((mode[1] == 't') || (mode[2] == 't'))
   _text_mode(fp->_file);
  else if (_fmode & _F_BINARY)
   _binary_mode(fp->_file);
  else if (_fmode & _F_TEXT)
   _text_mode(fp->_file);
  else
   _text_mode(fp->_file);

  switch (*mode) {
   case 'r':
    fp->_flag = _IOREAD;
    break;
   case 'w':
    fp->_flag = _IOWRITE;
    break;
   case 'a':
    fp->_flag = _IOREAD | _IOWRITE | _IOAPPEND;
    break;
   default:
    return NULL;
    break;
  }
  if (index(mode, '+'))
   fp->_flag |= (_IOWRITE | _IOREAD);

  fp->_cnt    = 0;
  fp->_ptr    = NULL;
  fp->_base   = NULL;
  fp->_bufsiz = 0;

  return fp;
}