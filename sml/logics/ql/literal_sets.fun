use "logics/literals.sig";
use "logics/literal_sets.sig";

functor QLLiteralSets(Lit: Literals): LiteralSets =
   struct
      structure Literals =  Lit
      type L =  Literals.T Option.option
      type T =  Literals.V
      type Selector = unit
      type Clause =  { antecedent: L, conclusion: Literals.T }
      val eq = Literals.veq

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

     fun pmap (phi: T -> T Option.option) Option.NONE =  Option.NONE
       | pmap (phi: T -> T Option.option) (Option.SOME l) =  Option.SOME(Literals.pmap phi l)
   end;
