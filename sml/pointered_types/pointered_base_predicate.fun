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

      val predicate: PointeredSingleton.PointeredType.BaseType.T -> bool

   end ): PointeredPredicate =
   struct
      structure PointeredType =  X.PointeredSingleton.PointeredType
      structure PointeredMap =  X.PointeredBaseMap
      structure PointerType =  X.PointeredSingleton.PointerType

      val predicate =  X.predicate
      val predicate_map
         =  PointeredMap.get_map
               (fn (p, b)
               => if (predicate b)
                  then
                     PointeredMap.apply X.PointeredSingleton.singleton (p, b)
                  else
                     PointeredType.empty )

   end;
