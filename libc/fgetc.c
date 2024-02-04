#include <stdio.h>

int
fgetc(FILE *stream)
{
  int c;

  do {
    c = (--stream->_cnt >= 0)?
     (int) *stream->_ptr++:
     _fillbuf(stream);
  } while ((c == '\r') && _istext(fileno(stream)));

  return c;
}