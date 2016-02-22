%{
	#include <stdio.h>
	#include "type.h"
	#include "hw2.tab.h"
	
	
%}

letter		[a-zA-Z]
digit		[0-9]
character	[\=\-\+\_\(\)\&\^\%\$\#\@\!\`\~\\\]\[\|\}\{\'\;\"\:\.\,\?\>\<]
whitespace	[ \t\r]
newline		[\n]

%%
class												/*printf("%s", yytext);*/ return CLASS; 
public												/*printf("%s", yytext);*/ return PUBLIC;
static												/*printf("%s", yytext);*/ return STATIC;
main												/*printf("%s", yytext);*/ return MAIN;
if													/*printf("%s", yytext);*/ return IF;
else												/*printf("%s", yytext);*/ return ELSE;
while												/*printf("%s", yytext);*/ return WHILE;
new													/*printf("%s", yytext);*/ return NEW;
(System.out.println)								/*printf("%s", yytext);*/ return PRINTLN;
String												/*printf("type_String");*/ return TYPE_STRING;
int													/*printf("type_int");*/ return TYPE_INT;
boolean												/*printf("type_boolean");*/ return TYPE_BOOLEAN;
void												/*printf("type_void");*/ return TYPE_VOID;
[\{]												/*printf("%s", yytext);*/ return LEFTBRACE;
[\}]												/*printf("%s", yytext);*/ return RIGHTBRACE;
[\[]												/*printf("%s", yytext);*/ return LEFTBRACKET;
[\]]												/*printf("%s", yytext);*/ return RIGHTBRACKET;
[\(]												/*printf("%s", yytext);*/ return LEFTPARENTHESE;
[\)]												/*printf("%s", yytext);*/ return RIGHTPARENTHESE;
[\=]												/*printf("%s", yytext);*/ return EQUAL;
[\!]												/*printf("%s", yytext);*/ return EXCLAMATION;
[\,]												/*printf("%s", yytext);*/ return COMMA;
[\;]												/*printf("%s", yytext);*/ return SEMICOLON;
true												/*printf("_true");*/ yylval.val = 1; yylval.type = "Boolean"; return TRUE; 
false												/*printf("_false");*/ yylval.val = 0; yylval.type = "Boolean"; return FALSE;
{letter}({letter}|{digit}|_)* 						/*printf("_identifier");*/ yylval.val = (int)strdup(yytext); yylval.type = "String"; return IDENTIFIER;
0|([1-9]{digit}*)									/*printf("_integer");*/ yylval.val = atoi(yytext); yylval.type = "Integer"; return INTEGER;
"&&"												/*printf("_and");*/ return OP_AND;
"||"												/*printf("_or");*/ return OP_OR;
"<"													/*printf("_lessthan");*/ return OP_LESSTHAN;
"+"													/*printf("_add");*/ return OP_ADD;
"-"													/*printf("_minus");*/ return OP_MINUS;
"*"													/*printf("_times");*/ return OP_TIMES;
(\/\/({letter}|{digit}|{character}|[\*]|[\/]|{whitespace})*\n)|(\/\*({letter}|{digit}|{whitespace}|[\n]|{character}|[\/]|\*+({letter}|{digit}|{whitespace}|[\n]|{character}))*\*+\/)		/*printf("\ncomments_\n");*/
{newline}											/*printf("\n");*/
{whitespace}+										/*printf("\t");*/

.								printf("\nERROR: %s\n", yytext); fflush(stdout); exit(1);
%%
/*
int main( int argc, char **argv )
{
	++argv, --argc;
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;
	yylex();
}
*/