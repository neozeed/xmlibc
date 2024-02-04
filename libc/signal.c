#include <stdlib.h>
#include <signal.h>

void (*signal (int sig, void (*func)(int)))(int)
{
  /* Not Support. */

  return SIG_ERR;
}