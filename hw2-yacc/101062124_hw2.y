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

%left ADD MINUS
%left MULTIPLY DIVIDE
%start prog

%%
prog: prog func {
        printf("prog func -> prog\n");
    }
    | /* NULL */
    ;

func: type name args follow {
        printf("type name args follow -> func\n");
    }
    ;

type: INT {printf("INT -> type\n");}
    | DOUBLE {printf("DOUBLE -> type\n");}
    | CHAR {printf("CHAR -> type\n");}
    ;

name: STRING {printf("STRING -> name\n");};

args: LP decs RP {
        printf("( decs ) -> args\n");
    };

decsName: type name {
        printf("type name -> decsName\n");
    }
    | /* NULL */
    ;
decs: decs COMMA decsName {
        printf("decs , decsName -> decs\n");
    }
    | decsName {
        printf("decsName -> decs\n");
    }
    ;

follow: END /* function dec */ {
        printf("END -> follow\n");
      }
      | LLP content ret LRP {
        printf("{ content ret } -> follow\n");
      }
      ;
decName: name ASSIGN expr {
    printf("name = expr -> decName\n");
   }
   | name {
    printf("name -> decName\n");
   }
   ;
dec: dec COMMA decName {
    printf("dec , decName -> dec\n");
   }
   | decName {
    printf("decName -> dec\n");
   }
   ;
content: content type dec END {
        printf("content type dec END -> content\n");
       }
       | content stmt END {
        printf("content stmt END -> content\n");
       }
       | /* NULL */
       ;
stmt: name ASSIGN expr {
        printf("name = expr -> stmt\n");
    }
    | expr {
        printf("expr -> stmt\n");
    }
    ;
ret: RETURN expr END{
    printf("return expr ; -> ret\n");
   }
   ;
value: NUMBER {
    printf("number -> value\n");
   }
   | CHARACTER {
    printf("character -> value\n");
   }
   ;
arg: arg COMMA value {
    printf("arg , value -> arg\n");
   }
   | value {
    printf("value -> arg\n");
   }
   ;
expr: name LP arg RP {
        printf("name ( arg ) -> expr\n");
    }
    | expr ADD expr {
        printf("expr + expr -> expr\n");
    }
    | expr MINUS expr {
        printf("expr - expr -> expr\n");
    }
    | expr MULTIPLY expr {
        printf("expr * expr -> expr\n");
    }
    | expr DIVIDE expr {
        printf("expr / expr -> expr\n");
    }
    | LP expr RP {
        printf("( expr ) -> expr\n");
    }
    | CHARACTER {
        printf("character -> expr\n");
    }
    | NUMBER {
        printf("number -> expr\n");
    }
    | name {
        printf("name -> expr\n");
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
