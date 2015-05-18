%{
    #include <stdio.h>
    #include "y.tab.h"
    int i;
    int line_number = 1;
    int char_flag = 0;
    char unknownID[128];
%}
LETTER      [a-zA-Z_]
DIGIT       [0-9]
ID          {LETTER}({LETTER}|{DIGIT})*
ADD         [\+]
MINUS       [\-]
MULTIPLY    [\*]
DIVIDE      [\/]
GTE         ">="
LTE         "<="
EQ          "=="
ASSIGN      "="
GT          ">"
LT          "<"
AND         "&&"
OR          "||"
PP          "++"
MM          "--"
PE          "+="
ME          "-="
FOR         for
WHILE       while
UNSIGNED    unsigned
CHAR        char
SHORT       short
LONG        long
INT         int
FLOAT       float
DOUBLE      double
INTEGER     (({UNSIGNED}" ")?(({SHORT}|{LONG}|{LONG}" "{LONG})" ")?{INT}?)
FLOATING    ({FLOAT}|{DOUBLE}|{LONG}" "{DOUBLE})
DATA_TYPE   ({INTEGER}|{FLOATING}|{CHAR})
OPERATOR    ({ADD}|{MINUS}|{MULTIPLY}|{DIVIDE}|{GTE}|{LTE}|{ASSIGN}|{GT}|{LT}|{PP}|{MM}|{PE}|{ME}|{AND}|{OR}|{EQ})
RETURN      return
DOUBLE_VAL  ([0-9]\.[0-9]+)
INT_VAL     ([0]|[1-9][0-9]*)

%%

{WHILE}         {
                    printf("#%-2d %-11s: %s\n", line_number, "while-loop", yytext);
                    return WHILE;
                }
{FOR}           {
                    printf("#%-2d %-11s: %s\n", line_number, "for-loop", yytext);
                    return FOR;
                }
{ADD}           {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return ADD;
                }
{MINUS}         {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return MINUS;
                }
{MULTIPLY}      {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return MULTIPLY;
                }
{DIVIDE}        {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return DIVIDE;
                }
{GTE}           {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return GTE;
                }
{LTE}           {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return LTE;
                }
{ASSIGN}        {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return ASSIGN;
                }
{GT}            {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return GT;
                }
{LT}            {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return LT;
                }
{PP}            {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return PP;
                }
{MM}            {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return MM;
                }
{PE}            {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return PE;
                }
{ME}            {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return ME;
                }
{AND}           {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return AND;
                }
{OR}            {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return OR;
                }
{EQ}            {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                    yylval.strVal = strdup(yytext);
                    return EQ;
                }
{INT_VAL}       {
                    printf("#%-2d %-11s: %s\n", line_number, "number", yytext);
                    yylval.intVal = atoi(yytext);
                    return NUMBER;
                }
{INT}           {
                    printf("#%-2d %-11s: %s\n", line_number, "data type", yytext);
                    return INT;
                }
{DOUBLE}        {
                    printf("#%-2d %-11s: %s\n", line_number, "data type", yytext);
                    return DOUBLE;
                }
{CHAR}          {
                    printf("#%-2d %-11s: %s\n", line_number, "data type", yytext);
                    return CHAR;
                }
{RETURN}        {
                    printf("#%-2d return\n", line_number);
                    return RETURN;
                }

{ID}            {
                    printf("#%-2d %-11s: %s\n", line_number, "ID", yytext);
                    yylval.strVal = strdup(yytext);
                    return STRING;
                }
\(          {
                printf("#%-2d (\n", line_number);
                return LP;
            }
\)          {
                printf("#%-2d )\n", line_number);
                return RP;
            }
\{          {
                printf("#%-2d {\n", line_number);
                return LLP;
            }
\}          {
                printf("#%-2d }\n", line_number);
                return LRP;
            }
,           {
                printf("#%-2d ,\n", line_number);
                return COMMA;
            }
'           {
                printf("#%-2d '\n", line_number);
                char character = input();
                yylval.charVal = character;
                printf("#%-2d %-11s: %c\n", line_number, "character", character);
                character = input();
                printf("#%-2d '\n", line_number);
                return CHARACTER;
            }
;           {
                printf("#%-2d ;\n", line_number);
                return END;
            }

"/*"        {
                char prev_ch = '\0', cur_ch = input();
                for (;;) {
                    if(cur_ch == EOF)
                        break;
                    if(cur_ch == '\n')
                        printf("#%-2d comment\n", line_number++);
                    if(prev_ch == '*' && cur_ch == '/') {
                        printf("#%-2d comment\n", line_number);
                        break;
                    }
                    prev_ch = cur_ch;
                    cur_ch = input();
                }
            }
"//"        {
                char prev_ch = '\0', cur_ch = input();
                for (;;) {
                    if(cur_ch == EOF)
                        break;
                    if(cur_ch == '\n') {
                        printf("#%-2d comment\n", line_number++);
                        break;
                    }
                    prev_ch = cur_ch;
                    cur_ch = input();
                }
            }

\n	        {
                line_number++;
            }
[ \t]+      {
                /* Do nothing */
            }
.           {
                /* Do nothing */
            }

%%
/*
int main(){
	yylex();
	return 0;
}
*/
