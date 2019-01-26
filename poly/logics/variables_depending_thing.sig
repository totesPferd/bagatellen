use "logics/variables.sig";

signature VariablesDependingThing =
   sig
      structure Variables: Variables
      type T
      val map: (T Variables.Variable -> T Variables.Variable) -> T -> T
   end;
