use "collections/type.sig";

signature PolymorphicPointerType =
   sig
      structure ContainerType:
         sig
            type 'a T
         end
      structure PointerType: Type

      val select:  PointerType.T * 'a ContainerType.T -> 'a

      val fold:       ('a * 'b -> 'b) -> 'b -> 'a ContainerType.T -> 'b
      val map:        ('a -> 'a) -> 'a ContainerType.T -> 'a ContainerType.T
      val empty:      unit -> 'a ContainerType.T
      val is_empty:   'a ContainerType.T -> bool
      val all:        ('a -> bool) -> 'a ContainerType.T -> bool
      val all_zip:    ('a * 'a -> bool) -> ('a ContainerType.T * 'a ContainerType.T) -> bool

      val mapfold:    ('b -> 'b) -> ('b * 'b * 'a -> 'a) -> 'a -> 'b ContainerType.T -> ('b ContainerType.T * 'a)

      val fe:         'a -> 'a ContainerType.T
      val p_fop:      ('a * 'a -> bool) -> ('a -> 'a ContainerType.T) -> 'a ContainerType.T -> 'a ContainerType.T
      val p_is_in:    ('a * 'a -> bool) -> 'a * 'a ContainerType.T -> bool
      val p_subeq:    ('a * 'a -> bool) -> 'a ContainerType.T * 'a ContainerType.T -> bool

      val transition: ('a * 'b -> 'b Option.option) -> 'a ContainerType.T -> 'b -> 'b

   end;
