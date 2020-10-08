use "general/eqs.sig";
use "collections/pointered_type_extended.sig";
use "collections/string_type.sig";
use "pointered_types/pointered_singleton.sig";

signature NamingPointeredTypeExtension =
   sig
     structure StringType: StringType
     structure PointeredTypeExtended: PointeredTypeExtended
     sharing PointeredTypeExtended.PointerType =  StringType

     val sum:        PointeredTypeExtended.ContainerType.T * PointeredTypeExtended.ContainerType.T -> PointeredTypeExtended.ContainerType.T

     val add:        PointeredTypeExtended.BaseType.T -> PointeredTypeExtended.ContainerType.T -> PointeredTypeExtended.ContainerType.T
     val adjoin:     string * PointeredTypeExtended.BaseType.T * PointeredTypeExtended.ContainerType.T -> PointeredTypeExtended.ContainerType.T
     val transition: (string Option.option * PointeredTypeExtended.BaseType.T * 'b -> 'b Option.option) -> PointeredTypeExtended.ContainerType.T -> 'b -> 'b

     val get_name :  PointeredTypeExtended.BaseType.T
                     -> PointeredTypeExtended.ContainerType.T -> string option
     val set_name :  string * PointeredTypeExtended.BaseType.T
                     -> PointeredTypeExtended.ContainerType.T -> bool
     val uniquize :  PointeredTypeExtended.ContainerType.T -> unit
   end;

