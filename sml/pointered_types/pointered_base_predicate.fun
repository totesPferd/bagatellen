use "general/type.sig";
use "pointered_types/pointered_base_map.sig";
use "pointered_types/pointered_map.sig";
use "pointered_types/pointered_predicate.sig";
use "pointered_types/pointered_singleton.sig";
use "pointered_types/pointered_type.sig";

functor PointeredBasePredicate(X:
   sig
      structure PointeredSingleton: PointeredSingleton
      structure PointeredBaseMap: PointeredBaseMap
      sharing PointeredSingleton.PointeredMap = PointeredBaseMap
      sharing PointeredSingleton.PointeredType.BaseType = PointeredBaseMap.Start
      sharing PointeredSingleton.PointeredType.ContainerType = PointeredBaseMap.End
   end ): PointeredPredicate =
   struct
      structure PointeredType =  X.PointeredSingleton.PointeredType
      structure PointeredMap =  X.PointeredBaseMap
      structure PointerType =  X.PointeredSingleton.PointerType

      fun get_predicate pi
         =  PointeredMap.get_map
               (fn (p, b)
               => if (pi b)
                  then
                     PointeredMap.apply X.PointeredSingleton.singleton (p, b)
                  else
                     PointeredType.empty )

   end;
