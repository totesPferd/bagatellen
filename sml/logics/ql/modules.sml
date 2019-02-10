use "logics/ql/modules.sig";

structure Modules: Modules =
   struct
      type T =  string Option.option ref

      fun new_anonymous() =  ref(Option.NONE)
      fun new s =  ref (Option.SOME s)
      fun get_name q =  !q
      fun eq (p, q) =  (p = q)

   end;
