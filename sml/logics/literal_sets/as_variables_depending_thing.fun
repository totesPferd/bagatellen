use "logics/literal_sets.sig";
use "logics/variables_depending_thing.sig";

functor LiteralSetAsVariablesDependingThing(X: LiteralSets): VariablesDependingThing =
   struct
      type V =  X.V
      type L =  X.Clause

      val veq =  X.veq
      val vcopy =  X.vcopy

      fun pmap (phi: V -> V Option.option) (cl: X.Clause)
        = case (X.Literals.pmap phi (#conclusion cl)) of
             Option.NONE =>  Option.NONE
          |  Option.SOME c
                => case(X.pmap phi (#antecedent cl)) of
                      Option.NONE => Option.NONE
                   |  Option.SOME a => Option.SOME { antecedent = a, conclusion = c }

   end;
