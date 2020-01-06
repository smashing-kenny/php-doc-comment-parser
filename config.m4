PHP_ARG_ENABLE(doc, Whether you want DQL nativ parser support, [ --enable-doc Enable DOC])

if test "$PHP_DOC" = "yes"; then   
	PHP_NEW_EXTENSION(doc, src/doc.c src/scanner.c src/parser.c, $ext_shared)
fi
