use "general/eq_type.sig";
use "logics/literal.sig";

signature ContectedCommon =
   sig
      structure Literal: Literal
      include EqType

      val get_context: T -> Literal.VariableContext.T
      val alpha_transform: Literal.variableMap_t -> T -> T
   end
