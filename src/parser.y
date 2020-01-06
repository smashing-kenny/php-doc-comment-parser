%{
	#include "scanner.h"
	#include "parser.h"

	#include "doc.h"

	void strtolower(char *str){
		int i = 0;
		while (str[i]) { 
			str[i] = tolower(str[i]);
			i++;
		}
	}

%}

%code requires {
	#include "doc.h"
}

%define api.token.prefix {DOC_}
%parse-param { zval* context } 

%union {
	int ival;
	float fval;
	char* sval;

	Option option;
	zval options;
}

/*********************************
 ** Token Definition
 *********************************/
%token <ival> INT
%token <fval> FLOAT
%token <sval> IDENTIFIER STRING

%type <option> option
%type <options> options

/* Keywords */
%token SCOPE_RESOLUTION REGISTER ASSIGN INJECT AT DI

%%
input:
	AT DI SCOPE_RESOLUTION REGISTER '(' options ')' {
		add_index_long(context, KW_STATEMENT, KW_REGISTER);
		add_index_zval(context, KW_OPTIONS, &$6);
	}
	| AT DI SCOPE_RESOLUTION INJECT '(' options ')' {
		add_index_long(context, KW_STATEMENT, KW_INJECT);
		add_index_zval(context, KW_OPTIONS, &$6);
	}
	| error input{
		yyerrok;
		yyclearin;
		//printf("skip error\n");
	}
	;

options:
	/* empty */ {
		array_init(&$$);
	}
	| option {
		array_init(&$$);
		//add_next_index_zval(&$$, &$1);

		switch($1.type){
			case 0:
				add_assoc_string(&$$, $1.name, (char*) $1.value);
			break;
			case 1:
				add_assoc_long(&$$, $1.name, *((int*) $1.value));
			break;
			case 2:
				add_assoc_double(&$$, $1.name, *((float*) $1.value));
			break;
		}

		free($1.name);
		free($1.value);
	}
	| options ',' option{
		$$ = $1;

		switch($3.type){
			case 0:
				add_assoc_string(&$$, $3.name, (char*) $3.value);
			break;
			case 1:
				add_assoc_long(&$$, $3.name, *((int*) $3.value));
			break;
			case 2:
				add_assoc_double(&$$, $3.name, *((float*) $3.value));
			break;
		}

		free($3.name);
		free($3.value);

	}
	;

option:
	IDENTIFIER ASSIGN IDENTIFIER{
		$$.type  = 0;
		$$.name = malloc(strlen($1)+1);
		memcpy($$.name, $1, strlen($1)+1);
		strtolower($$.name);

		$$.value = malloc(strlen($3)+1);
		memcpy($$.value, $3, strlen($3)+1);
	}
	| IDENTIFIER ASSIGN STRING{
		$$.type  = 0;
		$$.name = malloc(strlen($1)+1);
		memcpy($$.name, $1, strlen($1)+1);
		strtolower($$.name);

		$$.value = malloc(strlen($3)+1);
		memcpy($$.value, $3, strlen($3)+1);
	}
	| IDENTIFIER ASSIGN FLOAT{
		$$.type  = 2;
		$$.name = malloc(strlen($1)+1);
		memcpy($$.name, $1, strlen($1)+1);
		strtolower($$.name);

		$$.value = malloc(sizeof(float));
		memcpy($$.value, &$3, sizeof(float));
	}
	| IDENTIFIER ASSIGN INT{
		$$.type  = 1;
		$$.name = malloc(strlen($1)+1);
		memcpy($$.name, $1, strlen($1)+1);
		strtolower($$.name);

		$$.value = malloc(sizeof(int));
		memcpy($$.value, &$3, sizeof(int));
	}
	;
%%
