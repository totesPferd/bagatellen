use "general/eq_type.sig";
use "general/subset_eq_type.sig";

functor EqTypeForSubsetEqType(X:
   sig
      structure SubsetEqType: SubsetEqType
   end ): EqType =
   struct

      type T =  X.SubsetEqType.T

      fun eq(x, y) =  X.SubsetEqType.subseteq(x, y) andalso X.SubsetEqType.subseteq(y, x)

   end;
