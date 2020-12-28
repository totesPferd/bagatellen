use "logics/contected_common.sig";

signature ContectedClauseCommon =
   sig
      include ContectedCommon

      val get_antecedent: T -> Literal.Multi.T
      val is_assumption: T -> bool
   end
