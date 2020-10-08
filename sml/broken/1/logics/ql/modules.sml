use "logics/ql/modules.sig";

structure Modules: Modules =
   struct
      type T =  unit ref

      fun new() =  ref()
      fun eq (p, q) =  (p = q)

   end;
