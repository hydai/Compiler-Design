/* lex scanner for compiler hw3 by hydai */

%{
#include "y.tab.h"
// Define symbol
#include "symbol_define.h"
#include "gen_asm.h"
#include <stdio.h>
#include <stdlib.h>

// File pointer for generating asm
FILE *fptr_asm = NULL;

%}



%%

%%

int yywrap() {
    int i;
    printf("Total lines: %d\n", line_number);
    printf("YYTEXT\t\tVALUE\n");
    printf("---------------------------\n");
    for (i = 0; i < symbol_table_index; i++) {
        printf("%s\t\t", symbol_table[i].text);
        if (symbol_table[i].token == IDENTIFIER) {
            printf("%s\n", symbol_table[i].attr.str_val);
        } else if (symbol_table[i].token == INTEGER) {
            printf("%d\n", symbol_table[i].attr.int_val);
        } else {
            printf("%s\n", symbol_table[i].attr.str_val);
        }
    }
    return 1;
}
