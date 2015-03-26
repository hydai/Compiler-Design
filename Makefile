LEX=flex
CC=gcc
CFLAG=-lfl
SOURCE=101062124_hw1
TARGET=101062124_hw1
TESTCASE=testfile

all:
	flex ${SOURCE}.l
	${CC} lex.yy.c ${CFLAG} -o ${TARGET}.out

test:
	./${TARGET}.out < ${TESTCASE}.c > output.txt
	vimdiff output.txt result.txt

clean:
	rm lex.yy.c *.out output.txt
