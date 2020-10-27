use "general/eq_type.sig";

functor EqTypeForList(X:
   sig
      structure EqType: EqType
   end ): EqType =
   struct

      type T =  X.EqType.T list
      val eq =  ListPair.allEq X.EqType.eq

   end;
