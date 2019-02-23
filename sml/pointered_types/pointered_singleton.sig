use "general/type.sig";
use "pointered_types/pointered_map.sig";
use "pointered_types/pointered_type.sig";

signature PointeredSingleton =
   sig
      structure PointeredType: PointeredType
      structure PointeredMap: PointeredMap
      structure PointerType: Type
      sharing PointeredMap.Start = PointeredType.BaseType
      sharing PointeredMap.End = PointeredType.ContainerType
      sharing PointeredMap.PointerType = PointerType
      sharing PointeredType.PointerType = PointerType

      val singleton: PointeredMap.Map.T
   end;
