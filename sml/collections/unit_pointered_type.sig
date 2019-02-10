use "collections/eqs.sig";
use "collections/pointered_type.sig";
use "collections/type.sig";

signature UnitPointeredType =
   sig
     structure PointeredType: PointeredType

     val get_val:   PointeredType.ContainerType.T -> PointeredType.BaseType.T Option.option

   end;

