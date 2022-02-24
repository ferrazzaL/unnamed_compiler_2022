/*
Leonardo Ferrazza
Thales Paim
*/
%{
#include <stdio.h>

int yylex(void);
extern int get_line_number();
int yyerror (char const *s){
	printf("%s, on line %d\n", s, get_line_number());
	return 1;
}
%}

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_CHAR
%token TK_PR_STRING
%token TK_PR_IF
%token TK_PR_THEN
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_DO
%token TK_PR_INPUT
%token TK_PR_OUTPUT
%token TK_PR_RETURN
%token TK_PR_CONST
%token TK_PR_STATIC
%token TK_PR_FOREACH
%token TK_PR_FOR
%token TK_PR_SWITCH
%token TK_PR_CASE
%token TK_PR_BREAK
%token TK_PR_CONTINUE
%token TK_PR_CLASS
%token TK_PR_PRIVATE
%token TK_PR_PUBLIC
%token TK_PR_PROTECTED
%token TK_PR_END
%token TK_PR_DEFAULT
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_OC_SL
%token TK_OC_SR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_LIT_CHAR
%token TK_LIT_STRING
%token TK_IDENTIFICADOR
%token TOKEN_ERRO
%start programa

%left '+' '-' '/' '%' '|' '^' '!' '?' ':' TK_OC_LE TK_OC_GE TK_OC_EQ TK_OC_NE TK_OC_AND TK_OC_OR
%right '&' '*' '#'

%%

programa:
	g_var programa
	|func programa
	|/*%empty*/;

/*UTILITY*/
type_static:
	type_list
	|TK_PR_STATIC type_list;

type_const:
	type_list
	|TK_PR_CONST type_list;

type_static_const:
	type_list
	|TK_PR_STATIC type_list
	|TK_PR_CONST type_list
	|TK_PR_STATIC TK_PR_CONST type_list;

type_list:
	TK_PR_INT
	|TK_PR_FLOAT
	|TK_PR_CHAR
	|TK_PR_BOOL
	|TK_PR_STRING;

literal:
	TK_LIT_INT
	|TK_LIT_FLOAT
	|TK_LIT_FALSE
	|TK_LIT_TRUE
	|TK_LIT_CHAR
	|TK_LIT_STRING;


/*GLOBAL VARIABLES*/
g_var:
	type_static g_v_list ';';


g_v_list:
	g_v_name
	|g_v_name ',' g_v_list;

g_v_name:
	TK_IDENTIFICADOR
	|TK_IDENTIFICADOR '[' TK_LIT_INT ']';

/*FUNCTIONS*/
func:
	head body;

head:
	type_static f_name parameters;

f_name:
	TK_IDENTIFICADOR;

parameters:
	'(' ')'
	|'(' parameter_list ')';
	
parameter_list:
	type_const TK_IDENTIFICADOR
	|type_const TK_IDENTIFICADOR ',' parameter_list;

body:
	block;

/*BLOCK*/
block:
	'{' '}'
	|'{' command_list '}';

command_list:
	command ';'
	|command ';' command_list
	|flow_command
	|flow_command command_list;


/*COMMANDS*/
command:
	declaration
	|attribution
	|input
	|output
	|return
	|break
	|continue
	|block
	|call
	|shift;

flow_command:
	control;

/*DECLARATION*/
declaration:
	type_static_const l_v_list;

l_v_list:
	l_v_name
	|l_v_name ',' l_v_list;

l_v_name:
	TK_IDENTIFICADOR
	|TK_IDENTIFICADOR TK_OC_LE TK_IDENTIFICADOR
	|TK_IDENTIFICADOR TK_OC_LE literal;

/*ATTRIBUTION*/
attribution:
	TK_IDENTIFICADOR '=' expression
	|TK_IDENTIFICADOR '[' expression ']' '=' expression;

/*INPUT and OUTPUT*/
input:
	TK_PR_INPUT TK_IDENTIFICADOR;

output:
	TK_PR_OUTPUT TK_IDENTIFICADOR
	|TK_PR_OUTPUT literal;

/*FUNCTION CALL*/
call:
	TK_IDENTIFICADOR '(' ')'
	|TK_IDENTIFICADOR '(' arg_list ')';

arg_list:
		argument
	|argument ',' arg_list;

argument:
	expression;

/*SHIFT COMMANDS*/
shift:
	TK_IDENTIFICADOR shift_command TK_LIT_INT
	|TK_IDENTIFICADOR '[' expression ']' shift_command TK_LIT_INT;

shift_command:
	TK_OC_SL
	|TK_OC_SR;

/*RETURN, BREAK and CONTINUE COMMANDS*/
return:
	TK_PR_RETURN expression;

break:
	TK_PR_BREAK;

continue:
	TK_PR_CONTINUE;


/*FLOW CONTROL*/
control:
	if
	|for
	|while;

if:
	TK_PR_IF '(' expression ')' block
	|TK_PR_IF '(' expression ')' block TK_PR_ELSE block;

for:
	TK_PR_FOR '(' attribution ':' expression ':' attribution ')' block;

while:
	TK_PR_WHILE '(' expression ')' TK_PR_DO block;


/*EXPRESSIONS*/
expression:
	'+' operand
	|'-' operand
	|'!' operand
	|'&' operand
	|'*' operand
	|'?' operand
	|'#' operand
	|operand '*' operand
	|operand '/' operand
	|operand '+' operand
	|operand '-' operand
	|operand '%' operand
	|operand '|' operand
	|operand '&' operand
	|operand '^' operand
	|operand TK_OC_LE operand
	|operand TK_OC_GE operand
	|operand TK_OC_EQ operand
	|operand TK_OC_NE operand
	|operand TK_OC_AND operand
	|operand TK_OC_OR operand
	|operand '?' operand ':' operand; 


operand:
	TK_IDENTIFICADOR
	|TK_IDENTIFICADOR '[' expression ']'
	|TK_LIT_INT
	|TK_LIT_FLOAT
	|TK_LIT_TRUE
	|TK_LIT_FALSE
	|call
	|expression
	|'(' expression ')';


%%
