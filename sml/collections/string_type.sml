use "collections/eqs.sig";

structure StringType: Eqs =
   struct
      type T =  string
      fun eq(s, t) =  (s = t)
   end;
