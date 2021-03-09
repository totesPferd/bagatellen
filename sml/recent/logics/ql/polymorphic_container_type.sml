use "logics/polymorphic_container_type.sig";

structure QLPolymorphicContainerType: PolymorphicContainerType =
   struct
      type 'a T =  'a Option.option
      fun cong eq (Option.NONE, Option.NONE) =  true
        | cong eq (Option.NONE, Option.SOME _) =  false
        | cong eq (Option.SOME _, Option.NONE) =  false
        | cong eq (Option.SOME x, Option.SOME y) =  eq (x, y)
      val empty =  Option.NONE
      fun is_empty a =  not(Option.isSome a)

      fun is_in eq (a, Option.NONE) =  false
        | is_in eq (a, Option.SOME b) =  eq(a, b)
      fun subeq eq (Option.NONE, _) =  true
        | subeq eq (Option.SOME a, d) =  is_in eq (a, d)

      val map =  Option.map 

      fun lift f =  Option.join o Option.map f

      exception OutOfRange
      exception ContainerTypeArgsDoNotSuit
      fun get_alpha_transform _ (Option.NONE, Option.NONE) _ =  raise OutOfRange
        | get_alpha_transform eq (Option.SOME x, Option.SOME y) z =
            if (eq(x, z))
            then
               y
            else
               raise OutOfRange
        | get_alpha_transform _ _ _ =  raise ContainerTypeArgsDoNotSuit

   end;
