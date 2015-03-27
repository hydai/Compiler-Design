LEX=flex
CC=gcc
CFLAG=-lfl
SOURCE=101062124_hw1
TARGET=101062124_hw1
TESTCASE=testfile
TESTCASEBONUS=testfile-loop

all:
	flex ${SOURCE}.l
	${CC} lex.yy.c ${CFLAG} -o ${TARGET}.out

test:
	./${TARGET}.out < ${TESTCASE}.c > output.txt
	vimdiff output.txt result.txt

bonus:
	./${TARGET}.out < ${TESTCASEBONUS}.c > output.txt
	vimdiff output.txt result-loop.txt

clean:
	rm lex.yy.c *.out output.txt
