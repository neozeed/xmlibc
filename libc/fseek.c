#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/file.h>

int
fseek(FILE *stream, long int offset, int orig)
{
  int position;

  if (!stream || !_file_p(fileno(stream))) return !0;

  fflush(stream);

  position = lseek(fileno(stream), offset, orig);

  stream->_cnt  = 0;
  stream->_ptr  = stream->_base;
  stream->_flag &= ~_IOEOF;

  if (position < 0) return !0;

  return 0;
}
