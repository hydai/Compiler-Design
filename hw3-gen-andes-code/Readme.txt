### Please follow the steps

1. Compile without dumping lex, yacc message:
    1. `make`
    2. `./101062124_hw3.out test1.c`
    3. `make adx` # or use nds32le-elf-gcc andes.s -Wa,-g -static -0 andes.adx
    4. Then you get the binary file `andes.adx`.
    5. You can use `nds32le-elf-gdb` to run it

2. Compile with dumping lex, yacc message:
    1. `make test`
    2. `./101062124_hw3.out test1.c`
    3. `make adx` # or use nds32le-elf-gcc andes.s -Wa,-g -static -0 andes.adx
    4. Then you get the binary file `andes.adx`.
    5. You can use `nds32le-elf-gdb` to run it

3. Clean up:
    1. `make clean`
    2. It will remove lex.yy.c *.out *.s *.adx

#### Warning

1. I use math.h to get log2 function. If you get a compiler error/warning with `cannot find log2`, add `-lm` to the compiler option list.
