%{
    #include "ASTnode.h"
    #include<stdio.h>
    extern int yylineno;
    extern FILE* yyin;
    int yylex(void);
    int yyerror(char* msg);
    int yyrestart(FILE *f);
    ASTnode* root ;
%}

%union{
    int INTNUM;
    int FLOATNUM;
    ASTnode* node ;
};

//tokens
%token<node>    NE
                BE
                LE
                COMMA
                NOT
                BT
                LT
                EQ
                ASSIGN
                SEMICOLON
                PLUS
                MINUS
                MULT
                DIV
                PERCENT
                LP
                RP
                LS
                RS
                LB
                RB
                CONST
                INT
                FLOAT
                VOID
                IF
                ELSE
                WHILE
                CONTINUE
                BREAK
                RETURN
                INT_CONST
                FLOAT_CONST
                ID
                AND
                OR

//associations 运算符优先级定义越早出现的优先级越低
%right ASSIGN //赋值优先级最低
%left AND OR //&& ||
%left LT BT LE BE EQ NE //< > <= >= == !=
%left PLUS MINUS MULT DIV PERCENT // + - * / %
%right NOT //"!"
%left LS RS LP RP //括号优先级最高

%nonassoc WHILE ELSE RETURN //表示这些运算符不能在不确定优先级的情况下连续出现

%type<node> CompUnit
            Decl
            ConstDecl
            ConstDecl_R
            ConstDef
            VecDef_R
            ConstInitVal
            ConstInitVal_R
            VarDecl
            VarDef
            VarDef_R
            InitVal
            InitVal_R
            FuncDef
            Type
            FuncFParams
            FuncFParam_R
            FuncFParam
            Vec_R
            Block
            BlockItem
            BlockItem_R
            Stmt
            Exp
            Cond
            LVal
            PrimaryExp
            NUMBER
            UnaryExp
            UnaryOp
            FuncRParams
            Exp_R
            MulExp
            AddExp
            RelExp
            EqExp
            LAndExp
            LOrExp
            ConstExp
%%

CompUnit        :CompUnit Decl {$$=createNodeOp("CompUnit");root=$$;addChild($$,$2);addChild($$,$1);}
                |CompUnit FuncDef {$$=createNodeOp("CompUnit");root=$$;addChild($$,$2);addChild($$,$1);}
                |Decl {$$=createNodeOp("CompUnit");root=$$;addChild($$,$1);}
                |FuncDef {$$=createNodeOp("CompUnit");root=$$;addChild($$,$1);}
                ;

Decl            :ConstDecl {$$=createNodeOp("Decl");addChild($$,$1);}
                |VarDecl {$$=createNodeOp("Decl");addChild($$,$1);}
                ;

ConstDecl       :CONST Type ConstDef ConstDecl_R SEMICOLON {$$=createNodeOp("ConstDecl");addChild($$,$5);addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

ConstDecl_R     :ConstDecl_R COMMA ConstDef {$$=createNodeOp("ConstDecl_R");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |/*empty*/ {$$=createNodeOp("ConstDecl_R");}
                ;



ConstDef        :ID VecDef_R EQ ConstInitVal {$$=createNodeOp("ConstDef");addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

VecDef_R        :VecDef_R LS ConstExp RS {$$=createNodeOp("VecDef_R");addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |/*empty*/ {$$=createNodeOp("VecDef_R");}
                ;

ConstInitVal    :ConstExp {$$=createNodeOp("ConstInitVal");addChild($$,$1);}
                |LB ConstInitVal ConstInitVal_R RB {$$=createNodeOp("ConstInitVal");addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |LB RB {$$=createNodeOp("ConstInitVal");addChild($$,$2);addChild($$,$1);}
                ;

ConstInitVal_R  :ConstInitVal_R COMMA ConstInitVal {$$=createNodeOp("ConstInitVal_R");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |/*empty*/ {$$=createNodeOp("ConstInitVal_R");}
                ;

VarDecl         :Type VarDef VarDef_R SEMICOLON {$$=createNodeOp("VarDecl");addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

VarDef          :ID VecDef_R {$$=createNodeOp("VarDef");addChild($$,$2);addChild($$,$1);}
                |ID VecDef_R ASSIGN InitVal {$$=createNodeOp("VarDef");addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

VarDef_R        :VarDef_R COMMA VarDef {$$=createNodeOp("VarDef_R");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |/*empty*/ {$$=createNodeOp("VarDef_R");}
                ;

InitVal         :Exp {$$=createNodeOp("InitVal");addChild($$,$1);}
                |LB InitVal InitVal_R RB {$$=createNodeOp("InitVal");addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |LB RB {$$=createNodeOp("InitVal");addChild($$,$2);addChild($$,$1);}
                ;

InitVal_R       :InitVal_R COMMA InitVal {$$=createNodeOp("InitVal_R");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |/*empty*/ {$$=createNodeOp("InitVal_R");}
                ;

FuncDef         :Type ID LP RP Block {$$=createNodeOp("FuncDef");addChild($$,$5);addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |Type ID LP FuncFParams RP Block {$$=createNodeOp("FuncDef");addChild($$,$6);addChild($$,$5);addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

Type            :VOID {$$=createNodeOp("Type");addChild($$,$1);}
                |INT {$$=createNodeOp("Type");addChild($$,$1);}
                |FLOAT {$$=createNodeOp("Type");addChild($$,$1);}
                ;

FuncFParams     :FuncFParam FuncFParam_R {$$=createNodeOp("FuncFParams");addChild($$,$2);addChild($$,$1);}
                ;

FuncFParam_R    :FuncFParam_R COMMA FuncFParam {$$=createNodeOp("FuncFParam_R");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |/*empty*/ {$$=createNodeOp("FuncFParam_R");}
                ;

FuncFParam      :Type ID {$$=createNodeOp("FuncFParam");addChild($$,$2);addChild($$,$1);}
                |Type ID LS RS Vec_R {$$=createNodeOp("FuncFParam");addChild($$,$5);addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ; 

Vec_R           :Vec_R LS Exp RS {$$=createNodeOp("Vec_R");addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |/*empty*/ {$$=createNodeOp("Vec_R");}
                ;

Block           :LB BlockItem_R RB {$$=createNodeOp("Block");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

BlockItem       :Decl {$$=createNodeOp("BlockItem");addChild($$,$1);}
                |Stmt {$$=createNodeOp("BlockItem");addChild($$,$1);}
                ;

BlockItem_R     :BlockItem_R BlockItem {$$=createNodeOp("BlockItem_R");addChild($$,$2);addChild($$,$1);}
                |/*empty*/ {$$=createNodeOp("BlockItem_R");}
                ;

Stmt            :LVal ASSIGN Exp SEMICOLON {$$=createNodeOp("Stmt");addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |Exp SEMICOLON {$$=createNodeOp("Stmt");addChild($$,$2);addChild($$,$1);}
                |SEMICOLON {$$=createNodeOp("Stmt");addChild($$,$1);}
                |Block {$$=createNodeOp("Stmt");addChild($$,$1);}
                |IF LP Cond RP Stmt {$$=createNodeOp("Stmt");addChild($$,$5);addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |IF LP Cond RP Stmt ELSE Stmt {$$=createNodeOp("Stmt");addChild($$,$7);addChild($$,$6);addChild($$,$5);addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |WHILE LP Cond RP Stmt {$$=createNodeOp("Stmt");addChild($$,$5);addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |BREAK SEMICOLON {$$=createNodeOp("Stmt");addChild($$,$2);addChild($$,$1);}
                |CONTINUE SEMICOLON {$$=createNodeOp("Stmt");addChild($$,$2);addChild($$,$1);}
                |RETURN SEMICOLON {$$=createNodeOp("Stmt");addChild($$,$2);addChild($$,$1);}
                |RETURN Exp SEMICOLON {$$=createNodeOp("Stmt");addChild($$,$3);addChild($$,$2);addChild($$,$1);}

Exp             :AddExp {$$=createNodeOp("Exp");addChild($$,$1);}
                ;

Cond            :LOrExp {$$=createNodeOp("Cond");addChild($$,$1);}
                ;

LVal            :ID Vec_R {$$=createNodeOp("LVal");addChild($$,$2);addChild($$,$1);}
                ;


PrimaryExp      :LP Exp RP {$$=createNodeOp("PrimaryExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |LVal {$$=createNodeOp("PrimaryExp");addChild($$,$1);}
                |NUMBER {$$=createNodeOp("PrimaryExp");addChild($$,$1);}
                ;

NUMBER          :INT_CONST {$$=createNodeOp("NUMBER");addChild($$,$1);}
                |FLOAT_CONST {$$=createNodeOp("NUMBER");addChild($$,$1);}
                ;

UnaryExp        :PrimaryExp {$$=createNodeOp("UnaryExp");addChild($$,$1);}
                |ID LP FuncRParams RP {$$=createNodeOp("UnaryExp");addChild($$,$4);addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |ID LP RP {$$=createNodeOp("UnaryExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |UnaryOp UnaryExp {$$=createNodeOp("UnaryExp");addChild($$,$2);addChild($$,$1);}
                ;

UnaryOp         :PLUS {$$=createNodeOp("UnaryOp");addChild($$,$1);}
                |MINUS {$$=createNodeOp("UnaryOp");addChild($$,$1);}
                |NOT {$$=createNodeOp("UnaryOp");addChild($$,$1);}
                ;

FuncRParams     :Exp Exp_R {$$=createNodeOp("FuncRParams");addChild($$,$2);addChild($$,$1);}
                ;

Exp_R           :Exp_R COMMA Exp {$$=createNodeOp("Exp_R");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |/*empty*/ {$$=createNodeOp("Exp_R");}
                ;

MulExp          :UnaryExp {$$=createNodeOp("MulExp");addChild($$,$1);}
                |MulExp MULT UnaryExp {$$=createNodeOp("MulExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |MulExp DIV UnaryExp {$$=createNodeOp("MulExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |MulExp PERCENT UnaryExp {$$=createNodeOp("MulExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

AddExp          :MulExp {$$=createNodeOp("AddExp");addChild($$,$1);}
                |AddExp PLUS MulExp {$$=createNodeOp("AddExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |AddExp MINUS MulExp {$$=createNodeOp("AddExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

RelExp          :AddExp {$$=createNodeOp("RelExp");addChild($$,$1);}
                |RelExp LT AddExp {$$=createNodeOp("RelExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |RelExp BT AddExp {$$=createNodeOp("RelExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |RelExp LE AddExp {$$=createNodeOp("RelExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |RelExp BE AddExp {$$=createNodeOp("RelExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

EqExp           :RelExp {$$=createNodeOp("EqExp");addChild($$,$1);}
                |EqExp EQ RelExp {$$=createNodeOp("EqExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                |EqExp NE RelExp {$$=createNodeOp("EqExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

LAndExp         :EqExp {$$=createNodeOp("LAndExp");addChild($$,$1);}
                |LAndExp AND EqExp {$$=createNodeOp("LAndExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

LOrExp          :LAndExp {$$=createNodeOp("LOrExp");addChild($$,$1);}
                |LOrExp OR LAndExp {$$=createNodeOp("LOrExp");addChild($$,$3);addChild($$,$2);addChild($$,$1);}
                ;

ConstExp        :AddExp {$$=createNodeOp("ConstExp");addChild($$,$1);}
                ;

%%

int yyerror(char *msg) {
    fprintf(stderr, "Error: %s at line %d\n", msg, yylineno);
    return 0;
}

int main(int argc, char **argv) {
    FILE *file;
    if (argc > 1) {
        file = fopen(argv[1], "r");
        if (!file) {
            perror("Error opening file");
            return 1;
        }
    } else {
        file = stdin;
    }
    if (file == stdin) {
        yylineno = 1 ;
        yyparse();
        printTree(root,0) ;
    } else {
        yyin = file;
        yyparse();
        printTree(root,0) ;
        fclose(file);
    }
    return 0;
}