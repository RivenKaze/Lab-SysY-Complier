%{
    #include <ctype.h>
    #include <string.h>
    #include "ASTnode.h"
    #include <stdio.h>
    #include "complier.tab.h"
%}

%option yylineno
%option noyywrap

WHITESPACE [ \t\n]
OCTAL_CONST 0[0-7]+
DECIMAL_CONST [0-9][0-9]*
FLOAT_CONST [0-9][0-9]*[/.][0-9]*
HEXADECIMAL_CONST (0X|0x)[0-9a-fA-F]+
IDENT [a-zA-Z_][a-zA-Z0-9_]*

%%

{WHITESPACE}                        {}

"!="                                {yylval.node = createNodeString("NE","!=");return NE;}
">="                                {yylval.node = createNodeString("BE",">=");return BE;} 
"<="                                {yylval.node = createNodeString("LE","<=");return LE;}
","                                 {yylval.node = createNodeOp("COMMA");return COMMA;}
"!"                                 {yylval.node = createNodeOp("NOT");return NOT;}
">"                                 {yylval.node = createNodeString("BT",">");return BT;}
"<"                                 {yylval.node = createNodeString("LT","<");return LT;}
"=="                                {yylval.node = createNodeString("EQ","==");return EQ;}
"="                                 {yylval.node = createNodeOp("ASSIGN");return ASSIGN;}
";"                                 {yylval.node = createNodeOp("SEMICOLON");return SEMICOLON;}
"+"                                 {yylval.node = createNodeOp("PLUS");return PLUS;}
"-"                                 {yylval.node = createNodeOp("MINUS");return MINUS;}
"*"                                 {yylval.node = createNodeOp("MULT");return MULT;}
"/"                                 {yylval.node = createNodeOp("DIV");return DIV;}
"%"                                 {yylval.node = createNodeOp("PERCENT");return PERCENT;}
"("                                 {yylval.node = createNodeOp("LP");return LP;}
")"                                 {yylval.node = createNodeOp("RP");return RP;}
"["                                 {yylval.node = createNodeOp("LS");return LS;}
"]"                                 {yylval.node = createNodeOp("RS");return RS;}
"{"                                 {yylval.node = createNodeOp("LB");return LB;}
"}"                                 {yylval.node = createNodeOp("RB");return RB;}
"||"                                {yylval.node = createNodeOp("OR");return OR;}
"&&"                                {yylval.node = createNodeOp("AND");return AND;}
"const"                             {yylval.node = createNodeOp("CONST");return CONST;}
"int"                               {yylval.node = createNodeOp("INT");return INT;}
"float"                             {yylval.node = createNodeOp("FLOAT");return FLOAT;} 
"void"                              {yylval.node = createNodeOp("VOID");return VOID;}
"if"                                {yylval.node = createNodeOp("IF");return IF;}
"else"                              {yylval.node = createNodeOp("ELSE");return ELSE;}
"while"                             {yylval.node = createNodeOp("WHILE");return WHILE;}
"continue"                          {yylval.node = createNodeOp("CONTINUE");return CONTINUE;}
"break"                             {yylval.node = createNodeOp("BREAK");return BREAK;} 
"return"                            {yylval.node = createNodeOp("RETURN");return RETURN;}

{FLOAT_CONST}                       {yylval.node = createNodeFloat("FLOAT",atof(yytext));return FLOAT_CONST;}
{OCTAL_CONST}                       {yylval.node = createNodeString("OCTAL_INT",yytext);return INT_CONST;}
{HEXADECIMAL_CONST}                 {yylval.node = createNodeString("HEXADECIMAL_INT",yytext);return INT_CONST;}
{DECIMAL_CONST}                     {yylval.node = createNodeInt("DECIMAL_CONST",atoi(yytext));return INT_CONST;}
{IDENT}                             {yylval.node = createNodeString("IDENT",yytext);return ID;}

"//".*                              { }
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] { }
[/][*]                              { perror("fatal_error"); }

.                                   {printf("ERROR: NOT SUPPORT CHARACTER!\n");}

%%