#Definição das variáveis do make
CC=gcc #C compiler
EXEC=etapa2 #Nome do executável
FLEX_SRC=scanner.l
FLEX_C=lex.yy.c
FLEX_O=lex.yy.o
FLEX_H=lex.yy.h
BISON_SRC=parser.y
BISON_C=parser.tab.c
BISON_O=parser.tab.o
BISON_H=parser.tab.h
BISON_OUT=parser.output
MAIN_C=main.c
MAIN_O=main.o
REPORT_FILE = report
LFL := lfl

#test if macos
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)
	LFL = ll
endif

all: $(FLEX_SRC) $(BISON_SRC)
	bison -d $(BISON_SRC)
	flex $(FLEX_SRC)
	$(CC) -c $(FLEX_C) $(BISON_C) $(MAIN_C)
	$(CC) -$(LFL) -o $(EXEC) $(FLEX_O) $(BISON_O) $(MAIN_O)

clean:
	rm -rf $(BISON_C)
	rm -rf $(FLEX_C)
	rm -rf $(BISON_H)
	rm -rf *.o
	rm -rf $(REPORT_FILE)
	rm -rf $(BISON_OUT)
	rm -rf $(FLEX_H)
	
#Regra para gerar arquivo com descrição da gramática
verb: $(BISON_SRC)
	bison -v $(BISON_SRC) --report-file=report
