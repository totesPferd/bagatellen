use "general/eqs.sig";

signature PolymorphicPointeredType =
   sig
      structure ContainerType:
         sig
            type 'a T
            val polymorphic_eq: ('a * 'a -> bool) -> 'a T * 'a T -> bool
         end
      structure PointerType: Eqs

      val select:  PointerType.T * 'a ContainerType.T -> 'a Option.option

      val map:        ('a -> 'a) -> 'a ContainerType.T -> 'a ContainerType.T
      val empty:      unit -> 'a ContainerType.T
      val is_empty:   'a ContainerType.T -> bool
      val all:        ('a -> bool) -> 'a ContainerType.T -> bool
      val all_zip:    ('a * 'a -> bool) -> ('a ContainerType.T * 'a ContainerType.T) -> bool

      val p_fop:      ('a * 'a -> bool) -> ('a -> 'a ContainerType.T) -> 'a ContainerType.T -> 'a ContainerType.T
      val p_is_in:    ('a * 'a -> bool) -> 'a * 'a ContainerType.T -> bool
      val p_subeq:    ('a * 'a -> bool) -> 'a ContainerType.T * 'a ContainerType.T -> bool

      val filter:     ('a -> bool) -> 'a ContainerType.T -> 'a ContainerType.T
      val transition: ('a * 'b -> 'b Option.option) -> 'a ContainerType.T -> 'b -> 'b

   end;
