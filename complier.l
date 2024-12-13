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
DECIMAL_CONST [1-9][0-9]*
FLOAT_CONST [0-9][0-9]*[/.][0-9]*
HEXADECIMAL_CONST (0X|0x)[0-9a-fA-F]+
IDENT [a-zA-Z_][a-zA-Z0-9_]*

%%

{WHITESPACE}                        {}

"!="                                {printf("1\n");yylval.node = createNodeString("NE","!=");return NE;}
">="                                {printf("2\n");yylval.node = createNodeString("BE",">=");return BE;} 
"<="                                {printf("3\n");yylval.node = createNodeString("LE","<=");return LE;}
","                                 {printf("4\n");yylval.node = createNodeOp("COMMA");return COMMA;}
"!"                                 {printf("5\n");yylval.node = createNodeOp("NOT");return NOT;}
">"                                 {printf("6\n");yylval.node = createNodeString("BT",">");return BT;}
"<"                                 {printf("7\n");yylval.node = createNodeString("LT","<");return LT;}
"=="                                {printf("8\n");yylval.node = createNodeString("EQ","==");return EQ;}
"="                                 {printf("9\n");yylval.node = createNodeOp("ASSIGN");return ASSIGN;}
";"                                 {printf("10\n");yylval.node = createNodeOp("SEMICOLON");return SEMICOLON;}
"+"                                 {printf("11\n");yylval.node = createNodeOp("PLUS");return PLUS;}
"-"                                 {printf("12\n");yylval.node = createNodeOp("MINUS");return MINUS;}
"*"                                 {printf("13\n");yylval.node = createNodeOp("MULT");return MULT;}
"/"                                 {printf("14\n");yylval.node = createNodeOp("DIV");return DIV;}
"%"                                 {printf("15\n");yylval.node = createNodeOp("PERCENT");return PERCENT;}
"("                                 {printf("16\n");yylval.node = createNodeOp("LP");return LP;}
")"                                 {printf("17\n");yylval.node = createNodeOp("RP");return RP;}
"["                                 {printf("18\n");yylval.node = createNodeOp("LS");return LS;}
"]"                                 {printf("19\n");yylval.node = createNodeOp("RS");return RS;}
"{"                                 {printf("20\n");yylval.node = createNodeOp("LB");return LB;}
"}"                                 {printf("21\n");yylval.node = createNodeOp("RB");return RB;}
"||"                                {printf("22\n");yylval.node = createNodeOp("OR");return OR;}
"&&"                                {printf("23\n");yylval.node = createNodeOp("AND");return AND;}
"const"                             {printf("24\n");yylval.node = createNodeOp("CONST");return CONST;}
"int"                               {printf("25\n");yylval.node = createNodeOp("INT");return INT;}
"float"                             {printf("26\n");yylval.node = createNodeOp("FLOAT");return FLOAT;} 
"void"                              {printf("27\n");yylval.node = createNodeOp("VOID");return VOID;}
"if"                                {printf("28\n");yylval.node = createNodeOp("IF");return IF;}
"else"                              {printf("29\n");yylval.node = createNodeOp("ELSE");return ELSE;}
"while"                             {printf("30\n");yylval.node = createNodeOp("WHILE");return WHILE;}
"continue"                          {printf("31\n");yylval.node = createNodeOp("CONTINUE");return CONTINUE;}
"break"                             {printf("32\n");yylval.node = createNodeOp("BREAK");return BREAK;} 
"return"                            {printf("33\n");yylval.node = createNodeOp("RETURN");return RETURN;}

{FLOAT_CONST}                       {printf("34\n");yylval.node = createNodeFloat("FLOAT",atof(yytext));return FLOAT_CONST;}
{OCTAL_CONST}                       {printf("35\n");yylval.node = createNodeString("OCTAL_INT",yytext);return INT_CONST;}
{HEXADECIMAL_CONST}                 {printf("36\n");yylval.node = createNodeString("HEXADECIMAL_INT",yytext);return INT_CONST;}
{DECIMAL_CONST}                     {printf("37\n");yylval.node = createNodeInt("DECIMAL_CONST",atoi(yytext));return INT_CONST;}
{IDENT}                             {printf("38\n");yylval.node = createNodeString("IDENT",yytext);return ID;}

"//".*                              { }
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] { }
[/][*]                              { perror("fatal_error"); }

.                                   {printf("ERROR: NOT SUPPORT CHARACTER!\n");}

%%