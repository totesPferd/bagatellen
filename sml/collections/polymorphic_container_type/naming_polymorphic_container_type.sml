use "collections/naming_polymorphic_container_type.sig";

structure NamingPolymorphicContainerType: NamingPolymorphicContainerType =
   struct
      type 'a T =  (string Option.option ref * 'a) list
      fun contains eq  (_, nil) =  false
      |   contains eq  ((m, x), ((n, y)::c))
             =  if (m = n)
                then
                   eq (x, y)
                else
                   contains eq ((m, x), c)
      fun subeq eq (c_1, c_2)
             =  List.all (fn (m, x) => contains eq ((m, x), c_2)) c_1
      fun cong eq (c_1, c_2) =  subeq eq (c_1, c_2) andalso subeq eq (c_2, c_1)
   end;
