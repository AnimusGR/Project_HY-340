%{
#include "lib/al.h"
#define YY_DECL int alpha_yylex(void* yylval)
%}

%option noyywrap
%option yylineno
						
COMMENT_BLOCK   "/*"
COMMENT_LINE    "//".*
IF				"if"
ELSE			"else"
WHILE			"while"
FOR				"for"
FUNCTION		"function"
RETURN			"return"
BREAK			"break"
CONTINUE		"continue"
AND				"and"
NOT				"not"
OR				"or"
LOCAL			"local"
TRUE			"true"
FALSE			"false"
NIL				"nil"
ADD				"\+"
ASSIGN			"\="
SUB				"\-"
MUL             "\*"
DIV             "\/"
MOD             "\%"
EQUALS          "\=\="
NOT_EQUALS		"\!\="
INCREMENT		"\+\+"
DECREMENT		"\-\-"
GREATER_THAN	"\>"
LESS_THAN		"\<"
GREATER_EQ		"\>\="
LESS_EQ			"\<\="
INT_CONST		[0-9]+
REAL_CONST		{INT_CONST}\.{INT_CONST}
STRING_START    "\""
LEFT_BRACE		"\{"
RIGHT_BRACE		"\}"
LEFT_BRACKET    "\["
RIGHT_BRACKET	"\]"
LEFT_PARENS	    "\("
RIGHT_PARENS	"\)"
SEMICOLON		"\;"
COMMA			"\,"
COLON			"\:"
SCOPE			"\:\:"
DOT				"\."
DOTDOT			"\.\."
IDENTIFIER      [a-zA-Z][a-zA-Z0-9_]*
WHITESPACE      [\n\t ]
%%

{IF}            {addToken(KEYWORD, KWRD_IF, yylineno, yytext);}
{ELSE}          {addToken(KEYWORD, KWRD_ELSE, yylineno, yytext);}
{WHILE}         {addToken(KEYWORD, KWRD_WHILE, yylineno, yytext);}
{FOR}           {addToken(KEYWORD, KWRD_FOR, yylineno, yytext);}
{FUNCTION}      {addToken(KEYWORD, KWRD_FUNCTION, yylineno, yytext);}
{RETURN}        {addToken(KEYWORD, KWRD_RETURN, yylineno, yytext);}
{BREAK}         {addToken(KEYWORD, KWRD_BREAK, yylineno, yytext);}
{CONTINUE}      {addToken(KEYWORD, KWRD_CONTINUE, yylineno, yytext);}
{AND}           {addToken(KEYWORD, KWRD_AND, yylineno, yytext);}
{NOT}           {addToken(KEYWORD, KWRD_NOT, yylineno, yytext);}
{OR}            {addToken(KEYWORD, KWRD_OR, yylineno, yytext);}
{LOCAL}         {addToken(KEYWORD, KWRD_LOCAL, yylineno, yytext);}
{TRUE}          {addToken(KEYWORD, KWRD_TRUE, yylineno, yytext);}
{FALSE}         {addToken(KEYWORD, KWRD_FALSE, yylineno, yytext);}
{NIL}           {addToken(KEYWORD, KWRD_NIL, yylineno, yytext);}

{ASSIGN}        {addToken(OPERATOR, OPRTR_ASSIGN, yylineno, yytext);}
{ADD}           {addToken(OPERATOR, OPRTR_ADD, yylineno, yytext);}
{SUB}           {addToken(OPERATOR, OPRTR_SUB, yylineno, yytext);}
{MUL}           {addToken(OPERATOR, OPRTR_MUL, yylineno, yytext);}
{DIV}           {addToken(OPERATOR, OPRTR_DIV, yylineno, yytext);}
{MOD}           {addToken(OPERATOR, OPRTR_MOD, yylineno, yytext);}
{EQUALS}        {addToken(OPERATOR, OPRTR_EQUALS, yylineno, yytext);}
{NOT_EQUALS}    {addToken(OPERATOR, OPRTR_NEQ, yylineno, yytext);}
{INCREMENT}     {addToken(OPERATOR, OPRTR_INCR, yylineno, yytext);}
{DECREMENT}     {addToken(OPERATOR, OPRTR_DECR, yylineno, yytext);}
{GREATER_THAN}  {addToken(OPERATOR, OPRTR_GT, yylineno, yytext);}
{LESS_THAN}     {addToken(OPERATOR, OPRTR_LT, yylineno, yytext);}
{GREATER_EQ}    {addToken(OPERATOR, OPRTR_GTEQ, yylineno, yytext);}
{LESS_EQ}       {addToken(OPERATOR, OPRTR_LTEQ, yylineno, yytext);}

{LEFT_BRACE}    {addToken(PUNCTUATION, PUNCT_LEFT_BRACE, yylineno, yytext);}
{RIGHT_BRACE}   {addToken(PUNCTUATION, PUNCT_RIGHT_BRACE, yylineno, yytext);}
{LEFT_BRACKET}  {addToken(PUNCTUATION, PUNCT_LEFT_BRACKET, yylineno, yytext);}
{RIGHT_BRACKET} {addToken(PUNCTUATION, PUNCT_RIGHT_BRACKET, yylineno, yytext);}
{LEFT_PARENS}   {addToken(PUNCTUATION, PUNCT_LEFT_PARENS, yylineno, yytext);}
{RIGHT_PARENS}  {addToken(PUNCTUATION, PUNCT_RIGHT_PARENS, yylineno, yytext);}
{SEMICOLON}     {addToken(PUNCTUATION, PUNCT_SEMICOLON, yylineno, yytext);}
{COMMA}         {addToken(PUNCTUATION, PUNCT_COMMA, yylineno, yytext);}
{COLON}         {addToken(PUNCTUATION, PUNCT_COLON, yylineno, yytext);}
{SCOPE}         {addToken(PUNCTUATION, PUNCT_SCOPE, yylineno, yytext);}
{DOT}           {addToken(PUNCTUATION, PUNCT_DOT, yylineno, yytext);}
{DOTDOT}        {addToken(PUNCTUATION, PUNCT_DOTDOT, yylineno, yytext);}

{INT_CONST}     {addToken(INTEGER_CONST, NO_SUB, yylineno, yytext);}
{REAL_CONST}    {addToken(REAL_CONST, NO_SUB, yylineno, yytext);}
{IDENTIFIER}    {addToken(IDENTIFIER, NO_SUB, yylineno, yytext);}
{COMMENT_LINE}  {addToken(COMMENT, COMMENT_L, yylineno, "");}
{COMMENT_BLOCK} {    
                     int c;
	                 int start = yylineno;
	                 int nested = 0;
                     int nestStart;
                     char nestCommentScope[64];
                     char commentScope[64];
                     
	                 while (c = input()) {
		                 if (c == '/') {
			                 if ((c = input()) == '*') {
				                 nested++;
                                 nestStart = yylineno;
			                 } else {
				                 unput(c);
                             }
		                 } else if (c == '*') {
			                 if ((c = input()) == '/') {
				                 if (nested == 0) {
					                 break;
				                 } else {
				 	                 nested--;
                                     snprintf(nestCommentScope, sizeof(nestCommentScope), "%d - %d", nestStart, yylineno);
                                     addToken(COMMENT, COMMENT_N, yylineno, nestCommentScope);
                                 }
			                  } else {
				                 unput(c);
			                  }
		                 }
                     }
                 
	                 if (!c) {
					     fprintf(yyout, "%d: %sERROR:%s Comment starting at this line not terminated\n", start, BOLD_RED, STYLE_RESET);
	                 } else {
					     snprintf(commentScope, sizeof(commentScope), "%d - %d", start, yylineno);
                         addToken(COMMENT, COMMENT_B, yylineno, commentScope);
	                 }
                }

{STRING_START}  {
				     int c;
                     unsigned int stringalloc = 1;
					 char *string_out = malloc(stringalloc * sizeof(char));
					 int pos = 0;
					 int stringClosed = 0;
                     int startingLine = yylineno;
                     
					 while (c = input()) {
                         
						 if (c == '\\') {
							 c = input();
                             stringalloc++;
						     string_out = realloc(string_out, stringalloc);
                             
							 if (c == 'n') {
                                 string_out[pos++] = '\n';
							 } else if (c == 't') {
                               	 string_out[pos++] = '\t';
							 } else if (c == '\\') {
                                 string_out[pos++] = c;
							 } else if (c == '\"') {
                                 string_out[pos++] = c;
							 } else if (c == '\'') {
                                 string_out[pos++] = c;
							 } else{
                                 fprintf(yyout, "%d: %sERROR:%s Illegal escaped character '%s\\%c%s'\n", startingLine, BOLD_RED, STYLE_RESET, COLOR_YEL, c, STYLE_RESET);
                                 return -1;
							 }

                             continue;
						 }
                         
                         /* In case we are asked why we support multi-line strings just un-comment this and refer to the mail regarding the aforementioned
                         if(c == '\n'){
                             printf("%d: %sERROR:%s String spanning multiple lines!\n", startingLine, BOLD_RED, STYLE_RESET);
                             return -1;
                         }*/
						 
						 if (c == '\"') {
						     stringClosed = 1;
                             string_out[pos] = '\0';
						     break;
						 }
                         
                         stringalloc++;
						 string_out = realloc(string_out, stringalloc);
						 string_out[pos++] = c;
                     }
                     
                     if (!stringClosed)
					     fprintf(yyout, "%d: %sERROR:%s Missing terminating '%s\"%s' character \n", startingLine, BOLD_RED, STYLE_RESET, COLOR_YEL, STYLE_RESET);
                     else
                         addToken(STRING, NO_SUB, yylineno, string_out);
				}

{WHITESPACE}    {;}
.               {fprintf(yyout, "%d: %sWARNING:%s undefined token %s%s%s\n", yylineno, BOLD_MAGENTA, STYLE_RESET, COLOR_YEL, yytext, STYLE_RESET);}

%%

int main(int argc, char* argv[]){
	
	if (argc > 1) {
		if (!(yyin = fopen(argv[1], "r"))) {
			fprintf(stderr, "Cannot open file %s\n", argv[1]);
			return -1;
		}
		
		if (argc > 2) {
			if (!(yyout = fopen(argv[2], "w"))) {
				fprintf(stderr, "Cannot open file %s\n", argv[1]);
				return -1;
			}
		}
	}
	
	alpha_yylex(tokenListHead);
	return 0;
}

/* Prints a token based on the style shown at http://www.csd.uoc.gr/~hy340/#answer0 */
void printToken(alpha_token_t *token)
{
	char* type;
	char* categ;
	char* subcateg;

    categ = categStr[token->categ];
	
	if (token->subcateg == NO_SUB){
		subcateg = token->content;
	} else {
		subcateg = subcategStr[token->subcateg];
	}
	
	switch(token->categ) {
	case INTEGER_CONST :
		type = "integer";
		break;
	case REAL_CONST :
		type = "double";
		break;
	case IDENTIFIER :
	case STRING :
		type = "char*";
		break;
	default :
		type = "enumerated";
		break;
	}
	
	if (!strcmp(type, "char*")){
		fprintf(yyout, "%d: #%d \"%s\" %s \"%s\" <-%s\n", token->lineno, token->tokenno, token->content, categ, subcateg, type);
	} else {
		fprintf(yyout, "%d: #%d \"%s\" %s %s <-%s\n", token->lineno, token->tokenno, token->content, categ, subcateg, type);
	}
}

alpha_token_t* addToken(int categ, int subcateg, int lineno, char* content)
{
	alpha_token_t *newToken = malloc(sizeof(alpha_token_t));

	/* Initialise token contents */
	newToken->categ = categ;
	newToken->subcateg = subcateg;
	newToken->content = strdup(content);
	newToken->lineno = lineno;
	newToken->tokenno = ++tokenno;

	/* Insert in token List */
	newToken->next = tokenListHead;
	tokenListHead = newToken;
	
	printToken(newToken);
	return newToken;
}
