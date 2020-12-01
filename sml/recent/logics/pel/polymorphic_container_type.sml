use "logics/polymorphic_container_type.sig";

structure PELPolymorphicContainerType: PolymorphicContainerType =
   struct
      type 'a T =  (string Option.option ref * 'a) list

      fun cong P (c_1, c_2)
        =  let
              fun aux (P, nil) (m, x) =  false
              |   aux (P, (n, y)::c) (m, x)
                     =   if (m = n)
                         then
                            P(x, y)
                         else
                            aux (P, c) (m, x)
           in List.all (aux (P, c_2)) c_1
           end

      fun uniquize(container)
        = let
             fun rename(do_not_use_list, candidate)
               = if (List.exists (fn (n) => (n = candidate)) do_not_use_list)
                 then
                    rename(do_not_use_list, candidate ^ "'")
                 else
                    candidate
             fun get_candidate name_r
               = (
                    case (!name_r) of
                       Option.NONE => "_"
                    |  Option.SOME n => n )
             fun get_next_do_not_use_list((name_r, b), do_not_use_list)
               = let
                    val new_name =  rename(do_not_use_list, get_candidate name_r)
                 in
                    (
                       name_r := Option.SOME new_name;
                       (new_name :: do_not_use_list) )
                 end;
          in
             (List.foldl (get_next_do_not_use_list) nil container; ())
          end

   end;
