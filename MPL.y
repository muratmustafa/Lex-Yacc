%{
	#include<stdio.h>
	#include<stdlib.h>
	
	int flag = 0;
	int yylex();
	int symbols[52];
	int symbolVal(char symbol);
	void updateSymbolVal(char symbol, int val);
	void yyerror(char *s);
%}

%union {int num; char id;}
%start lines
%token print exit_command 
%token <num> IF ELSE WHILE LE GE EQ NE OR AND 
%token <num> number
%token <id> identifier
%type  <num> line exp term factor condition
%type  <id> assignment print 
%right '='
%left  AND OR
%left  '<' '>' LE GE EQ NE
%left  '*''/'
%left  '+''-'
%right  '!'
%expect 1

%%

lines          : exit_command					{ printf("OK\n"); }
			| line lines					{ ; }
			;

line			: assignment						{ ; }
			| print exp						{ printf("%d\n",$2); }
			| IF '('condition')' line ELSE line	{ ; }
			| IF '('condition')' line			{ ; }
			| WHILE '('condition')' line			{ ; }
			;		 
		 
		
assignment : identifier '=' exp 	{updateSymbolVal($1, $3);}
		 ;
		 
condition	 : condition '>' term 		{ $$ = $1 > $3  ? 1 : 0; }
		 | condition '<' term 		{ $$ = $1 < $3  ? 1 : 0; } 
		 | condition GE  term 		{ $$ = $1 >= $3 ? 1 : 0; }
		 | condition LE  term 		{ $$ = $1 <= $3 ? 1 : 0; }
		 | condition EQ  term 		{ $$ = $1 == $3 ? 1 : 0; }
		 | condition NE  term 		{ $$ = $1 != $3 ? 1 : 0; }
		 | condition OR  term		{ $$ = $1 || $3 ? 1 : 0; }
		 | condition AND term 		{ $$ = $1 && $3 ? 1 : 0; }
		 | exp				     { $$ = $1; }
		 ;		 

exp 	      : term 				{ $$ = $1; }
		 | exp '+' term		{ $$ = $1 + $3; }
		 | exp '-' term 		{ $$ = $1 - $3; }
		 | '!'term	 		{ $$ = !$2; } 
		 ;

term 	 : factor				{ $$ = $1; }
		 | term '*' factor 		{ $$ = $1 * $3; }
		 | term '/' factor 		{ $$ = $1 / $3; }	
		 ;
		 
factor 	 : number				{$$ = $1; }
		 | identifier 			{$$ = symbolVal($1); }
		 ;
		  
%%

int computeSymbolIndex(char token)
{
	int idx = -1;
	
	if(token >= 'a' && token <= 'z')
	{
		idx = token - 'a' + 26;
	} 
	
	else if(token >= 'A' && token <= 'Z') 
	{
		idx = token - 'A';
	}
	
	return idx;
} 

int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	
	return symbols[bucket];
}

void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	
	symbols[bucket] = val;
}

int main (void) 
{
	
	yyparse();
		
	return 0;
}

void yyerror (char *s) 
{
	fprintf (stderr, "%s\n", s);
	
	flag = 1;
}
