incfile = xmhd.inc xmmac.mac xmmsg.def termio.inc exp.inc stat.inc

src = xm.asm xmmem.asm xmmisc.asm xmfile.asm xmmsg.asm \
	xdas.asm xminit.asm xmdebg.asm xmos.asm xmdos.asm 

obj = xm.obj xmmisc.obj xmfile.obj xdas.obj xmmsg.obj xmmem.obj \
	xminit.obj xmdebg.obj xmdos.obj xmos.obj

all: xm.exe 

xm.obj: xm.asm  $(incfile)
	tasm  /ks1800 xm

.asm.obj: 
	tasm	/l $<

.c.obj :
	tcc -c -ml -f- -1 -O $<
	
far.exe: far.obj farp.asm
	tcc -efar -y far.obj farp.asm


xdas.obj: xdas.asm xmhd.inc
xmmisc.obj : $(incfile)
xmos.obj: $(incfile)
xmdos.obj: $(incfile)
xmfile.obj: $(incfile)
xmmsg.obj: $(incfile)
xmmem.obj: $(incfile)
xminit.obj: $(incfile)
xmdebg.obj: $(incfile)

xm.exe:  $(obj)
	tlink /m/3 xm+xmmem+xminit+xmdebg+xmmisc+xmfile+xmos+xmdos+xdas+xmmsg

arc: $(src)  $(incfile) 
	lharc a xm $(src) 
	lharc a xm $(incfile) makefile

clean:
	del *.lst
	del *.map
	del *.obj
	del *.bak
	