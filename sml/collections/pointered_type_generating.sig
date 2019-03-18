use "general/eqs.sig";
use "general/map.sig";
use "general/binary_relation.sig";
use "general/type.sig";

signature PointeredTypeGenerating =
   sig
      structure PolymorphicContainerType:
         sig
            type 'a T
         end
      structure PointeredTypeExtended:
         sig
            structure BaseType: Eqs
            structure ContainerType:
            sig
               type T =  BaseType.T PolymorphicContainerType.T
               val eq: T * T -> bool
            end
            structure PointerType: Type
            structure BaseStructure: Eqs
            structure BaseStructureMap: Map
            sharing BaseStructure = BaseType
            sharing BaseStructureMap.Start = BaseStructure
            sharing BaseStructureMap.End = BaseStructure

            val empty: ContainerType.T
            val is_empty: ContainerType.T -> bool
            val select: PointerType.T * ContainerType.T -> BaseType.T Option.option

            val all:        (BaseType.T -> bool) -> ContainerType.T -> bool
            val all_zip:    (BaseType.T * BaseType.T -> bool) -> (ContainerType.T * ContainerType.T) -> bool

            val is_in:      BaseType.T * ContainerType.T -> bool
            val subeq:      ContainerType.T * ContainerType.T -> bool

            val base_map:   BaseStructureMap.Map.T -> BaseType.T -> BaseType.T

            val transition: (BaseType.T * 'b -> 'b Option.option) -> ContainerType.T -> 'b -> 'b

      end
      structure AllZip:
         sig
            structure BinaryRelation: BinaryRelation
            structure PointeredType:
               sig
                  structure BaseType: Eqs
                  structure ContainerType:
                     sig
                        type T =  PointeredTypeExtended.ContainerType.T
                     end
                  structure PointerType: Type
                  structure BaseStructure: Eqs
                  sharing BaseStructure = BaseType
               end
         end
      sharing AllZip.PointeredType.BaseType =  PointeredTypeExtended.BaseType
      sharing AllZip.PointeredType.PointerType =  PointeredTypeExtended.PointerType
      sharing AllZip.PointeredType.BaseStructure =  PointeredTypeExtended.BaseStructure

      val singleton: PointeredTypeExtended.PointerType.T * PointeredTypeExtended.BaseType.T -> PointeredTypeExtended.ContainerType.T

   end;

