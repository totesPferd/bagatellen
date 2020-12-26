use "general/eq_type.sig";
use "logics/literal_equate.sig";
use "logics/multi_literal.sig";

signature Literal =
   sig
      structure Single: LiteralEquate
      structure Multi: MultiLiteral

      structure VariableContext: EqType
      type variableMap_t
      val copy: variableMap_t
      val context_alpha_transform: variableMap_t -> VariableContext.T -> VariableContext.T
      val single_alpha_transform: variableMap_t -> Single.T -> Single.T
      val multi_alpha_transform: variableMap_t -> Multi.T -> Multi.T

      type alphaTransform_t
      val make_alpha_transform: VariableContext.T * variableMap_t -> alphaTransform_t
      val get_alpha_transform: alphaTransform_t -> variableMap_t

   end
