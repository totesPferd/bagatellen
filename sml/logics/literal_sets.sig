use "logics/literals.sig";

signature LiteralSets =
   sig
      structure Literals: Literals
      type LiteralSet
      type Selector
      type Clause =  { antecedent: LiteralSet, conclusion: Literals.T }

      val is_proven: LiteralSet -> bool
      val resolve: Selector * Clause *  LiteralSet -> LiteralSet Option.option
   end;
