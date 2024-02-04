#include <stdlib.h>
#include <stdio.h>
#include "handle.h"
#include "iob.h"

FILE *
fopen(const char *filename, const char *mode)
{
  register FILE  *fp;

  fp = get_free_file_structure();

  if (fp == NULL) return NULL;

  fp = freopen(filename, mode, fp);

  if (fp == NULL) return NULL;

  return fp;
}