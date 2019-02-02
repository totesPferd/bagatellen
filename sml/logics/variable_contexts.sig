use "logics/variables.sig";
use "logics/variables_depending_thing.sig";

signature VariableContexts =
   sig
      structure Variables: Variables
      structure VariableContext: VariablesDependingThing
      sharing VariableContext.Variables =  Variables

      type AlphaConverter

      val alpha_convert:                 VariableContext.T -> AlphaConverter
      val get_variable_context:          AlphaConverter -> VariableContext.T
      val apply_alpha_converter:         AlphaConverter -> Variables.T -> Variables.T

      val alpha_zip_all:                 AlphaConverter * AlphaConverter -> (Variables.T * Variables.T -> bool) -> bool
   end;
