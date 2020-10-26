signature ContectedEqType =
   sig

      type context_t

      type T

      val ceq: context_t * T * T -> bool

   end;
