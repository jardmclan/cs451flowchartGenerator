#ifndef HEADER_FILE
#define HEADER_FILE

#include <string>
#include <vector>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <stdlib.h>
	
using namespace std;


int save(string s);
int saveOP(string s);
<<<<<<< HEAD
string lookup(int n);
string lookupOP(int n);
=======
int saveBlock(string s);
int saveStatement(string s);
int saveStatements(string s);
string lookup(int n);
string lookupOP(int n);
string lookupBlock(int n);
string lookupStatement(int n);
string lookupStatements(int n);
>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
int yylex(void);
void yyerror(const char *);
int count();

#endif
