#ifndef _ASTNODE_H
#define _ASTNODE_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node{
    int lineno ;
    char name[16] ;
    char value[32] ;
    int int_val ;
    struct Node *child ;
    struct Node *next ;
}ASTnode;
ASTnode *createNodeOp(char* name);
ASTnode *createNodeString(char* name,char* value);
ASTnode *createNodeInt(char* name,int int_val);
void addChild(ASTnode* fa,ASTnode* child);
void printTree(ASTnode* root,int count);

#endif