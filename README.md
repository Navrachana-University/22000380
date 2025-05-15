README.txt
==========

Project Title:
--------------
*NewLang Compiler using FLEX and BISON*

Description:
------------
This project is a simple compiler for a custom-designed language called *NewLang*. The compiler is built using **FLEX** (Fast Lexical Analyzer) and **BISON** (GNU parser generator). The language features C-style syntax and supports basic variable assignments, arithmetic operations, conditionals, and loops. The compiler processes a source file written in NewLang and generates intermediate code (three-address code style) as output.

NewLang is designed to introduce beginners to compiler design concepts such as lexical analysis, parsing, intermediate code generation, control structures, and temporary variable management.

Language Syntax Overview:
-------------------------
NewLang includes the following features:
- Variable declaration and initialization using `let`
- Arithmetic operations: `add`, `sub`, `mul`, `div`
- Combined operations with `into` and `from` syntax
- Conditional branching using `if`, `then`, `else`
- Loops using `while` and comparison operators: `<`, `>`, `==`, `!=`, `<=`, `>=`

Example Input (input.txt):
----------------------------
BEGIN

let x = 5;
let y = 10;

add x y into z;
sub x y into w;
mul x y into v;
div x y into u;

if (z > 10) then {
    sub 1 from z;
}    
else {
    add 1 to z;
}
while (z < 20) {
    add 1 to z;
}

END

How it Works:
-------------
1. *Lexical Analysis* (in `.l` file):
   - Uses FLEX to tokenize keywords like `let`, `add`, `sub`, `if`, `while`, etc.
   - Recognizes identifiers, numbers, operators, and symbols.
   - Skips whitespaces and tracks line numbers for debugging.
   - Unrecognized characters are flagged with an error message.

2. *Parsing and Intermediate Code Generation* (in `.y` file):
   - Uses BISON to define the grammar rules and parsing structure.
   - Translates NewLang statements into intermediate three-address code.
   - Supports temporary variable generation and label handling for control flow.
   - Outputs generated code to a file (`output.txt`) using `fprintf`.

Compilation Instructions:
-------------------------
To compile the project run the following commands in a terminal:
1) flex newlang.l  
2) bison -d newlang.y  
3) gcc lex.yy.c newlang.tab.c -o newlang  
4) ./newlang    # This reads from input.txt and writes to output.txt

Files:
------
- newlang.l - FLEX file for lexical analysis
- newlang.y - BISON file for syntax analysis and code generation
- input.txt - Sample input in NewLang
- output.txt - Generated intermediate code
- newlang.tab.h, newlang.tab.c, lex.yy.c - Generated during compilation

Author:
-------
Aum Bosmiya
