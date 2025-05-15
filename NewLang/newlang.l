%{
#include "newlang.tab.h"
#include <string.h>
int line_num = 1;
%}
%%
"BEGIN"       { return BEGIN_PROGRAM; }
"END"         { return END_PROGRAM; }
"let"         { return LET; }
"add"         { return ADD; }
"sub"         { return SUB; }
"mul"         { return MUL; }
"div"         { return DIV; }
"if"          { return IF; }
"then"        { return THEN; }
"else"        { return ELSE; }
"while"       { return WHILE; }
"into"        { return INTO; }
"to"          { return TO; }
"from"        { return FROM; }
">"           { return GT; }
"<"           { return LT; }
"=="          { return EQ; }
"!="          { return NE; }
"<="          { return LE; }
">="          { return GE; }
"="           { return ASSIGN; }
"{"           { return '{'; }
"}"           { return '}'; }
"("           { return '('; }
")"           { return ')'; }
";"           { return ';'; }
[0-9]+        { yylval.str = strdup(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*  { yylval.str = strdup(yytext); return ID; }
[ \t]         ;   // skip whitespace
\n            { line_num++; }  
.             { printf("Unknown character: %s\n", yytext); }
%%
int yywrap() {
    return 1;
}