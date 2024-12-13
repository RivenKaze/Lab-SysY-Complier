bison -d .\complier.y
flex .\complier.l
gcc -o complier ASTnode.c complier.tab.c lex.yy.c
del lex.yy.c
del complier.tab.h 
del complier.tab.c
.\complier.exe .\test\test1.sy > result\test1.log