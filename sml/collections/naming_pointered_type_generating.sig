use "general/eqs.sig";
use "collections/naming_polymorphic_container_type.sig";

signature NamingPointeredTypeGenerating =
   sig
      structure PolymorphicContainerType: NamingPolymorphicContainerType
      structure BaseType: Eqs
      structure ContainerType:
         sig
            type T =  BaseType.T PolymorphicContainerType.T
         end
      structure PointerType:
         sig
            type T =  string
         end

      val empty: ContainerType.T
      val is_empty: ContainerType.T -> bool
      val select: PointerType.T * ContainerType.T -> BaseType.T Option.option

   end;

