%{
    int line_number = 1;
    int char_flag = 0;
    char unknownID[128];
%}
%Start      UNKNOWNID
%Start      DATATYPE
LETTER      [a-zA-Z_]
DIGIT       [0-9]
ID          {LETTER}({LETTER}|{DIGIT})*
ADD         [\+]
MINUS       [\-]
MULTIPLY    [\*]
DIVIDE      [\/]
GTE         ">="
LTE         "<="
ASSIGN      "="
GT          ">"
LT          "<"
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
OPERATOR    ({ADD}|{MINUS}|{MULTIPLY}|{DIVIDE}|{GTE}|{LTE}|{ASSIGN}|{GT}|{LT})
RETURN      return
DOUBLE_VAL  ([0-9]\.[0-9]+)
INT_VAL     ([0]|[1-9][0-9]*)

%%

<UNKNOWNID>" "  ;
<UNKNOWNID>"("  {
                    printf("#%-2d %-11s: %s\n", line_number, "function ID", unknownID);
                    printf("#%-2d (\n", line_number);
                    BEGIN INITIAL;
                }
<UNKNOWNID>"="  {
                    printf("#%-2d %-11s: %s\n", line_number, "variable ID", unknownID);
                    printf("#%-2d %-11s: =\n", line_number, "operator");
                    BEGIN INITIAL;
                }
<UNKNOWNID>.    {
                    printf("#%-2d %-11s: %s\n", line_number, "variable ID", unknownID);
                    unput(yytext[0]);
                    BEGIN INITIAL;
                }
{OPERATOR}      {
                    printf("#%-2d %-11s: %s\n", line_number, "operator", yytext);
                }
{DOUBLE_VAL}    {
                    printf("#%-2d %-11s: %s\n", line_number, "number", yytext);
                }
{INT_VAL}       {
                    printf("#%-2d %-11s: %s\n", line_number, "number", yytext);
                }
{DATA_TYPE}     {
                    printf("#%-2d %-11s: %s\n", line_number, "data type", yytext);
                    BEGIN DATATYPE;
                }
{RETURN}        {
                    printf("#%-2d return\n", line_number);
                }

{ID}            {
                    strcpy(unknownID, yytext);
                    BEGIN UNKNOWNID;
                    //printf("#%-2d %-11s: %s\n", line_number, "variable ID", yytext);
                }
\(          {
                printf("#%-2d (\n", line_number);
            }
\)          {
                printf("#%-2d )\n", line_number);
            }
\{          {
                printf("#%-2d {\n", line_number);
            }
\}          {
                printf("#%-2d }\n", line_number);
            }
,           {
                printf("#%-2d ,\n", line_number);
            }
'           {
                printf("#%-2d '\n", line_number);
                if (char_flag == 0) {
                    char_flag = 1;
                    char character = input();
                    printf("#%-2d %-11s: %c\n", line_number, "character", character);
                } else {
                    char_flag = 0;
                }
            }
;           {
                printf("#%-2d ;\n", line_number);
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
int main(){
	yylex();
	return 0;
}
