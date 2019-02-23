use "general/map.sig";
use "pointered_types/pointered_type.sig";

signature PointeredFilter =
   sig
      structure PointeredType: PointeredType

      val filter:  (PointeredType.BaseType.T -> bool) -> PointeredType.ContainerType.T -> PointeredType.ContainerType.T

   end;
