use "collections/eqs.sig";
use "collections/pointered_type.sig";
use "collections/type.sig";

signature NamingPointeredType =
   sig
     structure PointeredType: PointeredType

     val get_name : PointeredType.BaseType.T
                    -> PointeredType.ContainerType.T -> string option
     val set_name : string * PointeredType.BaseType.T
                    -> PointeredType.ContainerType.T -> bool
     val uniquize : PointeredType.ContainerType.T -> unit
   end;

