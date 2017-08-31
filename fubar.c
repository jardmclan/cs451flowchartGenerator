#include "fubar.h"

<<<<<<< HEAD
vector <string> data, dataOP;
=======
vector <string> data, dataOP, dataBlock, dataStatement, dataStatements;

>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
int save(string s){
	int n = data.size();
	data.push_back(s);
	return n;
}
<<<<<<< HEAD

int saveOP(string s){
	int n = dataOP.size();
	dataOP.push_back(s);
	return n;
}

=======

int saveOP(string s){
	int n = dataOP.size();
	dataOP.push_back(s);
	return n;
}

int saveBlock(string s){
	int n = dataBlock.size();
	dataBlock.push_back(s);
	return n;
}

int saveStatement(string s){
	int n = dataStatement.size();
	dataStatement.push_back(s);
	return n;
}

int saveStatements(string s){
	int n = dataStatements.size();
	dataStatements.push_back(s);
	return n;
}

>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
string lookup(int n){
	return data[n];
}
string lookupOP(int n){
	return dataOP[n];
}
<<<<<<< HEAD
=======
string lookupBlock(int n){
	return dataBlock[n];
}
string lookupStatement(int n){
	return dataStatement[n];
}
string lookupStatements(int n){
	return dataStatements[n];
}
>>>>>>> 31601c60eecd415a7f2b7235c899ecdb37cbd19a
