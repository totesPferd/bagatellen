signature UnitPolymorphicContainerType =
   sig
      type 'a T =  'a Option.option
      val cong: ('a * 'a -> bool) -> 'a T * 'a T -> bool
   end;
