use "general/base_map_extension.sig";
use "general/map.sig";
use "general/type.sig";

functor BaseMapExtension(X:
   sig
      structure Start: Type
      structure End: Type
   end ): BaseMapExtension =
   struct
      structure BaseMap =
         struct
            structure Start =  X.Start
            structure End =  X.End
      
            type T =  Start.T -> End.T
      
            fun apply f x =  f x
         end

      fun get_map f =  f

   end;
