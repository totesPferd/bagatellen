use "general/type.sig";
use "collections/unit_polymorphic_container_type.sig";

signature UnitPointeredTypeGenerating =
   sig
      structure PolymorphicContainerType: UnitPolymorphicContainerType
      structure BaseType: Type
      structure ContainerType:
         sig
            type T =  BaseType.T PolymorphicContainerType.T
         end
      structure PointerType:
         sig
            type T =  unit
         end

      val empty: ContainerType.T
      val is_empty: ContainerType.T -> bool
      val select: PointerType.T * ContainerType.T -> BaseType.T Option.option

   end;

