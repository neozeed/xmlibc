#include <stdlib.h>
#include <stdio.h>

void
clearerr(FILE *stream)
{
  stream->_flag &= ~(_IOEOF | _IOERR);
}
