%{
#include <stdio.h>
#include "y.tab.h"
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

function: type name LP param_dec RP END {
            if (DEBUG_YACC) {
                printf("type name ( param_dec ); -> function\n");
            }
        }
        | type name LP param_dec RP LLP content LRP {
            if (DEBUG_YACC) {
                printf("type name ( param_dec ) { content } -> function\n");
            }
        }
        ;

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
     }
     ;

name: STRING {
        if (DEBUG_YACC) {
            printf("STRING -> name\n");
        }
    }
    ;
%%

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main() {
    yyparse();
    return 0;
}
