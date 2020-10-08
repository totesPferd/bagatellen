signature UnitType =
   sig
      type T
      val point: T
      val eq: T * T -> bool
   end;
