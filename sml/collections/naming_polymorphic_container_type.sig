signature NamingPolymorphicContainerType =
   sig
      type 'a T =  (string Option.option ref * 'a) list
      val cong: ('a * 'a -> bool) -> 'a T * 'a T -> bool
   end;
