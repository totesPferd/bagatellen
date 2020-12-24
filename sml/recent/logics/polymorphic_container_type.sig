signature PolymorphicContainerType =
   sig
      type 'a T
      val cong: ('a * 'a -> bool) -> 'a T * 'a T -> bool
      val empty: 'a T
      val is_empty: 'a T -> bool
   end;
