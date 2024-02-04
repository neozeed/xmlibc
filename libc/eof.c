#include <sys/extender.h>

_eof(int fd)
{
  if (_file_p(fd) && (_dos_get_input_status(fd) == 0))
   return 1;
  return 0;
}
