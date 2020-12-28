use "logics/contected_clause_common.sig";

signature ContectedSingleClause =
   sig
      include ContectedClauseCommon

      val get_conclusion: T -> Literal.Single.T
      val construct: Literal.VariableContext.T * Literal.Multi.T * Literal.Single.T -> T
   end
