CC := gcc
LFL := lfl
CCFLAGS := -g -Wall

#test if macos
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)
	LFL = ll
endif

all: lex.yy.o

	$(CC) $(CCFLAGS) main.c lex.yy.o -$(LFL) -o etapa1

lex.yy.o: scanner.l
	flex --header-file=lex.yy.h scanner.l
	$(CC) -c lex.yy.c

clean:
	rm -rf etapa3 lex.yy.* *.dSYM etapa1
