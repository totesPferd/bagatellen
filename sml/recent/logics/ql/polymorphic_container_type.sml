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
   end;
