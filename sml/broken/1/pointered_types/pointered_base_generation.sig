use "general/type.sig";
use "pointered_types/pointered_base_map.sig";
use "pointered_types/pointered_type.sig";

signature PointeredBaseGeneration =
   sig
      structure Start: PointeredType
      structure End: PointeredType
      structure PointeredMap: PointeredBaseMap
      structure PointerType: Type
      sharing Start.PointerType = PointerType
      sharing End.PointerType = PointerType
      sharing PointeredMap.PointerType = PointerType
      sharing PointeredMap.Start = Start.BaseType
      sharing PointeredMap.End = End.ContainerType

      val generate: PointeredMap.Map.T -> Start.ContainerType.T -> End.ContainerType.T

   end;
