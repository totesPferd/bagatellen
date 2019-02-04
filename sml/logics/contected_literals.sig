use "logics/literals.sig";
use "logics/variables.sig";
use "logics/variable_contexts.sig";

signature ContectedLiterals =
   sig
      structure Literals: Literals
      structure VariableContexts: VariableContexts
      structure Variables: Variables
      sharing Literals.Variables = Variables
      sharing VariableContexts.Variables = Variables

      type T
      val get_t: VariableContexts.VariableContext.T * Literals.Single.T -> T
      val get_conclusion: T -> Literals.Single.T
      val get_context: T -> VariableContexts.VariableContext.T

      val eq: T * T -> bool

      val alpha_convert: (Variables.Base -> Variables.Base) -> T -> VariableContexts.AlphaConverter
      val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T
   end;
