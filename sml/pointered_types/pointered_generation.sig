use "general/type.sig";
use "pointered_types/pointered_map.sig";
use "pointered_types/pointered_type.sig";

signature PointeredGeneration =
   sig
      structure Start: PointeredType
      structure End: PointeredType
      structure PointeredMap: PointeredMap
      structure PointerType: Type
      sharing Start.PointerType = PointerType
      sharing End.PointerType = PointerType
      sharing PointeredMap.PointerType = PointerType
      sharing PointeredMap.Start = Start.BaseType
      sharing PointeredMap.End = End.ContainerType

      val generate: PointeredMap.Map.T -> Start.ContainerType.T -> End.ContainerType.T

   end;
