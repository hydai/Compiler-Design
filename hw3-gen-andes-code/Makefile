LEX=flex
YACC=byacc
CC=gcc
CFLAG=-ll
SOURCE=101062124_hw3
TARGET=101062124_hw3
MYLIB=symbol_table
TESTCASE=test1
TESTCASEBONUS=bonus

all:
	${YACC} -dv ${SOURCE}.y
	${LEX} ${SOURCE}.l
	${CC} lex.yy.c y.tab.c ${MYLIB}.c ${CFLAG} -o ${TARGET}.out -D DEBUG_LEX=0 -D DEBUG_YACC=0

test:
	${YACC} -dv ${SOURCE}.y
	${LEX} ${SOURCE}.l
	${CC} lex.yy.c y.tab.c ${MYLIB}.c ${CFLAG} -o ${TARGET}.out -D DEBUG_LEX=1 -D DEBUG_YACC=1

clean:
	rm lex.yy.c *.out output.txt y.tab.* y.output
