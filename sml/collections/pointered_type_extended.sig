use "general/eqs.sig";
use "general/type.sig";
use "pointered_types/pointered_type.sig";

signature PointeredTypeExtended =
   sig
      include PointeredType

      val all:        (BaseType.T -> bool) -> ContainerType.T -> bool
      val all_zip:    (BaseType.T * BaseType.T -> bool) -> (ContainerType.T * ContainerType.T) -> bool

      val is_in:      BaseType.T * ContainerType.T -> bool
      val subeq:      ContainerType.T * ContainerType.T -> bool

      val filter:     (BaseType.T -> bool) -> ContainerType.T -> ContainerType.T
      val transition: (BaseType.T * 'b -> 'b Option.option) -> ContainerType.T -> 'b -> 'b

   end;
