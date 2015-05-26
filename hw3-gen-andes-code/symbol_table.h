#ifdef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H
const int SYMBOL_TABLE_SIZE = 128;
typedef struct {
    char* text;
    int token;
    union {
        int int_val;
        char* str_val;
    } attr;
} symbol;

symbol symbol_table[SYMBOL_TABLE_SIZE];
int symbol_table_index = 0;

/*************************Utils*************************/
/*  char* create_new_string(char* source)
    @function:  malloc and copy a new instance of source
    @param:     char*   - origin string
    @retval:    char*   - new string
*/
char* create_new_string(char* source);

/*************************Generate ASM*************************/
/*  int insert_to_symbol_table(char* symbol_text, int symbol_type)
    @function:  insert a new symbol to symbol table
    @param1:    char*   - left expression string
    @param2:    int     - type of the symbol
    @retval:    int     - 0 if success, otherwise return 1
*/
int insert_to_symbol_table(char* symbol_text, int symbol_type);
void code_gen_with_header(FILE* fptr, char* file_name);

#endif
