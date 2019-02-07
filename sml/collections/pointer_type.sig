use "collections/eqs.sig";
use "collections/type.sig";

signature PointerType =
   sig
      structure BaseType: Eqs
      structure ContainerType: Type
      structure PointerType: Type

      val select:  PointerType.T * ContainerType.T -> BaseType.T

      val fold:       (BaseType.T * 'b -> 'b) -> 'b -> ContainerType.T -> 'b
      val map:        (BaseType.T -> BaseType.T) -> ContainerType.T -> ContainerType.T
      val empty:      unit -> ContainerType.T
      val is_empty:   ContainerType.T -> bool
      val all:        (BaseType.T -> bool) -> ContainerType.T -> bool
      val all_zip:    (BaseType.T * BaseType.T -> bool) -> (ContainerType.T * ContainerType.T) -> bool

      val mapfold:    (BaseType.T -> BaseType.T) -> (BaseType.T * BaseType.T * 'a -> 'a) -> 'a -> ContainerType.T -> (ContainerType.T * 'a)

      val fe:         BaseType.T -> ContainerType.T
      val fop:        (BaseType.T -> ContainerType.T) -> ContainerType.T -> ContainerType.T
      val is_in:      BaseType.T * ContainerType.T -> bool
      val subeq:      ContainerType.T * ContainerType.T -> bool

      val transition: (BaseType.T * 'b -> 'b Option.option) -> ContainerType.T -> 'b -> 'b

      (* auf der Abschussliste: *)
      val replace:    BaseType.T * ContainerType.T -> ContainerType.T -> ContainerType.T

   end;
