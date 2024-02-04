#include <stdlib.h>
#include <sys/extender.h>

void
exit(int status)
{
/*  _do_atexit();	/* run atexit routines */
  _cleanup();
  _exit(status);
}
