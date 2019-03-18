signature PolymorphicContainerType =
   sig
      type 'a T
      val cong: ('a * 'a -> bool) -> 'a * 'a T -> bool
   end;
