LEX=flex
CC=gcc
CFLAG=-lfl
SOURCE=hw1
TARGET=hw1
TESTCASE=testfile

all:
	flex ${SOURCE}.l
	${CC} lex.yy.c ${CFLAG} -o ${TARGET}.out

test:
	./${TARGET}.out < ${TESTCASE}.c

clean:
	rm lex.yy.c *.out
