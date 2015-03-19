%{
    int line_number = 1;
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
DATA_TYPE   ({INTEGER}|{FLOATING})
OPERATOR    ({ADD}|{MINUS}|{MULTIPLY}|{DIVIDE}|{GTE}|{LTE}|{ASSIGN}|{GT}|{LT})
RETURN      return
DOUBLE_VAL  -?([0-9]\.[0-9]+)
INT_VAL     -?([0]|[1-9][0-9]*)

%%

{OPERATOR}      {
                    printf("#%d operator : %s\n", line_number, yytext);
                }
{DOUBLE_VAL}    {
                    printf("#%d number : %s\n", line_number, yytext);
                }
{INT_VAL}       {
                    printf("#%d number : %s\n", line_number, yytext);
                }
{DATA_TYPE}     {
                    printf("#%d data type : %s\n", line_number, yytext);
                }
{RETURN}        {
                    printf("#%d return\n", line_number);
                }

{ID}            {
                    printf("#%d ID : %s\n", line_number, yytext);
                    /*
                       function ID
                       variable ID
                     */
                }
\(          {
                printf("#%d (\n", line_number);
            }
\)          {
                printf("#%d )\n", line_number);
            }
{           {
                printf("#%d {\n", line_number);
            }
}           {
                printf("#%d }\n", line_number);
            }
,           {
                printf("#%d ,\n", line_number);
            }
;           {
                printf("#%d ;\n", line_number);
            }

"/*"        {
                char prev_ch = '\0', cur_ch = input();
                for (;;) {
                    if(cur_ch == EOF)
                        break;
                    if(cur_ch == '\n')
                        printf("#%d comment\n", line_number++);
                    if(prev_ch == '*' && cur_ch == '/') {
                        printf("#%d comment\n", line_number);
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
                        printf("#%d comment\n", line_number++);
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
