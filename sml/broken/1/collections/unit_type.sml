use "collections/unit_type.sig";

structure UnitType: UnitType =
   struct
      type T =  unit
      val point =  ()
      fun eq(s, t) =  true
   end;
