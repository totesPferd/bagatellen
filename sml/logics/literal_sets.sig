use "logics/literals.sig";
use "logics/variables.sig";

signature LiteralSets =
   sig
      structure Literals: Literals
      structure Variables: Variables

      type L
      type Selector
      type Clause =  { antecedent: L, conclusion: Literals.T }
      type T =  Literals.T Variables.Variable
      val eq: T * T -> bool

      val is_proven: L -> bool
      val resolve: Selector * Clause *  L -> L Option.option

      val pmap: (T -> T Option.option) -> L -> L Option.option
   end;
