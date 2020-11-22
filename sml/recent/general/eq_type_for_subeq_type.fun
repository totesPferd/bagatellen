use "general/eq_type.sig";
use "general/subeq_type.sig";

functor EqTypeForSubeqType(X:
   sig
      structure SubeqType: SubeqType
   end ): EqType =
   struct

      type T =  X.SubeqType.T

      fun eq(x, y) =  X.SubeqType.subeq(x, y) andalso X.SubeqType.subeq(y, x)

   end;
