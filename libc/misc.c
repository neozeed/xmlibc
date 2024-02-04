#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <strings.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <sys/extender.h>

char *
_msdos_filename(const char *path)
{
  char *p;

  p = malloc(strlen(path) + 1);
  strcpy(p, path);

  return _change_path_char(p, '\\');
}

char *
_change_path_char(char *path, char pathchar)
{
  char *p = path;
  char ch = (pathchar == '\\')? '/': '\\';

  while (*p) {
    if (*p == ch)
    *p = pathchar;
    p++;
  }

  return path;
}

int
_legal_fd(int fd)
{
  if (_dos_get_device_infomation(fd) < 0) {
    errno = _dos_errno;
    return -1;
  }
  return 0;
}

int
_get_file_size(const char *path)
{
  int fd;
  int size;

  if ((fd = open(path, O_RDONLY)) < 0)
   return -1;

  size = _fget_file_size(fd);

  close(fd);

  return size;
}


int
_fget_file_size(int fd)
{
  long pos;
  long siz;

  pos = tell(fd);
  siz = lseek(fd, 0, L_XTND);
  lseek(fd, pos, L_SET);

  return siz;
}

int
_get_file_type(const char *filename)
{
  int fd;
  int mode;

  if ((fd = open(filename, O_RDONLY)) < 0)
   return -1;

  mode = _fget_file_type(fd);

  close (fd);

  return mode;
}

int
_fget_file_type(int fd)
{
  int ftype;
  int mode  = 0;

  ftype = _dos_get_device_infomation(fd);

  if ((ftype & 0x80) == 0)
   mode = S_IFCHR;
  else
   mode = S_IFREG;

  return mode;
}
