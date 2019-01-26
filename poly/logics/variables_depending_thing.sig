use "logics/variables.sig";

signature VariablesDependingThing =
   sig
      structure Variables: Variables
      type L
      type T =  L Variables.Variable
      val eq: T * T -> bool
      val pmap: (T -> T Option.option) -> L -> L Option.option
   end;
