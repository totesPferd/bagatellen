use "logics/contected_literal_common.sig";

signature ContectedSingleLiteral =
   sig
      include ContectedLiteralCommon

      val get_conclusion: T -> Literal.Single.T
      val construct: Literal.VariableContext.T * Literal.Single.T -> T

   end
