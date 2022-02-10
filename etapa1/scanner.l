%{
#include "stdlib.h"
#include "tokens.h"

int lines = 1;

int get_line_number() {
	return lines;
}

%}

white [ \t]+
digit [0-9]
letter [a-zA-Z]
alphabetic {letter}|_
alphanumeric {alphabetic}|{digit}

spec_char [,;:\(\)\[\]\{\}\+\-\|\*\/<>=!&%#^.$]
control_char "\\0"|"\\t"|"\\n"|"\\v"|"\\f"|"\\r"


int_lit (\-|\+)?{digit}+
float_lit {int_lit}\.{digit}+((E|e){int_lit})?
false_lit "false"
true_lit "true"
char_lit '{alphanumeric}|{spec_char}'

id {alphabetic}{alphanumeric}*

linebreak \n
inlinecomment \/\/.*
block_start \/\*
block_end \*\/

%x MULTILINE_COMMENT
%option yylineno

%%
 /*PALAVRAS RESERVADAS*/
"int" 		{ return TK_PR_INT; }
"float" 	{ return TK_PR_FLOAT; }
"bool" 		{ return TK_PR_BOOL;}
"char" 		{ return TK_PR_CHAR; }
"string"	{ return TK_PR_STRING; }
"if" 		{ return TK_PR_IF; }
"then" 		{ return TK_PR_THEN; }
"else" 		{ return TK_PR_ELSE; }
"while"		{ return TK_PR_WHILE; }
"do"		{ return TK_PR_DO; }
"input"		{ return TK_PR_INPUT; }
"output"	{ return TK_PR_OUTPUT; }
"return"	{ return TK_PR_RETURN; }
"const"		{ return TK_PR_CONST; }
"static"	{ return TK_PR_STATIC; }
"foreach"	{ return TK_PR_FOREACH; }
"for"		{ return TK_PR_FOR; }
"switch"	{ return TK_PR_SWITCH; }
"case"		{ return TK_PR_CASE; }
"break"		{ return TK_PR_BREAK; }
"continue"	{ return TK_PR_CONTINUE; }
"class"		{ return TK_PR_CLASS; }
"private"	{ return TK_PR_PRIVATE; }
"public"	{ return TK_PR_PUBLIC; }
"protected"	{ return TK_PR_PROTECTED; }
"end"		{ return TK_PR_END; }
"default"	{ return TK_PR_DEFAULT; }

 /*CARACTERES ESPECIAIS*/
{spec_char} { return yytext[0]; }

 /*OPERADORES COMPOSTOS*/
"<=" 	{ return TK_OC_LE; }
">=" 	{ return TK_OC_GE; }
"==" 	{ return TK_OC_EQ; }
"!=" 	{ return TK_OC_NE; }
"&&" 	{ return TK_OC_AND; }
"||"	{ return TK_OC_OR; }
">>"	{ return TK_OC_SR; }
"<<"	{ return TK_OC_SL; }

 /*LITERAIS*/
{int_lit} { return TK_LIT_INT; }
{float_lit} { return TK_LIT_FLOAT; }
{char_lit} { return TK_LIT_CHAR; }
{true_lit} { return TK_LIT_TRUE; }
{false_lit} { return TK_LIT_FALSE; }
\"[^\"\n]*\" { return TK_LIT_STRING; }

 /*IDENTIFICADORES*/
{id} { return TK_IDENTIFICADOR; }

{linebreak} { ++lines; }
{white} { }
{inlinecomment} { }

{block_start} { BEGIN(MULTILINE_COMMENT); }
<MULTILINE_COMMENT>{block_end} {  BEGIN(INITIAL); }
<MULTILINE_COMMENT>{linebreak} { ++lines; }
<MULTILINE_COMMENT>. { }

. { return TOKEN_ERRO; }

%%


