signature PolymorphicContainerType =
   sig
      type 'a T
      val cong: ('a * 'a -> bool) -> 'a T * 'a T -> bool
   end;
