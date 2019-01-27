use "logics/literals.sig";
use "logics/variables.sig";

signature LiteralSets =
   sig
      structure Literals: Literals

      type V
      val veq: V * V -> bool
      val vcopy: V -> V

      type L
      type Selector
      type Clause =  { antecedent: L, conclusion: Literals.T }
      type T =  Literals.V
      val eq: T * T -> bool

      val is_proven: L -> bool
      val resolve: Selector * Clause *  L -> L Option.option

      val pmap: (T -> T Option.option) -> L -> L Option.option
   end;
