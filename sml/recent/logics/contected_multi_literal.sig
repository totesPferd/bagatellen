use "logics/contected_literal_common.sig";

signature ContectedMultiLiteral =
   sig
      include ContectedLiteralCommon

      val get_antecedent: T -> Literal.Multi.T
      val construct: Literal.VariableContext.T * Literal.Multi.T -> T

      val empty: Literal.VariableContext.T -> T
      val is_empty: T -> bool
   end
