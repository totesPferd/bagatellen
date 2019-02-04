use "logics/literals.sig";
use "logics/variable_contexts.sig";
use "logics/variables.sig";

signature Clauses =
   sig
      structure Literals: Literals
      structure VariableContexts: VariableContexts
      structure Variables: Variables
      sharing Literals.Variables =  Variables
      sharing VariableContexts.Variables =  Variables

      type T
      val get_t: VariableContexts.VariableContext.T * Literals.Multi.T * Literals.Single.T -> T
      val get_antecedent: T -> Literals.Multi.T
      val get_conclusion: T -> Literals.Single.T
      val get_context: T -> VariableContexts.VariableContext.T

      val eq: T * T -> bool

      val alpha_convert: (Variables.Base -> Variables.Base) -> T -> VariableContexts.AlphaConverter
      val apply_alpha_conversion: VariableContexts.AlphaConverter -> T -> T
      val resolve: T -> Literals.PointerType.T -> Literals.Multi.T -> Literals.Multi.T Option.option
   end;
