use "general/base_map.sig";
use "general/type.sig";

functor BaseMap(X:
   sig
      structure Start: Type
      structure End: Type
   end ): BaseMap =
   struct
      structure Start =  X.Start
      structure End =  X.End
      structure Map =
         struct
            type T =  Start.T -> End.T
         end
      fun apply f x =  f x
      fun get_map f = f

   end;
