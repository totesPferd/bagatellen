use "logics/variables.sig";

signature VariableContexts =
   sig
      type T
      type V
      type VariableContext
      type AlphaConverter

      val alpha_convert:                 VariableContext -> AlphaConverter
      val get_variable_context:          AlphaConverter -> VariableContext
      val apply_alpha_converter:         AlphaConverter -> V -> V Option.option
      val apply_alpha_converter_as_vdt:  AlphaConverter -> T -> T Option.option

      val uniquize:                      VariableContext -> unit
   end;
