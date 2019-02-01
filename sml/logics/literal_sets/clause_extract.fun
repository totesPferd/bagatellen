use "logics/literal_sets.sig";
use "logics/variables_depending_thing.sig";
use "logics/variables.sig";

functor ClauseExtract(X: LiteralSets) =
   struct
      structure Variables =  X.Variables
      type T =  X.Clause

      fun eq(c: T, d: T)
        = X.eq (#antecedent c, #antecedent d) andalso X.Literals.eq (#conclusion c, #conclusion d)
      fun vmap (phi: Variables.T -> Variables.T) (cl: X.Clause)
        = ({ antecedent =  X.vmap phi (#antecedent cl), conclusion =  X.Literals.vmap phi (#conclusion cl) }): X.Clause

   end;
