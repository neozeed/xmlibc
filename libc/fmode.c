/*

  default file open mode.

  mode:

    for open
	O_TEXT, O_BINARY

    for fopen, freopen, fdopen, etc.
	_F_TEXT, _F_BINARY

*/

#include <fcntl.h>

int _fmode = 0;
