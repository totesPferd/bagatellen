use "logics/variables.sig";

signature VariablesDependingThing =
   sig
      structure Variables: Variables
      type L
      val vmap: (Variables.T -> Variables.T) -> L -> L
   end;
