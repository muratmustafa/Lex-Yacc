%{
	#include "y.tab.h"
	void yyerror (char *s);
%}

%%
"print"			        {return print;}
"exit"			        {return exit_command;}
"if"					   {return IF;}		
"else"                      {return ELSE;}
"while"                     {return WHILE;}
"<="    				   {return LE;}
">="    			        {return GE;}
"=="                        {return EQ;}
"!="    			        {return NE;}
"||"    				   {return OR;}
"&&"    			        {return AND;}  
[a-zA-Z]			        {yylval.id = yytext[0]; return identifier;}
[0-9]+                      {yylval.num = atoi(yytext); return number;}
[ \t\n]                     ;
[-+*/<>!(){}=;]             {return yytext[0];}
.                      	   {ECHO; yyerror ("Unexpected character\n");}
%%

int yywrap (void)
{
	return 1;
}
