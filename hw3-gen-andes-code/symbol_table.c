#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"
struct symbol {
    char* text;
    int type;
    union {
        int int_val;
        char* str_val;
    } attr;
};
struct symbol symbol_table[128];
int symbol_table_index = 0;

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
struct entry entry_table[128];
int entry_table_index = 0;

char* create_new_string(char* source) {
    char* ret = NULL;
    ret = (char*)malloc(sizeof(char)*(strlen(source)+1));
    strcpy(ret, source);
    return ret;
}

int is_symbol_table_full() {
    if (symbol_table_index >= 128) {
        return 0;
    } else {
        return 1;
    }
}

int insert_to_symbol_table(char* symbol_text, int symbol_type) {
    if (is_symbol_table_full()) {
        // Failed
        return 1;
    }

    symbol_table[symbol_table_index].text = create_new_string(symbol_text);
    symbol_table[symbol_table_index].type = symbol_type;
    if (symbol_type == STRING) {
        // String
        symbol_table[symbol_table_index].attr.str_val = create_new_string(symbol_text);
    } else if (symbol_type == NUMBER) {
        // Integer
        symbol_table[symbol_table_index].attr.int_val = atoi(symbol_text);
    } else {
        // Unkown value
        symbol_table[symbol_table_index].attr.str_val = create_new_string(symbol_text);
    }
    // Increase index
    symbol_table_index = symbol_table_index + 1;
    // Success
    return 0;
}


void code_gen_with_header(FILE* fptr, char* file_name) {
    fprintf(fptr, "    .file 1 \"%s\"\n", file_name);
    fprintf(fptr, "    .section    .mdebug.abi_nds32\n");
    fprintf(fptr, "    .previous\n");
    fprintf(fptr, "    .text\n");
    fprintf(fptr, "    .align 2\n");
    fprintf(fptr, "    .globl main\n");
    fprintf(fptr, "    .type main, @function\n");
}
