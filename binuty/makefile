include ../makerule.gcc

CC	= $(LD) $(LDFLAGS) /gnu/usr/lib/crt0.o

# Makefile for GNU binary-file utilities
# select a set of CFLAGS and PROGS, below, depending on the system type
# Copyright (C) 1989, Free Software Foundation, Inc.
#
# This file is part of GNU CC.
# 
# GNU CC is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 1, or (at your option)
# any later version.
# 
# GNU CC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with GNU CC; see the file COPYING.  If not, write to
# the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.


GNUCC = gcc -O

# for BSD systems
CFLAGS = -g
# Don't add robotussin; it won't compile on BSD or GNU systems.
# objdump also won't compile on most systems (trouble with N_DATADDR).
#PROGS = $(archpfx)gprof $(archpfx)ld $(archpfx)size \
#        $(archpfx)nm $(archpfx)strip $(archpfx)ar $(archpfx)ranlib
PROGS =  $(archpfx)ld.exp $(archpfx)size.exp \
        $(archpfx)nm.exp $(archpfx)ar.exp \
        $(archpfx)objdump.exp

# for USG systems using COFF_ENCAPSULATE
# also, you will want to make the target libc.a (but it takes a long time)
# Note that you should leave a copy of `ar' in this directory
# after you install it, since `ranlib' will try to run it from here.
#CFLAGS = -g -DUSG -DCOFF_ENCAPSULATE -DPORTAR -DNON_NATIVE
#PROGS = ld size nm strip ar robotussin objdump ranlib gprof
# On ALTOS systems, add -DALTOS to CFLAGS.

#it's better to move a copy of alloca into your libc than to risk getting some
#incompatiable functions from -lPW (like index()), but if you
#want to be lazy, uncomment this line
#LIBS = -lPW
LIBS = $(LIBS) $(CLIB)

# For HP-UX systems
# Don't add robotussin; use hpxt instead.
# Note that you should leave a copy of `ar' in this directory
# after you install it, since `ranlib' will try to run it from here.
#CFLAGS = -g -Ihp-include -DUSG -DNON_NATIVE
#PROGS = ld size nm strip ar ranlib
#LIBS = alloca.o

# Use the GNU getopt unless you have problems with it.
GNU_GETOPT = $(archpfx)getopt.o
GNU_GETOPT_LONG = $(archpfx)getopt.o $(archpfx)getopt1.o

all: $(PROGS)

ld: $(archpfx)ld.o
# LIBS is used here since ld needs to use alloca.
# Alternatively, compile it with GNU C--then the compiler handles alloca.
	$(CC) -o $(archpfx)ld $(archpfx)ld.o $(LIBS) 

$(archpfx)size: $(archpfx)size.o
	$(CC) -o $(archpfx)size $(archpfx)size.o $(LIBS)

$(archpfx)nm: $(archpfx)nm.o $(GNU_GETOPT_LONG)
	$(CC) -o $(archpfx)nm $(archpfx)nm.o $(LIBS) $(GNU_GETOPT_LONG) $(LIBS)

$(archpfx)strip: $(archpfx)strip.o $(GNU_GETOPT)
	$(CC) -o $(archpfx)strip $(archpfx)strip.o $(LIBS) $(GNU_GETOPT_LONG) $(LIBS)

$(archpfx)ar: $(archpfx)ar.o
	$(CC) -o $(archpfx)ar $(archpfx)ar.o $(LIBS)

$(archpfx)gprof: $(archpfx)gprof.o $(GNU_GETOPT_LONG)
	$(GNUCC) -o $(archpfx)gprof $(archpfx)gprof.o $(GNU_GETOPT_LONG)
$(archpfx)gprof.o: gprof.c gmon.h 
	$(GNUCC) -c $(CFLAGS) gprof.c $(OUTPUT_OPTION)

$(archpfx)ranlib: $(archpfx)ranlib.o
	$(CC) -o $(archpfx)ranlib $(archpfx)ranlib.o $(GNU_GETOPT_LONG)
$(archpfx)ranlib.o: ranlib.c
	$(CC) -c $(CFLAGS) -DAR_PROG=\"$(bindir)/ar\" ranlib.c $(OUTPUT_OPTION)

$(archpfx)objdump: $(archpfx)objdump.o
	$(CC) -o $(archpfx)objdump $(archpfx)objdump.o $(GNU_GETOPT_LONG) $(LIBS)

# Robotussin is NOT part of `all'.
$(archpfx)robotussin: $(archpfx)robotussin.o
	$(CC) -o $(archpfx)robotussin $(archpfx)robotussin.o

libc.a: $(archpfx)robotussin libconvert $(archpfx)ar
	libconvert /lib/libc.a libc.a

# usg-gnulib is the file gcc makes using the usg compiler
gnulib: $(archpfx)robotussin libconvert usg-gnulib $(archpfx)ar
	libconvert usg-gnulib gnulib

clean:
	-rm -f *.o core
	-rm -f $(PROGS)

dist:
	-rm -rf binutils
	mkdir binutils
	-cd binutils; ln -s ../* .
	cd binutils; \
		rm -f GNUmakefile *~ "#*" log* binutils binutils.tar* =*; \
		make clean
	tar cohf binutils.tar binutils
	compress < binutils.tar > binutils.tar.Z
	rm -rf binutils

.PHONY: install
install: $(PROGS)
	for file in $(PROGS); do \
	cp $$file $(bindir)/$${file}.new \
	mv $(bindir)/$${file}.new $(bindir)/$file \
	done

