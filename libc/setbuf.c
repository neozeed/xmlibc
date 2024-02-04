#include <stdlib.h>
#include <stdio.h>

int
setvbuf(FILE *stream, char *buf, int mode, size_t size)
{
  unsigned char	*p;

  size = (size > 0) ? size: 1;

  if(buf == NULL) {
    p = (unsigned char *) malloc (size);
    if (p == NULL) return !0;
  } else {
    p = (unsigned char *) buf;
    stream->_flag |= _SETBUF;
  }

  if((stream->_base != NULL) && ((stream->_flag & _SETBUF) != _SETBUF)) {
    free(stream->_base);
  }

  stream->_base   =
  stream->_ptr    = p;
  stream->_bufsiz = size;
  stream->_flag   &= ~(_IONBF | _IOLBF | _IOFBF);
  stream->_flag   |= mode & (_IONBF | _IOLBF | _IOFBF);
  stream->_cnt    = 0;

  return 0;
}

void
setbuf(FILE *stream, char *buf)
{
  if(buf == NULL)
   setvbuf(stream, buf, _IONBF, 1);
  else
   setvbuf(stream, buf, _IOFBF, BUFSIZ);
}

void
setbuffer(FILE *stream, char *buf, int size)
{
  stream->_bufsiz = size;
  stream->_cnt    = 0;
  stream->_base   = (unsigned char *) buf;
  stream->_ptr    = (unsigned char *) buf;
}
