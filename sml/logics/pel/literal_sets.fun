use "collections/dictset.fun";
use "collections/sets.fun";
use "logics/literals.sig";
use "logics/literal_sets.sig";

functor PELLiteralSets(Lit: Literals): LiteralSets =
   struct
      structure Literals =  Lit
      structure DictSet =  DictSet(Literals)
      structure LSets = Sets(DictSet)
      type L =  LSets.T
      type T =  Literals.V
      type Selector = Literals.T
      type Clause =  { antecedent: L, conclusion: Literals.T }
      val eq = Literals.veq
      type V =  Literals.V
      val veq =  Literals.veq
      val vcopy =  Literals.vcopy

      val is_proven = LSets.is_empty
      fun resolve (sel, clause: Clause, ls)
        = case (LSets.drop_if_exists(sel, ls)) of
             Option.NONE => Option.NONE
          |  Option.SOME ls
             => if Literals.equate(sel, #conclusion clause)
                then
                   Option.SOME (LSets.union(ls, #antecedent clause))
                else
                   Option.NONE

      fun pmap (phi: T -> T Option.option) =  LSets.pmap (Lit.pmap phi)

   end;
