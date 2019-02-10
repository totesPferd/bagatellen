signature UnitType =
   sig
      type T
      val pointer: T
      val eq: T * T -> bool
   end;
