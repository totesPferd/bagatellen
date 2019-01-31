use "collections/dictset.fun";
use "collections/sets.fun";
use "logics/literals.sig";
use "logics/literal_sets.sig";
use "logics/variables.sig";

functor PELLiteralSets(Lit: Literals): LiteralSets =
   struct
      structure Literals =  Lit
      structure Variables =  Lit:Variables
      structure DictSet =  DictSet(Literals)
      structure LSets = Sets(DictSet)
      type L =  LSets.T
      type Selector = Literals.T
      type Clause =  { antecedent: L, conclusion: Literals.T }

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

      fun transition phi l b =  LSets.transition phi l b
      fun pmap (phi: Lit.Variable -> Lit.Variable Option.option) =  LSets.pmap (Lit.pmap phi)

   end;
