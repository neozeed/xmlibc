include /gnu/makerule.gcc
include object.def

all: $(OBJS)


lib.a: $(OBJS)
	${cmdsplit $(AR) rv lib.a %, 60, $?}
	$(AR) sv lib.a
	

