%{
	#include "type.h"
    #include <stdio.h>
	#include <stdlib.h>
	
	
    void yyerror(char *str) {
		fprintf(stderr, "Error: %s\n", str);
	}
	
	extern FILE *yyin;
	
%}


/*%union YYSTYPE
	{
		struct
		{
			int val;
			char* type;
		};
	}*/


%token CLASS
%token PUBLIC
%token STATIC
%token MAIN 
%token IF
%token ELSE
%token WHILE
%token NEW
%token PRINTLN 
%token TYPE_STRING
%token TYPE_INT
%token TYPE_BOOLEAN
%token TYPE_VOID 
%token LEFTBRACE
%token RIGHTBRACE
%token LEFTBRACKET
%token RIGHTBRACKET
%token LEFTPARENTHESE
%token RIGHTPARENTHESE 
%token EQUAL
%token EXCLAMATION
%token COMMA
%token SEMICOLON 
%token TRUE
%token FALSE
%token IDENTIFIER
%token INTEGER
%token OP_AND
%token OP_OR
%token OP_LESSTHAN
%token OP_ADD
%token OP_MINUS
%token OP_TIMES


%%
Program: MainClass
	|	/* empty */
	;

MainClass: CLASS IDENTIFIER LEFTBRACE PUBLIC STATIC TYPE_VOID MAIN LEFTPARENTHESE TYPE_STRING LEFTBRACKET RIGHTBRACKET IDENTIFIER RIGHTPARENTHESE LEFTBRACE StatementList RIGHTBRACE RIGHTBRACE
	;

StatementList: StatementList Statement
	|	/* empty */
	;
	
Statement: LEFTBRACE StatementList RIGHTBRACE
	|	IF LEFTPARENTHESE Exp RIGHTPARENTHESE Statement ELSE Statement
	|	WHILE LEFTPARENTHESE Exp RIGHTPARENTHESE Statement
	|	PRINTLN LEFTPARENTHESE Exp RIGHTPARENTHESE SEMICOLON
	|	IDENTIFIER EQUAL Exp SEMICOLON
	|	IDENTIFIER LEFTBRACKET Exp RIGHTBRACKET EQUAL Exp SEMICOLON
	|	VarDecl
	;
	
VarDecl: Type idList SEMICOLON
	;

Type: TYPE_INT LEFTBRACKET RIGHTBRACKET
	|	TYPE_BOOLEAN
	|	TYPE_INT
	|	IDENTIFIER
	;
	
idList: IDENTIFIER
	|	IDENTIFIER COMMA idList
	|	IDENTIFIER EQUAL Exp
	|	IDENTIFIER EQUAL Exp COMMA idList
	;

Exp: Exp OP_OR ExpAnd
					{
						if (strcmp($1.type, "Boolean") == 0 && strcmp($3.type, "Boolean") == 0) {
							$$.val = $1.val || $3.val;
							$$.type = "Boolean";
							if ($$.val == 1)
								printf("\ntrue\n");
							else
								printf("\nfalse\n");
						}
						else
							$$.type = "String";
					}
	|	ExpAnd	
					{
						if (strcmp($1.type, "String") != 0) {
							$$.val = $1.val;
							$$.type = $1.type;
						}
						else
							$$.type = "String";
					}
	;

ExpAnd: ExpAnd OP_AND ExpLessthan
					{
						if (strcmp($1.type, "Boolean") == 0 && strcmp($3.type, "Boolean") == 0) {
							$$.val = $1.val && $3.val;
							$$.type = "Boolean";
							if ($$.val == 1)
								printf("\ntrue\n");
							else
								printf("\nfalse\n");
						}
						else
							$$.type = "String";
					}
	|	ExpLessthan	
					{
						if (strcmp($1.type, "String") != 0) {
							$$.val = $1.val;
							$$.type = $1.type;
						}
						else
							$$.type = "String";
					}
	;

ExpLessthan: ExpLessthan OP_LESSTHAN ExpAddMinus
	|	ExpAddMinus
					{
						$$.val = $1.val;
						$$.type = $1.type;
					}
	;

ExpAddMinus: ExpAddMinus OP_ADD ExpTimes	
					{
						if (strcmp($1.type, "Integer") == 0 && strcmp($3.type, "Integer") == 0) {
							$$.val = $1.val + $3.val;
							$$.type = "Integer";
							printf("\n%d\n", $$.val);
						}
						else
							$$.type = "String";
					}
	|	ExpAddMinus OP_MINUS ExpTimes	
					{
						if (strcmp($1.type, "Integer") == 0 && strcmp($3.type, "Integer") == 0) {
							$$.val = $1.val - $3.val;
							$$.type = "Integer";
							printf("\n%d\n", $$.val);
						}
						else
							$$.type = "String";
					}
	|	ExpTimes	
					{
						if (strcmp($1.type, "String") != 0) {
							$$.val = $1.val;
							$$.type = $1.type;
						}
						else
							$$.type = "String";
					}
	;

ExpTimes: ExpTimes OP_TIMES Exp0	
					{
						if (strcmp($1.type, "Integer") == 0 && strcmp($3.type, "Integer") == 0) {
							$$.val = $1.val * $3.val;
							$$.type = "Integer";
							printf("\n%d\n", $$.val);
						}
						else
							$$.type = "String";
					}
	|	Exp0	
					{
						if (strcmp($1.type, "String") != 0) {
							$$.val = $1.val;
							$$.type = $1.type;
						}
						else
							$$.type = "String";
					}
	;
	
Exp0: INTEGER	{$$.val = $1.val; $$.type = $1.type}
	|	TRUE	{$$.val = $1.val; $$.type = $1.type}
	|	FALSE	{$$.val = $1.val; $$.type = $1.type}
	|	NEW TYPE_INT LEFTBRACKET Exp RIGHTBRACKET
	|	IDENTIFIER
	|	IDENTIFIER LEFTBRACKET Exp RIGHTBRACKET
	|	LEFTPARENTHESE Exp RIGHTPARENTHESE	
					{
						if (strcmp($2.type, "String") != 0) {
							$$.val = $2.val;
							$$.type = $2.type;
						}
					}
	|	EXCLAMATION IDENTIFIER
	|	EXCLAMATION IDENTIFIER LEFTBRACKET Exp RIGHTBRACKET
	|	EXCLAMATION LEFTPARENTHESE Exp RIGHTPARENTHESE
					{
						if (strcmp($3.type, "Boolean") == 0) {
							if ($3.val == 1) {
								$$.val = 0;
								printf("\nfalse\n");
							}
							else {
								$$.val = 1;
								printf("\ntrue\n");
							}
							$$.type = $3.type;
						}
					}
	;

%%

void main (int argc, char *argv[])
{
    ++argv, --argc; /* skip over program name */
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;
	
    yyparse();
}
