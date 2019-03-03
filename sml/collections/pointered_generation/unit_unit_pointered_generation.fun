use "collections/unit_pointered_type_generating.sig";
use "general/type.sig";
use "pointered_types/pointered_base_map.sig";
use "pointered_types/pointered_generation.sig";

functor UnitUnitPointeredGeneration(X:
   sig
      structure From: UnitPointeredTypeGenerating
      structure To: UnitPointeredTypeGenerating
   end ): PointeredGeneration =
   struct
      structure Start =  X.From.PointeredTypeExtended
      structure End =  X.To.PointeredTypeExtended
      structure PointerType =  Start.PointerType
      structure PointeredMap: PointeredBaseMap =
         struct
            structure Start =  Start.BaseType
            structure End =  End.ContainerType
            structure Map =
               struct
                  type T =  Start.T -> End.T
               end
            structure PointerType =  PointerType

            fun apply f (_, m) =  f m
            fun get_map f =  (fn x => f((), x))
         end
      fun generate f c =  Option.join(Option.map f c)
   end;
