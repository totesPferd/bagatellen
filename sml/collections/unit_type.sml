use "collections/eqs.sig";

structure UnitType: Eqs =
   struct
      type T =  unit
      fun eq(s, t) =  true
   end;
