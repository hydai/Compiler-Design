/* lex scanner for compiler hw3 by hydai */

%{
#include "y.tab.h"
// Define symbol
#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>

struct symbol{
    char* text;
    int type;
    int offset;
    union {
        int int_val;
        char* str_val;
    } attr;
};

extern struct symbol symbol_table[128];
extern int symbol_table_index;
int line_number = 1;
// File pointer for generating asm
FILE *fptr = NULL;
%}


LETTER      [a-zA-Z_]
DIGIT       [0-9]
ID          {LETTER}({LETTER}|{DIGIT})*
ADD         [\+]
MINUS       [\-]
MULTIPLY    [\*]
DIVIDE      [\/]
ASSIGN      [\=]
INT         int
RETURN      return
INT_VAL     ([0]|[1-9][0-9]*)

%%
{INT_VAL}   {
    if (DEBUG_LEX) {
        printf("#%-2d %-11s: %s\n", line_number, "number", yytext);
    }

    yylval.intVal = atoi(yytext);
    return NUMBER;
}

{INT}   {
    if (DEBUG_LEX) {
        printf("#%-2d %-11s: %s\n", line_number, "data type", yytext);
    }
    return INT;
}

{ASSIGN}    {
    if (DEBUG_LEX) {
        printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
    }
    yylval.strVal = strdup(yytext);
    return ASSIGN;
}

{ADD}   {
    if (DEBUG_LEX) {
        printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
    }
    yylval.strVal = strdup(yytext);
    return ADD;
}

{MINUS}     {
    if (DEBUG_LEX) {
        printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
    }
    yylval.strVal = strdup(yytext);
    return MINUS;
}

{MULTIPLY}  {
    if (DEBUG_LEX) {
        printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
    }
    yylval.strVal = strdup(yytext);
    return MULTIPLY;
}

{DIVIDE}    {
    if (DEBUG_LEX) {
        printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
    }
    yylval.strVal = strdup(yytext);
    return DIVIDE;
}

{RETURN}    {
    if (DEBUG_LEX) {
        printf("#%-2d return\n", line_number);
    }
    return RETURN;
}

{ID} {
    if (DEBUG_LEX) {
        printf("#%-2d %-11s: %s\n", line_number, "ID", yytext);
    }
    yylval.strVal = strdup(yytext);
    return STRING;
}

\(  {
    if (DEBUG_LEX) {
        printf("#%-2d (\n", line_number);
    }
    return LP;
}

\)  {
    if (DEBUG_LEX) {
        printf("#%-2d )\n", line_number);
    }
    return RP;
}

\{  {
    if (DEBUG_LEX) {
        printf("#%-2d {\n", line_number);
    }
    return LLP;
}

\}  {
    if (DEBUG_LEX) {
        printf("#%-2d }\n", line_number);
    }
    return LRP;
}

,   {
    if (DEBUG_LEX) {
        printf("#%-2d ,\n", line_number);
    }
    return COMMA;
}

;   {
    if (DEBUG_LEX) {
        printf("#%-2d ;\n", line_number);
    }
    return END;
}

"/*"    {
    char prev_ch = '\0', cur_ch = input();
    for (;;) {
        if(cur_ch == EOF)
            break;
        if(cur_ch == '\n')
            if (DEBUG_LEX) {
                printf("#%-2d comment\n", line_number);
            }
            line_number++;
        if(prev_ch == '*' && cur_ch == '/') {
            if (DEBUG_LEX) {
                printf("#%-2d comment\n", line_number);
            }
            break;
        }
        prev_ch = cur_ch;
        cur_ch = input();
    }
}
"//"    {
    char prev_ch = '\0', cur_ch = input();
    for (;;) {
        if(cur_ch == EOF)
            break;
        if(cur_ch == '\n') {
            if (DEBUG_LEX) {
                printf("#%-2d comment\n", line_number);
            }
            line_number++;
            break;
        }
        prev_ch = cur_ch;
        cur_ch = input();
    }
}

\n	{
    line_number++;
}
[ \t]+  {
    /* Do nothing */
}
.   {
    /* Do nothing */
}

%%

int yywrap() {
    int i;
    printf("\nTotal lines: %d\n", line_number-1);
    printf("YYTEXT\t\tOFFSET\n");
    printf("---------------------------\n");
    for (i = 0; i < symbol_table_index; i++) {
        printf("%s\t\t", symbol_table[i].text);
        printf("%d\n", symbol_table[i].offset);
        /*
        if (symbol_table[i].type == STRING) {
            printf("%s\n", symbol_table[i].attr.str_val);
        } else if (symbol_table[i].type == NUMBER) {
            printf("%d\n", symbol_table[i].attr.int_val);
        } else {
            printf("%s\n", symbol_table[i].attr.str_val);
        }
        */
    }
    return 1;
}
