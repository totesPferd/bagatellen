use "general/map.sig";
use "general/type.sig";

functor BaseMap(X:
   sig
      structure Start: Type
      structure End: Type
   end ): Map =
   struct
      structure Start =  X.Start
      structure End =  X.End

      type T =  Start.T -> End.T

      fun apply f x =  f x

   end;
