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

      val empty =  List.nil
      val is_empty =  List.null

      fun map f nil =  nil
      |   map f ((n, a)::l) =  (n, f(a))::(map f l)

      exception OutOfRange
      exception ContainerTypeArgsDoNotSuit
      fun get_alpha_transform (nil, nil) _ =  raise OutOfRange
        | get_alpha_transform ((_, x)::lx, (_, y)::ly) z =
            if (x = z)
            then
               y
            else
               get_alpha_transform (lx, ly) z
        | get_alpha_transform _ _ =  raise ContainerTypeArgsDoNotSuit

   end;
