use "general/map.sig";
use "pointered_types/pointered_type.sig";

signature PointeredFunctor =
   sig
      structure Start: PointeredType
      structure End: PointeredType
      structure Map: Map
      sharing Map.Start = Start.BaseType
      sharing Map.End = End.BaseType

      val map: Map.Map.T -> Start.ContainerType.T -> End.ContainerType.T
   end;
