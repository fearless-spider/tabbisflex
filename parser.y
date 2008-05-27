%{ 
#include <iostream>
#include <stdio.h>
#include <string>
#include "symtab.cpp"

unsigned int licznik_id = 1;
int preustaw_type = NONE;
unsigned int isref = nRefer;
unsigned int scope_ctrl = 1;
string tmpname = "";
unsigned int ret_args = NONE;

extern FILE* yyin;		//smierc flexowo-lexowy
extern char* yytext;
int yylex();			

int yyerror(char *s);
FILE* fp_output;

// %union declaration specifies the entire list of possible types - used instead of defining YYSTYPE.
%}

%union { 
  int intval; 
  double realval; 
  char* stringval; 
}

%token <stringval> PT_ID 
%token <intval> PT_INTNUM 
%token <realval> PT_REALNUM

%token	PT_PROGRAM
%token 	PT_BEGIN
%token 	PT_END
%token	PT_REPEAT
%token	PT_UNTIL
%token	PT_READ
%token	PT_WRITE
%token 	PT_NOT
%token 	PT_ASSIGN
%token 	PT_JW
%token 	PT_JM
%token 	PT_WR
%token 	PT_MR
%token 	PT_WHILE
%token 	PT_DO
%token 	PT_DIV
%token 	PT_MOD
%token	PT_FUNCTION
%token	PT_PROCEDURE
%token	PT_VAR
%token 	PT_INTEGER
%token 	PT_REAL
%token 	PT_ARRAY
%token 	PT_OF
%token	PT_IF
%token	PT_THEN
%token	PT_ELSE
%token 	PT_AND
%token 	PT_OR
%token 	PT_NR
%token 	PT_RW
%token 	PT_DOTS

%%
program: 		PT_PROGRAM			{symtab.start();
										printf("Poczatek\n");}
			PT_ID {printf(" Znaleziono program: %s", yylval.stringval);} 
			'(' PT_ID ',' {printf(" (%s,",yylval.stringval)}
			PT_ID ')' ';'   {printf(" %s)\n\n",yylval.stringval); printf("Dekleracje:\n");}
			declare_sect   {printf("\nFunkcje:\n");}
			subprograms   
			code_sect   	{printf("Czesc z kodem:\n");}
			'.'				{printf("To jest juz koniec"); symtab.wypisz();}
;
id_list:		PT_ID				{symtab.add(yytext); symtab.ustaw_ref(isref);printf("Znaleziono identyfikator: %s\n",yylval.stringval);}
			| id_list ',' {licznik_id++;} PT_ID	{symtab.add(yytext); symtab.ustaw_ref(isref);printf("Znaleziono identyfikator: %s\n",yylval.stringval);}
;
declare_sect:		declare_sect PT_VAR {printf("Znaleziono slowo var\n");} id_list ':' type ';'
{
  symtab.ustaw_typ(licznik_id,preustaw_type);
  licznik_id=1;
  preustaw_type=0;
}
			|
;
type:			base_type
			|PT_ARRAY '[' PT_INTNUM		{symtab.ustaw_poczatekTablicy(licznik_id,yylval.intval);}
			 PT_DOTS PT_INTNUM		{symtab.ustaw_koniecTablicy(licznik_id,yylval.intval);}
			 ']' PT_OF base_type 		{symtab.ustaw_typTablicy(licznik_id,preustaw_type); preustaw_type = tTablica;}
;
base_type:		PT_INTEGER	  		{preustaw_type = tInt;printf("znaleziono slowo integer\n");}
			|PT_REAL				{preustaw_type = tReal;printf("znaleziono slowo real\n");}
;
subprograms:		subprograms sub_declaration ';'
			|
;
sub_declaration:	sub_start declare_sect code_sect
;
sub_start:		PT_FUNCTION {isref = Refer;printf("znaleziono slowo function\n");} PT_ID {printf("Function %s\n",yylval.stringval);}
{
  symtab.add(yytext);
  tmpname= yytext;
  symtab.ustaw_typ(licznik_id,tFunkcja);
  symtab.ustaw_ref(isref);
}
			 arguments ':' base_type
{
  symtab.ustaw_typZwracany(tmpname,preustaw_type);
  preustaw_type=NONE;
}
			 ';' 
			| PT_PROCEDURE {isref = Refer;} PT_ID		
{
  symtab.add(yytext);
  tmpname = yytext;
  symtab.ustaw_typ(licznik_id,tProcedura);
  symtab.ustaw_ref(isref);
}
			 arguments ';' 
;
arguments:		'(' param_list ')' { symtab.ustaw_args(tmpname,ret_args); ret_args=0; tmpname=""; }
			|
;

param_list:		id_list ':' type 
{ symtab.ustaw_typ(licznik_id,preustaw_type); ret_args +=licznik_id; licznik_id=1; preustaw_type=NONE; isref = nRefer;} 
			| param_list ';' id_list ':' type 
{ symtab.ustaw_typ(licznik_id,preustaw_type); ret_args +=licznik_id; licznik_id=1; preustaw_type=NONE; isref = nRefer;} 
;
code_sect:		PT_BEGIN code_body PT_END 
;
code_body:	 	statements 
			| statements ';'
			|
;
statements:		statement  
			| statements ';' statement 	
;
statement:		variable PT_ASSIGN expr 
			| procedure_statement 
			| code_sect
			| PT_IF {printf("Znaleziono: IF\n");} expr PT_THEN {printf("Znaleziono: THEN\n");}statement  
			| PT_IF {printf("Znaleziono: IF\n");} expr PT_THEN {printf("Znaleziono: THEN\n");} statement PT_ELSE statement {printf("Zanleziono: ELSE\n");}
			| PT_WHILE expr PT_DO statement

;
variable:		PT_ID | PT_ID '[' expr ']' 
;
procedure_statement:	PT_ID 
			| PT_ID '(' expr_list ')' 
;
expr_list:		expr
			| expr_list ',' expr 
			|
;

expr:			simple_expr 
			| simple_expr PT_JW simple_expr 
			| simple_expr PT_WR simple_expr 
			| simple_expr PT_MR simple_expr 
			| simple_expr PT_NR  simple_expr 
			| simple_expr PT_RW simple_expr 
			| simple_expr PT_JM  simple_expr 
;
simple_expr:		term
			| sign term 
			| simple_expr '+' term 
			| simple_expr '-' term
			| simple_expr PT_OR term 
;
term:			factor  
			| term '*' factor 
			| term '/' factor 
			| term PT_DIV factor 
			| term PT_MOD factor 
			| term PT_AND factor
;
factor:			variable 
			| PT_ID '('expr_list')' 
			| PT_INTNUM
			| PT_REALNUM 
			| '(' expr ')'
			| PT_NOT factor
;
sign:			'-'
			| '+'
;

%%
char name[100];
int main(int argc, char *argv[]) {
  if(argc != 2) {
    printf("\nBrak wejsciowego pliku PAS\\n");
    return 0;
  }

  FILE* fp_input;
  if((fp_input=fopen(argv[1], "r")) == NULL) {
    printf("\nNie udalo sie otworzyc pliku OUTPUT\n\n");
    return 0;
  }
  yyin = fp_input;

  if((fp_output = fopen("output.asm","w+")) == NULL) { 	
  printf("\nNie udalo sie otworzyc pliku\n\n");		
}
  yyparse();
  fclose(fp_input);
  fclose(fp_output);
  return 0;
}

int yyerror (char *s) {
    printf("yyerror cos zwrocil:\n%s\n",s);
    return 0;
}
