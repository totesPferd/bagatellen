use "logics/ql/qualifier.sig";

structure Qualifier: Qualifier =
   struct
      type T =  string Option.option ref

      fun new_anonymous() =  ref(Option.NONE)
      fun new s =  ref (Option.SOME s)
      fun get_name q =  !q
      fun eq (p, q) =  (p = q)

   end;
