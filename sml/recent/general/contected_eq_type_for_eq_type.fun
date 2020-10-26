use "general/contected_eq_type.sig";
use "general/eq_type.sig";

functor ContectedEqTypeForEqType(X:
   sig
      type context_t
      structure EqType: EqType
   end ): ContectedEqType =
   struct

      type context_t =  X.context_t

      type T =  X.EqType.T

      fun ceq (_, x, y) =  X.EqType.eq(x, y)

   end;
