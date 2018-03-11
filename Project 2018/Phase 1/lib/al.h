#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define COLOR_RED      "\x1b[31m"
#define COLOR_MAGENTA  "\x1b[35m"
#define COLOR_YEL     "\x1b[33m"
#define TEXT_BOLD      "\033[1m"

#define BOLD_RED       "\x1b[31m\033[1m"
#define BOLD_MAGENTA   "\033[1m\x1b[35m"
#define STYLE_RESET    "\033[22m\x1b[0m"

int tokenno = 0;

typedef enum {
	KEYWORD,
	OPERATOR,
	INTEGER_CONST,
	REAL_CONST,
	STRING,
	PUNCTUATION,
	IDENTIFIER,
	COMMENT,
	UNKNOWN
} category;	

/*
 * Mapping to category types for the sole
 * purpose of printing out the tokens
 * as shown at http://www.csd.uoc.gr/~hy340/#answer0
 */
char *categStr[] = {
	"KEYWORD",
	"OPERATOR",
	"INTEGER_CONST",
	"REAL_CONST",
	"STRING",
	"PUNCTUATION",
	"IDENTIFIER",
	"COMMENT",
	"UNKNOWN"
};

typedef enum {
		KWRD_IF,
		KWRD_ELSE,
		KWRD_WHILE,
		KWRD_FOR,
		KWRD_FUNCTION,
		KWRD_RETURN,
		KWRD_BREAK,
		KWRD_CONTINUE,
		KWRD_AND,
		KWRD_NOT,
		KWRD_OR,
		KWRD_LOCAL,
		KWRD_TRUE,
		KWRD_FALSE,
		KWRD_NIL,
		OPRTR_ASSIGN,
		OPRTR_ADD,
		OPRTR_SUB,
		OPRTR_MUL,
		OPRTR_DIV,
		OPRTR_MOD,
		OPRTR_EQUALS,
		OPRTR_NEQ,
		OPRTR_INCR,
		OPRTR_DECR,
		OPRTR_GT,
		OPRTR_LT,
		OPRTR_GTEQ,
		OPRTR_LTEQ,
		PUNCT_LEFT_BRACE,
		PUNCT_RIGHT_BRACE,
		PUNCT_LEFT_BRACKET,
		PUNCT_RIGHT_BRACKET,
		PUNCT_LEFT_PARENS,
		PUNCT_RIGHT_PARENS,
		PUNCT_SEMICOLON,
		PUNCT_COMMA,
		PUNCT_COLON,
		PUNCT_SCOPE,
		PUNCT_DOT,
		PUNCT_DOTDOT,
		COMMENT_L,
		COMMENT_B,
		COMMENT_N,
		NO_SUB
} subcategory;

/*
 * Mapping to subcategory types for the sole
 * purpose of printing out the tokens
 * as shown at http://www.csd.uoc.gr/~hy340/#answer0
 */
char *subcategStr[] = {
	    "IF",
		"ELSE",
		"WHILE",
		"FOR",
		"FUNCTION",
		"RETURN",
		"BREAK",
		"CONTINUE",
		"AND",
		"NOT",
		"OR",
		"LOCAL",
		"TRUE",
		"FALSE",
		"NIL",
		"ASSIGN",
		"ADD",
		"SUB",
		"MUL",
		"DIV",
		"MOD",
		"EQUALS",
		"NOT_EQUALS",
		"INCREMENT",
		"DECREMENT",
		"GREATER_THAN",
		"LESS_THAN",
		"GREATER_OR_EQUAL",
		"LESS_OR_EQUAL",
		"LEFT_BRACE",
		"RIGHT_BRACE",
		"LEFT_BRACKET",
		"RIGHT_BRACKET",
		"LEFT_PARENS",
		"RIGHT_PARENS",
		"SEMICOLON",
		"COMMA",
		"COLON",
		"SCOPE",
		"DOT",
		"DOTDOT",
		"LINE_COMMENT",
		"BLOCK_COMMENT",	
		"NESTED_COMMENT",
		"\"\""
};

/*
 * Struct containing all the required "data" for each token.
 * Though it might possibly change for the upcomming project phases
 * due to obsolete data
 */
typedef struct alpha_token_t {
    int lineno;
    int tokenno;
    char *content;	
    category categ;
	subcategory subcateg;
	struct alpha_token_t* next;
} alpha_token_t;

struct alpha_token_t* tokenListHead = NULL;
void printToken(alpha_token_t *token);
alpha_token_t* addToken(int categ, int subcateg, int lineno, char* content);
void printTokenList(alpha_token_t *head);

/* Testing fuction to see if tokenListHead is handled properly */
void printTokenList(alpha_token_t *head)
{
    while (head) {
	    printToken(head);
		head = head->next;
	}
}
