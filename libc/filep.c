#include <sys/extender.h>

int
_file_p(int fd)
{
  if (_dos_get_device_infomation(fd) & (1 << 7))
   return 0;
  return 1;
}
