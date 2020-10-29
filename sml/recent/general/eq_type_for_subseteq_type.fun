use "general/eq_type.sig";
use "general/subseteq_type.sig";

functor EqTypeForSubseteqType(X:
   sig
      structure SubseteqType: SubseteqType
   end ): EqType =
   struct

      type T =  X.SubseteqType.T

      fun eq(x, y) =  X.SubseteqType.subseteq(x, y) andalso X.SubseteqType.subseteq(y, x)

   end;
