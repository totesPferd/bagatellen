use "logics/literals.sig";
use "logics/variables_depending_thing.sig";

functor LiteralsAsVariablesDependingThing(L: Literals): VariablesDependingThing =
   struct
      structure Variables =  L.Variables
      type L =  L.T
      type T =  L Variables.Variable
      val eq =  Variables.eq
      val pmap =  L.pmap
   end;
