use "collections/naming_polymorphic_container_type.sig";

structure NamingPolymorphicContainerType: NamingPolymorphicContainerType =
   struct
      type 'a T =  (string Option.option ref * 'a) list

      fun all_zip P (c_1, c_2)
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

      val cong =  all_zip

   end;
