use "collections/eqs.sig";
use "collections/type.sig";

signature PointeredType =
   sig
      structure BaseType: Eqs
      structure ContainerType: Type
      structure PointerType: Eqs

      val select:  PointerType.T * ContainerType.T -> BaseType.T Option.option

      val map:        (BaseType.T -> BaseType.T) -> ContainerType.T -> ContainerType.T
      val empty:      ContainerType.T
      val is_empty:   ContainerType.T -> bool
      val all:        (BaseType.T -> bool) -> ContainerType.T -> bool
      val all_zip:    (BaseType.T * BaseType.T -> bool) -> (ContainerType.T * ContainerType.T) -> bool

      val mapfold:    (BaseType.T -> BaseType.T) -> (BaseType.T * BaseType.T * 'b -> 'b) -> 'b -> ContainerType.T -> (ContainerType.T * 'b)

      val fe:         BaseType.T -> ContainerType.T
      val fop:        (BaseType.T -> ContainerType.T) -> ContainerType.T -> ContainerType.T
      val is_in:      BaseType.T * ContainerType.T -> bool
      val subeq:      ContainerType.T * ContainerType.T -> bool

      val filter:     (BaseType.T -> bool) -> ContainerType.T -> ContainerType.T
      val transition: (BaseType.T * 'b -> 'b Option.option) -> ContainerType.T -> 'b -> 'b

   end;
