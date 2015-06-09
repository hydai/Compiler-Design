#ifdef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H
const int TYPE_STRING = 0;
const int TYPE_NUMBER = TYPE_STRING + 1;

extern symbol symbol_table[128];
extern int symbol_table_index = 0;

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
int is_symbol_table_full();

#endif
