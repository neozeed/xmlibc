#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/extender.h>

int
stat(const char *p, struct stat *buf)
{
  char *path;
	
  path = _msdos_filename(p);

  {
    int fd;

    if ((fd = open (path, O_RDONLY, 0)) < 0) {
      errno = _dos_errno;
      return -1;
    }

    if (_legal_fd(fd)) {
      errno = _dos_errno;
      return -1;
    }

    close (fd);
  }

  buf->st_dev	= 0;
  buf->st_ino	= 0;
  buf->st_mode	= _get_file_mode(path) | _get_file_type(path);
  buf->st_nlink	= 1;
  buf->st_uid	= 0;
  buf->st_gid	= 0;
  buf->st_rdev	= 0;
  buf->st_size	= _get_file_size(path);
  buf->st_atime	=
  buf->st_mtime	=
  buf->st_ctime	= _get_file_time(path);

  free(path);

  return 0;
}
