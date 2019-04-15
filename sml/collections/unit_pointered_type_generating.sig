use "general/binary_relation.sig";
use "general/eqs.sig";
use "general/map.sig";
use "collections/all_zip.sig";
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
                  structure PointerType:
                     sig
                        type T =  unit
                     end
                  structure BaseStructure: Eqs
                  structure BaseStructureMap: Map
                  sharing BaseStructure = BaseType
                  sharing BaseStructureMap.Start =  BaseStructure
                  sharing BaseStructureMap.End =  BaseStructure

                  val empty:     ContainerType.T
                  val is_empty:  ContainerType.T -> bool
                  val select:    PointerType.T * ContainerType.T -> BaseType.T Option.option

                  val base_map:  BaseStructureMap.Map.T -> BaseType.T -> BaseType.T

               end

            val result: BinaryRelation.Relation.T -> PointeredType.ContainerType.T * PointeredType.ContainerType.T -> bool

         end
      sharing AllZip.PointeredType.BaseType =  PointeredTypeExtended.BaseType
      sharing AllZip.PointeredType.BaseStructure =  PointeredTypeExtended.BaseStructure
      sharing AllZip.PointeredType.BaseStructureMap =  PointeredTypeExtended.BaseStructureMap

      val singleton: PointeredTypeExtended.PointerType.T * PointeredTypeExtended.BaseType.T -> PointeredTypeExtended.ContainerType.T

   end;

