%{

    #include "parser.h"
    #include "doc.h"

    #define TOKEN(name) { return DOC_##name; }

    char* substr(const char* source, int from, int to) {
        int len = to - from;
        char* copy = (char*)malloc(len + 1);

        strncpy(copy, source + from, len);
        copy[len] = '\0';
        return copy;
    }

%}

/* performance tweeks */
%option never-interactive
%option batch

/* other flags */
%option noyywrap
%option caseless
%option nounput

/* Define the output files */

%%
[ \t\r\n]+ {
	/* eat up whitespace */
}

SCOPE_RESOLUTION        TOKEN(SCOPE_RESOLUTION)
ASSIGN                          TOKEN(ASSIGN)
AT                                      TOKEN(AT)

"@" { 
	//printf("AT\n");
	return DOC_AT; 
}

"=" { 
	//printf("Assign\n");
	return DOC_ASSIGN; 
}

"::" { 
	//printf("SCOPE_RESOLUTION\n");
	return DOC_SCOPE_RESOLUTION; 
}

[*-+/(){},.;^%:?\[\]|] { 
	//printf("symbols(%s)\n", yytext);
	return yytext[0]; 
}

\"[^\"\'\n]+\" {
	yylval.sval = substr(yytext, 1, strlen(yytext)-1);
	//printf("string(%s)\n", yytext);
	return DOC_STRING;
}

-?[0-9]+"."[0-9]* |
"."[0-9]* {
	yylval.fval = atof(yytext);
	//printf("float(%s)\n", yytext);
	return DOC_FLOAT;
}

-?[0-9]+ {
	yylval.ival = atol(yytext);
	//printf("int(%s)\n", yytext);
	return DOC_INT;
}

[A-Za-z][A-Za-z0-9_]* {
	yylval.sval = strdup(yytext);
	//printf("ident(%s)\n", yytext);
	return DOC_IDENTIFIER;
}

%%