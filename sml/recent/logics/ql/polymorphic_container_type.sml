use "logics/polymorphic_container_type.sig";

structure QLPolymorphicContainerType: PolymorphicContainerType =
   struct
      type 'a T =  'a Option.option
      fun cong eq (Option.NONE, Option.NONE) =  true
      |   cong eq (Option.NONE, Option.SOME _) =  false
      |   cong eq (Option.SOME _, Option.NONE) =  false
      |   cong eq (Option.SOME x, Option.SOME y) =  eq (x, y)
      val empty =  Option.NONE
      fun is_empty a =  not(Option.isSome a)
      val map =  Option.map 

      exception OutOfRange
      exception ContainerTypeArgsDoNotSuit
      fun get_alpha_transform (Option.NONE, Option.NONE) _ =  raise OutOfRange
        | get_alpha_transform (Option.SOME x, Option.SOME y) z =
            if (x = z)
            then
               y
            else
               raise OutOfRange
        | get_alpha_transform _ _ =  raise ContainerTypeArgsDoNotSuit

   end;
