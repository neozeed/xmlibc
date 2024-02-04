#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

size_t
fread(void *ptr, size_t size, size_t n, FILE *stream)
{
  int total = size * n, nread;

  if (total == 0)
   return 0;

  if (_file_p(fileno(stream))) {
    fseek(stream, 0L, SEEK_CUR);	/* Set file pointer */

    nread = read(fileno(stream), ptr, total);

    if (nread < 0)  stream->_flag |= _IOERR;
    if (nread == 0) stream->_flag |= _IOEOF;
    if (nread != total)
     return (nread? (total / size): 0);
  } else {
    int i;
    char c;
    char *p = ptr;

    for (i = 0; i < total; i++) {
      if (EOF == (c = getc(stream))) {
        stream->_flag |= _IOEOF;
        break;
      }
      p[i] = c;
    }

    n = i / size;
  }

  return n;
}
