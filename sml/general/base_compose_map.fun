use "general/base_map.sig";
use "general/compose_map.sig";

functor BaseComposeMap(X:
   sig
      structure A: BaseMap
      structure B: BaseMap
      structure Result: BaseMap
      sharing Result.Start = A.Start
      sharing A.End = B.Start
      sharing Result.End = B.End
   end ): ComposeMap =
   struct
      structure A =  X.A
      structure B =  X.B
      structure Result =  X.Result

      fun compose (f_1, f_2)
         =  let
               val rf_1 =  A.apply f_1
               val rf_2 =  B.apply f_2
               val rr =  rf_2 o rf_1
            in X.Result.get_map rr
            end
   end;
