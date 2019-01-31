use "logics/variables.sig";

signature VariablesDependingThing =
   sig
      structure Variables: Variables
      type L
      val pmap: (Variables.T -> Variables.T Option.option) -> L -> L Option.option
   end;
