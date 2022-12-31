grammar Pel;

@header {
import dom.jfischer.probeunify3.basic.INonVariableXt;
import dom.jfischer.probeunify3.basic.ITNonVariableXt;
import dom.jfischer.probeunify3.basic.IVariableContext;
import dom.jfischer.probeunify3.basic.IXpr;
import dom.jfischer.probeunify3.module.IObject;
import dom.jfischer.probeunifyfrontend1.names.IVariableInfo;
}

logic
:
  module_decls
  sort_decls
  predicate_decls
  operation_decls
  axiom_decls
;

proof
:
  SymbolToken ( clauses+=clause )*
;

module_decls
:
  '[' 'modules' ']' ( decls+=module_decl )* ( eqs+=module_eq )*
;

sort_decls
:
  '[' 'sorts' ']' ( decls+=sort_decl )*
;

predicate_decls
:
  '[' 'predicates' ']' ( decls+=predicate_decl )*
;

operation_decls
:
  '[' 'operations' ']' ( decls+=operation_decl )*
;

axiom_decls
:
  '[' 'axioms' ']' (axioms+=axiom_decl )*
;

module_decl
:
  SymbolToken ':' SymbolToken '.'
;

module_eq
:
  args+=symbol ( '=' args+=symbol )* '.'
;

sort_decl
:
  SymbolToken '.'
;

predicate_decl
:
  SymbolToken ':' ( args+=symbol )* '.'
;

operation_decl
:
  SymbolToken ':' ( lhs+=symbol )* '->' rhs=symbol '.'
;

axiom_decl
:
  SymbolToken ':' clause '.'
;

term
locals  [ IXpr<INonVariableXt> expectedSort;
          IVariableContext<ITNonVariableXt> variableContext;
          IVariableInfo variableInfo ]
:
  term_variable                                     # termVariable
| symbol '(' ( args+=term (',' args+=term)* )? ')'  # termExpression
;

literal
locals  [ IVariableContext<ITNonVariableXt> variableContext;
          IVariableInfo variableInfo ]
:
  literal_variable                                  # literalVariable
| symbol '(' ( args+=term (',' args+=term)* )? ')'  # literalExpression
;

clause
locals  [ IVariableContext<ITNonVariableXt> variableContext;
          IVariableInfo variableInfo ]
:
  symbol                                            # axiomConstant
| variable_ctx premises+=clause* '==>' conclusion=literal
                                                    # axiomExpression
;

symbol
:
  ( quals+=SymbolToken '.' )* base=SymbolToken ;

term_variable
locals  [ IXpr<INonVariableXt> expectedSort;
          IVariableContext<ITNonVariableXt> variableContext;
          IVariableInfo variableInfo ]
:
  BaseVariableToken                                 # termBaseVariable
| IndexedVariableToken                              # termIndexedVariable
;

literal_variable
locals  [ IVariableContext<ITNonVariableXt> variableContext;
          IVariableInfo variableInfo ]
:
  BaseVariableToken                                 # literalBaseVariable
| IndexedVariableToken                              # literalIndexedVariable
;

variable_ctx
locals  [ IVariableContext<ITNonVariableXt> variableContext;
          IVariableInfo variableInfo ]
:
    '{' ( args+=ctx_variable )* '}' ;

ctx_variable
locals  [ IVariableContext<ITNonVariableXt> variableContext;
          IVariableInfo variableInfo ]
:
  BaseVariableToken                                 # ctxBaseVariable
| IndexedVariableToken                              # ctxIndexedVariable
;

SymbolToken: [A-Za-z_][A-Za-z0-9]* ;

BaseVariableToken: '?' PBaseVariableToken ;
IndexedVariableToken: '?' PIndexedVariableToken ;
PBaseVariableToken: ('__'|SymbolToken) ;
Number: [0-9]+ ;
PIndexedVariableToken: PBaseVariableToken'_'Number ;

NEWLINE: [\r\n]+       ->skip;
COMMENT: '#'.*?NEWLINE ->skip;
WHITESPACE: ([ \t\f]|COMMENT|NEWLINE)+ ->skip;
