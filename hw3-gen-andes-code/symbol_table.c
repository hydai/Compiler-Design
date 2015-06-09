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
    fprintf(fptr, "\t.file\t\"%s\"\n", file_name);
    fprintf(fptr, "\t.section\t.mdebug.abi_nds32\n");
    fprintf(fptr, "\t.previous\n");
}


void code_gen_function_header(FILE* fptr, char* func_name) {
    fprintf(fptr, "\t.text\n");
    fprintf(fptr, "\t.align\t2\n");
    fprintf(fptr, "\t.global\t%s\n", func_name);
    fprintf(fptr, "\t.type\t%s, @function\n", func_name);
    fprintf(fptr, "%s:\n", func_name);
    fprintf(fptr, "\tpush.s\t{ $fp $lp }\n");
    fprintf(fptr, "\taddi\t$fp,\t$sp,\t8\n");
    fprintf(fptr, "\taddi\t$sp,\t$sp,\t-16\n");
}


void code_gen_function_body_end(FILE* fptr, char* func_name) {
    fprintf(fptr, "\taddi\t$sp,\t$fp,\t-8\n");
    fprintf(fptr, "\tpop.s\t{ $fp $lp }\n");
    fprintf(fptr, "\tret\n");
    fprintf(fptr, "\t.size\t%s, .-%s\n", func_name, func_name);
}


void code_gen_with_end(FILE* fptr) {
    fprintf(fptr, "\t.ident  \"GCC: (GNU) 4.9.0\"\n");
}
