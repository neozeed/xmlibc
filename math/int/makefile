#
include /gnu/makerule.gcc
include source.def

LIBFUNCS1 =	\
	builtin.o \
	builtind.o \
	builtinv.o \
	divsi3.o \
	div.o \
	labs.o \
	abs.o \
	eprintf.o \
	udivsi3.o

LIBFUNCS2 =	\
	adddi3.o \
	anddi3.o \
	ashldi3.o \
	ashrdi3.o \
	bdiv.o \
	cmpdi2.o \
	divdi3.o \
	iordi3.o \
	lshldi3.o \
	lshrdi3.o \
	moddi3.o \
	muldi3.o \
	negdi2.o \
	onecmpld.o \
	subdi3.o \
	ucmpdi2.o \
	udivdi3.o \
	umoddi3.o \
	xordi3.o

all: ../libce.a ../libc.a

../libce.a: $(LIBFUNCS1) $(LIBFUNCS2)
	${cmdsplit $(AR) r ../libce.a %, 60, $?}
	$(RANLIB) ../libce.a

../libc.a: $(LIBFUNCS1) $(LIBFUNCS2)
	${cmdsplit $(AR) r ../libc.a %, 60, $?}
	$(RANLIB) ../libc.a

mathi.lzh : $(SOURCE) makefile source.def
	${cmdsplit lharc a mathi.lzh %, 60, $?}
	
