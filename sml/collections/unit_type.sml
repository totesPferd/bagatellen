use "collections/unit_type.sig";

structure UnitType: UnitType =
   struct
      type T =  unit
      val pointer =  ()
      fun eq(s, t) =  true
   end;
