use "logics/literal_sets.sig";
use "logics/variables_depending_thing.sig";
use "logics/variables.sig";

functor LiteralSetAsVariablesDependingThing(X: LiteralSets): VariablesDependingThing =
   struct
      structure Variables =  X.Variables
      type L =  X.Clause

      fun pmap (phi: Variables.T -> Variables.T Option.option) (cl: X.Clause)
        = case (X.Literals.pmap phi (#conclusion cl)) of
             Option.NONE =>  Option.NONE
          |  Option.SOME c
                => case(X.pmap phi (#antecedent cl)) of
                      Option.NONE => Option.NONE
                   |  Option.SOME a => Option.SOME { antecedent = a, conclusion = c }

   end;
