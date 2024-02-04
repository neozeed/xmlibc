#include <sys/extender.h>

void
_exit(int status)
{
  _dos_exit(status);
}
