#include "ASTnode.h"
extern int yylineno;

ASTnode* createNodeOp(char* name)
{
    ASTnode *node ;
    node = malloc(sizeof(*node)) ;
    strcpy(node->name,name) ;
    node->child = NULL ;
    node->next = NULL ;
    node->lineno = yylineno ;
    return node ; 
}

ASTnode* createNodeString(char* name,char* value)
{
    ASTnode *node ;
    node = malloc(sizeof(*node)) ;
    strcpy(node->name,name) ;
    strcpy(node->value,value) ;
    node->child = NULL ;
    node->next = NULL ;
    node->lineno = yylineno ;
    return node ; 
}

ASTnode* createNodeInt(char* name,int int_val)
{
    ASTnode *node ;
    node = malloc(sizeof(*node)) ;
    strcpy(node->name,name) ;
    node->int_val = int_val ;
    node->child = NULL ;
    node->next = NULL ;
    node->lineno = yylineno ;
    return node ; 
}

void addChild(ASTnode* fa,ASTnode* child)
{
    if(child == NULL)
    {
        fa->child = NULL ;
        return ;
    }
    if(fa != NULL && child != NULL)
    {
        child->next = fa->child ;
        fa->child = child ;
        fa->lineno = child->lineno ;
    }
}

void printTree(ASTnode* root,int count)
{
    if(root == NULL) return ;
    if(root->child == NULL)
    {
        for(int i = 0 ; i < count ; i++)
        {
            printf(" ") ;
        }
        if(strcmp(root->name,"TYPE") == 0
            || strcmp(root->name,"INTCONST") == 0
            || strcmp(root->name,"ID") == 0)
        {
            if(strcmp(root->child,"INTCONST") == 0)
            {
                printf("%s: %d\n",root->name,root->int_val) ;
            }
            else
            {
                printf("%s: %s\n",root->name,root->value) ;
            }
        }
        else
        {
            printf("%s\n",root->name) ;
        }
    }
    else
    {
        for(int i = 0 ; i < count ; i++)
        {
            printf(" ") ;
        }
        printf("%s(%d)\n",root->name,root->lineno) ;
        ASTnode* nxt = root->child ;
        while(nxt != NULL)
        {
            printTree(nxt,count+1) ;
            nxt = nxt->child ;
        }
    }
    return ;
}