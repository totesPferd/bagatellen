use "collections/unit_polymorphic_container_type.sig";

structure UnitPolymorphicContainerType: UnitPolymorphicContainerType =
   struct
      type 'a T =  'a Option.option
      fun cong eq (Option.NONE, Option.NONE) =  true
      |   cong eq (Option.NONE, Option.SOME _) =  false
      |   cong eq (Option.SOME _, Option.NONE) =  false
      |   cong eq (Option.SOME x, Option.SOME y) =  eq (x, y)
   end;
