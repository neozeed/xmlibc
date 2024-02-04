#include <stdlib.h>
#include <strings.h>
#include <sys/extender.h>

char *
getcwd(char *buf, size_t n)
{
  char buffer[64];

  if (!buf) buf = malloc(n);

  _dos_get_current_directory(0, buffer);

  if ((strlen(buffer) + 1) > n) {
/*  errno = ERROR;	*/
    return NULL;
  }

  buf[0] = '/';
  strcpy(&buf[1], _change_path_char(buffer, '/'));

  return buf;
}
