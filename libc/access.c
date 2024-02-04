#include <sys/stat.h>
#include <strings.h>
#include <stdlib.h>
#include <fcntl.h>

int
access(const char *path, int mode)
{
  struct stat  buf;

  if (!stat(path, &buf)) {
    int file_mode = (R_OK | W_OK) & mode;

    if (X_OK & mode) {
      if (strcmp(rindex(path, '.'), ".exe") &&
	  strcmp(rindex(path, '.'), ".com") &&
	  strcmp(rindex(path, '.'), ".bat"))
	return -1;
    } else if ((buf.st_mode & file_mode) != file_mode) {
      return -1;
    }

    return 0;
  }

  return -1;
}
