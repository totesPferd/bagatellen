use "general/type.sig";
use "collections/unit_pointered_type_generating.sig";
use "collections/unit_polymorphic_container_type.sig";

functor UnitPointeredTypeGenerating(X:
   sig
      structure BaseType: Type
      structure PolymorphicContainerType: UnitPolymorphicContainerType
   end ): UnitPointeredTypeGenerating =
   struct
      structure PolymorphicContainerType =  X.PolymorphicContainerType
      structure BaseType =  X.BaseType
      structure ContainerType =
         struct
            type T =  BaseType.T PolymorphicContainerType.T
         end
      structure PointerType =
         struct
            type T =  unit
         end

      val empty         =  Option.NONE
      val is_empty      =  not o Option.isSome
      fun select (_, x) =  x

   end;
