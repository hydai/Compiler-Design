%{
#include <stdio.h>
#include "symbol_table.h"
#include "y.tab.h"
extern int line_number;
extern FILE* fptr;
extern void code_gen_with_header(FILE* fptr, char* file_name);
extern void code_gen_function_header(FILE* fptr, char* file_name);
extern void code_gen_function_body_end(FILE* fptr, char* file_name);
extern void code_gen_with_end(FILE* fptr);
%}

%union {
    int intVal;
    char *strVal;
}
%token <intVal>NUMBER
%token RETURN
%token ADD MINUS
%token MULTIPLY DIVIDE
%token ASSIGN
%token LP RP LLP LRP
%token COMMA END
%token INT
%token <strVal> STRING

%type <intVal> value
%type <strVal> function_name name

%left ADD MINUS
%left MULTIPLY DIVIDE
%start program

%%
program: program function {
        if (DEBUG_YACC) {
            printf("program function -> program\n");
        }
    }
    | /* NULL */
    ;

function: type function_name LP param_dec RP END {
            code_gen_function_body_end(fptr, $2);
            if (DEBUG_YACC) {
                printf("type name ( param_dec ); -> function\n");
            }
        }
        | type function_name LP param_dec RP LLP content LRP {
            code_gen_function_body_end(fptr, $2);
            if (DEBUG_YACC) {
                printf("type name ( param_dec ) { content } -> function\n");
            }
        }
        ;

function_name: STRING {
                if (DEBUG_YACC) {
                    printf("STRING -> funciton_name\n");
                }
                code_gen_function_header(fptr, $1);
                $$ = $1;
             }

param_dec: param_dec COMMA type name {
            if (DEBUG_YACC) {
                printf("param_dec, type name -> param_dec\n");
            }
         }
         | type name {
            if (DEBUG_YACC) {
                printf("type name -> param_dec\n");
            }
         }
         | /* NULL */
         ;

content: content var_dec END {
            if (DEBUG_YACC) {
                printf("content var_dec ; -> content\n");
            }
       }
       | content statement END {
            if (DEBUG_YACC) {
                printf("content statement ; -> content\n");
            }
       }
       | /* NULL */
       ;

var_dec: var_dec COMMA name ASSIGN expr {
            if (DEBUG_YACC) {
                printf("var_dec, name = expr -> var_dec\n");
            }
       }
       | type name ASSIGN expr {
            if (DEBUG_YACC) {
                printf("type name = expr -> var_dec\n");
            }
       }
       | type name {
            if (DEBUG_YACC) {
                printf("type name -> var_dec\n");
            }
       }
       ;

statement: RETURN expr {
            if (DEBUG_YACC) {
                printf("return expr -> statement\n");
            }
         }
         | name ASSIGN function_call {
            if (DEBUG_YACC) {
                printf("name = expr -> function_call\n");
            }
         }
         | name ASSIGN expr {
            if (DEBUG_YACC) {
                printf("name = expr -> statement\n");
            }
         }
         | expr {
            if (DEBUG_YACC) {
                printf("expr -> statement\n");
            }
         }
         | function_call {
            if (DEBUG_YACC) {
                printf("function_call -> statement\n");
            }
         }
         ;

function_call: name LP arg_list RP {
                if (DEBUG_YACC) {
                    printf("name ( arg_list ) -> function_call\n");
                }
             };

arg_list: arg_list COMMA name {
            if (DEBUG_YACC) {
                printf("arg_list, name -> arg_list\n");
            }
        }
        | arg_list COMMA value {
            if (DEBUG_YACC) {
                printf("arg_list, value -> arg_list\n");
            }
        }
        | name {
            if (DEBUG_YACC) {
                printf("name -> arg_list\n");
            }
        }
        | value {
            if (DEBUG_YACC) {
                printf("value -> arg_list\n");
            }
        }
        | /* NULL */
        ;

expr: expr ADD expr {
        if (DEBUG_YACC) {
            printf("expr + expr -> expr\n");
        }
    }
    | expr MINUS expr {
        if (DEBUG_YACC) {
            printf("expr - expr -> expr\n");
        }
    }
    | expr MULTIPLY expr {
        if (DEBUG_YACC) {
            printf("expr * expr -> expr\n");
        }
    }
    | expr DIVIDE expr {
        if (DEBUG_YACC) {
            printf("expr / expr -> expr\n");
        }
    }
    | LP expr RP {
        if (DEBUG_YACC) {
            printf("( expr ) -> expr\n");
        }
    }
    | value {
        if (DEBUG_YACC) {
            printf("value -> expr\n");
        }
    }
    | name {
        if (DEBUG_YACC) {
            printf("name -> expr\n");
        }
    }
    ;

type: INT {
        if (DEBUG_YACC) {
            printf("INT -> type\n");
        }
    }
    ;

value: NUMBER {
        if (DEBUG_YACC) {
            printf("NUMBER -> value\n");
        }
        fprintf(fptr, "\tmovi\t$r0,\t%d\n", $1);
        fprintf(fptr, "\tswi\t\t$r0,\t[$fp+(-12)]\n");
        $$ = $1;
     }
     ;

name: STRING {
        if (DEBUG_YACC) {
            printf("STRING -> name\n");
        }
        $$ = $1;
    }
    ;
%%

int yyerror(char *s) {
    fprintf(stderr, "ERROR in line #%d: %s\n", line_number, s);
    return 0;
}

int main() {
    fptr = fopen("andes.s", "w");
    code_gen_with_header(fptr, "testfile");
    yyparse();
    code_gen_with_end(fptr);
    fclose(fptr);
    return 0;
}
