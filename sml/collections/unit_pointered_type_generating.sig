use "general/eqs.sig";
use "collections/unit_polymorphic_container_type.sig";

signature UnitPointeredTypeGenerating =
   sig
      structure PolymorphicContainerType: UnitPolymorphicContainerType
      structure PointeredTypeExtended:
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
            structure BaseStructure: Eqs
            sharing BaseStructure = BaseType
      
            val empty: ContainerType.T
            val is_empty: ContainerType.T -> bool
            val select: PointerType.T * ContainerType.T -> BaseType.T Option.option

            val all:        (BaseType.T -> bool) -> ContainerType.T -> bool
            val all_zip:    (BaseType.T * BaseType.T -> bool) -> (ContainerType.T * ContainerType.T) -> bool
      
            val is_in:      BaseType.T * ContainerType.T -> bool
            val subeq:      ContainerType.T * ContainerType.T -> bool
      
            val filter:     (BaseType.T -> bool) -> ContainerType.T -> ContainerType.T
            val transition: (BaseType.T * 'b -> 'b Option.option) -> ContainerType.T -> 'b -> 'b

         end

         val singleton: PointeredTypeExtended.PointerType.T * PointeredTypeExtended.BaseType.T -> PointeredTypeExtended.ContainerType.T

   end;

