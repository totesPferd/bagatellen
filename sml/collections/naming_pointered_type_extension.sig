use "general/eqs.sig";
use "collections/pointered_type.sig";
use "collections/string_type.sig";
use "pointered_types/pointered_singleton.sig";

signature NamingPointeredTypeExtension =
   sig
     structure StringType: StringType
     structure PointeredType2: PointeredType2
     sharing PointeredType2.PointerType =  StringType

     structure PointeredSingleton: PointeredSingleton
     sharing PointeredSingleton.PointeredType =  PointeredType2
     sharing PointeredSingleton.PointerType =  StringType

     val sum:        PointeredType2.ContainerType.T * PointeredType2.ContainerType.T -> PointeredType2.ContainerType.T

     val add:        PointeredType2.BaseType.T -> PointeredType2.ContainerType.T -> PointeredType2.ContainerType.T
     val adjoin:     string * PointeredType2.BaseType.T * PointeredType2.ContainerType.T -> PointeredType2.ContainerType.T
     val transition: (string Option.option * PointeredType2.BaseType.T * 'b -> 'b Option.option) -> PointeredType2.ContainerType.T -> 'b -> 'b

     val get_name :  PointeredType2.BaseType.T
                     -> PointeredType2.ContainerType.T -> string option
     val set_name :  string * PointeredType2.BaseType.T
                     -> PointeredType2.ContainerType.T -> bool
     val uniquize :  PointeredType2.ContainerType.T -> unit
   end;

