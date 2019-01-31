use "logics/variables.sig";

signature VariablesDependingThing =
   sig
      structure Variables: Variables
      type T
      val vmap: (Variables.T -> Variables.T) -> T -> T
   end;
