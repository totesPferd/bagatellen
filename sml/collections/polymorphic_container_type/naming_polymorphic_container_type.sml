use "collections/naming_polymorphic_container_type.sig";

structure NamingPolymorphicContainerType: NamingPolymorphicContainerType =
   struct
      type 'a T =  (string Option.option ref * 'a) list
   end;
