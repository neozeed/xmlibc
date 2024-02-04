#include <stdlib.h>
#include "handle.h"

int _handle_mode[20] = {
  _TEXT,	/* fileno(stdin)  */
  _TEXT,	/* fileno(stdout) */
  _TEXT,	/* fileno(stderr) */
  _TEXT,	/* fileno(stdprn) */
  _TEXT,	/* fileno(stdaux) */
};

int
_istext(int handle)
{
  return (_handle_mode[handle] == _TEXT);
}

void
_text_mode(int handle)
{
  _handle_mode[handle] |= _TEXT;
}

void
_binary_mode(int handle)
{
  _handle_mode[handle] &= ~_TEXT;
}
