LEX=flex
YACC=bison
CC=gcc
CFLAG=-ll
SOURCE=101062124_hw2
TARGET=101062124_hw2
TESTCASE=testfile
TESTCASEBONUS=bonus

all:
	${YACC} -d ${SOURCE}.y
	${LEX} ${SOURCE}.l
	${CC} lex.yy.c y.tab.c ${CFLAG} -o ${TARGET}.out

test:
	./${TARGET}.out < ${TESTCASE}.c > output.txt

bonus:
	./${TARGET}.out < ${TESTCASEBONUS}.c > output.txt
	vimdiff output.txt result-bonus.txt

clean:
	rm lex.yy.c *.out output.txt
