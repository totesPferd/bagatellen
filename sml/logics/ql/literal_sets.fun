use "logics/literals.sig";
use "logics/literal_sets.sig";

functor LiteralSets(L: Literals): LiteralSets =
   struct
      structure Literals =  L
      type LiteralSet =  L.T Option.option
      type Selector = unit
      type Clause =  { antecedent: LiteralSet, conclusion: Literals.T }

      val is_proven = Option.isSome
      fun resolve (sel, clause: Clause, ls)
        = case (ls) of
             Option.NONE => Option.NONE
          |  Option.SOME l
             => if Literals.equate(l, #conclusion clause)
                then
                   Option.SOME (#antecedent clause)
                else
                   Option.NONE
   end;
