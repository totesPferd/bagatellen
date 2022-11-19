grammar Pel;

logic:
  module_decls sort_decls predicate_decls operation_decls variable_decls term_decls literal_decls axiom_decls ;

proof:
  SymbolToken                                       # initProof
| proof clause                                      # anotherClause
;

module_decls:
  '[' 'modules' ']' ( decls+=module_decl )* ( eqs+=module_eq )* ;

sort_decls:
  '[' 'sorts' ']' ( decls+=sort_decl )* ;

predicate_decls:
  '[' 'predicates' ']' ( decls+=predicate_decl )* ;

operation_decls:
  '[' 'operations' ']' ( decls+=operation_decl )* ;

variable_decls:
  '[' 'variables' ']' ( decls+=variable_decl )* ;

term_decls:
  '[' 'terms' ']' ( decls+=term_decl )* ;

literal_decls:
  '[' 'literals' ']' (decls+=literal_decl )* ;

axiom_decls:
  '[' 'axioms' ']' (axioms+=axiom_decl )* ;

module_decl:
  SymbolToken ':' SymbolToken '.' ;

module_eq:
  args+=symbol ( '=' args+=symbol )* '.' ;

sort_decl:
  SymbolToken '.' ;

predicate_decl:
  SymbolToken ':' ( args+=symbol )* '.' ;

operation_decl:
  SymbolToken ':' ( lhs+=symbol )* '->' rhs=symbol '.' ;

variable_decl:
  SymbolToken ':' symbol '.' ;

term_decl:
  SymbolToken ':' term '.' ;

literal_decl:
  SymbolToken ':' literal '.' ;

axiom_decl:
  SymbolToken ':' clause '.' ;

term:
  symbol                                            # termConstant
| variable                                          # termVariable
| symbol '(' ( args+=term (',' args+=term)* )? ')'  # termExpression
;

literal:
  symbol                                            # literalConstant
| symbol '(' ( args+=term (',' args+=term)* )? ')'  # literalExpression
;

clause:
  symbol                                            # axiomConstant
| ( premises+=literal (';' premises+=literal)* )? '==>' conclusion=literal
                                                    # axiomExpression
;

symbol:
  ( quals+=SymbolToken '.' )* base=SymbolToken ;

variable:
  IndexedVariableToken                              # IndexedVariable
| VariableToken                                     # BasicVariable
;

SymbolToken: [A-Za-z_][A-Za-z0-9]* ;

VariableToken: '?'('__'|SymbolToken) ;
Number: [0-9]+ ;
IndexedVariableToken: VariableToken'_'Number ;

NEWLINE: [\r\n]+       ->skip;
COMMENT: '#'.*?NEWLINE ->skip;
WHITESPACE: ([ \t\f]|COMMENT|NEWLINE)+ ->skip;
