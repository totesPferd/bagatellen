use "logics/variables_depending_thing.sig";

signature PELVariableContexts =
   sig
      structure VariableContext: VariablesDependingThing

      val uniquize:                      VariableContext.T -> unit
   end;
