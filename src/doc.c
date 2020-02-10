#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"

#include "parser.h"
#include "scanner.h"
#include "doc.h"

#define DOC_VERSION "0.0.1"
//#define DOC_NAME "DOC"
#define DOC_NAME "DocComment"

zend_class_entry *doc_class_entry;

#define REGISTER_DQL_CLASS_CONST_LONG(const_name, value) \
	zend_declare_class_constant_long(doc_class_entry, const_name, sizeof(const_name) - 1, (zend_long)value);

#define REGISTER_DQL_CLASS_CONST_STRING(const_name, value) \
	zend_declare_class_constant_stringl(doc_class_entry, const_name, sizeof(const_name) - 1, value, sizeof(value) - 1);

void yyerror(zval *result, const char *s)
{
	//printf("yyerror\n");
	//php_error_docref(NULL TSRMLS_CC, E_NOTICE, s);
}

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO(di_doc_comment_parse_return, IS_ARRAY, 0)
ZEND_END_ARG_INFO()

ZEND_FUNCTION(di_doc_comment_parse)
{
	array_init(return_value);

	char *query;
	size_t len;

	if (FAILURE == zend_parse_parameters_ex(ZEND_PARSE_PARAMS_QUIET, ZEND_NUM_ARGS() TSRMLS_CC, "s", &query, &len))
	{
		//php_error_docref(NULL TSRMLS_CC, E_NOTICE, "Unable to parse parameters");
		//RETURN_FALSE;
		return;
	}

	if (len < 1)
	{
		//php_error_docref(NULL TSRMLS_CC, E_NOTICE, "doc is empty");
		//RETURN_FALSE;
		return;
	}

	yy_scan_bytes(query, len);

	int result = yyparse(return_value);
	yylex_destroy();

	/* 	if (result != 0)
	{
		RETURN_FALSE;
	} */
}

const zend_function_entry doc_functions[] = {
	ZEND_FENTRY(
		parse,
		ZEND_FN(di_doc_comment_parse),
		di_doc_comment_parse_return,
		ZEND_ACC_PUBLIC | ZEND_ACC_STATIC)
		ZEND_FE_END};

PHP_MINIT_FUNCTION(doc)
{
	zend_class_entry class_entry;
	INIT_CLASS_ENTRY(class_entry, "Trackpoint\\DocComment", doc_functions);

	doc_class_entry = zend_register_internal_class(&class_entry);

	//REGISTER_DQL_CLASS_CONST_LONG("STATEMENT", (zend_long)KW_STATEMENT);
	//REGISTER_DQL_CLASS_CONST_LONG("REGISTER", (zend_long)KW_REGISTER);
	//REGISTER_DQL_CLASS_CONST_LONG("OPTIONS", (zend_long)KW_OPTIONS);
	//REGISTER_DQL_CLASS_CONST_LONG("INJECT", (zend_long)KW_INJECT);

	return SUCCESS;
}

zend_module_entry doc_module_entry = {
	STANDARD_MODULE_HEADER,
	DOC_NAME,
	doc_functions,
	PHP_MINIT(doc), // name of the MINIT function or NULL if not applicable
	NULL,			// name of the MSHUTDOWN function or NULL if not applicable
	NULL,			// name of the RINIT function or NULL if not applicable
	NULL,			// name of the RSHUTDOWN function or NULL if not applicable
	NULL,			// name of the MINFO function or NULL if not applicable
	DOC_VERSION,
	STANDARD_MODULE_PROPERTIES};

#if defined(COMPILE_DL_DOC)
ZEND_GET_MODULE(doc);
#endif
