%union {
	int i;
	float x;
	char c;
	int s;
}

<<<<<<< HEAD

%token <s> ID
=======
%token <s> VOID
%token <s> TYPE
%token <s> ID
%token <s> RETURN
>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
%token <x> FLOATPT
%token <i> INTEGER
%token <s> CHAR
%token <s> PARAMS
%token <s> CALLPARAMS
%token <s> STRING
%token <s> IF
%token <s> WHILE
%token <s> ELSE
%token <s> OP
%token <s> COP
%token <s> AOP
%token <s> IOP
<<<<<<< HEAD
%type <s> expr
=======
%type <s> block
%type <s> params
%type <s> callparams
%type <s> statements
%type <s> statement
%type <s> expr
%type <s> sexpr
>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
%type <s> exp
/*
%type <s> oper
%type <s> coper
%type <s> aoper
%type <s> ioper
%type <s> sexpr
%type <s> ifexpr
%type <s> whexpr
%type <s> else
*/


%left '+'


%{
	#include "fubar.h"
	//open file to write digraph to
	FILE *fchart = fopen("fchart.dot", "w");
	//position of final node at the end of top level control structures
	int nc = 0;
	//recursive depth
	int depth = 0;
	//maximum recursive depth in this recursion
	//int maxdepth = 0;
	//maximum node, place to continue after recursion complete
	int maxnode = 0;
	//assumes a recursive depth of less than 101
	//holds the number of junk (non-control) nodes at each level
	int junk[100];
	int junkSize = sizeof(junk)/sizeof(junk[0]);
	//number of control nodes at each level
	int atDepth[100];
	int atDepthSize = sizeof(atDepth)/sizeof(atDepth[0]);
	//stores current node for reuse in if else statements
	int storeCurrent[100];
	int storeCurrentSize = sizeof(storeCurrent)/sizeof(storeCurrent[0]);
	//stores the current file position for rewinding at the end of while and if else statements
	long int pos = 0;
	int lsize = 0;



	int ltype[100];
	int ltypeSize = sizeof(ltype)/sizeof(ltype[0]);
%}


%%


program: program fndef | {cout << "ready" << endl; }
    	;
fndef: void '(' params ')' block 
	{ 
		if(junk[0] != 0) {
			nc = nc + junk[0] + 1;
			junk[0] = 0;
			fprintf(fchart, "%d[label = \"\"]", nc);

		}
		else {
			fprintf(fchart, "%d[label = \"\"]", nc + 1);
		}
		
		
		
	}
	| type '(' params ')' returnblock 	{ //cout << "function defined" << endl;
										}
       	;

void:
	VOID ID
	{ 
		
		fprintf(fchart, "%d->%d\n%d[label = \"%s\"]", nc, nc + 1, nc, lookup($2).c_str());
		//nc++;
	};

type:
	TYPE ID
	{ 
		
		fprintf(fchart, "%d->%d\n%d[label = \"%s\"]", nc, nc + 1, nc, lookup($2).c_str());
		//nc++;
	};

params: PARAMS params { $$ = save(lookup($1)+lookup($2));} | 
	TYPE ID {save(lookup($1)+ " " +lookup($2));}|
		{$$ = save("");}
	;

callparams: CALLPARAMS callparams { $$ = save(lookup($1)+lookup($2));} |
	ID {$$ = $1;} | 
		{$$ = save("");}
	

	;

block: '{' statements '}'   { $$ = saveBlock(lookupStatements($2));} 	 
    	;

returnblock: '{' statements return';' '}'    	 
    	;

return : RETURN exp { 
			//$$ = save(lookup($2)+";");

			//get current node
			int current = nc;
			//increment number of junk nodes at this level
			junk[depth]++;
			//add number of junk nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
				current += junk[i];
			}
			//add number of control nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
			current += atDepth[i];
			}
			//if this is the last node increase last node
			if(current + 1 > maxnode) {
				maxnode = current + 1;
			}

			
			//cout << maxdepth;

			//store position to rewind if need
			pos = ftell(fchart);

			//add junk node to the graph
			//fprintf(fchart, "%d->%d\n", current, current + 1);
			
			lsize = ftell(fchart) - pos;

			fprintf(fchart, "%d[label = \"return %s\", shape = \"circle\"]\n", current, lookup($2).c_str());
			
		};

statements:
    	statements statement   	{ 
									$$ = saveStatements(lookupStatements($1) + lookup($2) + "\\n");
									
								} 
    	| 			
		{ 
			$$ = saveStatements("");
				
		}
		
    	;
statement:
<<<<<<< HEAD
		IF '(' expr ')' block 	{cout << "if expression found" << endl;}
		| WHILE '(' expr ')' block 	{cout << "while expression found" << endl;}
    	| IF '(' expr ')' block ELSE block {cout << "if else expression found" << endl;}
    	| block
    	| ';'
    	| expr ';'           	{ cout << "expression " << lookup($1) << endl; }
    	//| iexpr ';'          	{ cout << "integer expression: " << fixed << setprecision(0) << lookup($1) << endl; }
    	//| sexpr ';' 		{ cout  << "string: " << '"' << lookup($1) << '"' << endl; }
	;

expr:
    	exp COP exp	{ 
    			  	string s = lookup($1); 
				  	//cout << "iexpr: " << s << endl;
				  	s += lookupOP($2);
				  	//cout << "iexpr oper: " << s << endl;
				  	s += lookup($3);
				  	//cout << "iexpr oper iexpr: " << s << endl;
  				 	$$ = save(s); } 
		| exp
		| ID AOP exp	{
					string s = lookup($1); 
				  	//cout << "iexpr: " << s << endl;
				  	s += lookupOP($2);
				  	//cout << "iexpr oper: " << s << endl;
				  	s += lookup($3);
				  	//cout << "iexpr oper iexpr: " << s << endl;
  				 	$$ = save(s); } 
    	;

exp:
    	INTEGER              	{ $$ = save(to_string($1)); }
		| FLOATPT              	{ $$ = save(to_string($1)); }
		| ID	              	{ $$ = $1;}
    	| expr OP expr    	{ 
    			  	string s = lookup($1); 
				  	//cout << "iexpr: " << s << endl;
				  	s += lookupOP($2);
				  	//cout << "iexpr oper: " << s << endl;
				  	s += lookup($3);
				  	//cout << "iexpr oper iexpr: " << s << endl;
  				 	$$ = save(s); }
		| ID IOP    			{ 
    			  	string s = lookup($1); 
				  	//cout << "iexpr: " << s << endl;
				  	s += lookupOP($2);
  				 	$$ = save(s); }
=======
	//assignment 
	TYPE ID '=' exp ';'
		{ 
			//$$ = save(lookup($1)+";");

			ltype[depth] = 1;


			//get current node
			int current = nc;
			//increment number of junk nodes at this level
			junk[depth]++;
			//add number of junk nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
				current += junk[i];
			}
			//add number of control nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
			current += atDepth[i];
			}
			//if this is the last node increase last node
			if(current + 1 > maxnode) {
				maxnode = current + 1;
			}

			
			//cout << maxdepth;

			//store position to rewind if need
			pos = ftell(fchart);

			//add junk node to the graph
			fprintf(fchart, "%d->%d\n", current, current + 1);
			
			lsize = ftell(fchart) - pos;

			fprintf(fchart, "%d[label = \"%s %s = %s\", shape = \"rectangle\"]\n", current, lookup($1).c_str(), lookup($2).c_str(),lookup($4).c_str());
			
		}

	//void function call		
	| ID'('callparams')'';'
		{ 
			$$ = save(lookup($1)+";");

			ltype[depth] = 1;


			//get current node
			int current = nc;
			//increment number of junk nodes at this level
			junk[depth]++;
			//add number of junk nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
				current += junk[i];
			}
			//add number of control nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
			current += atDepth[i];
			}
			//if this is the last node increase last node
			if(current + 1 > maxnode) {
				maxnode = current + 1;
			}

			
			//cout << maxdepth;

			//store position to rewind if need
			pos = ftell(fchart);

			//add junk node to the graph
			fprintf(fchart, "%d->%d\n", current, current + 1);
			
			lsize = ftell(fchart) - pos;

			fprintf(fchart, "%d[label = \"%s (%s)\", shape = \"rectangle\"]\n", current, lookup($1).c_str(), lookup($3).c_str());
			
		}


	//non-void function call
	| ID '=' ID'('callparams')'';'
		{ 
			$$ = save(lookup($1)+";");

			ltype[depth] = 1;


			//get current node
			int current = nc;
			//increment number of junk nodes at this level
			junk[depth]++;
			//add number of junk nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
				current += junk[i];
			}
			//add number of control nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
			current += atDepth[i];
			}
			//if this is the last node increase last node
			if(current + 1 > maxnode) {
				maxnode = current + 1;
			}

			
			//cout << maxdepth;

			//store position to rewind if need
			pos = ftell(fchart);

			//add junk node to the graph
			fprintf(fchart, "%d->%d\n", current, current + 1);
			
			lsize = ftell(fchart) - pos;

			fprintf(fchart, "%d[label = \"%s = %s(%s)\", shape = \"rectangle\"]\n", current, lookup($1).c_str(),lookup($3).c_str(),lookup($5).c_str());
			
		}

	//if expression		
	| IF sexpr statement 	
	{


		//cout << depth << "\n";
		//determine current node
		int current = nc;
		//depth - 1 since depth is incremented before code run
		//add number of junk nodes
		for(int i = depth - 1; i >= 0; i--) {
			current += junk[i];
		}

		
		//add number of control nodes
		for(int i = depth - 1; i >= 0; i--) {
			current += atDepth[i];
		}

		if(ltype[depth] == 0) {
			pos = ftell(fchart);
		}

		//add node to graph linking to statements if true
		fprintf(fchart, "%d->%d[label = true]\n", current, current + 1);

		if(ltype[depth] == 0) {
			lsize = ftell(fchart) - pos;
		}

		fprintf(fchart, "%d[label = \"%s\", shape = diamond]", current, lookup($2).c_str());

		//check if end node highest, else swap end node
		if(current + junk[depth] + 1 > maxnode) {
			maxnode = current + junk[depth] + 1;
		}



		//connect false part to end of if statement
		fprintf(fchart, "%d->%d[label= false]\n", current, maxnode);




		ltype[depth - 1] = 4;
		ltype[depth] = 0;

		junk[depth - 1] += junk[depth];
		junk[depth] = 0;
		atDepth[depth - 1] += atDepth[depth];
		atDepth[depth] = 0;

		
		//drop to next level
		depth--;
		
		//reset everything if bottom of recursion
		if(depth == 0) {

			//set node count at end of recursion to highest numbered node
			nc = maxnode - 1;
			maxnode = 0;
			junk[depth] = 0;
			atDepth[depth] = 0;
			//maxdepth = 0;
		}
	}

	//while expression
	| WHILE sexpr statement 	
	{

		if(ltype[depth] != 0) {
			int curPos = ftell(fchart);
			fseek(fchart, pos, SEEK_SET);
			for(int i = 0; i < lsize; i++) {
				fprintf(fchart, " ");
			}
			fseek(fchart, curPos, SEEK_SET);


		}



		//cout << depth << "\n";
		//determine current node
		int current = nc;
		//depth - 1 since depth is incremented before code run
		//add number of junk nodes
		for(int i = depth - 1; i >= 0; i--) {
			current += junk[i];
		}

		
		//add number of control nodes
		for(int i = depth - 1; i >= 0; i--) {
			current += atDepth[i];
		}


		//add node to graph linking to statements if true
		if(ltype[depth] != 0) {
			fprintf(fchart, "%d:s->%d:n[label=true]\n%d[label = \"%s\", shape=diamond]", current, current + 1, current, lookup($2).c_str());



			if(ltype[depth] == 1) {
				fprintf(fchart, "%d:w->%d:w\n%d[label = \"%s\"]", current + junk[depth] + atDepth[depth], current, current, lookup($2).c_str());
			}
			if(ltype[depth] == 2) {
				fprintf(fchart, "%d:w->%d:w\n%d[label = \"%s\"]", current + storeCurrent[depth - 2], current, current, lookup($2).c_str());
				fprintf(fchart, "%d:w->%d:w\n%d[label = \"%s\"]", current + junk[depth] + atDepth[depth], current, current, lookup($2).c_str());
			}
			if(ltype[depth] == 3) {
				fprintf(fchart, "%d:w->%d:w[label = false]\n%d[label = \"%s\"]", current + atDepth[depth - 1], current, current, lookup($2).c_str());
			}
			if(ltype[depth] == 4) {
				fprintf(fchart, "%d:w->%d:w[label = false]\n%d[label = \"%s\"]", current + atDepth[depth], current, current, lookup($2).c_str());
				fprintf(fchart, "%d:w->%d:w\n%d[label = \"%s\"]", current + junk[depth] + atDepth[depth], current, current, lookup($2).c_str());
			}

		}
		else {
			fprintf(fchart, "%d:w->%d:w[label=true]\n%d[label = \"%s\", shape=diamond]", current, current, current, lookup($2).c_str());	
		}


		ltype[depth - 1] = 3;
		ltype[depth] = 0;


		//check if end node highest, else swap end node
		if(current + junk[depth] + 1 > maxnode) {
			maxnode = current + junk[depth] + 1;
		}

		//store position to rewind if need
		pos = ftell(fchart);

		//connect false part to next node
		fprintf(fchart, "%d:e->%d[label = false]\n", current, maxnode);

		lsize = ftell(fchart) - pos;
		
		junk[depth - 1] += junk[depth];
		junk[depth] = 0;
		atDepth[depth - 1] += atDepth[depth];
		atDepth[depth] = 0;

		
		
		//drop to next level
		depth--;
		
		//reset everything if bottom of recursion
		if(depth == 0) {

			//set node count at end of recursion to highest numbered node
			nc = maxnode - 1;
			maxnode = 0;
			junk[depth] = 0;
			atDepth[depth] = 0;
		}
	}

	//if_else expression
    | IF else statement 
	{
		


		//cout << depth << "\n";
		//determine current node
		int current = nc;
		//depth - 1 since depth is incremented before code run
		//add number of junk nodes
		for(int i = depth - 1; i >= 0; i--) {
			current += junk[i];
		}

		
		//add number of control nodes
		for(int i = depth - 1; i >= 0; i--) {
			current += atDepth[i];
		}



		//link the top node of the if statement stored in storeCurrent to the first node of the else side
		fprintf(fchart, "%d->%d[label=\"false\"]\n", current, storeCurrent[depth - 1]);



		//check if end node highest, else swap end node
		if(current + junk[depth] + 1 > maxnode) {
			maxnode = current + junk[depth] + 1;
		}

		if(storeCurrent[depth - 1] - 1 != current) {
			fprintf(fchart, "%d->%d\n", storeCurrent[depth - 1] - 1, maxnode);

		}
		else {
			//store position to rewind if need
			pos = ftell(fchart);

			fprintf(fchart, "%d->%d[label=\"true\"]\n", current, maxnode);

			lsize = ftell(fchart) - pos;
		}

		ltype[depth - 1] = 2;
		ltype[depth] = 0;


		junk[depth - 1] += junk[depth];
		junk[depth] = 0;
		atDepth[depth - 1] += atDepth[depth];
		atDepth[depth] = 0;

		
		//drop to next level
		depth--;
		
		//reset everything if bottom of recursion
		if(depth == 0) {
/*
			for(int i = maxdepth; i >= 0; i--) {
				storeCurrent[i] = 0;
			}
*/
			//set node count at end of recursion to highest numbered node
			nc = maxnode - 1;
			maxnode = 0;
			junk[depth] = 0;
			atDepth[depth] = 0;
		}
	}

    	| block
    	| ';'
    	| expr ';'           	
		{ 
			$$ = save(lookup($1)+";");
			//check if greatest recursive depth

			ltype[depth] = 1;

			//get current top node
			int current = nc;
			//increment number of junk nodes at this level
			junk[depth]++;
			//add number of junk nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
				current += junk[i];
			}
			//add number of control nodes at all reached recursive levels
			for(int i = depth; i >= 0; i--) {
			current += atDepth[i];
			}
			//if this is the last node increase last node
			if(current + 1 > maxnode) {
				maxnode = current + 1;
			}

			
			//cout << maxdepth;

			//store position to rewind if need
			pos = ftell(fchart);

			//add junk node to the graph
			fprintf(fchart, "%d->%d\n", current, current + 1);
			
			lsize = ftell(fchart) - pos;

			fprintf(fchart, "%d[label = \"%s\", shape = \"rectangle\"]\n", current, lookup($1).c_str());
			
		}
	;



else:
	sexpr statement ELSE
	{
		if(ltype[depth] != 0) {
			int curPos = ftell(fchart);
			fseek(fchart, pos, SEEK_SET);
			for(int i = 0; i < lsize; i++) {
				fprintf(fchart, " ");
			}
			fseek(fchart, curPos, SEEK_SET);


		}
		
		//cout << depth << "\n";
		//determine current node
		int current = nc;
		//depth - 1 since depth is incremented before code run
		//add number of junk nodes
		for(int i = depth - 1; i >= 0; i--) {
			current += junk[i];
		}

		
		//add number of control nodes
		for(int i = depth - 1; i >= 0; i--) {
			current += atDepth[i];
		}
		
		

		if(ltype[depth] != 0) {
			//add node to graph linking to statements if true
			fprintf(fchart, "%d->%d[label=\"true\"]\n%d[label = \"%s\",  shape = \"diamond\"]", current, current + 1, current, lookup($1).c_str());
		}
		else {
			fprintf(fchart, "%d[label = \"%s\",  shape = \"diamond\"]", current, lookup($1).c_str());
		}


		//check if end node highest, else swap end node
		if(current + 1 + junk[depth] > maxnode) {
			maxnode = current + junk[depth] + 1;
		}


		//store the first node of the second side
		storeCurrent[depth - 1] = current + 1 + junk[depth] + atDepth[depth];



	};

expr:
	exp			{ $$ = save(lookup($1)); }
	
	//expression using comparsion operators
	| exp COP exp		{ string s = lookup($1); 
			  	  s += lookupOP($2);
			  	  s += lookup($3);
			 	  $$ = save(s); }  

	//expression using arithmetic operators	(e.g. +=, -=)		
	| ID AOP exp		{ string s = lookup($1); 
			  	  s += lookupOP($2);
			  	  s += lookup($3);
			 	  $$ = save(s); 
				} 
	//assignment operator
	| ID '=' exp		{ string s = lookup($1); 
			  	  s += "=";
			  	  s += lookup($3);
			 	  $$ = save(s); 
				}
    	;

//special expression that tracks recursive depth
sexpr:
	'(' exp ')'	{ 
					$$ = save(lookup($2)); 
					//increment number of control nodes at this depth and increment depth
					atDepth[depth]++;
					depth++;
				}
	
	//expression using comparsion operators
	| '(' exp COP exp ')'	{ 
								string s = lookup($2); 
						  	  	s += lookupOP($3);
						  	  	s += lookup($4);
						 	  	$$ = save(s); 
								//increment number of control nodes at this depth and increment depth
								atDepth[depth]++;
								depth++;
							}  

	//expression using arithmetic operators	(e.g. +=, -=)		
	| '(' ID AOP exp ')'	{
								string s = lookup($2); 
					  	  		s += lookupOP($3);
					  	  		s += lookup($4);
					 	  		$$ = save(s);
								//increment number of control nodes at this depth and increment depth
								atDepth[depth]++;
								depth++; 
							} 
	//assignment operator
	| '(' ID '=' exp ')'	{
								string s = lookup($2); 
					  	  		s += "=";
					  	  		s += lookup($4);
					 	  		$$ = save(s); 
								//increment number of control nodes at this depth and increment depth
								atDepth[depth]++;
								depth++;
							}
>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
    	;
/*
oper:  OP 			{ $$ = $1; }
	;
coper: COP			{ $$ = $1; }
	;
aoper: AOP			{ $$ = $1; }
	;
ioper: IOP			{ $$ = $1; }
	;

<<<<<<< HEAD
sexpr: 
	STRING 			{ $$ = $1; cout << $1 << endl; }
	; 
ifexpr: IF		{$$ = $1;}
	;
whexpr: WHILE		{$$ = $1;}
	;
else: 	ELSE		{$$ = $1;}
	;
*/
   	 
=======
exp:
    INTEGER              	{ $$ = save(to_string($1)); }
	| FLOATPT              	{ $$ = save(to_string($1)); }
	| ID	              	{ $$ = $1;}
	| CHAR			{ $$ = $1;}
    	| expr OP expr    	{ string s = lookup($1); 
			  	  s += lookupOP($2);
			  	  s += lookup($3);
			 	  $$ = save(s); 
				}
	//increment operator
	| ID IOP    		{ string s = lookup($1); 
			  	  s += lookupOP($2);
			 	  $$ = save(s); 
				}
    	;	 
>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
%%


void yyerror(const char *s) {
	cerr << s << endl;
}


int main(void) {
	//initialize digraph
	fprintf(fchart, "digraph {\nnode [shape=circle]\n");
	//initialize arrays
	for(int i = 0; i < junkSize; i++) {
		junk[i] = 0;
	}
	for(int i = 0; i < atDepthSize; i++) {
		atDepth[i] = 0;
	}
	for(int i = 0; i < storeCurrentSize; i++) {
		storeCurrent[i] = 0;
	}
	for(int i = 0; i < ltypeSize; i++) {
		ltype[i] = 0;
	}

	yyparse();
	//end digraph
	fprintf(fchart, "}");
	//close file
	fclose(fchart);
	return 0;
}






























