use "general/type.sig";
use "general/type_map.sig";
use "general/compose_map.sig";
use "pointered_types/pointered_base_map.sig";
use "pointered_types/pointered_compose_map.sig";
use "pointered_types/pointered_type_map.sig";

functor PointeredBaseComposeMap(X:
   sig
      structure A: TypeMap
      structure B: PointeredTypeMap
      structure Result: PointeredBaseMap
      structure PointerType: Type
      sharing Result.Start = A.Start
      sharing A.End = B.Start
      sharing Result.End = B.End
      sharing B.PointerType = PointerType
      sharing Result.PointerType = PointerType
   end ): PointeredComposeMap =
   struct
      structure A =  X.A
      structure B =  X.B
      structure Result =  X.Result
      structure PointerType =  X.PointerType

      fun compose (f_1, f_2)
         =  let
               val rf_1 =  A.apply f_1
               val rf_2 =  B.apply f_2
               fun rr (p, x) =  rf_2 (p, rf_1 x)
            in Result.get_map rr
            end
   end;
