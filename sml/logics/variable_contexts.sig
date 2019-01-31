signature VariableContexts =
   sig
      structure Variables: Variables

      type T
      type VariableContext
      type AlphaConverter

      val alpha_convert:                 VariableContext -> AlphaConverter
      val get_variable_context:          AlphaConverter -> VariableContext
      val apply_alpha_converter:         AlphaConverter -> Variables.Variable -> Variables.Variable Option.option
      val apply_alpha_converter_as_vdt:  AlphaConverter -> T -> T Option.option

      val uniquize:                      VariableContext -> unit
   end;
