use "collections/dictset.fun";
use "collections/sets.fun";
use "logics/literals.sig";
use "logics/literal_sets.sig";

functor LiteralSets(L: Literals): LiteralSets =
   struct
      structure Literals =  L
      structure DictSet =  DictSet(L)
      structure LSets = Sets(DictSet)
      type LiteralSet =  LSets.T
      type Selector = L.T
      type Clause =  { antecedent: LiteralSet, conclusion: Literals.T }

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
   end;
