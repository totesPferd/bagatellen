use "logics/literals.sig";
use "logics/literal_sets.sig";
use "logics/variables.sig";

functor QLLiteralSets(Lit: Literals): LiteralSets =
   struct
      structure Literals =  Lit
      structure Variables =  Lit.Variables
      type T =  Literals.T Option.option
      type Clause =  { antecedent: T, conclusion: Literals.T }

      fun eq (Option.NONE, Option.NONE) =  true
        | eq (Option.NONE, Option.SOME y) =  false
        | eq (Option.SOME x, Option.NONE) =  false
        | eq (Option.SOME x, Option.SOME y) =  Lit.eq(x, y)

      val is_proven = Option.isSome

      exception DoesNotContainLiteral
      exception ResolutionEmptyLiteralSet
      fun resolve (sel, clause: Clause, ls)
        = case (ls) of
             Option.NONE => raise ResolutionEmptyLiteralSet
          |  Option.SOME l
             => if Literals.eq(sel, l)
                then
                   if Literals.equate(l, #conclusion clause)
                   then
                      Option.SOME (#antecedent clause)
                   else
                      Option.NONE
                else raise DoesNotContainLiteral

      fun transition phi Option.NONE b =  b
        | transition phi (Option.SOME x) b
        = case(phi (x, b)) of
             Option.NONE =>  b
          |  Option.SOME c => c
 
      fun vmap (phi: Variables.T -> Variables.T) s =  Option.map (Lit.vmap phi) s
   end;
