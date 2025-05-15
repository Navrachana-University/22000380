%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern FILE *yyout;
extern int yylex();
extern int line_num;
void yyerror(const char *s);

// Function to generate new temporary variables
char* newTemp();

// Function to generate new labels
char* newLabel();

int tempCount = 1;  // Counter for temporary variables
int labelCount = 1; // Counter for labels

%}

%union {
    char* str;
}

%token <str> ID NUMBER
%token BEGIN_PROGRAM END_PROGRAM LET ADD SUB MUL DIV IF THEN ELSE WHILE 
%token INTO TO FROM GT LT EQ NE LE GE ASSIGN

%type <str> expr term factor condition

/* Precedence rules to avoid shift/reduce conflicts */
%left '+' '-'
%left '*' '/'

%%

program
    : BEGIN_PROGRAM {
        fprintf(yyout, "BEGIN\n");
    } 
    statement_list END_PROGRAM {
        fprintf(yyout, "END\n");
    }
    ;

statement_list
    : statement
    | statement_list statement
    ;

statement
    : variable_decl
    | operation_stmt
    | if_stmt
    | while_stmt
    ;

variable_decl
    : LET ID ASSIGN expr ';' {
        fprintf(yyout, "%s = %s\n", $2, $4);
    }
    ;

operation_stmt
    : ADD expr TO ID ';' {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s + %s\n", temp, $4, $2);
        fprintf(yyout, "%s = %s\n", $4, temp);
    }
    | SUB expr FROM ID ';' {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s - %s\n", temp, $4, $2);
        fprintf(yyout, "%s = %s\n", $4, temp);
    }
    | ADD expr expr INTO ID ';' {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s + %s\n", temp, $2, $3);
        fprintf(yyout, "%s = %s\n", $5, temp);
    }
    | SUB expr expr INTO ID ';' {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s - %s\n", temp, $2, $3);
        fprintf(yyout, "%s = %s\n", $5, temp);
    }
    | MUL expr expr INTO ID ';' {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s * %s\n", temp, $2, $3);
        fprintf(yyout, "%s = %s\n", $5, temp);
    }
    | DIV expr expr INTO ID ';' {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s / %s\n", temp, $2, $3);
        fprintf(yyout, "%s = %s\n", $5, temp);
    }
    ;

if_stmt
    : IF '(' condition ')' THEN '{' {
        char* true_label = newLabel();
        char* false_label = newLabel();
        char* end_label = newLabel();
        
        fprintf(yyout, "if %s goto %s\n", $3, true_label);
        fprintf(yyout, "goto %s\n", false_label);
        fprintf(yyout, "%s:\n", true_label);
    } 
    statement_list '}' ELSE '{' {
        char* end_label = newLabel();
        fprintf(yyout, "goto %s\n", end_label);
        fprintf(yyout, "L%d:\n", labelCount - 2); // false_label
    }
    statement_list '}' {
        fprintf(yyout, "L%d:\n", labelCount - 1); // end_label
    }
    ;

while_stmt
    : WHILE '(' {
        char* loop_start = newLabel();
        fprintf(yyout, "%s:\n", loop_start);
    }
    condition ')' '{' {
        char* body_label = newLabel();
        char* end_label = newLabel();
        fprintf(yyout, "if %s goto %s\n", $4, body_label);
        fprintf(yyout, "goto %s\n", end_label);
        fprintf(yyout, "%s:\n", body_label);
    }
    statement_list '}' {
        fprintf(yyout, "goto L%d\n", labelCount - 3); // loop_start
        fprintf(yyout, "L%d:\n", labelCount - 1);    // end_label
    }
    ;

condition
    : expr LT expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s < %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr GT expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s > %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr EQ expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s == %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr NE expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s != %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr LE expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s <= %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr GE expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s >= %s\n", temp, $1, $3);
        $$ = temp;
    }
    ;

expr
    : term {
        $$ = $1;
    }
    | expr '+' term {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr '-' term {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s - %s\n", temp, $1, $3);
        $$ = temp;
    }
    ;

term
    : factor {
        $$ = $1;
    }
    | term '*' factor {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s * %s\n", temp, $1, $3);
        $$ = temp;
    }
    | term '/' factor {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s / %s\n", temp, $1, $3);
        $$ = temp;
    }
    ;

factor
    : ID {
        $$ = $1;
    }
    | NUMBER {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s\n", temp, $1);
        $$ = temp;
    }
    | '(' expr ')' {
        $$ = $2;
    }
    ;

%%

char* newTemp() {
    char* buffer = malloc(10);
    sprintf(buffer, "t%d", tempCount++);
    return buffer;
}

char* newLabel() {
    char* buffer = malloc(10);
    sprintf(buffer, "L%d", labelCount++);
    return buffer;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", line_num, s);
}

int main() {
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    
    if (!yyin) {
        fprintf(stderr, "Could not open input.txt\n");
        return 1;
    }
    
    if (!yyout) {
        fprintf(stderr, "Could not create output.txt\n");
        return 1;
    }
    
    yyparse();
    
    fclose(yyin);
    fclose(yyout);
    
    return 0;
}