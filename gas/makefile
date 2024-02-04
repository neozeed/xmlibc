include /gnu/makerule.gcc

CPPFLAGS= $(CPPFLAGS) -I.

# Makefile for GAS.
# Copyright (C) 1989, Free Software Foundation
# 
# This file is part of GAS, the GNU Assembler.
# 
# GAS is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 1, or (at your option)
# any later version.
# 
# GAS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with GAS; see the file COPYING.  If not, write to
# the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

# This makefile may be used to make the VAX, 68020, 80386, 
# SPARC, or ns32k assembler(s).

#BINDIR = /usr/local/bin

# If you are on a BSD system, un-comment the next two lines, and comment out
# the lines for SystemV and HPUX below
G0 = -g -I.
#LDFLAGS = $(LDFLAGS) $(CFLAGS)
#
# To compile gas on a System Five machine, comment out the two lines above
# and un-comment out the next three lines
# Comment out the -lPW on the LOADLIBES line if you are using GCC.
# G0 = -g -I. -DUSG
# LDFLAGS = $(LDFLAGS) $(CFLAGS)
# LOADLIBES = -lmalloc -lPW
#
# To compile gas for HPUX, link m-hpux.h to m68k.h , and un-comment the
# next two lines.  (If you are using GCC, comment out the alloca.o part)
# (Get alloca from the emacs distribution, or use GCC.)
# G0 = -g -I. -DUSG
# LOADLIBES = alloca.o
#
# To compile gas for a Sequent Symmetry, comment out all the above lines,
# and un-comment the next two lines.
# G0 = -g -I. -DUSE_SYSTEM_HDR -DEXEC_VERSION=1
# LOADLIBES = -lc /usr/att/lib/libc.a

# If you just want to compile the vax assembler, type 'make avax'

# If you just want to compile the i386 assembler, type 'make a386'

# If you just want to compile the ns32k assembler, type 'make a32k'

# If you just want to compile the sparc assembler, type 'make asparc'

# If you just want to compile the mc68020 assembler, make sure m68k.h
# is correctly set up, and type type 'make a68'  (Except on HPUX machines,
# where you will have to make the changes marked below before typing
# 'make a68'
# m68k.h should be a symbolic or hard-link to one of
# m-sun3.h , m-hpux.h or m-generic.h
# depending on which machine you want to compile the 68020 assembler for.
#
# If you machine does not have vfprintf, but does have _doprnt(),
# remove the # from the -DNO_VARARGS line below.
#
# If the return-type of a signal-hander is void (instead of int),
# remove the # from the -DSIGTY line below.
#
# To include the mc68851 mmu coprocessor instructions in the 68020 assembler,
# remove the # from the -Dm68851 line below.
#
# If you want the 80386 assembler to correctly handle fsub/fsubr and fdiv/fdivr
# opcodes (unlike most 80386 assemblers), remove the # from
# the -DNON_BROKEN_WORDS line below.
#
# To compile 80386 Gas for the Sequent Symmetry, un-comment the -DEXEC_VERSION
# and the -DUSE_SYSTEM_HDR lines below.
#
# To compile gas for the HP 9000/300 un-comment the -DUSE_HP_HDR line below.
#

O1 = # -DNO_VARARGS
O2 = # -DNON_BROKEN_WORDS
O3 = # -Dm68851
O4 = # -DEXEC_VERSION=1
O5 = # -DSIGTY=void
G4 = # -DUSE_SYSTEM_HDR
G5 = # -DUSE_HP_HDR

OPTIONS = $(O1) $(O2) $(O3) $(O4) $(O5)

CFLAGS = $(G0) $(G4) $(G5)

#
# To make the 68020 assembler compile as the default, un-comment the next
# line, and comment out all the other lines that start with DEFAULT_GAS
#DEFAULT_GAS=a68
#
# To make the VAX assembler compile as the default, un-comment the next
# line and commment out all the other lines that start with DEFAULT_GAS
#DEFAULT_GAS=avax
#
# To make the 80386 assembler compile as the default, un-comment the next
# line and commment out all the other lines that start with DEFAULT_GAS
DEFAULT_GAS=gas.exp
#DEFAULT_GAS=a386
#
# To make the ns32k assembler compile as the default, un-comment the next
# line and commment out all the other lines that start with DEFAULT_GAS
#DEFAULT_GAS=a32k
#
# To make the sparc assembler compile as the default, un-comment the next
# line and commment out all the other lines that start with DEFAULT_GAS
#DEFAULT_GAS=asparc

# Global Sources -------------------------------------------------------------

a =\
as.o		xrealloc.o	xmalloc.o	hash.o		hex-value.o   \
atof-generic.o	append.o	messages.o	expr.o		app.o         \
frags.o		input-file.o	input-scrub.o	output-file.o	              \
subsegs.o	symbols.o					version.o     \
fl-const.o	fl-copy.o	fl-mult.o	strstr.o	bignum-copy.o \
gdb.o		gdb-file.o	gdb-symbols.o	gdb-blocks.o	obstack.o     \
gdb-lines.o

a:	$(DEFAULT_GAS)
#	@rm -f a
#	@ln $(DEFAULT_GAS) a		# has no effect on MS-DOS

# SPARC GAS ------------------------------------------------------------------
v = sparc.o  atof-m68k.o  write-sparc.o  read-sparc.o

V = sparc.c  sparc.h  sparc-opcode.h

atof-m68k.o:	flonum.h
sparc.o:	sparc.c sparc.h sparc-opcode.h as.h frags.h struc-symbol.h
sparc.o:	flonum.h expr.h hash.h md.h write.h read.h symbols.h
	$(CC) -c $(CFLAGS) -DSPARC sparc.c

write-sparc.o:	write.c
	$(CC) -c -DSPARC $(CFLAGS) write.c
	mv write.o write-sparc.o

read-sparc.o: read.c
	$(CC) -c -DSPARC $(CFLAGS) read.c
	mv read.o read-sparc.o

asparc: $a $v
	$(CC) -o asparc $(LDFLAGS) $a $v $(LOADLIBES) 

# NS32K GAS ------------------------------------------------------------------
w = ns32k.o  atof-ns32k.o  write-ns32k.o  read-ns32k.o

W = ns32k.c atof-ns32k.c ns32k-opcode.h

atof-ns32k.o:	flonum.h
ns32k.o:	as.h frags.h struc-symbol.h flonum.h expr.h md.h hash.h
ns32k.o:	write.h symbols.h ns32k-opcode.h

write-ns32k.o:	write.c
	$(CC) -c -DNS32K $(CFLAGS) write.c
	mv write.o write-ns32k.o

read-ns32k.o:
	$(CC) -c -DNS32K $(CFLAGS) read.c
	mv read.o read-ns32k.o

a32k: $a $w
	$(CC) -o a32k $(LDFLAGS) $a $w $(LOADLIBES)

# 80386 GAS ------------------------------------------------------------------
x = i386.o  atof-i386.o  write.o  read.o

X = i386.c  atof-i386.c  i386.h  i386-opcode.h

i386.o:		i386.c as.h read.h flonum.h frags.h struc-symbol.h expr.h
i386.o:		symbols.h hash.h md.h i386.h i386-opcode.h
#	$(CC) $(CFLAGS) $(OPTIONS) -c i386.c

atof-i386.o:	flonum.h

#a386: $a $x
#	$(CC) -o a386 $(LDFLAGS) $a $x $(LOADLIBES)
obj.a:	$a $x
	${cmdsplit $(AR) r obj.a %, 60, $?}
	$(RANLIB) obj.a

a386:	obj.a
	$(LD) $(LDFLAGS) -o a386 $(CRT0) obj.a $(LOADLIBS) $(CLIB)

gas.exp: a386
	$(GENEXP) a386 gas.exp
	$(NM) -n a386 > gas.map

# 68020 GAS ------------------------------------------------------------------
y = m68k.o  atof-m68k.o  write.o  read.o

Y = m68k.c atof-m68k.c m68k-opcode.h m-hpux.h m-sun3.h m-generic.h

atof-m68k.o:	flonum.h
m68k.o:		m68k.c a_out.h as.h expr.h flonum.h frags.h hash.h
m68k.o:		m68k-opcode.h m68k.h md.h obstack.h struc-symbol.h
	$(CC) $(CFLAGS) $(OPTIONS) -c m68k.c

a68: $a $y
	$(CC) -o a68 $(LDFLAGS) $a $y $(LOADLIBES)

# VAX GAS --------------------------------------------------------------------
z = vax.o  atof-vax.o  write.o  read.o

Z = vax.c atof-vax.c vax-opcode.h vax-inst.h    make-gas.com objrecdef.h vms.c

vax.o:		vax.c a_out.h as.h expr.h flonum.h frags.h md.h obstack.h
vax.o:		read.h struc-symbol.h symbols.h vax-inst.h vax-opcode.h
atof-vax.o:	as.h flonum.h read.h

avax:	$a $z
	$(CC) -o avax $(LDFLAGS) $a $z $(LOADLIBES)

# global files ---------------------------------------------------------------

as.o: as.c
#	$(CC) $(CFLAGS) $(OPTIONS) -c as.c

messages.o: messages.c
	$(CPP) $(CPPFLAGS) -Derror=as_fatal messages.c $(TMP)/messages.i
	$(CC1) $(CC1FLAGS) $(TMP)/messages.i -o $(TMP)/messages.s
	$(AS)  $(ASFLAGS)  $(TMP)/messages.s -o messages.o
	rm $(TMP)/messages.s $(TMP)/messages.i

hash.o:	hash.c
	$(CPP) $(CPPFLAGS) -Derror=as_fatal hash.c $(TMP)/hash.i
	$(CC1) $(CC1FLAGS) $(TMP)/hash.i -o $(TMP)/hash.s
	$(AS)  $(ASFLAGS)  $(TMP)/hash.s -o hash.o
	rm $(TMP)/hash.s $(TMP)/hash.i

xmalloc.o:	xmalloc.c
	$(CPP) $(CPPFLAGS) -Derror=as_fatal xmalloc.c $(TMP)/xmalloc.i
	$(CC1) $(CC1FLAGS) $(TMP)/xmalloc.i -o $(TMP)/xmalloc.s
	$(AS)  $(ASFLAGS)  $(TMP)/xmalloc.s -o xmalloc.o
	rm $(TMP)/xmalloc.s $(TMP)/xmalloc.i

xrealloc.o:	xrealloc.c
	$(CPP) $(CPPFLAGS) -Derror=as_fatal xrealloc.c $(TMP)/xrealloc.i
	$(CC1) $(CC1FLAGS) $(TMP)/xrealloc.i -o $(TMP)/xrealloc.s
	$(AS)  $(ASFLAGS)  $(TMP)/xrealloc.s -o xrealloc.o
	rm $(TMP)/xrealloc.s $(TMP)/xrealloc.i

A =\
as.c		xrealloc.c	xmalloc.c	hash.c		hex-value.c \
atof-generic.c	append.c	messages.c	expr.c		bignum-copy.c \
frags.c		input-file.c	input-scrub.c	output-file.c	read.c \
subsegs.c	symbols.c	write.c				strstr.c \
fl-const.c	fl-copy.c	fl-mult.c	app.c		version.c \
gdb.c		gdb-file.c	gdb-symbols.c	gdb-blocks.c	obstack.c \
gdb-lines.c

H = \
a_out.h		as.h		bignum.h	expr.h		flonum.h \
frags.h		hash.h		input-file.h	md.h	 \
obstack.h	read.h		struc-symbol.h	subsegs.h	\
symbols.h	write.h

dist: COPYING README ChangeLog $A $H $Z $Y $X $W $V Makefile
	echo gas-`sed -e 's/[^0-9.]*\([0-9.]*\).*/\1/' -e q < version.c` > .fname
	mkdir `cat .fname`

	ln COPYING README ChangeLog $A $H $Z $Y $X $W $V Makefile `cat .fname`
	tar cvhZf `cat .fname`.tar.Z `cat .fname`
	-rm -r `cat .fname`

clean:
	rm -f a avax a68 a386 a32k asparc $a $v $w $x $y $z a core gmon.out bugs a.out

install:	a
	cp a $(BINDIR)/gas


# General .o-->.h dependencies

app.o:		as.h
as.o:		a_out.h as.h read.h struc-symbol.h write.h
atof-generic.o:	flonum.h
bignum-copy.o:	bignum.h
expr.o:		a_out.h as.h expr.h flonum.h obstack.h read.h struc-symbol.h
expr.o:		 symbols.h
fl-const.o:	flonum.h
fl-copy.o:	flonum.h
fl-mult.o:	flonum.h
flonum-normal.o:flonum.h
flonum-print.o:	flonum.h
frags.o:	a_out.h as.h frags.h obstack.h struc-symbol.h subsegs.h
gdb.o:		as.h
gdb-blocks.o:	as.h
gdb-lines.o:	as.h frags.h obstack.h
gdb-symbols.o:	a_out.h as.h struc-symbol.h
#hash.o:		hash.h
input-file.o:	input-file.h
input-scrub.o:	as.h input-file.h read.h
#messages.o:	as.h
obstack.o:	obstack.h
read.o:		a_out.h as.h expr.h flonum.h frags.h hash.h md.h obstack.h
read.o:		read.h struc-symbol.h symbols.h
subsegs.o:	a_out.h as.h frags.h obstack.h struc-symbol.h subsegs.h write.h
symbols.o:	a_out.h as.h frags.h hash.h obstack.h struc-symbol.h symbols.h
write.o:	a_out.h as.h md.h obstack.h struc-symbol.h subsegs.h
write.o:	symbols.h write.h

flonum.h:					bignum.h

