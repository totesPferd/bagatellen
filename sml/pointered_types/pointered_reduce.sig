use "general/monoid.sig";
use "pointered_types/pointered_type.sig";

signature PointeredReduce =
   sig
      structure PointeredType: PointeredType
      structure Monoid: Monoid

      val reduce: (PointeredType.BaseType.T -> Monoid.Base.T) -> PointeredType.ContainerType.T -> Monoid.Base.T
   end;
