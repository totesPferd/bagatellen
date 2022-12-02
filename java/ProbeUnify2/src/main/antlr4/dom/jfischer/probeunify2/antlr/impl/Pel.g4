grammar Pel;

@header {
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
import dom.jfischer.probeunify2.basic.IVariableContext;
import dom.jfischer.probeunify2.module.IModule;
import dom.jfischer.probeunify2.pel.ILiteralNonVariableExtension;
import dom.jfischer.probeunify2.pel.INamedClause;
import dom.jfischer.probeunify2.pel.INamedLiteral;
import dom.jfischer.probeunify2.pel.INamedTerm;
import dom.jfischer.probeunify2.pel.IPELVariableContext;
import dom.jfischer.probeunify2.pel.ITermNonVariableExtension;
import java.util.Map;
}

logic
locals  [ IModule module ]
:
  module_decls
  sort_decls
  predicate_decls
  operation_decls
  axiom_decls ;

proof
:
  SymbolToken ( clauses+=clause )* ;

module_decls
:
  '[' 'modules' ']' ( decls+=module_decl )* ( eqs+=module_eq )* ;

sort_decls
:
  '[' 'sorts' ']' ( decls+=sort_decl )* ;

predicate_decls
:
  '[' 'predicates' ']' ( decls+=predicate_decl )* ;

operation_decls
:
  '[' 'operations' ']' ( decls+=operation_decl )* ;

axiom_decls
:
  '[' 'axioms' ']' (axioms+=axiom_decl )* ;

module_decl
:
  SymbolToken ':' SymbolToken '.' ;

module_eq
:
  args+=symbol ( '=' args+=symbol )* '.' ;

sort_decl
:
  SymbolToken '.' ;

predicate_decl
:
  SymbolToken ':' ( args+=symbol )* '.' ;

operation_decl
:
  SymbolToken ':' ( lhs+=symbol )* '->' rhs=symbol '.' ;

axiom_decl
:
  SymbolToken ':' clause '.' ;

term
locals  [ IBaseExpression<ITrivialExtension> expectedSort;
          IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext;
          TermVariableInfo termVariableInfo ]
:
  term_variable                                     # termVariable
| symbol '(' ( args+=term (',' args+=term)* )? ')'  # termExpression
;

literal
locals  [ IPELVariableContext pelVariableContext;
          LiteralVariableInfo literalVariableInfo ]
:
  literal_variable                                  # literalVariable
| symbol '(' ( args+=term (',' args+=term)* )? ')'  # literalExpression
;

clause
locals  [ IPELVariableContext pelVariableContext;
          LiteralVariableInfo literalVariableInfo ]
:
  symbol                                            # axiomConstant
| variable_ctx ( premises+=literal (';' premises+=literal)* )? '==>' conclusion=literal
                                                    # axiomExpression
;

symbol
:
  ( quals+=SymbolToken '.' )* base=SymbolToken ;

term_variable
locals  [ IBaseExpression<ITrivialExtension> expectedSort;
          IVariableContext<IBaseExpression<ITrivialExtension>, ITermNonVariableExtension> termVariableContext;
          TermVariableInfo termVariableInfo ]
:
  TermIndexedVariableToken                          # TermIndexedVariable
| TermVariableToken                                 # TermBasicVariable
;

literal_variable
locals  [ IPELVariableContext pelVariableContext;
          LiteralVariableInfo literalVariableInfo ]
:
  LiteralIndexedVariableToken                       # LiteralIndexedVariable
| LiteralVariableToken                              # LiteralBasicVariable
;

variable_ctx
locals  [ CtxBean ctxBean;
          IPELVariableContext pelVariableContext;
          LiteralVariableInfo literalVariableInfo ]
:
  '{' ( args+=ctx_variable )* '}' ;


ctx_variable
locals  [ IPELVariableContext pelVariableContext;
          LiteralVariableInfo literalVariableInfo ]
:
  LiteralIndexedVariableToken                       # LiteralIndexedCtx
| LiteralVariableToken                              # LiteralBaseCtx
| TermIndexedVariableToken                          # TermIndexedCtx
| TermVariableToken                                 # TermBaseCtx
;

SymbolToken: [A-Za-z_][A-Za-z0-9]* ;

TermVariableToken: '?' VariableToken ;
LiteralVariableToken: '??' VariableToken ;
VariableToken: ('__'|SymbolToken) ;
Number: [0-9]+ ;
TermIndexedVariableToken: TermVariableToken'_'Number ;
LiteralIndexedVariableToken: LiteralVariableToken'_'Number ;

NEWLINE: [\r\n]+       ->skip;
COMMENT: '#'.*?NEWLINE ->skip;
WHITESPACE: ([ \t\f]|COMMENT|NEWLINE)+ ->skip;
