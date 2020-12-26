signature PolymorphicContainerType =
   sig
      type 'a T
      val cong: ('a * 'a -> bool) -> 'a T * 'a T -> bool

      val empty: 'a T
      val is_empty: 'a T -> bool

      val map: ('a -> 'b) -> 'a T -> 'b T

      val get_alpha_transform: ''a T * 'b T -> ''a -> 'b

   end;
