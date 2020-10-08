use "general/map.sig";
use "general/type.sig";

signature PointeredType =
   sig
      structure BaseType: Type
      structure ContainerType: Type
      structure PointerType: Type

      structure BaseStructure:
         sig
         end

      structure BaseStructureMap: Map
      sharing BaseStructureMap.Start =  BaseStructure
      sharing BaseStructureMap.End =  BaseStructure

      val empty:     ContainerType.T
      val is_empty:  ContainerType.T -> bool
      val select:    PointerType.T * ContainerType.T -> BaseType.T Option.option

      val base_map:  BaseStructureMap.Map.T -> BaseType.T -> BaseType.T

   end;
