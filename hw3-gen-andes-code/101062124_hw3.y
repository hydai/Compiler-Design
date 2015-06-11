%{
#include <stdio.h>
#include <math.h>
#include "symbol_table.h"
#include "y.tab.h"
struct symbol {
    char* text;
    int type;
    int offset;
    union {
        int int_val;
        char* str_val;
    } attr;
};
struct entry {
    char* name;
    int scope;
    int offset;
    int id;
    int variant;
    int type;
    int args_count;
    int vars_count;
    int mode;
};
extern int line_number;
extern FILE* fptr;
extern char* create_new_string(char*);
extern int insert_to_symbol_table(char* symbol_text, int symbol_type, int offset);
extern void code_gen_with_header(FILE* fptr, char* file_name);
extern void code_gen_function_header(FILE* fptr, char* file_name);
extern void code_gen_function_body_end(FILE* fptr, char* file_name);
extern void code_gen_with_end(FILE* fptr);
extern int get_entry_table_index(char* name);
extern int get_symbol_table_index(char* name);
extern struct entry entry_table[128];
extern int entry_table_index;
extern struct symbol symbol_table[128];
extern int symbol_table_index;
int isFirstScan = 1;
int args_count = 0;
int vars_count = 0;
int vars_offset = 2;
int args_dec_count = 0;
int args_call_count = 0;
int current_index = 0;
int expr_mode = 0;
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

%type <intVal> value expr
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
            if (isFirstScan == 0) {
                code_gen_function_body_end(fptr, $2);
                vars_offset = 2;
                current_index++;
            } else {
                int index = get_entry_table_index($2);
                if (index == -1) {
                    entry_table[entry_table_index].name = create_new_string($2);
                    entry_table[entry_table_index].args_count = args_count;
                    args_count = 0;
                    entry_table[entry_table_index].vars_count = vars_count;
                    vars_count = 0;
                } else {
                    exit(1);
                }
            }
            if (DEBUG_YACC) {
                printf("type name ( param_dec ); -> function\n");
            }
        }
        | type function_name LP param_dec RP LLP content LRP {
            if (isFirstScan == 0) {
                code_gen_function_body_end(fptr, $2);
                vars_offset = 2;
                args_dec_count = 0;
                current_index++;
            } else {
                int index = get_entry_table_index($2);
                if (index == -1) {
                    entry_table[entry_table_index].name = create_new_string($2);
                    index = entry_table_index++;
                }
                entry_table[index].args_count = args_count;
                args_count = 0;
                entry_table[index].vars_count = vars_count;
                vars_count = 0;
            }
            if (DEBUG_YACC) {
                printf("type name ( param_dec ) { content } -> function\n");
            }
        }
        ;

function_name: STRING {
                if (DEBUG_YACC) {
                    printf("STRING -> funciton_name\n");
                }
                if (isFirstScan == 0) {
                    code_gen_function_header(fptr, $1);
                }
                $$ = $1;
             }

param_dec: param_dec COMMA type name {
            if (isFirstScan) {
                args_count++;
                vars_count++;
                insert_to_symbol_table($4, STRING, 0);
            } else {
                if (symbol_table[get_symbol_table_index($4)].offset == 0) {
                    symbol_table[get_symbol_table_index($4)].offset = args_dec_count + entry_table[current_index].vars_count;
                    args_dec_count++;
                }
                int tmp_offset = symbol_table[get_symbol_table_index($4)].offset;
                fprintf(fptr, "\tswi \t$r%d,\t[$fp + (-%d)]\n", tmp_offset-entry_table[current_index].vars_count, tmp_offset*4+4);
            }
            if (DEBUG_YACC) {
                printf("param_dec, type name -> param_dec\n");
            }
         }
         | type name {
            if (isFirstScan) {
                args_count++;
                vars_count++;
                insert_to_symbol_table($2, STRING, 0);
            } else {
                if (symbol_table[get_symbol_table_index($2)].offset == 0) {
                    symbol_table[get_symbol_table_index($2)].offset = args_dec_count + entry_table[current_index].vars_count;
                    args_dec_count++;
                }
                int tmp_offset = symbol_table[get_symbol_table_index($2)].offset;
                fprintf(fptr, "\tswi \t$r%d,\t[$fp + (-%d)]\n", tmp_offset-entry_table[current_index].vars_count, tmp_offset*4+4);
            }
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
            expr_mode = 0;
            if (isFirstScan) {
                vars_count++;
                insert_to_symbol_table($3, STRING, vars_offset++);
            } else {
                fprintf(fptr, "\tswi \t$r0,\t[$fp + (-%d)]\n", symbol_table[get_symbol_table_index($3)].offset*4+4);
            }
            if (DEBUG_YACC) {
                printf("var_dec, name = expr -> var_dec\n");
            }
       }
       | type name ASSIGN expr {
            expr_mode = 0;
            if (isFirstScan) {
                vars_count++;
                insert_to_symbol_table($2, STRING, vars_offset++);
            } else {
                fprintf(fptr, "\tswi \t$r0,\t[$fp + (-%d)]\n", symbol_table[get_symbol_table_index($2)].offset*4+4);
            }
            if (DEBUG_YACC) {
                printf("type name = expr -> var_dec\n");
            }
       }
       | type name {
            if (isFirstScan) {
                vars_count++;
                insert_to_symbol_table($2, STRING, vars_offset++);
            }
            if (DEBUG_YACC) {
                printf("type name -> var_dec\n");
            }
       }
       ;

statement: RETURN expr {
            expr_mode = 0;
            if (DEBUG_YACC) {
                printf("return expr -> statement\n");
            }
         }
         | name ASSIGN function_call {
            if (isFirstScan == 0) {
                fprintf(fptr, "\tswi \t$r0,\t[$fp + (-%d)]\n", symbol_table[get_symbol_table_index($1)].offset*4+4);
            }
            if (DEBUG_YACC) {
                printf("name = function_call -> statement\n");
            }
         }
         | name ASSIGN expr {
            expr_mode = 0;
            if (isFirstScan == 0) {
                fprintf(fptr, "\tswi \t$r0,\t[$fp + (-%d)]\n", symbol_table[get_symbol_table_index($1)].offset*4+4);
            }
            if (DEBUG_YACC) {
                printf("name = expr -> statement\n");
            }
         }
         | expr {
            expr_mode = 0;
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
                args_call_count = 0;
                if (isFirstScan == 0) {
                    fprintf(fptr, "\tjal \t%s\n", $1);
                }
                if (DEBUG_YACC) {
                    printf("name ( arg_list ) -> function_call\n");
                }
             };

arg_list: arg_list COMMA name {
            if (isFirstScan == 0) {
                fprintf(fptr, "\tlwi \t$r%d,\t[$fp + (-%d)]\n", args_call_count++, symbol_table[get_symbol_table_index($3)].offset*4+4);
            }
            if (DEBUG_YACC) {
                printf("arg_list, name -> arg_list\n");
            }
        }
        | arg_list COMMA value {
            if (isFirstScan == 0) {
                fprintf(fptr, "\tmovi\t$r%d,\t%d\n", args_call_count++, $3);
            }
            if (DEBUG_YACC) {
                printf("arg_list, value -> arg_list\n");
            }
        }
        | name {
            if (isFirstScan == 0) {
                fprintf(fptr, "\tlwi \t$r%d,\t[$fp + (-%d)]\n", args_call_count++, symbol_table[get_symbol_table_index($1)].offset*4+4);
            }
            if (DEBUG_YACC) {
                printf("name -> arg_list\n");
            }
        }
        | value {
            if (isFirstScan == 0) {
                fprintf(fptr, "\tmovi\t$r%d,\t%d\n", args_call_count++, $1);
            }
            if (DEBUG_YACC) {
                printf("value -> arg_list\n");
            }
        }
        | /* NULL */
        ;

expr: expr ADD expr {
        if (isFirstScan == 0) {
            fprintf(fptr, "\tadd \t$r0,\t$r0,\t$r1\n");
        }
        if (DEBUG_YACC) {
            printf("expr + expr -> expr\n");
        }
    }
    | expr MINUS expr {
        if (isFirstScan == 0) {
            fprintf(fptr, "\tsub \t$r0,\t$r0,\t$r1\n");
        }
        if (DEBUG_YACC) {
            printf("expr - expr -> expr\n");
        }
    }
    | expr MULTIPLY expr {
        if (isFirstScan == 0) {
            fprintf(fptr, "\tmovi\t$r1,\t%d\n", (int)log2($3));
            fprintf(fptr, "\tsll \t$r0,\t$r0,\t$r1\n");
        }
        if (DEBUG_YACC) {
            printf("expr * expr -> expr\n");
        }
    }
    | expr DIVIDE expr {
        if (isFirstScan == 0) {
            fprintf(fptr, "\tmovi\t$r1,\t%d\n", (int)log2($3));
            fprintf(fptr, "\tsrl \t$r0,\t$r0,\t$r1\n");
        }
        if (DEBUG_YACC) {
            printf("expr / expr -> expr\n");
        }
    }
    | LP expr RP {
        if (DEBUG_YACC) {
            printf("( expr ) -> expr\n");
        }
        $$ = $2;
    }
    | value {
        if (isFirstScan == 0) {
            if (expr_mode == 0) {
                fprintf(fptr, "\tmovi\t$r0,\t%d\n", $1);
                expr_mode = 1;
            } else {
                fprintf(fptr, "\tmovi\t$r1,\t%d\n", $1);
            }
        }
        if (DEBUG_YACC) {
            printf("value -> expr\n");
        }
        $$ = $1;
    }
    | name {
        if (isFirstScan == 0) {
            if (expr_mode == 0) {
                fprintf(fptr, "\tlwi \t$r0,\t[$fp + (-%d)]\n", symbol_table[get_symbol_table_index($1)].offset*4+4);
                expr_mode = 1;
            } else {
                fprintf(fptr, "\tlwi \t$r1,\t[$fp + (-%d)]\n", symbol_table[get_symbol_table_index($1)].offset*4+4);
            }
        }
        if (DEBUG_YACC) {
            printf("name -> expr\n");
        }
        $$ = 0;
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

void scan(char* filename, int isFirstScan) {
    line_number = 1;
    FILE *in = fopen(filename, "r");
    yyrestart(in);
    if (isFirstScan) {
        yyparse();
    } else {
        fptr = fopen("andes.s", "w");
        code_gen_with_header(fptr, filename);
        yyparse();
        code_gen_with_end(fptr);
        fclose(fptr);
    }
    fclose(in);
}

int main(int argc, char *argv[]) {
    // Scan first to get infomations
    isFirstScan = 1;
    scan(argv[1], isFirstScan);
    // Re-scan to generate file
    isFirstScan = 0;
    scan(argv[1], isFirstScan);
    return 0;
}
