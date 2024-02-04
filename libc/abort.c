#include <stdlib.h>
#include <stdio.h>

void
abort(void)
{
  fputs("\n\nprogram aborted.\n", stderr);
  exit(EXIT_FAILURE);
}


void
_abort(const char *message, int code)
{
  fputs(message, stderr);
  exit(code);
}
