#include <stdio.h>

int
fputc(int c, FILE *stream)
{
  if (--stream->_cnt >= 0) {
    *stream->_ptr++ = (unsigned char) c;
    if ((c == '\n') && (stream->_flag & _IOLBF)) fflush(stream);
  } else
   _flushbuf((unsigned char) c, stream);

  return c;
}
