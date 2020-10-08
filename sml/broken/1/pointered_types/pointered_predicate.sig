use "general/type.sig";
use "pointered_types/pointered_map.sig";
use "pointered_types/pointered_type.sig";

signature PointeredPredicate =
   sig
      structure PointeredType: PointeredType
      structure PointeredMap: PointeredMap
      structure PointerType: Type
      sharing PointeredMap.Start = PointeredType.BaseType
      sharing PointeredMap.End = PointeredType.ContainerType
      sharing PointeredMap.PointerType = PointerType
      sharing PointeredType.PointerType = PointerType

      val predicate: PointeredType.BaseType.T -> bool
      val predicate_map: PointeredMap.Map.T

   end;
