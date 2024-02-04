#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include "handle.h"
#include "iob.h"

FILE *
fdopen(int fd, const char *mode)
{
  FILE *fp;

  if ((mode[0] != 'r') && (mode[0] != 'w') && (mode[0] != 'a'))
   return NULL;

  if (fd < 0) return NULL;

  fp = get_free_file_structure();

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
   case 'w':	case 'r':
    break;
   case 'a':
    lseek(fd, 0L, 2);
    break;
   default:
    return NULL;
  }

  fp->_file   = fd;
  fp->_bufsiz = 0;
  fp->_cnt    = 0;
  fp->_base   = NULL;
  fp->_ptr    = NULL;
  fp->_flag   = (*mode == 'r') ? _IOREAD : _IOWRITE;

  if ((mode[1] == '+') || (mode[2] == '+'))
   fp->_flag |= (_IOREAD | _IOWRITE);

  return fp;
}
