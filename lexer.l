%option yylineno
%option nounput
%{
#include "parser.tab.h"

extern int yyerror(char *s);

%}

DIGIT			[0-9]
ALPHA			[A-Za-z]
INTEGER 		{DIGIT}+ 
REAL			{DIGIT}*"."{DIGIT}+([eE][-+]?{DIGIT}+)? 
ID			({ALPHA}|"_")({ALPHA}|{DIGIT}|"_")* 
BIAZNK			[ \t\n]

%%

program			{return PT_PROGRAM;}
begin			{return PT_BEGIN;}
end			{return PT_END;}
function		{return PT_FUNCTION;}
procedure		{return PT_PROCEDURE;}
var			{return PT_VAR;}
integer			{return PT_INTEGER;}
real			{return PT_REAL;}
array 			{return PT_ARRAY;}
of 			{return PT_OF;}
if			{return PT_IF;}
then			{return PT_THEN;}
else			{return PT_ELSE;}
repeat	{return PT_REPEAT;}
until	{return PT_UNTIL;}
read	{return PT_READ;}
write	{return PT_WRITE;}
while			{return PT_WHILE;}
do			{return PT_DO;}
div 			{return PT_DIV;}
mod 			{return PT_MOD;}
and			{return PT_AND;}
or			{return PT_OR;}
not			{return PT_NOT;}
":="			{return PT_ASSIGN;}
"="			{return PT_RW; }
"<>"			{return PT_NR;}
">="			{return PT_WR;}
">"			{return PT_JW;}
"<="			{return PT_MR;}
"<"			{return PT_JM;}
".."			{return PT_DOTS;}

{INTEGER}		{	yylval.intval = atoi(yytext);
				return PT_INTNUM;		}
{REAL}			{	yylval.realval = (float)atof(yytext);
				return PT_REALNUM;		}
{ID}			{	yylval.stringval = strdup(yytext);
				return PT_ID;			}
{BIAZNK}		{}

"-"|"*"|"/"|":"|";"|","|"."|"("|")"|"["|"]"|"+"	{return *yytext;}
.         		yyerror(yytext);

%%
