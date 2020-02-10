#ifndef DOC_H
#define DOC_H

#include "php.h"
#include "php_ini.h"

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

//#define KW_STATEMENT 0
//#define KW_REGISTER 1
//#define KW_OPTIONS 2
//#define KW_INJECT 3

typedef struct Option
{
	char *name;
	unsigned char type;
	void *value;
} Option;

void yyerror(zval *context, const char *s);

#endif