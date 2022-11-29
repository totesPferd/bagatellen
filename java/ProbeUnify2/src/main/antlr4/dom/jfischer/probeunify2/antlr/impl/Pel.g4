grammar Pel;

@header {
import dom.jfischer.probeunify2.antlr.ExpressionSystem;
import dom.jfischer.probeunify2.basic.IBaseExpression;
import dom.jfischer.probeunify2.basic.ITrivialExtension;
import dom.jfischer.probeunify2.basic.IVariable;
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
  variable_decls
  term_decls
  literal_decls
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

variable_decls
:
  '[' 'variables' ']' ( decls+=variable_decl )* ;

term_decls
:
  '[' 'terms' ']' ( decls+=term_decl )* ;

literal_decls
:
  '[' 'literals' ']' (decls+=literal_decl )* ;

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

variable_decl
:
  literal_variable_decl
| term_variable_decl
;

literal_variable_decl
:
  SymbolToken '.' ;

term_variable_decl
:
  SymbolToken ':' symbol '.' ;

term_decl
:
  SymbolToken ':' term '.' ;

literal_decl
:
  SymbolToken ':' literal '.' ;

axiom_decl
:
  SymbolToken ':' clause '.' ;

term
locals  [ IBaseExpression<ITrivialExtension> expectedSort;
          Map<String, IVariable<ITermNonVariableExtension>> termBaseVars;
          Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars;
          IPELVariableContext pelVariableContext ]
:
  symbol                                            # termConstant
| variable                                          # termVariable
| symbol '(' ( args+=term (',' args+=term)* )? ')'  # termExpression
;

literal
locals  [ Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars;
          Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars;
          Map<String, IVariable<ITermNonVariableExtension>> termBaseVars;
          Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars;
          IPELVariableContext pelVariableContext ]
:
  symbol                                            # literalConstant
| variable                                          # literalVariable
| symbol '(' ( args+=term (',' args+=term)* )? ')'  # literalExpression
;

clause
locals  [ Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars;
          Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars;
          Map<String, IVariable<ITermNonVariableExtension>> termBaseVars;
          Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars;
          IPELVariableContext pelVariableContext ]
:
  symbol                                            # axiomConstant
| ( premises+=literal (';' premises+=literal)* )? '==>' conclusion=literal
                                                    # axiomExpression
;

symbol
:
  ( quals+=SymbolToken '.' )* base=SymbolToken ;

variable
locals  [ IBaseExpression<ITrivialExtension> expectedSort;
          Map<String, IVariable<ILiteralNonVariableExtension>> literalBaseVars;
          Map<String, Map<Integer, IVariable<ILiteralNonVariableExtension>>> literalIndexedVars;
          Map<String, IVariable<ITermNonVariableExtension>> termBaseVars;
          Map<String, Map<Integer, IVariable<ITermNonVariableExtension>>> termIndexedVars;
          IPELVariableContext pelVariableContext;
          ExpressionSystem expressionSystem ]
:
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
