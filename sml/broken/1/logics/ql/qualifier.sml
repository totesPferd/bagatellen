use "logics/ql/qualifier.sig";

structure Qualifier: Qualifier =
   struct
      type T =  unit ref

      fun new() =  ref()
      fun eq (p, q) =  (p = q)

   end;
