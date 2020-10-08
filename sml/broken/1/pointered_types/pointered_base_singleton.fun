use "pointered_types/pointered_base_singleton.sig";
use "pointered_types/pointered_type.sig";

functor PointeredBaseSingleton(X:
   sig
      structure PointeredType: PointeredType
      val singleton: PointeredType.PointerType.T * PointeredType.BaseType.T -> PointeredType.ContainerType.T
   end ): PointeredBaseSingleton =
   struct
      structure PointeredType =  X.PointeredType
      structure PointerType =  PointeredType.PointerType
      structure PointeredMap =
         struct
            structure Start =  PointeredType.BaseType
            structure End =  PointeredType.ContainerType
            structure PointerType =  PointeredType.PointerType
            structure Map =
               struct
                  type T =  PointerType.T * Start.T -> End.T
               end
            fun apply f (p, x) =  f (p, x)
            fun get_map f =  f
         end

      val singleton =  X.singleton
   end;
