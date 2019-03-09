use "general/map.sig";
use "pointered_types/pointered_type.sig";

signature PointeredFunctor =
   sig
      structure Start: PointeredType
      structure End: PointeredType
      structure Map: Map
      sharing Map.Start = Start.BaseStructure
      sharing Map.End = End.BaseStructure

      val map: Map.Map.T -> Start.ContainerType.T -> End.ContainerType.T
   end;
