%{
  open Ast;;
%}

%token <string> LWORD
%token <string> UWORD

%token EOF COMMA CDASH QDASH LPAREN RPAREN DOT

%start main
%type <Ast.command> main
%%

main:
  | rule DOT
    { $1 }
  | inquery DOT
    { $1 }

rule:
  | term  { Rule($1, []) }
  | term CDASH term_list { Rule($1, $3) }

inquery:
  | QDASH term { Inquery $2 }

term:
  | lword { ConstTerm $1 }
  | uword { VarTerm $1 }
  | lword LPAREN RPAREN { ComplexTerm($1, []) }
  | lword LPAREN term_list RPAREN { ComplexTerm($1, $3) }

term_list:
  | term  { [$1] }
  | term COMMA term_list { $1::$3 }

lword:
  | LWORD { Const $1 }
uword: 
  | UWORD { Var $1 }
