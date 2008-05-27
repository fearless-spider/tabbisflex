OBJ = lex.o parser.o
FLEX = lex.yy.c lex.yy.h
BISON = parser.tab.c parser.tab.h
FLAGS = -Wall
OUTPUT = tabbisflex

result : $(OBJ)
	g++ -o $(OUTPUT) $(OBJ) -lfl $(FLAGS) 
lex.yy.c lex.yy.h : lexer.l
	flex -o lex.yy.c --header-file=lex.yy.h lexer.l
parser.tab.c parser.tab.h : parser.y symtab.h symtab.cpp
	bison -d parser.y
lex.o : parser.tab.h lex.yy.c
	g++ -c -o lex.o lex.yy.c $(FLAGS) 
parser.o : lex.yy.h parser.tab.c
	g++ -c -o parser.o parser.tab.c $(FLAGS) 
clean :
	rm -f symtab.o
	rm -f lex.o
	rm -f parser.o
	rm -f parser.tab.c
	rm -f lex.yy.c
	rm -f parser.tab.h
	rm -f lex.yy.h
	rm -f symtab

