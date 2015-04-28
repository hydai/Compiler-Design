%{
#include <stdio.h>
#include "y.tab.h"
%}

%union {
    int intVal;
    double douVal;
    char *strVal;
    char charVal;
}
%token <intVal>NUMBER
%token RETURN
%token WHILE FOR
%token ADD MINUS
%token MULTIPLY DIVIDE
%token AND OR EQ
%token GTE LTE GT LT
%token ASSIGN
%token PP MM PE ME
%token LP RP LLP LRP
%token COMMA END
%token INT DOUBLE CHAR
%token <strVal> STRING
%token <charVal> CHARACTER

%%
prog: prog func
    | /* NULL */
    ;

func: type name args follow
    | /* NULL */
    ;

type: INT
    | DOUBLE
    | CHAR
    ;

name: STRING;

args: LP decs RP;

decs: decs COMMA type STRING
    | type STRING;

follow: END /* function dec */
      | LLP content LRP
      ;
content: decs END;
%%

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main() {
    yyparse();
    return 0;
}
