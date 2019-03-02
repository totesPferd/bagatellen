use "general/eqs.sig";
use "collections/unit_polymorphic_container_type.sig";

signature UnitPointeredTypeGenerating =
   sig
      structure PolymorphicContainerType: UnitPolymorphicContainerType
      structure PointeredType:
         sig
            structure BaseType: Eqs
            structure ContainerType:
               sig
                  type T =  BaseType.T PolymorphicContainerType.T
                  val eq: T * T -> bool
               end
            structure PointerType:
               sig
                  type T =  unit
               end
      
            val empty: ContainerType.T
            val is_empty: ContainerType.T -> bool
            val select: PointerType.T * ContainerType.T -> BaseType.T Option.option

            val singleton: PointerType.T * BaseType.T -> ContainerType.T

         end

   end;

