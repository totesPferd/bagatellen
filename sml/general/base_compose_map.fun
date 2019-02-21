use "general/base_map_extension.sig";
use "general/compose_map.sig";
use "general/map.sig";

functor BaseComposeMap(X:
   sig
      structure A: Map
      structure B: Map
      structure RBME: BaseMapExtension
      sharing A.Start = RBME.BaseMap.Start
      sharing A.End = B.Start
      sharing B.End = RBME.BaseMap.End
   end ): ComposeMap =
   struct
      structure A =  X.A
      structure B =  X.B
      structure Result =  X.RBME.BaseMap

      fun compose (f_1, f_2)
         =  let
               val rf_1 =  A.apply f_1
               val rf_2 =  B.apply f_2
               val rr =  rf_2 o rf_1
            in X.RBME.get_map rr
            end
   end;
