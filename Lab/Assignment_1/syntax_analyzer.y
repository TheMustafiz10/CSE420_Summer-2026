%{

#include"symbol_info.h"

#define YYSTYPE symbol_info*

int yyparse(void);
int yylex(void);
void yyerror(char *);

extern FILE *yyin;


ofstream outlog;

extern int line_num;

// declare any other variables or functions needed here

%}

%token IF ELSE FOR WHILE DO BREAK CONTINUE RETURN INT FLOAT CHAR VOID DOUBLE SWITCH CASE DEFAULT PRINTLN ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COLON GOTO SEMICOLON COMMA ID CONST_INT CONST_FLOAT 

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%

start : program
	{
		outlog<<"At line no: "<<line_num<<" start : program "<<endl<<endl;
	}
	;

program : program unit
	{
		outlog<<"At line no: "<<line_num<<" program : program unit "<<endl<<endl;
		outlog<<$1->getname()+"\n"+$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"\n"+$2->getname(),"program");
	}
	| unit
	{
		outlog<<"At line no: "<<line_num<<" program : unit "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"program");
	}
	;

unit : variable_decl
	{
		outlog<<"At line no: "<<line_num<<" unit : variable_decl "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"unt");
	}
	| func_definition
	{
		outlog<<"At line no: "<<line_num<<" unit : func_definition "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"unt");
	}
	;

func_definition : type_specifier ID LPAREN param_list RPAREN compound_statement
		{	
			outlog<<"At line no: "<<line_num<<" func_definition : type_specifier ID LPAREN param_list RPAREN compound_statement "<<endl<<endl;
			outlog<<$1->getname()<<" "<<$2->getname()<<"("<<$4->getname()<<")\n"<<$6->getname()<<endl<<endl;
			
			$$ = new symbol_info($1->getname() + " " + $2->getname() + "(" + $4->getname() + ")\n" + $6->getname(),"func_def");
		}
		| type_specifier ID LPAREN RPAREN compound_statement
		{
			
			outlog<<"At line no: "<<line_num<<" func_definition : type_specifier ID LPAREN RPAREN compound_statement "<<endl<<endl;
			outlog<<$1->getname()<<" "<<$2->getname()<<"()\n"<<$5->getname()<<endl<<endl;
			
			$$ = new symbol_info($1->getname() + " " + $2->getname() + "()\n" + $5->getname(),"func_def");	
		}
 		;

param_list : param_list COMMA type_specifier ID
	{
		outlog<<"At line no: "<<line_num<<" param_list : param_list COMMA type_specifier ID "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<" "<<$4->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "," + $3->getname() + " " + $4->getname(),"param_list");
	}
	| param_list COMMA type_specifier
	{
		outlog<<"At line no: "<<line_num<<" param_list : param_list COMMA type_specifier "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "," + $3->getname(),"param_list");
	}
	| type_specifier ID
	{
		outlog<<"At line no: "<<line_num<<" param_list : type_specifier ID "<<endl<<endl;
		outlog<<$1->getname() + " "  + $2->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + " " + $2->getname(),"param_list");
	}
	| type_specifier
	{
		outlog<<"At line no: "<<line_num<<" param_list : type_specifier "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"param_list");
	}
	;

compound_statement : LCURL statements RCURL
	{
		outlog<<"At line no: "<<line_num<<" compound_statement : LCURL statements RCURL "<<endl<<endl;
		outlog<<"{\n"<<$2->getname()<<"\n} "<<endl<<endl;
			
		$$ = new symbol_info("{\n" + $2->getname() + "\n}","compund_stmt");	
	}
	| LCURL RCURL
	{
		outlog<<"At line no: "<<line_num<<" compound_statement : LCURL RCURL "<<endl<<endl;
		outlog<<"{\n}"<<endl<<endl;
			
		$$ = new symbol_info( "{\n}","compund_stmt");
	}
	;

variable_decl : type_specifier declaration_list SEMICOLON
	{
		outlog<<"At line no: "<<line_num<<" variable_decl : type_specifier declaration_list SEMICOLON "<<endl<<endl;
		outlog<<$1->getname()<<" "<<$2->getname()<<";"<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + " " + $2->getname() + ";","var_dec");
	}
	;

type_specifier : INT
	{
		outlog<<"At line no: "<<line_num<<" type_specifier : INT "<<endl<<endl;
		outlog<<"int"<<endl<<endl;
		
		$$ = new symbol_info("int","type_spec");
	}
	| FLOAT
	{
		outlog<<"At line no: "<<line_num<<" type_specifier : FLOAT "<<endl<<endl;
		outlog<<"float"<<endl<<endl;
		
		$$ = new symbol_info("float","type_spec");
	}
 	| VOID
	{
		outlog<<"At line no: "<<line_num<<" type_specifier : VOID "<<endl<<endl;
		outlog<<"void"<<endl<<endl;
		
		$$ = new symbol_info("void","type_spec");
	}
	| CHAR
	{
		outlog<<"At line no: "<<line_num<<" type_specifier : CHAR "<<endl<<endl;
		outlog<<"char"<<endl<<endl;
		
		$$ = new symbol_info("char","type_spec");
	}
 	;

declaration_list : declaration_list COMMA ID
	{
		outlog<<"At line no: "<<line_num<<" declaration_list : declaration_list COMMA ID "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "," + $3->getname(),"dec_list");	
	}
 	| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
	{
		outlog<<"At line no: "<<line_num<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<"["<<$5->getname()<<"]"<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "," + $3->getname() +"[" + $5->getname() + "]","dec_list");
	}
 	| ID
	{
		outlog<<"At line no: "<<line_num<<" declaration_list : ID "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"dec_list");
	}
 	| ID LTHIRD CONST_INT RTHIRD
	{
		outlog<<"At line no: "<<line_num<<" declaration_list : ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
		outlog<<$1->getname()<<"["<<$3->getname()<<"]"<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "[" + $3->getname() + "]","dec_list");
	}
 	;

statements : statement
	{
		outlog<<"At line no: "<<line_num<<" statements : statement "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"stmts");
	}
 	| statements statement
	{
		outlog<<"At line no: "<<line_num<<" statements : statements statement "<<endl<<endl;
		outlog<<$1->getname()<<"\n"<<$2->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "\n" + $2->getname(),"stmts");
	}
 	;

statement : variable_decl
	{
		outlog<<"At line no: "<<line_num<<" statement : variable_decl "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"stmnt");	
	}
 	| expression_statement
	{
		outlog<<"At line no: "<<line_num<<" statement : expression_statement "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"stmnt");
	}
 	| compound_statement
	{
		outlog<<"At line no: "<<line_num<<" statement : compound_statement "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"stmnt");
	}
 	| FOR LPAREN expression_statement expression_statement expression RPAREN statement
	{
		outlog<<"At line no: "<<line_num<<" statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement "<<endl<<endl;
		outlog<<"for("<<$3->getname()<<$4->getname()<<$5->getname()<<")\n"<<$7->getname()<<endl<<endl;
			
		$$ = new symbol_info("for(" + $3->getname() + $4->getname() + $5->getname() + ")\n" + $7->getname(),"stmnt");
	}
 	| IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	{
		outlog<<"At line no: "<<line_num<<" statement : IF LPAREN expression RPAREN statement "<<endl<<endl;
		outlog<<"if("<<$3->getname()<<")\n"<<$5->getname()<<endl<<endl;
			
		$$ = new symbol_info("if(" + $3->getname() + ")\n" + $5->getname(),"stmnt");
	}
	
 	| IF LPAREN expression RPAREN statement ELSE statement
	{
		outlog<<"At line no: "<<line_num<<" statement : IF LPAREN expression RPAREN statement ELSE statement "<<endl<<endl;
		outlog<<"if("<<$3->getname()<<")\n"<<$5->getname()<<"else\n"<<$7->getname()<<endl<<endl;
			
		$$ = new symbol_info("if(" + $3->getname() + ")\n" + $5->getname() + "else\n" + $7->getname(),"stmnt");
	}
	
 	| WHILE LPAREN expression RPAREN statement
	{
		outlog<<"At line no: "<<line_num<<" statement : WHILE LPAREN expression RPAREN statement "<<endl<<endl;
		outlog<<"while("<<$3->getname()<<")\n"<<$5->getname()<<endl<<endl;
			
		$$ = new symbol_info("while(" + $3->getname() + ")\n" + $5->getname(),"stmnt");	
	}
 	| PRINTLN LPAREN ID RPAREN SEMICOLON
	{
		outlog<<"At line no: "<<line_num<<" statement : PRINTLN LPAREN ID RPAREN SEMICOLON "<<endl<<endl;
		outlog<<"printf("<<$3->getname()<<")"<<";"<<endl<<endl;
			
		$$ = new symbol_info("printf(" + $3->getname() + ")" + ";","stmnt");
	}
 	| RETURN expression SEMICOLON
	{
		outlog<<"At line no: "<<line_num<<" statement : RETURN expression SEMICOLON "<<endl<<endl;
		outlog<<"return "<<$2->getname()<<";"<<endl<<endl;
			
		$$ = new symbol_info("return " + $2->getname() + ";","stmnt");
	}
 	;

expression_statement : SEMICOLON
	{
		outlog<<"At line no: "<<line_num<<" expression_statement : SEMICOLON "<<endl<<endl;
		outlog<<";"<<endl<<endl;
			
		$$ = new symbol_info(";","exp_stmnt");
	}
 	| expression SEMICOLON
	{
		outlog<<"At line no: "<<line_num<<" expression_statement : expression SEMICOLON "<<endl<<endl;
		outlog<<$1->getname()<<";"<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + ";","exp_stmnt");
	}
 	;



variable : ID
	{
		outlog<<"At line no: "<<line_num<<" variable : ID "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"var");
	}
	| ID LTHIRD expression RTHIRD
	{
		outlog<<"At line no: "<<line_num<<" variable : ID LTHIRD expression RTHIRD "<<endl<<endl;
		outlog<<$1->getname()<<"["<<$3->getname()<<"]"<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "[" + $3->getname() + "]","var");
	} 
 	;

expression : logic_expression
	{
		outlog<<"At line no: "<<line_num<<" expression : logic_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"exp");
	}
 	| variable ASSIGNOP logic_expression
	{
		outlog<<"At line no: "<<line_num<<" expression : variable ASSIGNOP logic_expression "<<endl<<endl;
		outlog<<$1->getname()<< "=" <<$3->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "=" + $3->getname(),"exp");
	}
 	;

logic_expression : rel_expression
	{
		outlog<<"At line no: "<<line_num<<" logic_expression : rel_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"logic_exp");
	}
 	| rel_expression LOGICOP rel_expression
	{
		outlog<<"At line no: "<<line_num<<" logic_expression : rel_expression LOGICOP rel_expression "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<$3->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + $2->getname() + $3->getname(),"logic_exp");
	}
 	;

rel_expression : simple_expression
	{
		outlog<<"At line no: "<<line_num<<" rel_expression : simple_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"rel_exp");
	}
 	| simple_expression RELOP simple_expression
	{
		outlog<<"At line no: "<<line_num<<" rel_expression : simple_expression RELOP simple_expression "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<$3->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + $2->getname() + $3->getname(),"rel_exp");
	}
 	;

simple_expression : term
	{
		outlog<<"At line no: "<<line_num<<" simple_expression : term "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"simple_exp");
	}
 	| simple_expression ADDOP term
	{
		outlog<<"At line no: "<<line_num<<" simple_expression :  simple_expression ADDOP term "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<$3->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + $2->getname() + $3->getname(),"simple_exp");
	}
 	;

term : unary_expression
	{
		outlog<<"At line no: "<<line_num<<"  term : unary_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"trm");
	}
 	| term MULOP unary_expression
	{
		outlog<<"At line no: "<<line_num<<" term :  term MULOP unary_expression "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<$3->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + $2->getname() + $3->getname(),"trm");
	}
 	;

unary_expression : ADDOP unary_expression
	{
		outlog<<"At line no: "<<line_num<<"  unary_expression : ADDOP unary_expression "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + $2->getname(),"unary_exp");
	}
 	| NOT unary_expression
	{
		outlog<<"At line no: "<<line_num<<"  unary_expression : NOT unary_expression "<<endl<<endl;
		outlog<<"!"<<$2->getname()<<endl<<endl;
			
		$$ = new symbol_info("!" + $2->getname(),"unary_exp");
	}
 	| factor_info
	{
		outlog<<"At line no: "<<line_num<<"  unary_expression : factor_info "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"unary_exp");
	}
 	;

factor_info : factor
	{
		outlog<<"At line no: "<<line_num<<"  factor_info : factor "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"fctr_info");
	}
	;

factor : variable
	{
		outlog<<"At line no: "<<line_num<<"  factor : variable "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"fctr");
	}
 	| ID LPAREN argument_list RPAREN
	{
		outlog<<"At line no: "<<line_num<<"  factor : ID LPAREN argument_list RPAREN "<<endl<<endl;
		outlog<<$1->getname()<<"("<<$3->getname()<<")"<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "(" + $3->getname() + ")","fctr");
	}
 	| LPAREN expression RPAREN
	{
		outlog<<"At line no: "<<line_num<<"  factor : LPAREN expression RPAREN "<<endl<<endl;
		outlog<<"("<<$2->getname()<<")"<<endl<<endl;
			
		$$ = new symbol_info("(" + $2->getname()+")","fctr");
	}
 	| CONST_INT
	{
		outlog<<"At line no: "<<line_num<<"  factor : CONST_INT "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"fctr");
	}
 	| CONST_FLOAT
	{
		outlog<<"At line no: "<<line_num<<"  factor : CONST_FLOAT "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"fctr");
	}
 	| variable INCOP
	{
		outlog<<"At line no: "<<line_num<<"  factor : variable INCOP "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + $2->getname(),"fctr");
	}
 	| variable DECOP
	{
		outlog<<"At line no: "<<line_num<<"  factor : variable DECOP "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + $2->getname(),"fctr");
	}
 	;

argument_list : arguments
 	{
		outlog<<"At line no: "<<line_num<<"  argument_list : arguments "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"arg_list");
	}
	| /* empty */
	{
		outlog<<"At line no: "<<line_num<<"  argument_list :  "<<endl<<endl;
		outlog<<""<<endl<<endl;
			
		$$ = new symbol_info("","arg_list");
	}
 	;

arguments : arguments COMMA logic_expression
	{
		outlog<<"At line no: "<<line_num<<"  arguments : arguments COMMA logic_expression "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname() + "," + $3->getname(),"args");
	}
 	| logic_expression
	{
		outlog<<"At line no: "<<line_num<<"  arguments : logic_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
			
		$$ = new symbol_info($1->getname(),"args");
	}
	;

%%
void yyerror(char *s) {   
}

int main(int argc, char *argv[])
{
	if(argc != 2) 
	{
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
	}
	yyin = fopen(argv[1], "r");
	outlog.open("log.txt", ios::trunc);
	
	if(yyin == NULL)
	{
		cout<<"Couldn't open file"<<endl;
		return 0;
	}
    
	yyparse();
	
	//print number of line_num
	outlog<<"Total line_num: "<< line_num<<endl;
	
	outlog.close();
	
	fclose(yyin);
	
	return 0;
}
