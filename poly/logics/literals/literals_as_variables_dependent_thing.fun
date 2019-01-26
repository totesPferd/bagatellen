use "logics/literals.sig";
use "logics/variables_depending_thing.sig";

functor LiteralsAsVariablesDependentThing(L: Literals): VariablesDependingThing =
   struct
      structure Variables =  L.Variables
      type T =  L.T
      val map =  L.map
   end;
