%{
	#include "foo.tab.h"
	#include "fubar.h"
%}


num_with_pt [0-9]*\.[0-9]+|[0-9]+\.[0-9]*


%%

<<<<<<< HEAD
if 		{return IF;}
=======
if 			{return IF;}
>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
while 		{return WHILE;}
else		{return ELSE;}

{num_with_pt} {  // first
            	stringstream(yytext) >> yylval.x;  
            	return FLOATPT;
        	}


[0-9]+  	{
            	stringstream(yytext) >> yylval.i;  
            	return INTEGER;
        	}
\'.\'		{
		string s = yytext;
		yylval.s = save(s);
		return CHAR;
}
		
(((int|char|short|long|double|float)(\*)*[ ]+([0-9]|[a-zA-Z_])+[ ]*,[ ]*)*)  {
				string s = yytext;
				yylval.s = save(s); 
		           	return PARAMS;
				}

((([0-9]|[a-zA-Z_])+[ ]*,[ ]*)*)  {
				string s = yytext;
				yylval.s = save(s); 
		           	return CALLPARAMS;
				}

(int|char|short|long|double|float)(\*)*	{      	
				string s = yytext;
				yylval.s = save(s); 
		           	return TYPE;
        	}

void(\*)*	{      	
				string s = yytext;
				yylval.s = save(s); 
		           	return VOID;
        	}

"return"	{      	
				string s = yytext;
				yylval.s = save(s); 
		           	return RETURN;
        	}

<<<<<<< HEAD
[A-Za-z]+   {      	
				string s = yytext;
				yylval.s = save(s); 
            	return ID;
=======
[a-zA-Z_]+  	{      	
				string s = yytext;
				yylval.s = save(s); 
		           	return ID;
>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
        	}



\"[^"]*\"		{
			string s = yytext;
			yylval.s = save(s); 
			
			return STRING;
		}
=		{
			return *yytext;
		}

[-+*/\%]?=	{
			string s = yytext;
			yylval.s = saveOP(s);
			return AOP; }

[-+*/\%]		{
			string s = yytext;
			yylval.s = saveOP(s);
			return OP;}

==|!=|>|<|<=|>=	{
			string s = yytext;
			yylval.s = saveOP(s);
			return COP; }

--|\+\+		{
			string s = yytext;
			yylval.s = saveOP(s);
			return IOP; }


<<<<<<< HEAD
[-+*/\%]?=	{
			string s = yytext;
			yylval.s = saveOP(s);
			return AOP; }

[-+*/\%]		{
			string s = yytext;
			yylval.s = saveOP(s);
			return OP;}

==|!=|>|<|<=|>=	{
			string s = yytext;
			yylval.s = saveOP(s);
			return COP; }

--|\+\+		{
			string s = yytext;
			yylval.s = saveOP(s);
			return IOP; }


[;(){}]  	return *yytext;
=======
[=;(){}]  	return *yytext;
>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a


[ \t\n]   	; /* skip whitespace */


.       	yyerror("invalid character");
%%


int yywrap(void) {
	return 1;
}
