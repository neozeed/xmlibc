/* Size of rel file utility (`size') for GNU.
   Copyright (C) 1986 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 1, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */

#include <stdio.h>
#include <ar.h>
#include <sys/types.h>
#include <sys/file.h>

#ifdef COFF_ENCAPSULATE
#include "a.out.encap.h"
#else
/* On native BSD systems, use the system's own a.out.h.  */
#ifdef TOWNS
#include <a_out.h>
#else
#include <a.out.h>
#endif /* TOWNS */
#endif

#ifdef USG
#include <fcntl.h>
#include <string.h>
#else
#include <strings.h>
#endif

/* Struct or union for header of object file.  */

#define HEADER_TYPE struct exec

/* Number of input file names specified.  */

int number_of_files;

/* Current file's name */

char *input_name;

/* Current member's name, or 0 if processing a non-library file.  */

char *input_member;

/* Offset within archive of the current member,
   if we are processing an archive.  */

int member_offset;

void do_one_file (), do_one_rel_file ();
char *concat ();

main (argc, argv)
     char **argv;
     int argc;
{
  int i;

  number_of_files = argc - 1;

  printf ("text\tdata\tbss\tdec\thex\n");

  /* Now scan and describe the files.  */

  if (number_of_files == 0)
    do_one_file ("a.out");
  else
    for (i = 1; i < argc; i++)
      do_one_file (argv[i]);
}

/* Print the filename of the current file on 'outfile' (a stdio stream).  */

print_file_name (outfile)
     FILE *outfile;
{
  fprintf (outfile, "%s", input_name);
  if (input_member)
    fprintf (outfile, "(%s)", input_member);
}

/* process one input file */
void scan_library ();

void
do_one_file (name)
     char *name;
{
  int len, desc;
  struct exec hdr;

  desc = open (name, O_RDONLY, 0);

  if (desc < 0)
    {
      perror_name (name);
      return;
    }

  input_name = name;
  input_member = 0;

#ifdef HEADER_SEEK_FD
  /* Skip the headers that encapsulate our data in some other format
     such as COFF.  */
  HEADER_SEEK_FD (desc);
#endif
  len = read (desc, &hdr, sizeof hdr);
  if (len != sizeof hdr)
    error_with_file ("failure reading header");
  else if (!N_BADMAG (hdr))
    do_one_rel_file (desc, 0);
  else
    {
      char armag[SARMAG];

      lseek (desc, 0, 0);
      if (SARMAG != read (desc, armag, SARMAG) || strncmp (armag, ARMAG, SARMAG))
	error_with_file ("malformed input file (not rel or archive)");
      else
        scan_library (desc);
    }

  close (desc);
}

/* Read in the archive data about one member.
   subfile_offset is the address within the archive of the start of that data.
   The value returned is the length of the member's contents, which does
   not include the archive data about the member.

   If there are no more valid members, zero is returned.  */

int
decode_library_subfile (desc, subfile_offset)
     int desc;
     int subfile_offset;
{
  int bytes_read;
  int namelen;
  int member_length;
  char *name;
  struct ar_hdr hdr1;

  lseek (desc, subfile_offset, 0);

  bytes_read = read (desc, &hdr1, sizeof hdr1);
  if (!bytes_read)
    ;		/* end of archive */

  else if (sizeof hdr1 != bytes_read)
    error_with_file ("malformed library archive");

  else if (sscanf (hdr1.ar_size, "%d", &member_length) != 1)
    error_with_file ("malformatted header of archive member");

  else
    {
      for (namelen = 0;
	   hdr1.ar_name[namelen] != 0
	   && hdr1.ar_name[namelen] != ' '
	   && hdr1.ar_name[namelen] != '/';
	   namelen++)
	;
      name = (char *) xmalloc (namelen+1);
      strncpy (name, hdr1.ar_name, namelen);
      *(name + namelen) = 0;

      input_member = name;

      return member_length;
    }
  return 0;   /* tell caller to exit loop */
}

/* Scan a library and describe each member.  */

void
scan_library (desc)
     int desc;
{
  int this_subfile_offset = SARMAG;
  int member_length;
  
  while (member_length = decode_library_subfile (desc, this_subfile_offset))
    {
      /* describe every member except the ranlib data if any */
      if (strcmp (input_member, "__.SYMDEF"))
	do_one_rel_file (desc, this_subfile_offset + sizeof (struct ar_hdr));

      this_subfile_offset += ((member_length + sizeof (struct ar_hdr)) + 1) & -2;
    }
}

void read_header ();

void
do_one_rel_file (desc, offset)
     int desc;
     int offset;
{
  HEADER_TYPE header;   /* file header read in here */
  int total;

  read_header (desc, &header, offset);

  if (N_BADMAG (header))
    {
      error_with_file ("bad magic number");
      return;
    }

  {
    int tsize, dsize, bsize;

    tsize = header.a_text;
    dsize = header.a_data;
    bsize = header.a_bss;
    total =  tsize + dsize + bsize;
    printf ("%d\t%d\t%d\t%d\t%x", tsize, dsize, bsize, total, total);
  }

  if (number_of_files > 1 || input_member)
    {
      printf ("\t");
      print_file_name (stdout);
    }
  printf ("\n");
}


/* read a file's header */

void
read_header (desc, loc, offset)
     int desc;
     HEADER_TYPE *loc;
     int offset;
{
  int len;

  lseek (desc, offset, 0);
#ifdef HEADER_SEEK_FD
  /* Skip the headers that encapsulate our data in some other format
     such as COFF.  */
  HEADER_SEEK_FD (desc);
#endif
  len = read (desc, loc, sizeof (struct exec));
  if (len != sizeof (struct exec))
    error_with_file ("failure reading header");
}

/* Report a fatal error.
   STRING is a printf format string and ARG is one arg for it.  */

fatal (string, arg)
     char *string, *arg;
{
  fprintf (stderr, "size: ");
  fprintf (stderr, string, arg);
  fprintf (stderr, "\n");
  exit (1);
}

/* Report a nonfatal error.
   STRING is a printf format string and ARG is one arg for it.  */

error (string, arg)
     char *string, *arg;
{
  fprintf (stderr, "size: ");
  fprintf (stderr, string, arg);
  fprintf (stderr, "\n");
}

/* Report a nonfatal error.
   STRING is printed, followed by the current file name.  */

error_with_file (string)
     char *string;
{
  fprintf (stderr, "size: ");
  print_file_name (stderr);
  fprintf (stderr, ": ");
  fprintf (stderr, string);
  fprintf (stderr, "\n");
}

/* Report an error using the message for the last failed system call,
   followed by the string NAME.  */

perror_name (name)
     char *name;
{
  extern int errno, sys_nerr;
  extern char *sys_errlist[];
  char *s;

  if (errno < sys_nerr)
    s = concat (name, ": ", sys_errlist[errno]);
  else
    s = concat (name, ": ", "unknown error");
  error (s, name);
}

/* Like malloc but get fatal error if memory is exhausted.  */

int
xmalloc (size)
     int size;
{
  int result = malloc (size);
  if (!result)
    fatal ("virtual memory exhausted", 0);
  return result;
}

/* Return a newly-allocated string
   whose contents concatenate those of S1, S2, S3.  */

char *
concat (s1, s2, s3)
     char *s1, *s2, *s3;
{
  int len1 = strlen (s1), len2 = strlen (s2), len3 = strlen (s3);
  char *result = (char *) xmalloc (len1 + len2 + len3 + 1);

  strcpy (result, s1);
  strcpy (result + len1, s2);
  strcpy (result + len1 + len2, s3);
  *(result + len1 + len2 + len3) = 0;

  return result;
}
