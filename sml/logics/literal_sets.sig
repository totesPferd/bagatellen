use "logics/literals.sig";
use "logics/variables.sig";

signature LiteralSets =
   sig
      structure Literals: Literals
      structure Variables: Variables
      sharing Variables =  Literals.Variables

      type L
      type Selector
      type Clause =  { antecedent: L, conclusion: Literals.T }

      val is_proven: L -> bool
      val resolve: Selector * Clause *  L -> L Option.option

      val transition: (Literals.T * 'b -> 'b Option.option) -> L -> 'b -> 'b
      val pmap: (Variables.Variable -> Variables.Variable Option.option) -> L -> L Option.option
   end;
