use "logics/contected_clause_common.sig";

signature ContectedMultiClause =
   sig
      include ContectedClauseCommon

      val get_conclusion: T -> Literal.Multi.T
      val construct: Literal.VariableContext.T * Literal.Multi.T * Literal.Multi.T -> T

      val is_empty: T -> bool
   end
