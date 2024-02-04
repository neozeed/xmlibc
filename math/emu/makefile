include  /gnu/makerule.cc
include  source.def
include  csource.def

# integer functions
# these functions are also in ../math.i/ 

INT = ../int/

OBJI=   $(INT)ashlsi3.o  $(INT)ashrsi3.o  $(INT)lshrsi3.o  $(INT)lshlsi3.o \
	$(INT)umodsi3.o  $(INT)modsi3.o $(INT)mulsi3.o  $(INT)udivsi3.o  \
   	$(INT)anddi3.o  $(INT)adddi3.o    $(INT)ashldi3.o  $(INT)ashrdi3.o    \
   	$(INT)bdiv.o $(INT)builtin.o $(INT)builtind.o  $(INT)builtinv.o \
   	$(INT)cmpdi2.o $(INT)divdi3.o $(INT)iordi3.o $(INT)lshldi3.o $(INT)lshrdi3.o \
  	$(INT)mjd.o $(INT)moddi3.o $(INT)muldi3.o $(INT)negdi2.o $(INT)onecmpld.o \
  	$(INT)subdi3.o $(INT)ucmpdi2.o $(INT)udivdi3.o $(INT)umoddi3.o $(INT)xordi3.o 

# float functions

OBJ=	femu1.o femu2.o femu3.o femu4.o femuer.o femuf.o \
	femui.o femul.o femup.o femus.o adddf3.o \
	femuzc.o \
	fisfdi.o fixsfsi.o frexp.o negsf2.o  \
	log.o log2.o log10.o exp.o const.o logtbl.o \
	sin.o cos.o \
	floor.o fmod.o fabs.o abs.o \
     addsf3.o  adddf3.o  subsf3.o  divdf3.o  divsf3.o \
     muldf3.o mulsf3.o \
     fisfsi.o  fldidf.o  frexps.o  \
    fiudfdi.o  fldisf.o  ldexp.o   sqrtsf2.o \
    fiudfsi.o  flsidf.o  ldexps.o  \
    extsfdf2.o  fiusfdi.o  flsisf.o \
    ffrac.o   fiusfsi.o  fludidf.o  \
    ffracs.o  fixdfdi.o  fludisf.o  trcdfsf2.o \
    fidfdi.o  fixdfsi.o  flusidf.o  \
    fidfsi.o  negdf2.o   flusisf.o  \
    modf.o    sqrtdf2.o fixsfdi.o  \
    cmpdf2.o  ferror.o  vbuiltin.o \
    cmpsf2.o  flsidf.o  \
    $(INT)divsi3.o  $(INT)umulsi3.o  \
    builtin_.o  \
    dbuiltin.o        

SCA =    $(INT)ashlsi3.s  cmpdf2.s  ferror.s  $(INT)mulsi3.s \
	vbuiltin.s \
    $(INT)ashrsi3.s  cmpsf2.s  flsidf.s  $(INT)divsi3.s  \
    $(INT)lshrsi3.s  $(INT)umulsi3.s  \
    builtin_.s   $(INT)modsi3.s  varargs.s  \
    $(INT)lshlsi3.s  $(INT)umodsi3.s  \
   floor.s fmod.s fabs.o abs.o $(INT)udivsi3.s eprintf.s dbuiltin.s  

all:  $(OBJ) $(SCA) $(OBJI)

sin.s:	  sincos.c
	$(CPP) $(CPPFLAGS) sincos.c -Dmake_sin $(TMP)/sin.i
	$(CC1) $(CC1FLAGS) $(TMP)/sin.i -o sin.s
	rm $(TMP)/sin.i

cos.s:	  sincos.c
	$(CPP) $(CPPFLAGS) sincos.c -Dmake_cos $(TMP)/cos.i
	$(CC1) $(CC1FLAGS) $(TMP)/cos.i -o cos.s
	rm $(TMP)/cos.i
log.s:	  explog.c
	$(CPP) $(CPPFLAGS) explog.c -Dmake_log $(TMP)/log.i
	$(CC1) $(CC1FLAGS) $(TMP)/log.i -o log.s
	rm $(TMP)/log.i

log2.s:   explog.c
	$(CPP) $(CPPFLAGS) explog.c -Dmake_log2 $(TMP)/log2.i
	$(CC1) $(CC1FLAGS) $(TMP)/log2.i -o log2.s
	rm $(TMP)/log2.i

log10.s:  explog.c
	$(CPP) $(CPPFLAGS) explog.c -Dmake_log10 $(TMP)/log10.i
	$(CC1) $(CC1FLAGS) $(TMP)/log10.i -o log10.s
	rm $(TMP)/log10.i

exp.s:	  explog.c
	$(CPP) $(CPPFLAGS) explog.c -Dmake_exp $(TMP)/exp.i
	$(CC1) $(CC1FLAGS) $(TMP)/exp.i -o exp.s
	rm $(TMP)/exp.i

const.s:  explog.c
	$(CPP) $(CPPFLAGS) explog.c -Dmake_const $(TMP)/const.i
	$(CC1) $(CC1FLAGS) $(TMP)/const.i -o const.s
	rm $(TMP)/const.i

logtbl.s: explog.c
	$(CPP) $(CPPFLAGS) explog.c -Dmake_table $(TMP)/logtbl.i
	$(CC1) $(CC1FLAGS) $(TMP)/logtbl.i -o logtbl.s
	rm $(TMP)/logtbl.i


asm:  $(SCAA)

mathe.a:  $(OBJ) 
	${ cmdsplit run386 g:\gnu\bin\ar dv  math.a %, 60,  $? }
	${ cmdsplit run386 g:\gnu\bin\ar rv  math.a %, 60,  $? }
	run386 \gnu\bin\ar  sv math.a

libce.a:  $(OBJ)
	${cmdsplit run386 g:\gnu\bin\ar rv  libce.a %, 60, $? }
	run386 g:\gnu\bin\ar sv libce.a

mathe.lzh: $(SOURCE) $(CSOURCE) makefile source.def csource.def
	${cmdsplit lharc a mathe %, 60, $? }
