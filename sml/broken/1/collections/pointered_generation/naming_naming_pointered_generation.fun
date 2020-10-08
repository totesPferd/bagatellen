use "collections/naming_pointered_type_generating.sig";
use "general/type.sig";
use "pointered_types/pointered_base_map.sig";
use "pointered_types/pointered_base_generation.sig";

functor NamingNamingPointeredGeneration(X:
   sig
      structure From: NamingPointeredTypeGenerating
      structure To: NamingPointeredTypeGenerating
   end ): PointeredBaseGeneration =
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
                  type T =  PointerType.T * Start.T -> End.T
               end
            structure PointerType =  PointerType

            fun apply f m =  f m
            fun get_map f =  f
         end
      fun generate f
         =  List.foldl (fn ((n, b), c') =>   X.To.sum(f(n, b), c')) nil
   end;
