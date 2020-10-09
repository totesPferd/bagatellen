use "general/eq_type.sig";

functor CanonicalEqType (X:
   sig
      eqtype T
   end ): EqType =
   struct

      open X
      val eq = op=

   end
