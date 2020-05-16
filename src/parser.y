%{
	#include "scanner.h"
	#include "parser.h"

	#include "doc.h"

	void strtoupper(char *str){
		int i = 0;
		while (str[i]) { 
			str[i] = toupper(str[i]);
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
	int bval;

	Option option;
	zval options;
}

/*********************************
 ** Token Definition
 *********************************/
%token <ival> INT
%token <fval> FLOAT
%token <sval> IDENTIFIER STRING
%type  <bval> BOOLEAN

%type <option> option
%type <options> options

/* Keywords */
%token SCOPE_RESOLUTION ARRAY_CLOSE ARRAY_OPEN ASSIGN 
%token TRUE FALSE AT

%%
input:
	AT IDENTIFIER SCOPE_RESOLUTION IDENTIFIER '(' options ')' {
		zval *namespace;

		//Perevodim NAMESPACE i PARAMETR v verhnee register
		strtoupper($2);
		strtoupper($4);

		if ((namespace = zend_hash_str_find(Z_ARRVAL_P(context), $2, strlen($2))) == NULL) {

			namespace = (zval *) safe_emalloc(sizeof(zval), 1, 0);
			array_init(namespace);

			zend_hash_str_update(
				Z_ARRVAL_P(context),
				$2,
				strlen($2),
				namespace);
		}

		zend_hash_str_update(
			Z_ARRVAL_P(namespace),
			$4,
			strlen($4),
			&$6);

	}
	| AT IDENTIFIER SCOPE_RESOLUTION IDENTIFIER ARRAY_OPEN options ARRAY_CLOSE {
		zval *namespace;

		//Perevodim NAMESPACE i PARAMETR v verhnee register
		strtoupper($2);
		strtoupper($4);

		if ((namespace = zend_hash_str_find(Z_ARRVAL_P(context), $2, strlen($2))) == NULL) {

			namespace = (zval *) safe_emalloc(sizeof(zval), 1, 0);
			array_init(namespace);

			zend_hash_str_update(
				Z_ARRVAL_P(context),
				$2,
				strlen($2),
				namespace);
		}

		zval *parameter;
		if ((parameter = zend_hash_str_find(Z_ARRVAL_P(namespace), $4, strlen($4))) == NULL) {

			parameter = (zval *) safe_emalloc(sizeof(zval), 1, 0);
			array_init(parameter);

			zend_hash_str_update(
				Z_ARRVAL_P(namespace),
				$4,
				strlen($4),
				parameter);
		}

		add_next_index_zval(
			parameter, 
			&$6);

	}
	| error input{
		yyerrok;
		yyclearin;
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
			case 3:
				add_assoc_bool(&$$, $1.name, *((int*) $1.value));
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
			case 3:
				add_assoc_bool(&$$, $3.name, *((int*) $3.value));
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
		strtoupper($$.name);

		$$.value = malloc(strlen($3)+1);
		memcpy($$.value, $3, strlen($3)+1);
	}
	| IDENTIFIER ASSIGN STRING{
		$$.type  = 0;
		$$.name = malloc(strlen($1)+1);
		memcpy($$.name, $1, strlen($1)+1);
		strtoupper($$.name);

		$$.value = malloc(strlen($3)+1);
		memcpy($$.value, $3, strlen($3)+1);
	}
	| IDENTIFIER ASSIGN FLOAT{
		$$.type  = 2;
		$$.name = malloc(strlen($1)+1);
		memcpy($$.name, $1, strlen($1)+1);
		strtoupper($$.name);

		$$.value = malloc(sizeof(float));
		memcpy($$.value, &$3, sizeof(float));
	}
	| IDENTIFIER ASSIGN INT{
		$$.type  = 1;
		$$.name = malloc(strlen($1)+1);
		memcpy($$.name, $1, strlen($1)+1);
		strtoupper($$.name);

		$$.value = malloc(sizeof(int));
		memcpy($$.value, &$3, sizeof(int));
	}
	| IDENTIFIER ASSIGN BOOLEAN{
		$$.type  = 3;
		$$.name = malloc(strlen($1)+1);
		memcpy($$.name, $1, strlen($1)+1);
		strtoupper($$.name);

		$$.value = malloc(sizeof(int));
		memcpy($$.value, &$3, sizeof(int));
	}
	;

BOOLEAN:
	TRUE { $$ = 1; }
	| FALSE { $$ = 0; }
;

%%
