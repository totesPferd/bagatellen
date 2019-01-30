use "logics/literals.sig";
use "logics/variables.sig";

signature LiteralSets =
   sig
      structure Literals: Literals

      type V =  Literals.V
      val veq: V * V -> bool
      val vcopy: V -> V

      type L
      type Selector
      type Clause =  { antecedent: L, conclusion: Literals.T }
      val eq: V * V -> bool

      val is_proven: L -> bool
      val resolve: Selector * Clause *  L -> L Option.option

      val transition: (Literals.T * 'b -> 'b Option.option) -> L -> 'b -> 'b
      val pmap: (V -> V Option.option) -> L -> L Option.option
   end;
