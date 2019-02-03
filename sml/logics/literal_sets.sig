use "logics/literals.sig";
use "logics/variables.sig";

signature LiteralSets =
   sig
      structure Literals: Literals
      structure Variables: Variables
      sharing Variables =  Literals.Variables

      type T
      type Clause =  { antecedent: T, conclusion: Literals.LiteralsIn.PT.BaseType.T }

      val eq: T * T -> bool

      val is_proven: T -> bool
      val resolve: Literals.LiteralsIn.PT.BaseType.T * Clause *  T -> T Option.option

      val transition: (Literals.LiteralsIn.PT.BaseType.T * 'b -> 'b Option.option) -> T -> 'b -> 'b
      val vmap: (Variables.T -> Variables.T) -> T -> T
   end;
