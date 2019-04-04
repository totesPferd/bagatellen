use "general/type.sig";
use "pointered_types/pointered_base_map.sig";
use "pointered_types/pointered_type.sig";

signature PointeredBaseSingleton =
   sig
      structure PointeredType: PointeredType
      structure PointeredMap: PointeredBaseMap
      structure PointerType: Type
      sharing PointeredMap.Start = PointeredType.BaseType
      sharing PointeredMap.End = PointeredType.ContainerType
      sharing PointeredMap.PointerType = PointerType
      sharing PointeredType.PointerType = PointerType

      val singleton: PointeredMap.Map.T
   end;
