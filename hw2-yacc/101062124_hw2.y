%{
#include <stdio.h>
#include <>
%}

%union {
    int intVal;
    double douVal;
    char *strVal;
}
%token NUMBER

%%

%%

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main() {
    yyparse();
    return 0;
}
