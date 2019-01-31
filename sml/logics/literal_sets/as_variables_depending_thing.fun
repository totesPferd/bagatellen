use "logics/literal_sets.sig";
use "logics/variables_depending_thing.sig";
use "logics/variables.sig";

functor LiteralSetAsVariablesDependingThing(X: LiteralSets): VariablesDependingThing =
   struct
      structure Variables =  X.Variables
      type T =  X.Clause

      fun vmap (phi: Variables.T -> Variables.T) (cl: X.Clause)
        = { antecedent =  X.vmap phi (#antecedent cl), conclusion =  X.Literals.vmap phi (#conclusion cl) }

   end;
