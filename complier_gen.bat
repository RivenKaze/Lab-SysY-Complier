@echo off
bison -d .\complier.y
flex .\complier.l
gcc -o complier ASTnode.c complier.tab.c lex.yy.c
del lex.yy.c
del complier.tab.h 
del complier.tab.c
.\complier.exe .\test\test1.sy > result\test1.log
.\complier.exe .\test\test2.sy > result\test2.log
.\complier.exe .\test\test3.sy > result\test3.log
.\complier.exe .\test\test4.sy > result\test4.log
.\complier.exe .\test\test5.sy > result\test5.log
.\complier.exe .\test\test6.sy > result\test6.log
.\complier.exe .\test\test7.sy > result\test7.log