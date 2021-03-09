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

      fun is_in eq (a, List.nil) =  false
        | is_in eq (a, ((_, b)::l)) =
          if eq(a, b)
          then
             true
          else
             is_in eq (a, l)
      fun subeq eq (List.nil, d) =  true
        | subeq eq ((_, a)::l, d) =
            is_in eq (a, d)
      andalso
            subeq eq (l, d)

      fun map f nil =  nil
      |   map f ((n, a)::l) =  (n, f(a))::(map f l)

      fun singleton x =  [(ref Option.NONE, x)]
      fun lift f nil =  nil
        | lift f ((n, a)::l) =  List.concat[(f a), lift f l]
      fun transition phi nil b =  b
        | transition phi ((n, a) :: tl) b
        = let
             fun prec_state_l () =  transition phi tl b
          in phi(a, prec_state_l)
          end

      exception OutOfRange
      exception ContainerTypeArgsDoNotSuit
      fun get_alpha_transform _ (nil, nil) _ =  raise OutOfRange
        | get_alpha_transform eq ((_, x)::lx, (_, y)::ly) z =
            if (eq(x, z))
            then
               y
            else
               get_alpha_transform eq (lx, ly) z
        | get_alpha_transform _ _ _ =  raise ContainerTypeArgsDoNotSuit

   end;
