use "logics/variables.sig";

signature VariablesDependingThing =
   sig
      structure Variables: Variables
      type L
      val pmap: (Variables.Variable -> Variables.Variable Option.option) -> L -> L Option.option
   end;
