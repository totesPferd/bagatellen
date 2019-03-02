use "collections/unit_polymorphic_container_type.sig";

structure UnitPolymorphicContainerType: UnitPolymorphicContainerType =
   struct
      type 'a T =  'a Option.option
   end;
