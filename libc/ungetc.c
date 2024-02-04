#include <stdlib.h>
#include <stdio.h>

int
ungetc(int c, FILE* stream)
{
  if (c == EOF) return EOF;

  if (!(stream->_flag & _IOREAD)) return EOF;

  clearerr(stream);

  if (stream->_base) {
    stream->_cnt++;
    stream->_ptr--;
    *stream->_ptr = c;
  } else {
    if (!stream->_bufsiz)
     stream->_bufsiz = (stream->_flag & _IONBF)? 1: BUFSIZ;

    stream->_ptr = stream->_base = malloc(stream->_bufsiz);

    if (stream->_base == NULL) return EOF;

    stream->_cnt  = 1;
    *stream->_ptr = c;
  }

  return c;
}